-- Baldur the Allfather - Death Event
-- Stops all mechanics, removes debuffs, teleports players out

local baldurDeath = CreatureEvent("BaldurTheAllfatherDeath")

-- PLACEHOLDER: Exit position (adjust to your map)
local EXIT_POSITION = Position(3048, 3148, 4)

-- Boss room bounds (must match baldur_mechanics.lua)
local ROOM_FROM = Position(3037, 3091, 4)
local ROOM_TO = Position(3068, 3122, 4)

function baldurDeath.onDeath(creature)
	-- Stop all boss mechanics
	if BaldurBoss then
		BaldurBoss.stop()
	end

	-- Get damage map to identify participants
	local damageMap = creature:getDamageMap()
	local participants = {}
	for playerId, damageInfo in pairs(damageMap) do
		local player = Player(playerId)
		if player then
			participants[player:getId()] = player
		end
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
			spec:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Baldur the Allfather has been defeated! The divine light fades...")

			-- Remove any lingering skill debuff, essences and unregister events
			spec:removeCondition(CONDITION_ATTRIBUTES, CONDITIONID_COMBAT, 55020, true)
			spec:removeItem(8828, 1)
			spec:unregisterEvent("BaldurPlayerDeath")
			spec:unregisterEvent("BaldurPlayerLogout")
		end
	end

	return true
end

baldurDeath:register()

-- ============================================================
-- Boss Spawn Hook: Start mechanics when boss is created
-- Uses CreatureEvent onSpawn or we hook via the lever/spawn system
-- ============================================================
local baldurSpawn = CreatureEvent("BaldurTheAllfatherSpawn")

function baldurSpawn.onHealthChange(creature, attacker, primaryDamage, primaryType, secondaryDamage, secondaryType, origin)
	if not BaldurBoss or BaldurBoss._active then
		-- Already started, just pass through
		return primaryDamage, primaryType, secondaryDamage, secondaryType
	end

	-- First hit triggers the fight mechanics
	if attacker and attacker:isPlayer() then
		BaldurBoss.start(creature)
	end

	return primaryDamage, primaryType, secondaryDamage, secondaryType
end

baldurSpawn:register()

print(">> Baldur the Allfather death/spawn events loaded successfully!")
