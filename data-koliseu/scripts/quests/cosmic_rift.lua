--[[
	Cosmic Rift Hunt System
	- 4 Rifts with 3 monsters each (12 total)
	- Prerequisite: Complete bestiary of all Soul War, Gnomprona, and Rotten Blood monsters
	- Each rift requires bestiary completion of the previous rift's monsters
	- Completing all 12 bestiaries rewards: 1x Bag of Cosmic Wishes, 500x Addon Doll, 500x Mount Doll
]]

-- ============================================
-- CONFIGURATION
-- ============================================

local COSMIC_RIFT_STORAGE = {
	REWARD_CLAIMED = 920100, -- storage to track if cosmic reward was already claimed
}

-- Reward is granted by the Cosmic Scholar NPC (npc/cosmic_scholar.lua)

-- ============================================
-- BESTIARY RACE IDs - PREREQUISITES (Soul War + Gnomprona + Rotten)
-- These are the raceIds that must be completed BEFORE accessing Cosmic Rift I
-- ============================================

-- Soul War normal monsters (19 raceIds)
local SOULWAR_RACE_IDS = {
	1926, -- Bony Sea Devil
	1927, -- Many Faces
	1928, -- Cloak of Terror
	1929, -- Vibrant Phantom
	1930, -- Brachiodemon
	1931, -- Branchy Crawler
	1932, -- Capricious Phantom
	1933, -- Infernal Phantom
	1938, -- Infernal Demon
	1939, -- Rotten Golem
	1940, -- Turbulent Elemental
	1941, -- Courage Leech
	1945, -- Mould Phantom
	1962, -- Distorted Phantom
}

-- Gnomprona / Primal Ordeal monsters
-- PLACEHOLDER: These monsters have NO raceId defined in their files.
-- You need to ADD raceIds to the primal ordeal monster files first, then list them here.
local GNOMPRONA_RACE_IDS = {
	2264, -- Sulphider
	2265, -- Sulphur Spouter
	2266, -- Gore Horn
	2267, -- Sabretooth
	2268, -- Emerald Tortoise
	2269, -- Undertaker
	2270, -- Nighthunter
	2271, -- Hulking Prehemoth
	2272, -- Stalking Stalk
	2274, -- Mantosaurus
	2275, -- Headpecker
	2276, -- Noxious Ripptor
	2277, -- Gorerilla
	2278, -- Shrieking Cry-Stal
	2279, -- Mercurial Menace
}

-- Rotten Blood monsters (16 raceIds)
local ROTTEN_RACE_IDS = {
	2375, -- Mycobiontic Beetle
	2376, -- Meandering Mushroom
	2377, -- Oozing Carcass
	2378, -- Darklight Construct
	2379, -- Converter
	2380, -- Darklight Matter
	2381, -- Oozing Corpus
	2382, -- Darklight Emitter
	2392, -- Bloated Man-Maggot
	2393, -- Rotten Man-Maggot
	2394, -- Walking Pillar
	2395, -- Wandering Pillar
	2396, -- Sopping Carcass
	2397, -- Sopping Corpus
	2398, -- Darklight Source
	2399, -- Darklight Striker
}

-- ============================================
-- COSMIC RIFT MONSTER RACE IDs (the 12 new monsters)
-- ============================================

local COSMIC_RIFT_MONSTERS = {
	-- Rift I
	[1] = {
		name = "Cosmic Rift I",
		raceIds = {
			2769, -- Astral Leech
			2770, -- Rift Stalker
			2771, -- Void Crawler
		},
	},
	-- Rift II
	[2] = {
		name = "Cosmic Rift II",
		raceIds = {
			2772, -- Dimensional Shade
			2773, -- Nebula Weaver
			2774, -- Starfall Sentinel
		},
	},
	-- Rift III
	[3] = {
		name = "Cosmic Rift III",
		raceIds = {
			2775, -- Cosmic Warden
			2776, -- Entropy Devourer
			2777, -- Singularity Spawn
		},
	},
	-- Rift IV
	[4] = {
		name = "Cosmic Rift IV",
		raceIds = {
			2778, -- Event Horizon
			2779, -- Oblivion Herald
			2780, -- Reality Fracture
		},
	},
}

-- All 12 cosmic rift raceIds (for final reward check)
local ALL_COSMIC_RACE_IDS = {
	2769, 2770, 2771, -- Rift I
	2772, 2773, 2774, -- Rift II
	2775, 2776, 2777, -- Rift III
	2778, 2779, 2780, -- Rift IV
}

-- ============================================
-- HELPER FUNCTIONS
-- ============================================

--- Check if the player has completed all bestiaries in a given raceId list
---@param player Player
---@param raceIds table
---@return boolean allComplete
---@return string|nil missingName (name of first missing bestiary, or nil)
local function hasCompletedBestiary(player, raceIds)
	for _, raceId in ipairs(raceIds) do
		if not player:isMonsterBestiaryUnlocked(raceId) then
			local mtype = MonsterType(raceId)
			local monsterName = mtype and mtype:name() or ("raceId " .. raceId)
			return false, monsterName
		end
	end
	return true, nil
end

