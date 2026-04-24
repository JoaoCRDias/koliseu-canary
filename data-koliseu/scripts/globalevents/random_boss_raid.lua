--[[
	Random Boss Raid System
	Spawns a random boss at the raid room 3x per day at fixed times.
	Schedule: 10:00, 16:00, 22:00
	Position: 1140, 1142, 7 (raid room)
	Uses KV for persistence across server restarts.
]]

local RAID_POSITION = Position(1140, 1142, 7)
local CHECK_INTERVAL = 60 -- seconds (checks every 1 minute)
local BOSS_DESPAWN_TIME = 30 * 60 -- 30 minutes to kill the boss
local WARNING_MINUTES = 5 -- warning X minutes before spawn

-- Raid schedule (hours of the day)
local RAID_HOURS = { 12, 18, 23, 3 }

local RAID_BOSSES = {
	"Morgaroth",
	"Ghazbaran",
	"Mawhawk",
	"Gaz'Haragoth",
	"Morshabaal",
	"Orshabaal",
	"The Abomination",
	"Feroxa",
	"General Murius",
	"Omrafir",
	"Hirintror",
	"Rotworm Queen",
	"Dracola",
	"Apprentice Sheng",
	"The Welter",
	"Man in the Cave",
	"Battlemaster Zunzu",
	"Brutus Bloodbeard",
	"Captain Jones",
	"Chizzoron the Distorter",
	"Deadeye Devious",
	"Fernfang",
	"Fleabringer",
	"Foreman Kneebiter",
	"Furyosa",
	"Grorlam",
	"Lethal Lissy",
	"Necropharus",
	"Ocyakao",
	"Ron the Ripper",
	"Rottie the Rotworm",
	"Sir Valorcrest",
	"The Horned Fox",
	"The Pale Count",
	"Zulazza the Corruptor",
}

local function getRaidKV()
	return kv.scoped("random-boss-raid")
end

local function getCurrentBoss()
	local raidKV = getRaidKV()
	return raidKV:get("current-boss")
end

local function setCurrentBoss(name)
	local raidKV = getRaidKV()
	if name then
		raidKV:set("current-boss", name)
	else
		raidKV:remove("current-boss")
	end
end

local function getBossDespawnTime()
	local raidKV = getRaidKV()
	return raidKV:get("boss-despawn-time") or 0
end

local function setBossDespawnTime(time)
	local raidKV = getRaidKV()
	if time and time > 0 then
		raidKV:set("boss-despawn-time", time)
	else
		raidKV:remove("boss-despawn-time")
	end
end

local function getLastBoss()
	local raidKV = getRaidKV()
	return raidKV:get("last-boss") or ""
end

local function setLastBoss(name)
	local raidKV = getRaidKV()
	raidKV:set("last-boss", name)
end

