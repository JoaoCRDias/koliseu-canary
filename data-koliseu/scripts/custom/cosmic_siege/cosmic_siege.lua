-- Cosmic Siege Event System
-- Entry and validation system for multi-level siege event

if CosmicSiege then
	return
end

CosmicSiege = {
	-- Object ID
	MECHANISM_AID = 34800,

	-- Timings
	COOLDOWN_SECONDS = 20 * 60 * 60, -- 20 hours
	ANNOUNCE_COOLDOWN_SECONDS = 60, -- 1 minute cooldown between announcements

	-- Positions (PLACEHOLDER - adjust these in the map)
	TEMPLE_TP_POS = Position(1000, 1000, 7),
	ISLAND_ENTRY_POS = Position(825, 766, 7),

	ENTRY_ROOM_FROM = Position(817, 738, 7),
	ENTRY_ROOM_TO = Position(833, 754, 7),

	ARENA_POSITIONS = {
		[500] = {
			spawn = Position(669, 724, 7),
			zoneFrom = Position(437, 599, 7),
			zoneTo = Position(712, 746, 8),
			bossName = "Nebular Warlord",
			bossSpawn = Position(458, 639, 8),
		},
		[1000] = {
			spawn = Position(392, 559, 7),
			zoneFrom = Position(376, 481, 7),
			zoneTo = Position(606, 574, 8),
			bossName = "Eclipse Sovereign",
			bossSpawn = Position(555, 508, 8),
		},
		[1500] = {
			spawn = Position(411, 378, 7),
			zoneFrom = Position(361, 300, 7),
			zoneTo = Position(590, 442, 8),
			bossName = "Astral Tyrant",
			bossSpawn = Position(499, 378, 8),
		},
	},

	EXIT_POS = Position(1000, 1000, 7), -- Temple

	-- Requirements
	REQUIREMENTS = {
		[500] = { hazard = 0 },
		[1000] = { hazard = 5 },
		[1500] = { hazard = 10 },
	},

	-- State
	_pendingAnnouncements = {},
	_zonesInitialized = false,
}

-- Zone helpers
function CosmicSiege.initializeZones()
	if CosmicSiege._zonesInitialized then
		return
	end

	-- Entry room zone
	local entryZone = Zone("cosmic_siege.entry")
	entryZone:addArea(CosmicSiege.ENTRY_ROOM_FROM, CosmicSiege.ENTRY_ROOM_TO)

	-- Arena zones (one per level)
	for level, config in pairs(CosmicSiege.ARENA_POSITIONS) do
		local zoneName = "cosmic_siege.arena." .. level
		local zone = Zone(zoneName)
		zone:addArea(config.zoneFrom, config.zoneTo)
		zone:setRemoveDestination(CosmicSiege.EXIT_POS)
		zone:blockFamiliars()
	end

	CosmicSiege._zonesInitialized = true
end

function CosmicSiege.getEntryZone()
	return Zone("cosmic_siege.entry")
end

function CosmicSiege.getArenaZone(level)
	return Zone("cosmic_siege.arena." .. level)
end

function CosmicSiege.getPlayersInEntryRoom()
	local zone = CosmicSiege.getEntryZone()
	zone:refresh()
	return zone:getPlayers()
end

-- Validation
function CosmicSiege.validateTeam(players, siegeLevel)
	local req = CosmicSiege.REQUIREMENTS[siegeLevel]
	local now = os.time()
	local failedPlayers = {}

	for _, player in ipairs(players) do
		-- 1. Check hazard level via KV
		local playerHazard = player:kv():scoped("hazard"):get("level") or 0
		if playerHazard < req.hazard then
			table.insert(failedPlayers, {
				player = player,
				reason = string.format("Requires Hazard %d (has %d)", req.hazard, playerHazard),
			})
		end

		-- 2. Check cooldown (individual per siege level)
		local cooldownEnd = player:kv():get("cosmic_siege.cooldown." .. siegeLevel) or 0
		if cooldownEnd > now then
			local remaining = cooldownEnd - now
			table.insert(failedPlayers, {
				player = player,
				reason = string.format("Cooldown: %s", Game.getTimeInWords(remaining)),
			})
		end
	end

	-- 3. Check arena occupancy
	local arenaZone = CosmicSiege.getArenaZone(siegeLevel)
	arenaZone:refresh()
	if arenaZone:countPlayers(IgnoredByMonsters) > 0 then
		return false, "Arena is currently occupied."
	end

	if #failedPlayers > 0 then
		return false, failedPlayers
	end

	return true
