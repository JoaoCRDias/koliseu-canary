-- Addon Quest
-- Yalahar-style boss quest:
-- 1. Players enter the arena room freely via entry teleport
-- 2. They use a mechanism in the middle to summon the boss
-- 3. Upon activation: boss spawns, entry/exit teleports are locked, 48h cooldown is set for all players in room
-- 4. Locks are released when: boss dies, all players die, or 20-minute timeout
-- 5. On boss death: surviving players are teleported to reward room
-- 6. Reward chest opens modal with addons the player doesn't own
-- 7. After selecting addon, player is teleported out

-- ============================================================
-- CONFIG - TODO: Fill these with real positions/IDs
-- ============================================================
local CONFIG = {
	-- Cooldown
	storageCooldown = 54501,
	cooldownSeconds = 48 * 60 * 60, -- 48 hours

	-- Action IDs (use on RME map editor)
	entryTeleportAid = 64503,  -- TP into arena
	exitTeleportAid = 64504,   -- TP out of arena (free while not in combat)
	mechanismAid = 64505,      -- The "mechanism" item in the middle of the arena
	rewardChestAid = 64506,    -- Reward chest in reward room

	-- Positions - TODO: Replace with real positions
	entryDestination = Position(809, 628, 8),   -- Where entry TP takes player (inside arena)
	exitDestination = Position(809, 635, 8),    -- Where exit TP takes player (outside arena)
	bossSpawnPos = Position(809, 621, 8),       -- Where the boss is summoned
	rewardRoomPos = Position(804, 639, 8),       -- Where survivors are teleported after boss death
	questExitPos = Position(809, 639, 8),       -- Where player goes after claiming reward

	-- Arena zone bounds - TODO: Replace with real bounds
	arenaFromPos = Position(799, 610, 8),
	arenaToPos = Position(818, 632, 8),

	-- Boss
	bossName = "The Master Book", -- TODO: Replace with real boss name

	-- Timing
	maxCombatDuration = 20 * 60 * 1000, -- 20 minutes in ms

	-- Zone name (unique identifier)
	zoneName = "quest.addon_arena",
}

-- ============================================================
-- Runtime state
-- ============================================================
local State = {
	locked = false,         -- true while fight is in progress
	timeoutEvent = nil,     -- 20-minute auto-unlock event id
	bossUid = nil,          -- summoned boss uid
}

-- ============================================================
-- Addon data (reused from !addon talkaction)
-- ============================================================
local addonMountData = dofile(CORE_DIRECTORY .. "/libs/tables/addon_mounts.lua")
local ADDON_INFO_RAW = addonMountData.addons or {}

-- Addons excluded from the quest reward pool
local EXCLUDED_ADDONS = {
	["male mage"] = true,
	["female summoner"] = true,
	["royal costume"] = true,
	["golden"] = true,
}

local ADDON_INFO = {}
for key, info in pairs(ADDON_INFO_RAW) do
	if not EXCLUDED_ADDONS[key] then
		ADDON_INFO[key] = info
	end
end

local function hasFullAddon(player, info)
	if info.outfit_male and player:hasOutfit(info.outfit_male, 3) then
		return true
	end
	if info.outfit_female and player:hasOutfit(info.outfit_female, 3) then
		return true
	end
	return false
end

local function buildAddonChoicesForPlayer(player)
	local choices = {}
	local playerSex = player:getSex()
	for key, info in pairs(ADDON_INFO) do
		if info and not hasFullAddon(player, info) then
			local isMaleOnly = info.outfit_male and not info.outfit_female
			local isFemaleOnly = info.outfit_female and not info.outfit_male

			if isMaleOnly and playerSex ~= PLAYERSEX_MALE then
				-- skip male-only for female
			elseif isFemaleOnly and playerSex ~= PLAYERSEX_FEMALE then
				-- skip female-only for male
			else
				table.insert(choices, key)
			end
		end
	end
	table.sort(choices)
	return choices
end

local function grantAddon(player, info)
	if info.outfit_male then
		player:addOutfitAddon(info.outfit_male, 3)
	end
	if info.outfit_female then
		player:addOutfitAddon(info.outfit_female, 3)
	end
end

