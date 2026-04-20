-- Storage to track the last task daily reset key (based on server save time)
TASK_LAST_SERVER_SAVE_STORAGE = 191100

local function parseServerSaveTime()
	-- Use the morning save as the canonical daily reset anchor.
	local timeStr = configManager.getString(configKeys.MORNING_SERVER_SAVE_TIME)
	local hours, minutes, seconds = string.match(timeStr, "^(%d+):(%d+):(%d+)$")
	if not hours then
		hours, minutes = string.match(timeStr, "^(%d+):(%d+)$")
		seconds = "0"
	end
	if not hours or not minutes then
		return 6, 0, 0
	end
	return tonumber(hours), tonumber(minutes), tonumber(seconds or 0)
end

local function getTaskResetKey(now)
	local hours, minutes, seconds = parseServerSaveTime()
	local dateTable = os.date("*t", now)
	dateTable.hour = hours
	dateTable.min = minutes
	dateTable.sec = seconds
	local resetTime = os.time(dateTable)
	if now < resetTime then
		resetTime = resetTime - (24 * 60 * 60)
	end
	return tonumber(os.date("%Y%m%d", resetTime))
end

local function resetPlayerTaskCounters(player, resetKey)
	player:setStorageValue(taskDailyCountStorage, -1)
	player:setStorageValue(TASK_LAST_SERVER_SAVE_STORAGE, resetKey)
end

local function ensurePlayerTaskCounters(player)
	local resetKey = getTaskResetKey(os.time())
	local playerLastReset = player:getStorageValue(TASK_LAST_SERVER_SAVE_STORAGE)
	if playerLastReset ~= resetKey then
		resetPlayerTaskCounters(player, resetKey)
	end
end

local function resetAllPlayersIfNeeded()
	local resetKey = getTaskResetKey(os.time())
	local globalResetKey = Game.getStorageValue(TASK_LAST_SERVER_SAVE_STORAGE)
	if globalResetKey == resetKey then
		return
	end

	local players = Game.getPlayers()
	for _, player in ipairs(players) do
		resetPlayerTaskCounters(player, resetKey)
	end

	Game.setStorageValue(TASK_LAST_SERVER_SAVE_STORAGE, resetKey)
	print("Task daily completion counters have been reset for all players.")
end

local taskLog = GlobalEvent("TaskLog")

function taskLog.onStartup()
	local newmissions = {}
	for i, data in pairs(taskConfiguration) do
		newmissions[#newmissions + 1] = {name = "Task: "..data.name, storageId = data.storage, missionId = #newmissions + 1, startValue = 0, endValue = os.time()*10, description = function(player) return (player:getTaskKills(data.storagecount) == -1 and "You have completed this task." or (player:getTaskKills(data.storagecount) == data.total and "You have completed this task, but you still need to collect your reward use !task." or "You killed ["..player:getTaskKills(data.storagecount).."/"..data.total.."] "..data.name)) end,}
	end
	Quests[#Quests + 1] = {name = "Tasks", startStorageId = taskQuestLog, startStorageValue = 1,
	                       missions = newmissions}
	resetAllPlayersIfNeeded()
	return true
end

taskLog:register()

local taskEvents = CreatureEvent("TaskEvents")
function taskEvents.onLogin(player)
	local events = {
      -- Custom Events
      "TaskCreature"
	}

	for i = 1, #events do
		player:registerEvent(events[i])
	end

	-- Ensure task counters are reset for the current server save cycle
	ensurePlayerTaskCounters(player)

	return true
end

taskEvents:register()

local taskDailyReset = GlobalEvent("TaskDailyReset")
function taskDailyReset.onThink(interval)
	resetAllPlayersIfNeeded()
	return true
end

taskDailyReset:interval(300000)
taskDailyReset:register()
