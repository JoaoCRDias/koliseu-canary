-- Eclipse Sovereign - Custom Spells
-- Siege 1000 Boss Special Mechanics

-- ============================================================
-- SPELL 1: Shadow Eclipse
-- Boss becomes immune and invisible for 3 seconds
-- Then appears behind a random player dealing massive damage
-- ============================================================

local shadowEclipse = Spell("instant")

function shadowEclipse.onCastSpell(creature, variant)
	local creaturePos = creature:getPosition()

	-- Make boss invisible
	creature:setOutfit({lookTypeEx = 0})
	creaturePos:sendMagicEffect(CONST_ME_POFF)

	-- Get all players in area
	local specs = Game.getSpectators(creaturePos, false, true, 10, 10, 10, 10)
	local players = {}
	for _, spec in ipairs(specs) do
		if spec:isPlayer() then
			table.insert(players, spec)
		end
	end

	if #players == 0 then
		-- Restore outfit if no players
		creature:setOutfit({lookType = 3110})
		return false
	end

	-- After 3 seconds, teleport behind random player
	addEvent(function(creatureId, playerList, originalOutfit)
		local boss = Creature(creatureId)
		if not boss then
			return
		end

		local target = playerList[math.random(#playerList)]
		if not target or not target:isPlayer() then
			boss:setOutfit({lookType = 3110})
			return
		end

		local targetPos = target:getPosition()
		-- Find position behind player
		local behindPos = Position(targetPos.x - 1, targetPos.y - 1, targetPos.z)

		-- Try to find valid position around target
		local positions = {
			Position(targetPos.x - 1, targetPos.y, targetPos.z),
			Position(targetPos.x + 1, targetPos.y, targetPos.z),
			Position(targetPos.x, targetPos.y - 1, targetPos.z),
			Position(targetPos.x, targetPos.y + 1, targetPos.z),
			Position(targetPos.x - 1, targetPos.y - 1, targetPos.z),
			Position(targetPos.x + 1, targetPos.y - 1, targetPos.z),
			Position(targetPos.x - 1, targetPos.y + 1, targetPos.z),
			Position(targetPos.x + 1, targetPos.y + 1, targetPos.z),
		}

		for _, pos in ipairs(positions) do
			local tile = Tile(pos)
			if tile and not tile:hasFlag(TILESTATE_BLOCKSOLID) then
				boss:teleportTo(pos)
				pos:sendMagicEffect(CONST_ME_TELEPORT)

				-- Deal damage
				doTargetCombatHealth(boss:getId(), target, COMBAT_DEATHDAMAGE, -1500, -2500, CONST_ME_MORTAREA)
				break
			end
		end

		-- Restore outfit
		boss:setOutfit({lookType = 3110})
	end, 3000, creature:getId(), players, creature:getOutfit())

	return true
end

shadowEclipse:name("eclipse_sovereign_shadow_eclipse")
shadowEclipse:words("###605")
shadowEclipse:isAggressive(true)
shadowEclipse:blockWalls(true)
shadowEclipse:needLearn(true)
shadowEclipse:register()

-- ============================================================
-- SPELL 2: Lunar Beams
-- Shoots multiple beams from the boss in cardinal directions
-- Each beam travels and damages everything in its path
-- ============================================================

local lunarBeams = Spell("instant")

function lunarBeams.onCastSpell(creature, variant)
	local centerPos = creature:getPosition()
	local creatureId = creature:getId()

	-- Track players already hit in this cast to avoid multiple hits
	local hitPlayers = {}

	-- Directions: North, South, East, West, NE, NW, SE, SW
	local directions = {
		{x = 0, y = -1},  -- North
		{x = 0, y = 1},   -- South
		{x = 1, y = 0},   -- East
		{x = -1, y = 0},  -- West
		{x = 1, y = -1},  -- NE
		{x = -1, y = -1}, -- NW
		{x = 1, y = 1},   -- SE
		{x = -1, y = 1},  -- SW
	}

	for _, dir in ipairs(directions) do
		-- Shoot beam in this direction
		for distance = 1, 8 do
			local beamPos = Position(
				centerPos.x + (dir.x * distance),
				centerPos.y + (dir.y * distance),
				centerPos.z
			)

			-- Schedule effect and damage
			addEvent(function(pos, bossId, alreadyHit)
				pos:sendMagicEffect(CONST_ME_ENERGYHIT)

				local boss = Creature(bossId)
				if not boss then
					return
				end

				local specs = Game.getSpectators(pos, false, true, 0, 0, 0, 0)
				for _, target in ipairs(specs) do
					if target:isPlayer() and not alreadyHit[target:getId()] then
						alreadyHit[target:getId()] = true
						doTargetCombatHealth(bossId, target, COMBAT_HOLYDAMAGE, -900, -1500, CONST_ME_NONE)
					end
				end
			end, distance * 100, beamPos, creatureId, hitPlayers)
		end
	end

	return true
end

lunarBeams:name("eclipse_sovereign_lunar_beams")
lunarBeams:words("###606")
lunarBeams:isAggressive(true)
lunarBeams:blockWalls(false)
lunarBeams:needLearn(true)
lunarBeams:register()

print(">> Eclipse Sovereign spells loaded successfully!")
