--[[
	AFK Mining Zone System

	Players inside the mining zone automatically mine every TICK_INTERVAL_MS.
	No pick usage required -- the server processes mining for all zone players.
]]

-- ============================================================
-- Configuration (fill in your map positions)
-- ============================================================
local MINING_ZONE_FROM = Position(1013, 1106, 8) -- Top-left corner of mining area
local MINING_ZONE_TO = Position(1061, 1163, 8) -- Bottom-right corner of mining area
local MINING_ZONE_SPAWN = Position(1045, 1146, 8) -- Where players appear when entering
local MINING_ZONE_EXIT = Position(990, 999, 9) -- Where players go when leaving

local PORTAL_ENTRY_AID = 62501 -- ActionId for the entry portal tile
local PORTAL_EXIT_AID = 62502 -- ActionId for the exit portal tile

local TICK_INTERVAL_MS = 3000 -- How often mining ticks (3 seconds)
local ATTEMPTS_PER_TICK = TICK_INTERVAL_MS / 1000 -- 3 attempts per tick (1 per second equivalent)

-- ============================================================
-- Load Mining system
-- ============================================================
local Mining = dofile("data-koliseu/scripts/systems/mining/init.lua")

-- ============================================================
-- Zone setup
-- ============================================================
_G.MiningZonePortalEntry = _G.MiningZonePortalEntry or {}
_G.OnMiningZone = _G.OnMiningZone or {}

local miningZone = Zone("mining.afk_zone")
miningZone:addArea(MINING_ZONE_FROM, MINING_ZONE_TO)

-- ============================================================
-- GlobalEvent: onThink (the core AFK mining loop)
-- ============================================================
local miningTick = GlobalEvent("miningZone.onThink")

function miningTick.onThink(interval, lastExecution)
	for playerId, _ in pairs(_G.OnMiningZone) do
		local player = Player(playerId)
		if player then
			Mining:attemptZoneMining(player, ATTEMPTS_PER_TICK)
		else
			_G.OnMiningZone[playerId] = nil
		end
	end

	return true
end

miningTick:interval(TICK_INTERVAL_MS)
miningTick:register()

-- ============================================================
-- ZoneEvent: Enter/Leave callbacks
-- ============================================================
local zoneEvent = ZoneEvent(miningZone)

function zoneEvent.afterEnter(zone, creature)
	local player = creature:getPlayer()
	if not player then
		return
	end

	local playerId = player:getId()
	local isPortalEntry = _G.MiningZonePortalEntry[playerId]
	_G.MiningZonePortalEntry[playerId] = nil

	_G.OnMiningZone[playerId] = { enteredAt = os.time() }

	player:sendTextMessage(MESSAGE_EVENT_ADVANCE,
		"You enter the mining zone. Mining will happen automatically every "
		.. (TICK_INTERVAL_MS / 1000) .. " seconds.")
	if isPortalEntry then
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	end
end

function zoneEvent.afterLeave(zone, creature)
	local player = creature:getPlayer()
	if not player then
		return
	end

	_G.OnMiningZone[player:getId()] = nil
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You leave the mining zone.")
end

zoneEvent:register()

-- ============================================================
-- MoveEvent: Entry portal
-- ============================================================
local portalEntry = MoveEvent()
portalEntry:type("stepin")

function portalEntry.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	-- Flag this player so afterEnter knows it's a portal entry (not a login spawn)
	_G.MiningZonePortalEntry[player:getId()] = true

	player:teleportTo(MINING_ZONE_SPAWN)
	player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	return true
end

portalEntry:aid(PORTAL_ENTRY_AID)
portalEntry:register()

-- ============================================================
-- MoveEvent: Exit portal
-- ============================================================
local portalExit = MoveEvent()
portalExit:type("stepin")

function portalExit.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	player:teleportTo(MINING_ZONE_EXIT)
	player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	_G.OnMiningZone[player:getId()] = nil
	return true
end

portalExit:aid(PORTAL_EXIT_AID)
portalExit:register()

logger.info("[MINING ZONE] AFK mining zone system loaded (tick: " .. TICK_INTERVAL_MS .. "ms)")
