-- Sylvareth the Unyielding — fight mechanics.
--
-- Boss has a chance to enter a "purify phase" every 10 seconds. While the
-- phase is active:
--   * Two icons show on the boss: 30s timer and 3-step counter.
--   * Boss is slowed.
--   * All damage dealt to the boss is reflected at 2x to the attacker (and the
--     boss itself takes no damage).
--   * A single hot sqm cycles between 7 fixed candidate positions every 5s.
--     The boss must be lured onto a hot sqm to consume one of the 3 steps.
--   * Reach 0 steps → phase ends cleanly.
--   * Reach 0 seconds without finishing → boss explodes for 95% max HP agony
--     to every player in the area, heals 10% max HP, enrages +50% damage 15s.

local cfg = SupremeVocation.NatureBoss

-- Internal helpers -----------------------------------------------------------

local function getBoss()
	if not NatureBoss.bossId then
		return nil
	end
	local boss = Creature(NatureBoss.bossId)
	if not boss then
		NatureBoss.bossId = nil
		return nil
	end
	return boss
end

local function clearStepEvents()
	if NatureBoss.tickEvent then
		stopEvent(NatureBoss.tickEvent)
		NatureBoss.tickEvent = nil
	end
	if NatureBoss.swapEvent then
		stopEvent(NatureBoss.swapEvent)
		NatureBoss.swapEvent = nil
	end
end

local function removeStepItem()
	if not NatureBoss.currentStepPos then
		return
	end
	local tile = Tile(NatureBoss.currentStepPos)
	if tile then
		local item = tile:getItemById(cfg.stepItemId)
		if item then
			item:remove()
		end
	end
	NatureBoss.currentStepPos = nil
end

