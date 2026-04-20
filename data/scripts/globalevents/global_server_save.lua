-- Two scheduled global server saves per day.
-- Times are set via config.lua keys `morningServerSaveTime` and `nightServerSaveTime`.
-- `resetTasks` is true only on the morning save: it zeroes per-player daily task counters.

local function ResetTaskDailyCounters()
	if not taskConfiguration or not taskDailyCountStorage then
		return
	end

	local players = Game.getPlayers()
	for _, player in ipairs(players) do
		if player then
			player:setStorageValue(taskDailyCountStorage, -1)
		end
	end
	print("Task daily completion counters have been reset for all players.")
end

local function ServerSave(resetTasks)
	if configManager.getBoolean(configKeys.GLOBAL_SERVER_SAVE_CLEAN_MAP) then
		cleanMap()
	end

	if configManager.getBoolean(configKeys.GLOBAL_SERVER_SAVE_CLOSE) then
		Game.setGameState(GAME_STATE_CLOSED)
	end
	if configManager.getBoolean(configKeys.GLOBAL_SERVER_SAVE_SHUTDOWN) then
		Game.setGameState(GAME_STATE_SHUTDOWN)
	end

	-- Update daily reward next server save timestamp
	UpdateDailyRewardGlobalStorage(DailyReward.storages.lastServerSave, os.time())

	-- Reset raid daily counters
	for name, raid in pairs(Raid.registry) do
		raid.kv:set("checks-today", 0)
		raid.kv:set("last-check-date", os.date("%Y%m%d"))
	end

	-- Reset per-player task daily counters only on the morning save
	if resetTasks then
		ResetTaskDailyCounters()
	end
end

local function ServerSaveWarning(time, resetTasks)
	local remainingTime = tonumber(time) - 60000
	if configManager.getBoolean(configKeys.GLOBAL_SERVER_SAVE_NOTIFY_MESSAGE) then
		local message = "Server is saving the game in " .. (remainingTime / 60000) .. " minute(s). Please logout."
		Webhook.sendMessage("Server save", message, WEBHOOK_COLOR_WARNING)
		Game.broadcastMessage(message, MESSAGE_GAME_HIGHLIGHT)
	end

	if remainingTime > 60000 then
		addEvent(ServerSaveWarning, 60000, remainingTime, resetTasks)
	else
		addEvent(ServerSave, 60000, resetTasks)
	end
end

local function onServerSaveTime(resetTasks)
	local remainingTime = configManager.getNumber(configKeys.GLOBAL_SERVER_SAVE_NOTIFY_DURATION) * 60000
	if configManager.getBoolean(configKeys.GLOBAL_SERVER_SAVE_NOTIFY_MESSAGE) then
		local message = "Server is saving the game in " .. (remainingTime / 60000) .. " minute(s). Please logout."
		Webhook.sendMessage("Server save", message, WEBHOOK_COLOR_WARNING)
		Game.broadcastMessage(message, MESSAGE_GAME_HIGHLIGHT)
	end

	addEvent(ServerSaveWarning, 60000, remainingTime, resetTasks)
	return not configManager.getBoolean(configKeys.GLOBAL_SERVER_SAVE_SHUTDOWN)
end

-- Morning server save (resets daily tasks)
local morningServerSave = GlobalEvent("MorningServerSave")
function morningServerSave.onTime(interval)
	return onServerSaveTime(true)
end
morningServerSave:time(configManager.getString(configKeys.MORNING_SERVER_SAVE_TIME))
morningServerSave:register()

-- Night server save (no task reset)
local nightServerSave = GlobalEvent("NightServerSave")
function nightServerSave.onTime(interval)
	return onServerSaveTime(false)
end
nightServerSave:time(configManager.getString(configKeys.NIGHT_SERVER_SAVE_TIME))
nightServerSave:register()