--- Check if the player has completed all prerequisite bestiaries (Soul War + Gnomprona + Rotten)
---@param player Player
---@return boolean
---@return string|nil errorMsg
local function hasPrerequisiteBestiary(player)
	local ok, missing

	ok, missing = hasCompletedBestiary(player, SOULWAR_RACE_IDS)
	if not ok then
		return false, "You need to complete the Soul War bestiary first. Missing: " .. missing
	end

	if #GNOMPRONA_RACE_IDS > 0 then
		ok, missing = hasCompletedBestiary(player, GNOMPRONA_RACE_IDS)
		if not ok then
			return false, "You need to complete the Gnomprona bestiary first. Missing: " .. missing
		end
	end

	ok, missing = hasCompletedBestiary(player, ROTTEN_RACE_IDS)
	if not ok then
		return false, "You need to complete the Rotten Blood bestiary first. Missing: " .. missing
	end

	return true, nil
end


-- Reward is granted by the Cosmic Scholar NPC (npc/cosmic_scholar.lua)

-- ============================================
-- MOVEMENT EVENTS
-- ============================================
-- Action IDs:
-- 62000 = Entrance to the Cosmic Rift room (requires Soul War + Gnomprona + Rotten bestiaries)
-- 62001 = Rift I, 62002 = Rift II, 62003 = Rift III, 62004 = Rift IV

-- Entrance to the rift room (prerequisite check only)
local riftRoomEntrance = MoveEvent()

riftRoomEntrance.onStepIn = function(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	if player:isInGhostMode() then
		return true
	end

	local canAccess, errorMsg = hasPrerequisiteBestiary(player)
	if not canAccess then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, errorMsg)
		player:teleportTo(fromPosition, false)
		position:sendMagicEffect(CONST_ME_POFF)
		return true
	end

	return true
end

riftRoomEntrance:type("stepin")
riftRoomEntrance:aid(62000)
riftRoomEntrance:register()

-- Individual rift gates (require previous rift bestiaries)
local riftGates = {
	{ actionId = 62001, riftLevel = 1 },
	{ actionId = 62002, riftLevel = 2 },
	{ actionId = 62003, riftLevel = 3 },
	{ actionId = 62004, riftLevel = 4 },
}

for _, gate in ipairs(riftGates) do
	local moveEvent = MoveEvent()

	moveEvent.onStepIn = function(creature, item, position, fromPosition)
		local player = creature:getPlayer()
		if not player then
			return true
		end

		if player:isInGhostMode() then
			return true
		end

		-- Rift I has no extra requirement (prerequisites already checked at room entrance)
		-- Rift II+ requires previous rift bestiaries completed
		if gate.riftLevel > 1 then
			for i = 1, gate.riftLevel - 1 do
				local rift = COSMIC_RIFT_MONSTERS[i]
				local ok, missing = hasCompletedBestiary(player, rift.raceIds)
				if not ok then
					player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You need to complete the " .. rift.name .. " bestiary first. Missing: " .. missing)
					player:teleportTo(fromPosition, false)
					position:sendMagicEffect(CONST_ME_POFF)
					return true
				end
			end
		end

		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Welcome to " .. COSMIC_RIFT_MONSTERS[gate.riftLevel].name .. "!")
		return true
	end

	moveEvent:type("stepin")
	moveEvent:aid(gate.actionId)
	moveEvent:register()
end

-- ============================================
-- TALKACTION - Check cosmic rift progress (!cosmicrift)
-- ============================================

local cosmicRiftCheck = TalkAction("!cosmicrift")

function cosmicRiftCheck.onSay(player, words, param, type)
	local messages = {}

	-- Check prerequisites
	local prereqOk, prereqMsg = hasPrerequisiteBestiary(player)
	if prereqOk then
		table.insert(messages, "[Prerequisites] Soul War + Gnomprona + Rotten: COMPLETE")
	else
		table.insert(messages, "[Prerequisites] " .. prereqMsg)
	end

	-- Check each rift
	for i = 1, 4 do
		local rift = COSMIC_RIFT_MONSTERS[i]
		local completed = 0
		local total = #rift.raceIds
		for _, raceId in ipairs(rift.raceIds) do
			if player:isMonsterBestiaryUnlocked(raceId) then
				completed = completed + 1
			end
		end
		local status = completed == total and "COMPLETE" or (completed .. "/" .. total)
		table.insert(messages, "[" .. rift.name .. "] Bestiary: " .. status)
	end

	-- Reward status
	if player:getStorageValue(COSMIC_RIFT_STORAGE.REWARD_CLAIMED) == 1 then
		table.insert(messages, "[Reward] Already claimed!")
	else
		local allDone, _ = hasCompletedBestiary(player, ALL_COSMIC_RACE_IDS)
		if allDone then
			table.insert(messages, "[Reward] All complete! Talk to the Cosmic Scholar to claim your reward.")
		else
			table.insert(messages, "[Reward] Not yet available (complete all 12 bestiaries).")
		end
	end

	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "=== Cosmic Rift Progress ===\n" .. table.concat(messages, "\n"))
	return true
end

cosmicRiftCheck:separator(" ")
cosmicRiftCheck:groupType("normal")
cosmicRiftCheck:register()