end

-- Modal windows
function CosmicSiege.showLevelSelectionModal(player)
	local modal = ModalWindow({
		title = "Cosmic Siege",
		message = "Select your siege level:",
	})

	-- Add choices for each level (hazard requirements from REQUIREMENTS table)
	modal:addChoice(string.format("Siege Level 500 (Requires Hazard %d)", CosmicSiege.REQUIREMENTS[500].hazard), function(p, button, choice)
		if button.name == "Confirm" then
			CosmicSiege.showConfirmationModal(p, 500)
		end
	end)

	modal:addChoice(string.format("Siege Level 1000 (Requires Hazard %d)", CosmicSiege.REQUIREMENTS[1000].hazard), function(p, button, choice)
		if button.name == "Confirm" then
			CosmicSiege.showConfirmationModal(p, 1000)
		end
	end)

	modal:addChoice(string.format("Siege Level 1500 (Requires Hazard %d)", CosmicSiege.REQUIREMENTS[1500].hazard), function(p, button, choice)
		if button.name == "Confirm" then
			CosmicSiege.showConfirmationModal(p, 1500)
		end
	end)

	modal:addButton("Confirm")
	modal:addButton("Cancel")
	modal:setDefaultEnterButton(0)
	modal:setDefaultEscapeButton(1)
	modal:sendToPlayer(player)
end

function CosmicSiege.showConfirmationModal(player, siegeLevel)
	local req = CosmicSiege.REQUIREMENTS[siegeLevel]

	local message = string.format([[Cosmic Siege - Level %d

Requirements:
- Hazard Level: %d
- Party Leader: %s
- Cooldown: 20 hours

Announce: Broadcast to server (select delay)
Go: Start immediately (validates all players)
Cancel: Return to selection]], siegeLevel, req.hazard, player:getName())

	local modal = ModalWindow({
		title = "Cosmic Siege - Confirmation",
		message = message,
	})

	modal:setDefaultCallback(function(p, button, choice)
		if button.id == 1 then -- Announce
			CosmicSiege.showAnnounceTimeModal(p, siegeLevel)
		elseif button.id == 2 then -- Go
			CosmicSiege.handleGo(p, siegeLevel)
		end
		-- button.id == 3 is Cancel (do nothing)
	end)

	modal:addButton("Announce")
	modal:addButton("Go")
	modal:addButton("Cancel")
	modal:setDefaultEnterButton(1)
	modal:setDefaultEscapeButton(3)
	modal:sendToPlayer(player)
end

function CosmicSiege.showAnnounceTimeModal(player, siegeLevel)
	-- Check announce cooldown
	local now = os.time()
	local announceCooldownEnd = player:kv():get("cosmic_siege.announce_cooldown") or 0

	if announceCooldownEnd > now then
		local remaining = announceCooldownEnd - now
		player:sendCancelMessage(string.format("You must wait %s before announcing again.", Game.getTimeInWords(remaining)))
		return
	end

	local modal = ModalWindow({
		title = "Cosmic Siege - Announce Time",
		message = "Select the announcement delay:",
	})

	-- Add choices for different times
	modal:addChoice("5 Minutes", function(p, button, choice)
		if button.name == "Confirm" then
			CosmicSiege.handleAnnounce(p, siegeLevel, 5 * 60)
		end
	end)

	modal:addChoice("3 Minutes", function(p, button, choice)
		if button.name == "Confirm" then
			CosmicSiege.handleAnnounce(p, siegeLevel, 3 * 60)
		end
	end)

	modal:addChoice("1 Minute", function(p, button, choice)
		if button.name == "Confirm" then
			CosmicSiege.handleAnnounce(p, siegeLevel, 1 * 60)
		end
	end)

	modal:addButton("Confirm")
	modal:addButton("Cancel")
	modal:setDefaultEnterButton(0)
	modal:setDefaultEscapeButton(1)
	modal:sendToPlayer(player)
end

