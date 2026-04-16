-- Nebular Warlord - Custom Spells
-- Siege 500 Boss Special Mechanics

-- ============================================================
-- SPELL 1: Nebular Chains
-- Creates void chains that pull players towards the boss
-- Shows purple energy chains effect and deals damage over time
-- ============================================================

local nebularChains = Spell("instant")

function nebularChains.onCastSpell(creature, variant)
	local creaturePos = creature:getPosition()

	-- Get all players in 7 sqm radius
	local specs = Game.getSpectators(creaturePos, false, true, 7, 7, 7, 7)

	for _, target in ipairs(specs) do
		if target:isPlayer() then
			local targetPos = target:getPosition()

			-- Visual effect: purple chain
			creaturePos:sendDistanceEffect(targetPos, CONST_ANI_ENERGY)
			targetPos:sendMagicEffect(CONST_ME_PURPLEENERGY)

			-- Pull player 1-2 sqms towards boss
			local dirX = creaturePos.x > targetPos.x and 1 or (creaturePos.x < targetPos.x and -1 or 0)
			local dirY = creaturePos.y > targetPos.y and 1 or (creaturePos.y < targetPos.y and -1 or 0)

			local pullPos = Position(targetPos.x + dirX, targetPos.y + dirY, targetPos.z)
			local tile = Tile(pullPos)
			if tile and not tile:hasFlag(TILESTATE_BLOCKSOLID) then
				target:teleportTo(pullPos)
				pullPos:sendMagicEffect(CONST_ME_TELEPORT)
			end

			-- Apply damage over time
			doTargetCombatHealth(creature:getId(), target, COMBAT_ENERGYDAMAGE, -800, -1200, CONST_ME_ENERGYHIT)
		end
	end

	return true
end

nebularChains:name("nebular_warlord_chains")
nebularChains:words("###603")
nebularChains:isAggressive(true)
nebularChains:blockWalls(true)
nebularChains:needLearn(true)
nebularChains:register()

-- ============================================================
-- SPELL 2: Void Collapse
-- Creates a black hole at boss position that sucks players in
-- and deals massive damage to those nearby
-- ============================================================

local voidCollapse = Spell("instant")

function voidCollapse.onCastSpell(creature, variant)
	local centerPos = creature:getPosition()

	-- Warning effect
	centerPos:sendMagicEffect(CONST_ME_BLACK_BLOOD)

	-- After 1.5 seconds, create the void collapse
	addEvent(function(pos, creatureId)
		local boss = Creature(creatureId)
		if not boss then
			return
		end

		-- Visual effect of void collapsing
		for radius = 1, 5 do
			for x = -radius, radius do
				for y = -radius, radius do
					if math.abs(x) == radius or math.abs(y) == radius then
						local effectPos = Position(pos.x + x, pos.y + y, pos.z)
						effectPos:sendMagicEffect(CONST_ME_PURPLEENERGY)
					end
				end
			end
		end

		-- Damage in 5 sqm radius
		local specs = Game.getSpectators(pos, false, true, 5, 5, 5, 5)
		for _, target in ipairs(specs) do
			if target:isPlayer() then
				local distance = math.max(math.abs(target:getPosition().x - pos.x), math.abs(target:getPosition().y - pos.y))
				local damage = 3000 - (distance * 400) -- More damage closer to center
				doTargetCombatHealth(boss:getId(), target, COMBAT_DEATHDAMAGE, -damage, -damage, CONST_ME_MORTAREA)
			end
		end
	end, 1500, centerPos, creature:getId())

	return true
end

voidCollapse:name("nebular_warlord_void_collapse")
voidCollapse:words("###604")
voidCollapse:isAggressive(true)
voidCollapse:blockWalls(true)
voidCollapse:needLearn(true)
voidCollapse:register()

print(">> Nebular Warlord spells loaded successfully!")