-- ============================================================
-- Zone helper
-- ============================================================
local _zoneInitialized = false
local function getArenaZone()
	local zone = Zone(CONFIG.zoneName)
	if not _zoneInitialized then
		zone:addArea(CONFIG.arenaFromPos, CONFIG.arenaToPos)
		_zoneInitialized = true
	end
	return zone
end

-- ============================================================
-- Unlock logic (called on boss death, wipe, or timeout)
-- ============================================================
local function unlockArena(teleportSurvivors)
	if not State.locked then
		return
	end

	State.locked = false

	-- Cancel pending timeout
	if State.timeoutEvent then
		stopEvent(State.timeoutEvent)
		State.timeoutEvent = nil
	end

	local zone = getArenaZone()

	if teleportSurvivors then
		-- Teleport all living players in the arena to the reward room
		for _, p in ipairs(zone:getPlayers()) do
			if p:getHealth() > 0 then
				p:teleportTo(CONFIG.rewardRoomPos)
				CONFIG.rewardRoomPos:sendMagicEffect(CONST_ME_TELEPORT)
				p:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Victory! Open the chest to claim your reward.")
			end
		end
	end

	-- Clean up any leftover boss (in case of timeout)
	if State.bossUid then
		local boss = Monster(State.bossUid)
		if boss then
			boss:remove()
		end
		State.bossUid = nil
	end

	-- Clean up any remaining monsters in the arena
	zone:removeMonsters()
end

-- ============================================================
-- Entry Teleport (blocked while fight is locked)
-- ============================================================
local entryTp = MoveEvent()

function entryTp.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	if State.locked then
		player:teleportTo(fromPosition, true)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The arena is currently locked. A fight is in progress.")
		fromPosition:sendMagicEffect(CONST_ME_POFF)
		return true
	end

	local lastUse = player:getStorageValue(CONFIG.storageCooldown)
	local now = os.time()
	if lastUse > now then
		local remaining = lastUse - now
		local hours = math.floor(remaining / 3600)
		local minutes = math.floor((remaining % 3600) / 60)
		player:teleportTo(fromPosition, true)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("You must wait %dh %dm before entering again.", hours, minutes))
		fromPosition:sendMagicEffect(CONST_ME_POFF)
		return true
	end

	player:teleportTo(CONFIG.entryDestination)
	CONFIG.entryDestination:sendMagicEffect(CONST_ME_TELEPORT)
	return true
end

entryTp:type("stepin")
entryTp:aid(CONFIG.entryTeleportAid)
entryTp:register()

-- ============================================================
-- Exit Teleport (blocked while fight is locked)
-- ============================================================
local exitTp = MoveEvent()

function exitTp.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	if State.locked then
		player:teleportTo(fromPosition, true)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The exit is sealed while the boss is alive.")
		fromPosition:sendMagicEffect(CONST_ME_POFF)
		return true
	end

	player:teleportTo(CONFIG.exitDestination)
	CONFIG.exitDestination:sendMagicEffect(CONST_ME_TELEPORT)
	return true
end

exitTp:type("stepin")
exitTp:aid(CONFIG.exitTeleportAid)
exitTp:register()

-- ============================================================
-- Mechanism Action: summon boss and lock the arena
-- ============================================================
local mechanism = Action()

function mechanism.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if State.locked then
		player:sendCancelMessage("The mechanism is already active.")
		return true
	end

	local zone = getArenaZone()
	local playersInZone = zone:getPlayers()

	if #playersInZone == 0 then
		player:sendCancelMessage("There must be someone in the arena to activate the mechanism.")
		return true
	end

	-- Check cooldown for all players in the arena
	local now = os.time()
	for _, p in ipairs(playersInZone) do
		local lastUse = p:getStorageValue(CONFIG.storageCooldown)
		if lastUse > now then
			local remaining = lastUse - now
			local hours = math.floor(remaining / 3600)
			local minutes = math.floor((remaining % 3600) / 60)
			player:sendCancelMessage(string.format("%s still has cooldown (%dh %dm).", p:getName(), hours, minutes))
			return true
		end
	end

	-- Apply cooldown to all players in the arena
	for _, p in ipairs(playersInZone) do
		p:setStorageValue(CONFIG.storageCooldown, now + CONFIG.cooldownSeconds)
		p:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The mechanism awakens the boss! The exits are sealed.")
	end

	-- Summon boss
	local boss = Game.createMonster(CONFIG.bossName, CONFIG.bossSpawnPos, false, true)
	if not boss then
		player:sendCancelMessage("Failed to summon the boss. Please contact an administrator.")
		return true
	end

	State.bossUid = boss:getId()
	State.locked = true

	CONFIG.bossSpawnPos:sendMagicEffect(CONST_ME_TELEPORT)

	-- Schedule 20-minute timeout
	State.timeoutEvent = addEvent(function()
		State.timeoutEvent = nil
		if not State.locked then
			return
		end
		local zn = getArenaZone()
		zn:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Time is up! The mechanism resets.")
		unlockArena(false)
	end, CONFIG.maxCombatDuration)

	return true