local function chooseStepPos(exclude)
	local candidates = cfg.stepPositions
	if #candidates == 0 then
		return nil
	end
	if #candidates == 1 then
		return candidates[1]
	end
	local pick
	repeat
		pick = candidates[math.random(1, #candidates)]
	until not exclude or pick.x ~= exclude.x or pick.y ~= exclude.y or pick.z ~= exclude.z
	return pick
end

local function spawnStep(pos)
	local item = Game.createItem(cfg.stepItemId, 1, pos)
	if item then
		pos:sendMagicEffect(cfg.stepEffect)
	end
end

local function getPlayersInArea()
	local players = {}
	for _, creature in ipairs(Game.getSpectators(cfg.spawnPosition, false, true,
			cfg.spawnPosition.x - cfg.areaFrom.x,
			cfg.areaTo.x - cfg.spawnPosition.x,
			cfg.spawnPosition.y - cfg.areaFrom.y,
			cfg.areaTo.y - cfg.spawnPosition.y)) do
		if creature:isPlayer() then
			players[#players + 1] = creature
		end
	end
	return players
end

local function broadcastArea(text)
	for _, p in ipairs(getPlayersInArea()) do
		p:sendTextMessage(MESSAGE_EVENT_ADVANCE, text)
	end
end

local function setIcons(boss)
	-- Timer icon (30 → 0)
	boss:setIcon("sylvareth_timer", CreatureIconCategory_Quests, CreatureIconQuests_GreenShield, NatureBoss.phaseSecondsLeft)
	-- Steps icon (3 → 0)
	boss:setIcon("sylvareth_steps", CreatureIconCategory_Quests, CreatureIconQuests_RedBall, NatureBoss.phaseStepsLeft)
end

local function clearIcons(boss)
	boss:removeIcon("sylvareth_timer", CreatureIconCategory_Quests)
	boss:removeIcon("sylvareth_steps", CreatureIconCategory_Quests)
end

-- Phase control --------------------------------------------------------------

local function endPhase(reason)
	local boss = getBoss()
	clearStepEvents()
	removeStepItem()

	NatureBoss.phaseActive = false
	NatureBoss.phaseStepsLeft = 0
	NatureBoss.phaseSecondsLeft = 0

	if boss then
		clearIcons(boss)
		-- Undo the slow: apply the inverse of the phase penalty.
		boss:changeSpeed(-cfg.phaseSpeedPenalty)
		if reason == "completed" then
			boss:say("The grove rests... for now.", TALKTYPE_MONSTER_SAY)
		end
	end
end

local function detonate()
	local boss = getBoss()
	for _, player in ipairs(getPlayersInArea()) do
		local dmg = math.floor(player:getMaxHealth() * cfg.timeoutAgonyFraction)
		if dmg > 0 then
			doTargetCombatHealth(0, player, COMBAT_AGONYDAMAGE, -dmg, -dmg, CONST_ME_BLACKSMOKE)
		end
	end
	if boss then
		local heal = math.floor(boss:getMaxHealth() * cfg.timeoutHealFraction)
		if heal > 0 then
			boss:addHealth(heal)
		end
		boss:say("YOU FAILED THE GROVE!", TALKTYPE_MONSTER_YELL)
		NatureBoss.enrageUntil = os.time() + cfg.timeoutEnrageSeconds
	end
	broadcastArea("Sylvareth detonates! The grove burns with wrath!")
end

local function tickPhase()
	NatureBoss.tickEvent = nil
	if not NatureBoss.phaseActive then
		return
	end

	NatureBoss.phaseSecondsLeft = NatureBoss.phaseSecondsLeft - 1
	local boss = getBoss()
	if not boss then
		endPhase("aborted")
		return
	end

	setIcons(boss)

	if NatureBoss.phaseSecondsLeft <= 0 then
		detonate()
		endPhase("timeout")
		return
	end

	NatureBoss.tickEvent = addEvent(tickPhase, cfg.tickIntervalMs)
end

local function swapStep()
	NatureBoss.swapEvent = nil
	if not NatureBoss.phaseActive then
		return
	end
	removeStepItem()
	local newPos = chooseStepPos(NatureBoss.currentStepPos)
	if newPos then
		NatureBoss.currentStepPos = newPos
		spawnStep(newPos)
	end
	NatureBoss.swapEvent = addEvent(swapStep, cfg.stepSwapIntervalMs)
end

local function startPhase()
	local boss = getBoss()
	if not boss or NatureBoss.phaseActive then
		return
	end

	NatureBoss.phaseActive = true
	NatureBoss.phaseStepsLeft = cfg.stepsRequired
	NatureBoss.phaseSecondsLeft = cfg.phaseDurationSeconds

	-- Slow the boss (delta; reverted by -delta in endPhase).
	boss:changeSpeed(cfg.phaseSpeedPenalty)

	setIcons(boss)
	boss:say("The grove demands a price! Lure me to the marks!", TALKTYPE_MONSTER_YELL)

	-- First step appears immediately
	local firstPos = chooseStepPos(nil)
	if firstPos then
		NatureBoss.currentStepPos = firstPos
		spawnStep(firstPos)
	end

	NatureBoss.tickEvent = addEvent(tickPhase, cfg.tickIntervalMs)
	NatureBoss.swapEvent = addEvent(swapStep, cfg.stepSwapIntervalMs)
end

-- Public consumer of a step (boss steps onto hot sqm)
local function consumeStepIfBossOn(pos)
	if not NatureBoss.phaseActive or not NatureBoss.currentStepPos then
		return
	end
	if pos.x ~= NatureBoss.currentStepPos.x or pos.y ~= NatureBoss.currentStepPos.y or pos.z ~= NatureBoss.currentStepPos.z then
		return
	end
	NatureBoss.phaseStepsLeft = NatureBoss.phaseStepsLeft - 1
	removeStepItem()
	pos:sendMagicEffect(CONST_ME_HOLYAREA)

	local boss = getBoss()
	if boss then
		setIcons(boss)
	end

	if NatureBoss.phaseStepsLeft <= 0 then
		endPhase("completed")
		broadcastArea("Sylvareth has been brought to the marks. The grove yields.")
	else
		-- Reset swap timer on consume so the next mark gets a full window
		if NatureBoss.swapEvent then
			stopEvent(NatureBoss.swapEvent)
			NatureBoss.swapEvent = nil
		end
		swapStep()
	end
end

-- Health change: roll trigger + reflect
local sylvarethHealth = CreatureEvent("SylvarethSpawn")

function sylvarethHealth.onHealthChange(creature, attacker, primaryDamage, primaryType, secondaryDamage, secondaryType, origin)
	local boss = getBoss()
	if not boss or boss:getId() ~= creature:getId() then
		return primaryDamage, primaryType, secondaryDamage, secondaryType
	end

	-- During the purify phase: reflect damage 2x to attacker, boss takes none.
	if NatureBoss.phaseActive and attacker and attacker:isPlayer() then
		local reflectPrimary = primaryDamage * cfg.reflectMultiplier
		local reflectSecondary = secondaryDamage * cfg.reflectMultiplier
		if reflectPrimary < 0 then
			doTargetCombatHealth(0, attacker, COMBAT_EARTHDAMAGE, reflectPrimary, reflectPrimary, CONST_ME_HITBYPOISON)
		end
		if reflectSecondary < 0 then
			doTargetCombatHealth(0, attacker, COMBAT_EARTHDAMAGE, reflectSecondary, reflectSecondary, CONST_ME_HITBYPOISON)
		end
		return 0, primaryType, 0, secondaryType
	end

	-- Roll trigger. Use a per-boss cooldown via timestamp.
	local now = os.time()
	NatureBoss._lastRollAt = NatureBoss._lastRollAt or now
	if (now - NatureBoss._lastRollAt) * 1000 >= cfg.triggerCheckIntervalMs then
		NatureBoss._lastRollAt = now
		if math.random(1, 100) <= cfg.triggerChance then
			startPhase()
		end
	end

	return primaryDamage, primaryType, secondaryDamage, secondaryType
end

sylvarethHealth:register()

-- Death: clean up + grant storage to all damagers
local sylvarethDeath = CreatureEvent("SylvarethDeath")

function sylvarethDeath.onDeath(creature)
	endPhase("aborted")
	NatureBoss.bossId = nil
	NatureBoss.enrageUntil = 0

	local damageMap = creature:getDamageMap() or {}
	for playerId, _ in pairs(damageMap) do
		SupremeVocation.grantNatureBossReward(playerId)
		local p = Player(playerId)
		if p then
			p:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The grove acknowledges your strike. The sealed door beyond yields to you.")
		end
	end
	return true
end

sylvarethDeath:register()

-- Movement listener: watch the boss; if it stands on the current step, consume.
-- Implemented via a tile MoveEvent on each candidate sqm.
for _, pos in ipairs(cfg.stepPositions) do
	local stepIn = MoveEvent()
	stepIn:type("stepin")
	function stepIn.onStepIn(creature, item, position, fromPosition)
		if not NatureBoss.phaseActive then
			return true
		end
		local monster = creature:getMonster()
		if not monster or monster:getName() ~= cfg.name then
			return true
		end
		consumeStepIfBossOn(position)
		return true
	end
	stepIn:position(pos)
	stepIn:register()
end