-- Handlers
function CosmicSiege.handleAnnounce(player, siegeLevel, delaySeconds)
	local playerId = player:getId()
	local now = os.time()

	-- Cancel existing announcement
	if CosmicSiege._pendingAnnouncements[playerId] then
		stopEvent(CosmicSiege._pendingAnnouncements[playerId].eventId)
	end

	-- Set announce cooldown (1 minute)
	player:kv():set("cosmic_siege.announce_cooldown", now + CosmicSiege.ANNOUNCE_COOLDOWN_SECONDS)

	-- Broadcast with selected time
	local timeText = delaySeconds >= 60 and string.format("%d minute%s", delaySeconds / 60, delaySeconds > 60 and "s" or "") or string.format("%d seconds", delaySeconds)
	Game.broadcastMessage(string.format("[Cosmic Siege] %s - Level %d will participate in Siege level %d in %s!", player:getName(), player:getLevel(), siegeLevel, timeText), MESSAGE_GAME_HIGHLIGHT)

	-- Schedule auto-start
	local eventId = addEvent(function()
		local p = Player(player:getName())
		if p then
			CosmicSiege.handleGo(p, siegeLevel)
		end
		CosmicSiege._pendingAnnouncements[playerId] = nil
	end, delaySeconds * 1000)

	CosmicSiege._pendingAnnouncements[playerId] = {
		level = siegeLevel,
		eventId = eventId,
	}

	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("Announcement sent! Siege will start in %s.", timeText))
end

