-- Hemothrak the Crimson Sovereign - Death Event
-- Stops all mechanics, removes debuffs/pools, teleports players out

local hemothrakDeath = CreatureEvent("HemothrakDeath")

-- PLACEHOLDER: Exit position (adjust to your map)
local EXIT_POSITION = Position(3015, 3106, 3)

-- Boss room bounds (must match hemothrak_mechanics.lua)
local ROOM_FROM = Position(3008, 3096, 4)
local ROOM_TO = Position(3020, 3113, 4)

function hemothrakDeath.onDeath(creature)
	-- Stop all boss mechanics
	if HemothrakBoss then
		HemothrakBoss.stop()
	end

	-- Get all players in boss room
	local cx = math.floor((ROOM_FROM.x + ROOM_TO.x) / 2)
	local cy = math.floor((ROOM_FROM.y + ROOM_TO.y) / 2)
	local rx = math.ceil((ROOM_TO.x - ROOM_FROM.x) / 2)
	local ry = math.ceil((ROOM_TO.y - ROOM_FROM.y) / 2)
	local specs = Game.getSpectators(Position(cx, cy, ROOM_FROM.z), false, true, rx, rx, ry, ry)

	for _, spec in ipairs(specs) do
		if spec:isPlayer() then
			-- Teleport to exit
			spec:teleportTo(EXIT_POSITION, true)
			EXIT_POSITION:sendMagicEffect(CONST_ME_TELEPORT)
			spec:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Hemothrak the Crimson Sovereign has been defeated! The blood recedes...")

			-- Remove any lingering conditions and unregister events
			spec:removeCondition(CONDITION_ATTRIBUTES, CONDITIONID_COMBAT, 55030, true)
			spec:removeCondition(CONDITION_ATTRIBUTES, CONDITIONID_COMBAT, 55031, true)
			spec:removeIcon("sanguine_link")
			spec:unregisterEvent("HemothrakPlayerDeath")
			spec:unregisterEvent("HemothrakPlayerLogout")
		end
	end

	return true
end

hemothrakDeath:register()

-- ============================================================
-- Boss Spawn Hook: Start mechanics when boss is first hit
-- ============================================================
local hemothrakSpawn = CreatureEvent("HemothrakSpawn")

function hemothrakSpawn.onHealthChange(creature, attacker, primaryDamage, primaryType, secondaryDamage, secondaryType, origin)
	if not HemothrakBoss or HemothrakBoss._active then
		return primaryDamage, primaryType, secondaryDamage, secondaryType
	end

	-- First hit triggers the fight mechanics
	if attacker and attacker:isPlayer() then
		HemothrakBoss.start(creature)
	end

	return primaryDamage, primaryType, secondaryDamage, secondaryType
end

hemothrakSpawn:register()
