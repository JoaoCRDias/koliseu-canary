--[[
	ADM Birthday Bash - Raid Event
	Spawns Gift Goblins in the main city every 2 hours.
	Active from 27/02/2026 until 02/03/2026.
	Goblins persist until server save.
	Uses KV for persistence across server restarts.
]]

-- Event time window
local EVENT_START = os.time({ year = 2026, month = 2, day = 27, hour = 10, min = 0, sec = 0 })
local EVENT_END = os.time({ year = 2026, month = 3, day = 2, hour = 10, min = 0, sec = 0 })

local MONSTER_NAME = "Gift Goblin"
local CHECK_INTERVAL = 60 -- seconds
local WARNING_MINUTES = 5

-- Raid schedule: {hour, minute} pairs - every 2 hours at :15
local RAID_SCHEDULE = {
	{ 0, 15 }, { 2, 15 }, { 4, 15 }, { 6, 15 }, { 8, 15 }, { 10, 15 },
	{ 12, 15 }, { 14, 15 }, { 16, 15 }, { 18, 15 }, { 20, 15 }, { 22, 15 },
}

-- Spawn areas: rectangles { from = Position, to = Position }
-- Monsters will be spawned at random valid tiles inside these areas
local SPAWN_AREAS = {
	-- Main city center
	{ from = Position(953, 977, 7), to = Position(1014, 1049, 7) },
	-- Central streets
	{ from = Position(1020, 973, 7), to = Position(1071, 1016, 7) },
	-- East district
	{ from = Position(926, 968, 7), to = Position(948, 1047, 7) },
	-- North area
	{ from = Position(905, 935, 7), to = Position(1082, 966, 7) },
	-- West side
	{ from = Position(782, 949, 7), to = Position(865, 1023, 7) },
	-- Far west district
	{ from = Position(1054, 939, 7), to = Position(1147, 1004, 7) },
}

local TOTAL_MONSTERS = 1300

local function isValidSpawnTile(tile)
	if not tile then
		return false
	end
	if tile:getHouse() then
		return false
	end
	if tile:hasFlag(TILESTATE_PROTECTIONZONE) then
		return false
	end
	if tile:hasFlag(TILESTATE_BLOCKSOLID) then
		return false
	end
	local ground = tile:getGround()
	if not ground then
		return false
	end
	if tile:getTopCreature() then
		return false
	end
	return true
end