function CosmicSiege.handleGo(player, siegeLevel)
	-- Get party members
	local party = player:getParty()
	if not party then
		player:sendCancelMessage("You must be in a party.")
		return
	end

	-- Get all party members (including leader)
	local partyMembers = party:getMembers()
	table.insert(partyMembers, party:getLeader())

	-- Get all players in entry room
	local playersInRoom = CosmicSiege.getPlayersInEntryRoom()

	-- Filter: only party members who are in the entry room
	local eligiblePlayers = {}
	for _, partyMember in ipairs(partyMembers) do
		for _, roomPlayer in ipairs(playersInRoom) do
			if partyMember:getId() == roomPlayer:getId() then
				table.insert(eligiblePlayers, partyMember)
				break
			end
		end
	end

	if #eligiblePlayers == 0 then
		player:sendCancelMessage("No party members in entry room.")
		return
	end

	-- Validate each player and build detailed lists
	local req = CosmicSiege.REQUIREMENTS[siegeLevel]
	local now = os.time()
	local validPlayers = {}
	local invalidPlayers = {}
	local hazard = CosmicSiege and CosmicSiege.getHazard()

	if not hazard then
		player:sendCancelMessage("Cosmic Siege hazard system not found!")
		return
	end

	for _, p in ipairs(eligiblePlayers) do
		local canEnter = true
		local reasons = {}

		-- Check hazard level using Cosmic Siege hazard system
		local playerHazard = hazard:getPlayerCurrentLevel(p)
		if playerHazard < req.hazard then
			canEnter = false
			table.insert(reasons, string.format("Hazard %d required (has %d)", req.hazard, playerHazard))
		end

		-- Check cooldown (individual per siege level)
		local cooldownEnd = p:kv():get("cosmic_siege.cooldown." .. siegeLevel) or 0
		if cooldownEnd > now then
			canEnter = false
			local remaining = cooldownEnd - now
			table.insert(reasons, string.format("Cooldown: %s", Game.getTimeInWords(remaining)))
		end

		if canEnter then
			table.insert(validPlayers, p)
		else
			table.insert(invalidPlayers, {
				player = p,
				reasons = reasons,
			})
		end
	end

	-- Check arena occupancy
	local arenaZone = CosmicSiege.getArenaZone(siegeLevel)
	arenaZone:refresh()
	if arenaZone:countPlayers(IgnoredByMonsters) > 0 then
		player:sendCancelMessage("Arena is currently occupied.")
		return
	end

	-- If ANY player in the entry room fails validation, nobody enters
	if #invalidPlayers > 0 then
		-- Send detailed report to party leader
		local reportLines = { "Cosmic Siege Validation Report" }
		table.insert(reportLines, string.format("Siege Level: %d (Requires Hazard %d)", siegeLevel, req.hazard))
		table.insert(reportLines, "")
		table.insert(reportLines, "ALL party members in the entry room must meet the requirements.")
		table.insert(reportLines, "Kick ineligible members with !kickparty or wait for their cooldown.")
		table.insert(reportLines, "")

		table.insert(reportLines, string.format("Invalid Players (%d):", #invalidPlayers))
		for _, entry in ipairs(invalidPlayers) do
			table.insert(reportLines, string.format("  - %s:", entry.player:getName()))
			for _, reason in ipairs(entry.reasons) do
				table.insert(reportLines, string.format("    * %s", reason))
			end
		end
		table.insert(reportLines, "")

		if #validPlayers > 0 then
			table.insert(reportLines, string.format("Ready Players (%d):", #validPlayers))
			for _, p in ipairs(validPlayers) do
				table.insert(reportLines, string.format("  - %s (Level %d)", p:getName(), p:getLevel()))
			end
		end

		local report = table.concat(reportLines, "\n")
		player:showTextDialog(8987, report) -- Scroll/book dialog

		-- Send individual messages to invalid players
		for _, entry in ipairs(invalidPlayers) do
			local reasonText = table.concat(entry.reasons, ", ")
			entry.player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("[Cosmic Siege] You cannot enter: %s", reasonText))
		end
		return
	end

	-- If no valid players (shouldn't happen if no invalid either, but safety check)
	if #validPlayers == 0 then
		player:sendCancelMessage("No party members in entry room meet the requirements.")
		return
	end

	-- Teleport valid players + set cooldown
	local arenaConfig = CosmicSiege.ARENA_POSITIONS[siegeLevel]
	local arenaPos = arenaConfig.spawn

	for _, p in ipairs(validPlayers) do
		p:teleportTo(arenaPos, true)
		p:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		p:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("Welcome to Cosmic Siege - Level %d!", siegeLevel))
		p:kv():set("cosmic_siege.cooldown." .. siegeLevel, now + CosmicSiege.COOLDOWN_SECONDS)
	end

	-- Spawn the boss
	if arenaConfig.bossName and arenaConfig.bossSpawn then
		-- Clear any existing boss first
		local specs = Game.getSpectators(arenaConfig.bossSpawn, false, false, 15, 15, 15, 15)
		for _, creature in ipairs(specs) do
			if creature:isMonster() and creature:getName() == arenaConfig.bossName then
				creature:remove()
			end
		end

		-- Spawn new boss
		local boss = Game.createMonster(arenaConfig.bossName, arenaConfig.bossSpawn, false, true)
		if boss then
			-- Death events are already registered in monster.events table (monster lua files)
			print(string.format("[Cosmic Siege] Spawned boss %s", arenaConfig.bossName))

			-- Apply power scaling to boss based on siege level
			local powerLevel = CosmicSiege.MONSTER_POWER and CosmicSiege.MONSTER_POWER[siegeLevel]
			if powerLevel and powerLevel > 0 then
				-- Calculate scaling
				local dmgDealtPercent = 100 + (powerLevel * 3) -- +3% per power
				local defenseBonus = math.min(50, powerLevel * 1) -- +1% defense per power, capped at 50%
				local dmgReceivedPercent = 100 - defenseBonus
				local speedBonus = powerLevel * 3 -- +3 speed per power

				-- Apply speed
				boss:changeSpeed(speedBonus)

				-- Apply damage/defense via Condition
				local condition = Condition(CONDITION_ATTRIBUTES)
				condition:setParameter(CONDITION_PARAM_TICKS, -1) -- Permanent
				condition:setParameter(CONDITION_PARAM_SUBID, 90000) -- Unique ID for Cosmic Siege
				condition:setParameter(CONDITION_PARAM_BUFF_DAMAGEDEALT, dmgDealtPercent)
				condition:setParameter(CONDITION_PARAM_BUFF_DAMAGERECEIVED, dmgReceivedPercent)
				boss:addCondition(condition)

				-- Set power icon
				boss:setIcon("cosmic_siege_power", CreatureIconCategory_Modifications, CreatureIconModifications_ReducedHealth, powerLevel)

				-- Store power level
				boss:setStorageValue(90000, powerLevel)

				print(string.format("[Cosmic Siege] Applied power %d to %s: +%d%% dmg dealt, -%d%% dmg received, +%d speed",
					powerLevel, arenaConfig.bossName, dmgDealtPercent - 100, defenseBonus, speedBonus))
			end

			arenaConfig.bossSpawn:sendMagicEffect(CONST_ME_TELEPORT)
			print(string.format("[Cosmic Siege] Spawned %s at position %s for siege level %d", arenaConfig.bossName, arenaConfig.bossSpawn:toString(), siegeLevel))
		else
			print(string.format("[Cosmic Siege] ERROR: Failed to spawn %s at position %s", arenaConfig.bossName, arenaConfig.bossSpawn:toString()))
		end
	end

	-- Clear pending announcement
	local playerId = player:getId()
	if CosmicSiege._pendingAnnouncements[playerId] then
		stopEvent(CosmicSiege._pendingAnnouncements[playerId].eventId)
		CosmicSiege._pendingAnnouncements[playerId] = nil
	end
end

-- Initialize zones on module load
CosmicSiege.initializeZones()
