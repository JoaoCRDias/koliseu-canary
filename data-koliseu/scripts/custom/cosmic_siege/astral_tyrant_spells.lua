-- Astral Tyrant - Custom Spells
-- Siege 1500 Boss Special Mechanics

-- ============================================================
-- SPELL 1: Reality Fracture
-- Creates rifts in reality that trap and damage players
-- Rifts persist for 8 seconds, damaging anyone standing on them
-- ============================================================

local realityFracture = Spell("instant")

-- Store active rifts
local activeRifts = {}

function realityFracture.onCastSpell(creature, variant)
	local creaturePos = creature:getPosition()

	-- Create 8-12 random rifts around the boss
	local riftCount = math.random(8, 12)

	for i = 1, riftCount do
		local riftPos = Position(
			creaturePos.x + math.random(-7, 7),
			creaturePos.y + math.random(-7, 7),
			creaturePos.z
		)

		local tile = Tile(riftPos)
		if tile and not tile:hasFlag(TILESTATE_BLOCKSOLID) then
			-- Visual warning
			riftPos:sendMagicEffect(CONST_ME_PINK_BEAM)

			-- Create rift after 1 second
			addEvent(function(pos, bossId)
				-- Store rift
				local riftId = pos.x .. "_" .. pos.y .. "_" .. pos.z
				activeRifts[riftId] = {
					position = pos,
					bossId = bossId,
					endTime = os.time() + 8
				}

				-- Rift visual and damage every 0.5 seconds for 8 seconds
				local function riftTick(tickPos, tickBossId, ticksLeft)
					if ticksLeft <= 0 then
						local tickRiftId = tickPos.x .. "_" .. tickPos.y .. "_" .. tickPos.z
						activeRifts[tickRiftId] = nil
						tickPos:sendMagicEffect(CONST_ME_POFF)
						return
					end

					-- Visual effect
					tickPos:sendMagicEffect(CONST_ME_PURPLEENERGY)

					-- Damage players on rift
					local boss = Creature(tickBossId)
					if boss then
						local specs = Game.getSpectators(tickPos, false, true, 0, 0, 0, 0)
						for _, target in ipairs(specs) do
							if target:isPlayer() then
								doTargetCombatHealth(boss:getId(), target, COMBAT_ENERGYDAMAGE, -500, -800, CONST_ME_ENERGYHIT)
							end
						end
					end

					-- Schedule next tick
					addEvent(riftTick, 500, tickPos, tickBossId, ticksLeft - 1)
				end

				-- Start rift ticks (16 ticks = 8 seconds)
				riftTick(pos, bossId, 16)
			end, 1000, riftPos, creature:getId())
		end
	end

	return true
end

realityFracture:name("astral_tyrant_reality_fracture")
realityFracture:words("###607")
realityFracture:isAggressive(true)
realityFracture:blockWalls(true)
realityFracture:needLearn(true)
realityFracture:register()

-- ============================================================
-- SPELL 2: Astral Judgment
-- Boss channels cosmic power for 3 seconds (immune during channel)
-- Then unleashes devastating damage to all players based on distance
-- ============================================================

local astralJudgment = Spell("instant")

function astralJudgment.onCastSpell(creature, variant)
	local creaturePos = creature:getPosition()

	-- Visual channeling effect
	creaturePos:sendMagicEffect(CONST_ME_HOLYAREA)
	creature:say("ASTRAL JUDGMENT!", TALKTYPE_MONSTER_YELL)

	-- Channeling effects every 0.5 seconds
	for i = 1, 6 do
		addEvent(function(pos)
			pos:sendMagicEffect(CONST_ME_HOLYDAMAGE)

			-- Expanding ring effect
			for radius = 1, 3 do
				for x = -radius, radius do
					for y = -radius, radius do
						if math.abs(x) == radius or math.abs(y) == radius then
							local effectPos = Position(pos.x + x, pos.y + y, pos.z)
							effectPos:sendMagicEffect(CONST_ME_HOLYAREA)
						end
					end
				end
			end
		end, i * 500, creaturePos)
	end

	-- After 3 seconds, unleash judgment
	addEvent(function(pos, creatureId)
		local boss = Creature(creatureId)
		if not boss then
			return
		end

		-- Massive visual effect
		pos:sendMagicEffect(CONST_ME_HOLYDAMAGE)

		-- Get all players in large radius
		local specs = Game.getSpectators(pos, false, true, 15, 15, 15, 15)

		for _, target in ipairs(specs) do
			if target:isPlayer() then
				local targetPos = target:getPosition()
				local distance = math.max(
					math.abs(targetPos.x - pos.x),
					math.abs(targetPos.y - pos.y)
				)

				-- Damage decreases with distance
				local baseDamage = 3000
				local damageReduction = distance * 150
				local finalDamage = math.max(baseDamage - damageReduction, 600)

				-- Send beam from boss to player
				pos:sendDistanceEffect(targetPos, CONST_ANI_HOLY)

				-- Apply damage
				doTargetCombatHealth(boss:getId(), target, COMBAT_HOLYDAMAGE, -finalDamage, -finalDamage, CONST_ME_HOLYDAMAGE)
			end
		end
	end, 3000, creaturePos, creature:getId())

	return true
end

astralJudgment:name("astral_tyrant_astral_judgment")
astralJudgment:words("###608")
astralJudgment:isAggressive(true)
astralJudgment:blockWalls(true)
astralJudgment:needLearn(true)
astralJudgment:register()

-- ============================================================
-- SPELL 3: Dimensional Shift
-- Boss creates copies of itself that also attack
-- Copies last for 15 seconds
-- ============================================================

local dimensionalShift = Spell("instant")

function dimensionalShift.onCastSpell(creature, variant)
	local creaturePos = creature:getPosition()

	-- Create 2-3 illusions
	local illusionCount = math.random(2, 3)

	for i = 1, illusionCount do
		-- Find random position around boss
		local angle = (math.pi * 2 / illusionCount) * i
		local distance = 3
		local illusionPos = Position(
			creaturePos.x + math.floor(math.cos(angle) * distance),
			creaturePos.y + math.floor(math.sin(angle) * distance),
			creaturePos.z
		)

		local tile = Tile(illusionPos)
		if tile and not tile:hasFlag(TILESTATE_BLOCKSOLID) then
			-- Spawn illusion
			local illusion = Game.createMonster("Astral Tyrant", illusionPos, false, true)
			if illusion then
				illusionPos:sendMagicEffect(CONST_ME_TELEPORT)

				-- Make illusion weaker
				illusion:setMaxHealth(illusion:getMaxHealth() / 4)
				illusion:setHealth(illusion:getMaxHealth())

				-- Remove illusion after 15 seconds
				addEvent(function(illusionId)
					local illu = Creature(illusionId)
					if illu then
						local pos = illu:getPosition()
						pos:sendMagicEffect(CONST_ME_POFF)
						illu:remove()
					end
				end, 15000, illusion:getId())
			end
		end
	end

	return true
end

dimensionalShift:name("astral_tyrant_dimensional_shift")
dimensionalShift:words("###609")
dimensionalShift:isAggressive(true)
dimensionalShift:blockWalls(true)
dimensionalShift:needLearn(true)
dimensionalShift:register()

print(">> Astral Tyrant spells loaded successfully!")