local function collectValidPositions()
	local positions = {}
	for _, area in ipairs(SPAWN_AREAS) do
		for x = area.from.x, area.to.x do
			for y = area.from.y, area.to.y do
				local pos = Position(x, y, area.from.z)
				local tile = Tile(pos)
				if isValidSpawnTile(tile) then
					positions[#positions+1] = pos
				end
			end
		end
	end
	return positions
end

local function getRaidKV()
	return kv.scoped("birthday-raid")
end

local function isEventActive()
	local now = os.time()
	return now >= EVENT_START and now <= EVENT_END
end

local function getRaidSlotKey(timestamp)
	local t = os.date("*t", timestamp)
	return string.format("%04d-%02d-%02d-%02d-%02d", t.year, t.month, t.day, t.hour, t.min)
end

local function getNextScheduledRaid()
	local now = os.time()
	local today = os.date("*t", now)

	for _, schedule in ipairs(RAID_SCHEDULE) do
		local raidTime = os.time({
			year = today.year,
			month = today.month,
			day = today.day,
			hour = schedule[1],
			min = schedule[2],
			sec = 0,
		})
		if raidTime > now then
			return raidTime
		end
	end

	-- All raids for today have passed, return first raid of tomorrow
	local tomorrow = os.time({
		year = today.year,
		month = today.month,
		day = today.day + 1,
		hour = RAID_SCHEDULE[1][1],
		min = RAID_SCHEDULE[1][2],
		sec = 0,
	})
	return tomorrow
end

local function spawnGoblins()
	local validPositions = collectValidPositions()
	if #validPositions == 0 then
		logger.warn("[BirthdayRaid] No valid spawn positions found in configured areas!")
		return false
	end

	-- Shuffle positions for random distribution
	for i = #validPositions, 2, -1 do
		local j = math.random(1, i)
		validPositions[i], validPositions[j] = validPositions[j], validPositions[i]
	end

	local toSpawn = math.min(TOTAL_MONSTERS, #validPositions)
	local spawned = 0
	for i = 1, toSpawn do
		local monster = Game.createMonster(MONSTER_NAME, validPositions[i], false, true)
		if monster then
			spawned = spawned + 1
		end
	end

	if spawned == 0 then
		logger.warn("[BirthdayRaid] Failed to spawn any Gift Goblins!")
		return false
	end

	Game.broadcastMessage(
		string.format(
			"[ADM Birthday Bash] Gift Goblins have invaded the city! %d goblins are running around with stolen presents! Defeat them to collect Present Tokens!",
			spawned
		),
		MESSAGE_EVENT_ADVANCE
	)

	logger.info("[BirthdayRaid] Spawned {} Gift Goblins in the city", spawned)
	return true
end

-- GlobalEvent: Check raid schedule
local raidCheck = GlobalEvent("birthday_raid.check")

function raidCheck.onThink(interval, lastExecution)
	if not isEventActive() then
		return true
	end

	local raidKV = getRaidKV()
	local now = os.time()
	local nextRaid = getNextScheduledRaid()
	local warningTime = nextRaid - (WARNING_MINUTES * 60)

	-- 5-minute warning
	local slotKey = getRaidSlotKey(nextRaid)
	if now >= warningTime and now < nextRaid and not raidKV:get("warning-" .. slotKey) then
		Game.broadcastMessage(
			string.format("[ADM Birthday Bash] Gift Goblins will invade the city in %d minutes! Get ready!", WARNING_MINUTES),
			MESSAGE_EVENT_ADVANCE
		)
		raidKV:set("warning-" .. slotKey, true)
	end

	-- Check if any scheduled raid should fire now
	local today = os.date("*t", now)
	for _, schedule in ipairs(RAID_SCHEDULE) do
		local raidTime = os.time({
			year = today.year,
			month = today.month,
			day = today.day,
			hour = schedule[1],
			min = schedule[2],
			sec = 0,
		})
		local raidSlot = getRaidSlotKey(raidTime)

		-- Within 1 minute window of scheduled time and not yet triggered
		if now >= raidTime and now < raidTime + 60 and not raidKV:get("triggered-" .. raidSlot) then
			raidKV:set("triggered-" .. raidSlot, true)
			spawnGoblins()
			return true
		end
	end

	return true
end

raidCheck:interval(CHECK_INTERVAL * 1000)
raidCheck:register()

-- TalkAction: Check next raid time
local raidInfo = TalkAction("!birthday", "!birthdayraid")

function raidInfo.onSay(player, words, param, type)
	if not isEventActive() then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "[ADM Birthday Bash] The event is not currently active.")
		return true
	end

	local nextRaid = getNextScheduledRaid()
	local remaining = nextRaid - os.time()

	if remaining <= 0 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "[ADM Birthday Bash] Gift Goblins will invade any moment now!")
		return true
	end

	local hours = math.floor(remaining / 3600)
	local minutes = math.floor((remaining % 3600) / 60)
	local nextHour = os.date("%H:%M", nextRaid)
	player:sendTextMessage(
		MESSAGE_EVENT_ADVANCE,
		string.format(
			"[ADM Birthday Bash] Next raid at %s (in %dh %02dmin). Raids happen every 2 hours!",
			nextHour,
			hours,
			minutes
		)
	)
	return true
end

raidInfo:separator(" ")
raidInfo:groupType("normal")
raidInfo:register()

-- TalkAction: Force start a raid (GOD only)
local forceRaid = TalkAction("!forcebirthday")

function forceRaid.onSay(player, words, param, type)
	if player:getGroup():getAccess() == false then
		return true
	end

	if spawnGoblins() then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "[BirthdayRaid] Force spawned Gift Goblins!")
	else
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "[BirthdayRaid] Failed to spawn. Check SPAWN_AREAS config.")
	end
	return true
end

forceRaid:separator(" ")
forceRaid:groupType("god")
forceRaid:register()