local function pickRandomBoss()
	local lastBoss = getLastBoss()
	local boss
	repeat
		boss = RAID_BOSSES[math.random(#RAID_BOSSES)]
	until boss ~= lastBoss or #RAID_BOSSES <= 1
	return boss
end

-- Returns the next scheduled raid time (os.time timestamp)
local function getNextScheduledRaid()
	local now = os.time()
	local today = os.date("*t", now)

	for _, hour in ipairs(RAID_HOURS) do
		local raidTime = os.time({
			year = today.year,
			month = today.month,
			day = today.day,
			hour = hour,
			min = 0,
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
		hour = RAID_HOURS[1],
		min = 0,
		sec = 0,
	})
	return tomorrow
end

-- Returns a unique key for a raid time slot (e.g. "2026-02-14-10")
local function getRaidSlotKey(timestamp)
	local t = os.date("*t", timestamp)
	return string.format("%04d-%02d-%02d-%02d", t.year, t.month, t.day, t.hour)
end

-- Raid room boundaries
local RAID_AREA_FROM = Position(1113, 1124, 7)
local RAID_AREA_TO = Position(1162, 1161, 7)

local function removeBossFromRaid()
	local currentBoss = getCurrentBoss()
	if currentBoss then
		local bossLower = currentBoss:lower()
		for x = RAID_AREA_FROM.x, RAID_AREA_TO.x do
			for y = RAID_AREA_FROM.y, RAID_AREA_TO.y do
				local tile = Tile(Position(x, y, RAID_AREA_FROM.z))
				if tile then
					local creature = tile:getTopCreature()
					if creature and creature:isMonster() and creature:getName():lower() == bossLower then
						creature:remove()
					end
				end
			end
		end
	end
	setCurrentBoss(nil)
	setBossDespawnTime(0)
end

local function spawnBoss(bossName)
	local monster = Game.createMonster(bossName, RAID_POSITION, false, true)
	if not monster then
		logger.warn("[RandomBossRaid] Failed to spawn boss: {}", bossName)
		return false
	end

	-- Register death callback to clear raid state when boss is killed
	monster:registerEvent("random_boss_raid.death")

	setCurrentBoss(bossName)
	setLastBoss(bossName)
	setBossDespawnTime(os.time() + BOSS_DESPAWN_TIME)

	Game.broadcastMessage(
		string.format("A powerful %s has appeared in the raid room! You have %d minutes to defeat it!", bossName, BOSS_DESPAWN_TIME / 60),
		MESSAGE_EVENT_ADVANCE
	)

	logger.info("[RandomBossRaid] Spawned boss: {} at position ({}, {}, {})", bossName, RAID_POSITION.x, RAID_POSITION.y, RAID_POSITION.z)
	return true
end

-- CreatureEvent: Clear raid state when boss is killed
local bossDeath = CreatureEvent("random_boss_raid.death")

function bossDeath.onDeath(creature, corpse, killer, mostDamageKiller, lastHitUnjustified, mostDamageUnjustified)
	local currentBoss = getCurrentBoss()
	if currentBoss and creature:getName():lower() == currentBoss:lower() then
		local killerName = "Unknown"
		if killer and killer:isPlayer() then
			killerName = killer:getName()
		end

		Game.broadcastMessage(
			string.format("The %s has been defeated by %s! The raid room is now clear.", currentBoss, killerName),
			MESSAGE_EVENT_ADVANCE
		)
		logger.info("[RandomBossRaid] Boss {} killed by {}", currentBoss, killerName)
		setCurrentBoss(nil)
		setBossDespawnTime(0)
	end
	return true
end

bossDeath:register()

-- GlobalEvent: Check raid schedule
local raidCheck = GlobalEvent("random_boss_raid.check")

function raidCheck.onThink(interval, lastExecution)
	local raidKV = getRaidKV()
	local currentBoss = getCurrentBoss()

	-- If a boss is currently alive, check despawn timer
	if currentBoss then
		if os.time() >= getBossDespawnTime() then
			Game.broadcastMessage(
				string.format("The %s has retreated from the raid room! The heroes were not strong enough...", currentBoss),
				MESSAGE_EVENT_ADVANCE
			)
			removeBossFromRaid()
		end
		return true
	end

	-- No boss active, check schedule
	local now = os.time()
	local nextRaid = getNextScheduledRaid()
	local warningTime = nextRaid - (WARNING_MINUTES * 60)

	-- 5-minute warning
	local slotKey = getRaidSlotKey(nextRaid)
	if now >= warningTime and now < nextRaid and not raidKV:get("warning-" .. slotKey) then
		Game.broadcastMessage(
			string.format("A powerful boss will appear in the raid room in %d minutes! Prepare yourselves!", WARNING_MINUTES),
			MESSAGE_EVENT_ADVANCE
		)
		raidKV:set("warning-" .. slotKey, true)
	end

	-- Check if any scheduled raid should fire now
	local today = os.date("*t", now)
	for _, hour in ipairs(RAID_HOURS) do
		local raidTime = os.time({
			year = today.year,
			month = today.month,
			day = today.day,
			hour = hour,
			min = 0,
			sec = 0,
		})
		local raidSlot = getRaidSlotKey(raidTime)

		-- Within 1 minute window of scheduled time and not yet triggered
		if now >= raidTime and now < raidTime + 60 and not raidKV:get("triggered-" .. raidSlot) then
			raidKV:set("triggered-" .. raidSlot, true)
			local bossName = pickRandomBoss()
			spawnBoss(bossName)
			return true
		end
	end

	return true
end

raidCheck:interval(CHECK_INTERVAL * 1000)
raidCheck:register()

-- TalkAction: Check next raid time
local raidInfo = TalkAction("!raid", "!raidinfo")

function raidInfo.onSay(player, words, param, type)
	local currentBoss = getCurrentBoss()
	if currentBoss then
		local remaining = getBossDespawnTime() - os.time()
		if remaining > 0 then
			local minutes = math.floor(remaining / 60)
			local seconds = remaining % 60
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE,
				string.format("[Raid] %s is currently in the raid room! Time remaining: %d min %02d sec.",
					currentBoss, minutes, seconds))
		end
		return true
	end

	local nextRaid = getNextScheduledRaid()
	local remaining = nextRaid - os.time()

	if remaining <= 0 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "[Raid] A boss will appear any moment now!")
		return true
	end

	local hours = math.floor(remaining / 3600)
	local minutes = math.floor((remaining % 3600) / 60)
	local nextHour = os.date("%H:%M", nextRaid)
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE,
		string.format("[Raid] Next boss raid at %s (in %dh %02dmin). Schedule: 10:00, 16:00, 22:00.",
			nextHour, hours, minutes))
	return true
end

raidInfo:separator(" ")
raidInfo:groupType("normal")
raidInfo:register()

-- TalkAction: Force start a raid (GOD only)
local forceRaid = TalkAction("!forceraid")

function forceRaid.onSay(player, words, param, type)
	if player:getGroup():getAccess() == false then
		return true
	end

	local currentBoss = getCurrentBoss()
	if currentBoss then
		-- Remove current boss first
		removeBossFromRaid()
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("[Raid] Removed current boss: %s.", currentBoss))
	end

	local bossName
	if param and param ~= "" then
		-- Check if the specified boss exists in the list
		for _, name in ipairs(RAID_BOSSES) do
			if name:lower() == param:lower() then
				bossName = name
				break
			end
		end
		if not bossName then
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("[Raid] Boss '%s' not found. Available bosses:", param))
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, table.concat(RAID_BOSSES, ", "))
			return true
		end
	else
		bossName = pickRandomBoss()
	end

	if spawnBoss(bossName) then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("[Raid] Force spawned: %s.", bossName))
	else
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("[Raid] Failed to spawn: %s.", bossName))
	end
	return true
end

forceRaid:separator(" ")
forceRaid:groupType("god")
forceRaid:register()