end

mechanism:aid(CONFIG.mechanismAid)
mechanism:register()

-- ============================================================
-- Boss Death CreatureEvent: teleport survivors and unlock
-- ============================================================
local bossDeath = CreatureEvent("AddonQuestBossDeath")

function bossDeath.onDeath(creature)
	if not State.locked then
		return true
	end
	if State.bossUid ~= creature:getId() then
		return true
	end

	State.bossUid = nil
	unlockArena(true)
	return true
end

bossDeath:register()

-- Register death event on the boss monster type at startup
local bossRegister = GlobalEvent("AddonQuestBossRegister")

function bossRegister.onStartup()
	local mType = MonsterType(CONFIG.bossName)
	if mType then
		mType:registerEvent("AddonQuestBossDeath")
	end
	return true
end

bossRegister:type("startup")
bossRegister:register()

-- ============================================================
-- Wipe detection: if no players remain in the arena, unlock
-- ============================================================
local playerDeathWipe = CreatureEvent("AddonQuestWipeCheck")

function playerDeathWipe.onDeath(creature)
	if not State.locked then
		return true
	end

	-- Schedule a check next tick so the dying player is already removed from the zone
	addEvent(function()
		if not State.locked then
			return
		end
		local zone = getArenaZone()
		local alive = 0
		for _, p in ipairs(zone:getPlayers()) do
			if p:getHealth() > 0 then
				alive = alive + 1
			end
		end
		if alive == 0 then
			local zn = getArenaZone()
			zn:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The arena has been wiped. The mechanism resets.")
			unlockArena(false)
		end
	end, 100)

	return true
end

playerDeathWipe:register()

-- Register wipe event on all players on login
local loginRegister = CreatureEvent("AddonQuestLoginRegister")

function loginRegister.onLogin(player)
	player:registerEvent("AddonQuestWipeCheck")
	return true
end

loginRegister:register()

-- ============================================================
-- Reward Chest Action: modal for addon selection
-- ============================================================
local chest = Action()

function chest.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local available = buildAddonChoicesForPlayer(player)

	if #available == 0 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You already own all available addons!")
		player:teleportTo(CONFIG.questExitPos)
		CONFIG.questExitPos:sendMagicEffect(CONST_ME_TELEPORT)
		return true
	end

	local window = ModalWindow({
		title = "Addon Reward",
		message = "Choose an addon as your reward:",
	})

	for _, name in ipairs(available) do
		window:addChoice(name)
	end

	window:addButton("Select", function(clickedPlayer, button, choice)
		if not choice or not choice.text then
			clickedPlayer:sendCancelMessage("You must select an addon.")
			return true
		end

		local info = ADDON_INFO[choice.text]
		if not info then
			clickedPlayer:sendCancelMessage("Invalid addon selection.")
			return true
		end

		if hasFullAddon(clickedPlayer, info) then
			clickedPlayer:sendCancelMessage("You already have this addon. Open the chest again.")
			return true
		end

		grantAddon(clickedPlayer, info)
		clickedPlayer:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Congratulations! You obtained the addon: " .. choice.text .. "!")
		clickedPlayer:getPosition():sendMagicEffect(CONST_ME_HOLYDAMAGE)

		clickedPlayer:teleportTo(CONFIG.questExitPos)
		CONFIG.questExitPos:sendMagicEffect(CONST_ME_TELEPORT)
		return true
	end)

	window:addButton("Cancel")
	window:setDefaultEnterButton(1)
	window:setDefaultEscapeButton(2)
	window:sendToPlayer(player)

	return true
end

chest:aid(CONFIG.rewardChestAid)
chest:register()
