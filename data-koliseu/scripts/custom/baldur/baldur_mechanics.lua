-- ============================================================
-- Baldur the Allfather - Boss Mechanics
-- ============================================================
-- Mechanic 1: Sentinel Spawn (30s) -> lives 10s -> transforms to Conduit if not killed
--             Sentinel death = RESET boss shield + damage boost directly
-- Mechanic 2: Shield stacking (+10% dmg per level every 15s)
-- Mechanic 3: Doom Counter (60s) -> debuff on 0 -> Bearer spawns -> debuff intensifies
--             Bearer lives 10s, if not killed + essence used, debuff gets worse
-- ============================================================

local ROOM_CENTER = Position(3054, 3106, 4)
local ROOM_FROM = Position(3045, 3095, 4)
local ROOM_TO = Position(3063, 3118, 4)
local DOOM_COUNTER_POS = Position(3048, 3104, 4)

local RUNIC_ESSENCE_ID = 8828
local DOOM_COUNTER_ITEM_ID = 33890

local CONDID_SHIELD_DAMAGE = 55010
local CONDID_SKILL_DEBUFF = 55020

local MINION_SPAWN_INTERVAL = 30000
local MINION_ALIVE_TIME = 10000
local SHIELD_TICK_INTERVAL = 15000
local CONDUIT_HEAL_INTERVAL = 2000
local DOOM_COUNTER_TOTAL = 30
local DOOM_TICK_INTERVAL = 1000
local BOSS_HEAL_AMOUNT = 200000
local BEARER_ALIVE_TIME = 15000
local BEARER_RESPAWN_DELAY = 5000

-- ============================================================
-- STATE MANAGEMENT
-- ============================================================
BaldurBoss = BaldurBoss or {}

function BaldurBoss.reset()
	if BaldurBoss._minionEvent then stopEvent(BaldurBoss._minionEvent) end
	if BaldurBoss._shieldEvent then stopEvent(BaldurBoss._shieldEvent) end
	if BaldurBoss._doomEvent then stopEvent(BaldurBoss._doomEvent) end
	if BaldurBoss._conduitHealEvent then stopEvent(BaldurBoss._conduitHealEvent) end
	if BaldurBoss._bearerDespawnEvent then stopEvent(BaldurBoss._bearerDespawnEvent) end
	if BaldurBoss._bearerRespawnEvent then stopEvent(BaldurBoss._bearerRespawnEvent) end

	BaldurBoss._bossId = nil
	BaldurBoss._shieldLevel = 0
	BaldurBoss._doomCounter = DOOM_COUNTER_TOTAL
	BaldurBoss._debuffLevel = 0
	BaldurBoss._minionEvent = nil
	BaldurBoss._shieldEvent = nil
	BaldurBoss._doomEvent = nil
	BaldurBoss._conduitHealEvent = nil
	BaldurBoss._conduitId = nil
	BaldurBoss._bearerId = nil
	BaldurBoss._bearerDespawnEvent = nil
	BaldurBoss._bearerRespawnEvent = nil
	BaldurBoss._active = false
end

local function getPlayersInRoom()
	local cx = math.floor((ROOM_FROM.x + ROOM_TO.x) / 2)
	local cy = math.floor((ROOM_FROM.y + ROOM_TO.y) / 2)
	local rx = math.ceil((ROOM_TO.x - ROOM_FROM.x) / 2)
	local ry = math.ceil((ROOM_TO.y - ROOM_FROM.y) / 2)
	local specs = Game.getSpectators(Position(cx, cy, ROOM_FROM.z), false, true, rx, rx, ry, ry)
	local players = {}
	for _, spec in ipairs(specs) do
		if spec:isPlayer() then
			table.insert(players, spec)
		end
	end
	return players
end

local function getBoss()
	if not BaldurBoss._bossId then return nil end
	local boss = Creature(BaldurBoss._bossId)
	if boss and boss:getHealth() > 0 then
		return boss
	end
	return nil
end

-- ============================================================
-- MECHANIC 1: Shield System
-- ============================================================
local function updateShieldIcon(boss, level)
	if level > 0 then
		boss:setIcon("baldur_shield", CreatureIconCategory_Modifications, CreatureIconModifications_ReducedHealthExclamation, level)
	else
		boss:removeIcon("baldur_shield")
	end
end

local function applyShieldDamageBoost(boss, level)
	boss:removeCondition(CONDITION_ATTRIBUTES, CONDITIONID_COMBAT, CONDID_SHIELD_DAMAGE)

	if level <= 0 then return end

	local dmgPercent = 100 + (level * 20)
	local cond = Condition(CONDITION_ATTRIBUTES)
	cond:setParameter(CONDITION_PARAM_TICKS, -1)
	cond:setParameter(CONDITION_PARAM_SUBID, CONDID_SHIELD_DAMAGE)
	cond:setParameter(CONDITION_PARAM_BUFF_DAMAGEDEALT, dmgPercent)
	boss:addCondition(cond)
end

local function resetBossShield()
	local boss = getBoss()
	if not boss then return end

	BaldurBoss._shieldLevel = 0
	updateShieldIcon(boss, 0)
	applyShieldDamageBoost(boss, 0)

	boss:getPosition():sendMagicEffect(CONST_ME_HOLYAREA)
	boss:say("NO! The runic seal breaks my shield!", TALKTYPE_MONSTER_SAY)

	local players = getPlayersInRoom()
	for _, player in ipairs(players) do
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "[Baldur] Rune Sentinel destroyed! The boss's shield has been RESET!")
	end
end

local function shieldTick()
	if not BaldurBoss._active then return end
	local boss = getBoss()
	if not boss then return end

	BaldurBoss._shieldLevel = BaldurBoss._shieldLevel + 1
	updateShieldIcon(boss, BaldurBoss._shieldLevel)
	applyShieldDamageBoost(boss, BaldurBoss._shieldLevel)

	local players = getPlayersInRoom()
	for _, player in ipairs(players) do
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("[Baldur] Shield level increased to %d! (+%d%% damage)", BaldurBoss._shieldLevel, BaldurBoss._shieldLevel * 20))
	end

	boss:say(string.format("My divine shield grows stronger! Level %d!", BaldurBoss._shieldLevel), TALKTYPE_MONSTER_SAY)

	BaldurBoss._shieldEvent = addEvent(shieldTick, SHIELD_TICK_INTERVAL)
end

-- ============================================================
-- MECHANIC 2: Sentinel Spawn + Transform to Conduit
-- ============================================================
local function stopConduitHeal()
	if BaldurBoss._conduitHealEvent then
		stopEvent(BaldurBoss._conduitHealEvent)
		BaldurBoss._conduitHealEvent = nil
	end
	BaldurBoss._conduitId = nil
end

local function conduitHealTick()
	if not BaldurBoss._active then return end

	local conduit = nil
	if BaldurBoss._conduitId then
		conduit = Creature(BaldurBoss._conduitId)
	end
	if not conduit or conduit:getHealth() <= 0 then
		stopConduitHeal()
		return
	end

	local boss = getBoss()
	if not boss then
		stopConduitHeal()
		return
	end

	local conduitPos = conduit:getPosition()
	local bossPos = boss:getPosition()

	conduitPos:sendMagicEffect(CONST_ME_HOLYAREA)

	boss:addHealth(BOSS_HEAL_AMOUNT)
	bossPos:sendMagicEffect(CONST_ME_MAGIC_BLUE)
	conduitPos:sendDistanceEffect(bossPos, CONST_ANI_HOLY)

	local players = getPlayersInRoom()
	for _, player in ipairs(players) do
		player:sendTextMessage(MESSAGE_GAME_HIGHLIGHT, "[Baldur] The Divine Conduit heals the boss for 200,000 HP! Kill it!")
	end

	BaldurBoss._conduitHealEvent = addEvent(conduitHealTick, CONDUIT_HEAL_INTERVAL)
end

local function transformSentinelToConduit(sentinelId)
	if not BaldurBoss._active then return end

	local sentinel = Creature(sentinelId)
	if not sentinel or sentinel:getHealth() <= 0 then
		return
	end

	local sentinelPos = sentinel:getPosition()
	sentinel:remove()

	local conduit = Game.createMonster("Allfather's Divine Conduit", sentinelPos, false, true)
	if conduit then
		BaldurBoss._conduitId = conduit:getId()
		sentinelPos:sendMagicEffect(CONST_ME_HOLYDAMAGE)
		conduit:say("The rune transforms! Divine energy flows!", TALKTYPE_MONSTER_SAY)

		conduit:registerEvent("BaldurMinionDeath")

		BaldurBoss._conduitHealEvent = addEvent(conduitHealTick, CONDUIT_HEAL_INTERVAL)
	end
end

local function spawnMinion()
	if not BaldurBoss._active then return end
	local boss = getBoss()
	if not boss then return end

	local sentinel = Game.createMonster("Allfather's Rune Sentinel", ROOM_CENTER, false, true)
	if sentinel then
		ROOM_CENTER:sendMagicEffect(CONST_ME_TELEPORT)
		sentinel:say("A Rune Sentinel materializes!", TALKTYPE_MONSTER_SAY)

		sentinel:registerEvent("BaldurMinionDeath")

		addEvent(transformSentinelToConduit, MINION_ALIVE_TIME, sentinel:getId())

		local players = getPlayersInRoom()
		for _, player in ipairs(players) do
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "[Baldur] A Rune Sentinel appeared! Kill it within 10 seconds or it will transform!")
		end
	end

	BaldurBoss._minionEvent = addEvent(spawnMinion, MINION_SPAWN_INTERVAL)
end

-- ============================================================
-- MECHANIC 3: Doom Counter + Skill Debuff + Bearer
-- ============================================================

local spawnRunicBearer
local amplifyDebuff

local function getDebuffPercent(level)
	if level <= 0 then return 100 end
	if level == 1 then return 20 end
	if level == 2 then return 10 end
	return 5
end

local function applySkillDebuff(level)
	if level <= 0 then return end
	BaldurBoss._debuffLevel = level

	local pct = getDebuffPercent(level)
	local players = getPlayersInRoom()

	for _, player in ipairs(players) do
		player:removeCondition(CONDITION_ATTRIBUTES, CONDITIONID_COMBAT, CONDID_SKILL_DEBUFF)

		local cond = Condition(CONDITION_ATTRIBUTES)
		cond:setParameter(CONDITION_PARAM_TICKS, -1)
		cond:setParameter(CONDITION_PARAM_SUBID, CONDID_SKILL_DEBUFF)
		cond:setParameter(CONDITION_PARAM_SKILL_MELEEPERCENT, pct)
		cond:setParameter(CONDITION_PARAM_SKILL_FISTPERCENT, pct)
		cond:setParameter(CONDITION_PARAM_SKILL_DISTANCEPERCENT, pct)
		cond:setParameter(CONDITION_PARAM_SKILL_SHIELDPERCENT, pct)
		cond:setParameter(CONDITION_PARAM_STAT_MAGICPOINTSPERCENT, pct)
		player:addCondition(cond)

		player:sendTextMessage(MESSAGE_GAME_HIGHLIGHT, string.format("[Baldur] DOOM! Your skills have been reduced to %d%%! (Level %d)", pct, level))
		player:getPosition():sendMagicEffect(CONST_ME_MORTAREA)
	end
end

local function removeSkillDebuff()
	if BaldurBoss._debuffLevel <= 0 then return end
	BaldurBoss._debuffLevel = 0

	local players = getPlayersInRoom()
	for _, player in ipairs(players) do
		player:removeCondition(CONDITION_ATTRIBUTES, CONDITIONID_COMBAT, CONDID_SKILL_DEBUFF, true)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "[Baldur] The doom has been lifted! Skills restored!")
		player:getPosition():sendMagicEffect(CONST_ME_MAGIC_GREEN)
	end
end

local function removeBearer()
	if BaldurBoss._bearerDespawnEvent then
		stopEvent(BaldurBoss._bearerDespawnEvent)
		BaldurBoss._bearerDespawnEvent = nil
	end
	if BaldurBoss._bearerRespawnEvent then
		stopEvent(BaldurBoss._bearerRespawnEvent)
		BaldurBoss._bearerRespawnEvent = nil
	end
	if BaldurBoss._bearerId then
		local bearer = Creature(BaldurBoss._bearerId)
		if bearer and bearer:getHealth() > 0 then
			bearer:remove()
		end
		BaldurBoss._bearerId = nil
	end
end

local function onBearerTimeout()
	if not BaldurBoss._active then return end

	if BaldurBoss._bearerId then
		local bearer = Creature(BaldurBoss._bearerId)
		if bearer and bearer:getHealth() > 0 then
			local pos = bearer:getPosition()
			pos:sendMagicEffect(CONST_ME_POFF)
			bearer:remove()
		end
		BaldurBoss._bearerId = nil
	end
	BaldurBoss._bearerDespawnEvent = nil

	amplifyDebuff()
end

amplifyDebuff = function()
	if not BaldurBoss._active then return end

	local newLevel = (BaldurBoss._debuffLevel or 0) + 1
	applySkillDebuff(newLevel)

	local boss = getBoss()
	if boss then
		boss:say("Your resistance crumbles further! The doom deepens!", TALKTYPE_MONSTER_SAY)
	end

	local players = getPlayersInRoom()
	for _, player in ipairs(players) do
		player:sendTextMessage(MESSAGE_GAME_HIGHLIGHT, string.format("[Baldur] The debuff intensifies! Level %d! Kill the Runic Bearer and use its essence!", newLevel))
	end

	BaldurBoss._bearerRespawnEvent = addEvent(function()
		BaldurBoss._bearerRespawnEvent = nil
		if BaldurBoss._active and BaldurBoss._debuffLevel > 0 then
			spawnRunicBearer()
		end
	end, BEARER_RESPAWN_DELAY)
end

spawnRunicBearer = function()
	if not BaldurBoss._active then return end
	local boss = getBoss()
	if not boss then return end

	if BaldurBoss._bearerId then
		local existing = Creature(BaldurBoss._bearerId)
		if existing and existing:getHealth() > 0 then
			return
		end
	end

	local offsets = { { -3, -3 }, { 3, -3 }, { -3, 3 }, { 3, 3 } }
	local pick = offsets[math.random(#offsets)]
	local spawnPos = Position(ROOM_CENTER.x + pick[1], ROOM_CENTER.y + pick[2], ROOM_CENTER.z)

	local bearer = Game.createMonster("Allfather's Runic Bearer", spawnPos, false, true)
	if bearer then
		BaldurBoss._bearerId = bearer:getId()
		spawnPos:sendMagicEffect(CONST_ME_TELEPORT)
		bearer:say("The runes of the Allfather manifest!", TALKTYPE_MONSTER_SAY)

		bearer:registerEvent("BaldurMinionDeath")

		local players = getPlayersInRoom()
		for _, player in ipairs(players) do
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "[Baldur] A Runic Bearer appeared! Kill it and use the Runic Essence on the doom counter within 10 seconds!")
		end

		BaldurBoss._bearerDespawnEvent = addEvent(onBearerTimeout, BEARER_ALIVE_TIME)
	end
end

local function doomCounterTick()
	if not BaldurBoss._active then return end

	BaldurBoss._doomCounter = BaldurBoss._doomCounter - 1

	local boss = getBoss()
	local players = getPlayersInRoom()

	-- Show countdown as monster say on the doom counter position
	if boss and BaldurBoss._doomCounter > 0 then
		boss:say(tostring(BaldurBoss._doomCounter), TALKTYPE_MONSTER_SAY, false, nil, DOOM_COUNTER_POS)
	end

	if BaldurBoss._doomCounter == 30 or BaldurBoss._doomCounter == 15 or BaldurBoss._doomCounter == 10 then
		for _, player in ipairs(players) do
			player:sendTextMessage(MESSAGE_GAME_HIGHLIGHT, string.format("[Baldur] DOOM COUNTER: %d seconds remaining!", BaldurBoss._doomCounter))
		end
		DOOM_COUNTER_POS:sendMagicEffect(CONST_ME_MAGIC_RED)
	elseif BaldurBoss._doomCounter <= 5 and BaldurBoss._doomCounter > 0 then
		for _, player in ipairs(players) do
			player:sendTextMessage(MESSAGE_GAME_HIGHLIGHT, string.format("[Baldur] DOOM COUNTER: %d!", BaldurBoss._doomCounter))
		end
		DOOM_COUNTER_POS:sendMagicEffect(CONST_ME_MORTAREA)
	end

	if BaldurBoss._doomCounter <= 0 then
		applySkillDebuff(1)

		if boss then
			boss:say("Your feeble efforts crumble! The doom consumes you!", TALKTYPE_MONSTER_SAY)
		end
		DOOM_COUNTER_POS:sendMagicEffect(CONST_ME_MORTAREA)

		spawnRunicBearer()
		return
	end

	BaldurBoss._doomEvent = addEvent(doomCounterTick, DOOM_TICK_INTERVAL)
end

-- ============================================================
-- MINION DEATH EVENT
-- ============================================================
local minionDeath = CreatureEvent("BaldurMinionDeath")

function minionDeath.onDeath(creature)
	local creatureName = creature:getName()
	local deathPos = creature:getPosition()
	local isConduit = BaldurBoss._conduitId and creature:getId() == BaldurBoss._conduitId
	local isBearer = BaldurBoss._bearerId and creature:getId() == BaldurBoss._bearerId
	if not BaldurBoss._active then return true end

	if isConduit then
		stopConduitHeal()
		deathPos:sendMagicEffect(CONST_ME_HOLYAREA)

		local players = getPlayersInRoom()
		for _, player in ipairs(players) do
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "[Baldur] Divine Conduit destroyed! The healing has stopped.")
		end
		return true
	end

	if isBearer then
		if BaldurBoss._bearerDespawnEvent then
			stopEvent(BaldurBoss._bearerDespawnEvent)
			BaldurBoss._bearerDespawnEvent = nil
		end
		BaldurBoss._bearerId = nil

		local essence = Game.createItem(RUNIC_ESSENCE_ID, 1, deathPos)
		if essence then
			deathPos:sendMagicEffect(CONST_ME_HOLYDAMAGE)
		end

		local players = getPlayersInRoom()
		for _, player in ipairs(players) do
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "[Baldur] Runic Bearer destroyed! Use the Runic Essence on the doom counter to lift the curse!")
		end
		return true
	end

	if creatureName == "Allfather's Rune Sentinel" then
		deathPos:sendMagicEffect(CONST_ME_HOLYAREA)
		resetBossShield()
		return true
	end

	return true
end

minionDeath:register()

-- ============================================================
-- ACTION: Use Runic Essence on doom counter item
-- ============================================================
local useRunicEssence = Action()

function useRunicEssence.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if not target or target:getId() ~= DOOM_COUNTER_ITEM_ID then
		return false
	end

	if not BaldurBoss._active then
		player:sendCancelMessage("There is no active fight.")
		return true
	end

	item:remove(1)

	BaldurBoss._doomCounter = DOOM_COUNTER_TOTAL

	removeSkillDebuff()
	removeBearer()

	if BaldurBoss._doomEvent then
		stopEvent(BaldurBoss._doomEvent)
	end
	BaldurBoss._doomEvent = addEvent(doomCounterTick, DOOM_TICK_INTERVAL)

	toPosition:sendMagicEffect(CONST_ME_HOLYAREA)
	player:say("The doom counter has been reset!", TALKTYPE_MONSTER_SAY)

	local players = getPlayersInRoom()
	for _, p in ipairs(players) do
		p:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("[Baldur] %s used a Runic Essence! Doom counter reset! Debuffs removed!", player:getName()))
	end

	return true
end

useRunicEssence:id(RUNIC_ESSENCE_ID)
useRunicEssence:register()

-- ============================================================
-- ROOM CHECK: GlobalEvent to monitor boss room
-- ============================================================
local bossPositionCheck = GlobalEvent("BaldurBossPositionCheck")

function bossPositionCheck.onThink(interval)
	if not BaldurBoss._active then return true end

	local players = getPlayersInRoom()
	if #players == 0 then
		local boss = getBoss()
		if boss then
			boss:remove()
		end
		BaldurBoss.stop()
		return true
	end

	return true
end

bossPositionCheck:interval(500)
bossPositionCheck:register()

-- ============================================================
-- PLAYER CLEANUP: Remove debuff, essences, and events
-- ============================================================
local function cleanupPlayer(player)
	if not player or not player:isPlayer() then
		return
	end

	-- Force remove skill debuff
	player:removeCondition(CONDITION_ATTRIBUTES, CONDITIONID_COMBAT, CONDID_SKILL_DEBUFF, true)

	-- Unregister events
	player:unregisterEvent("BaldurPlayerDeath")
	player:unregisterEvent("BaldurPlayerLogout")
end

-- ============================================================
-- PLAYER DEATH / LOGOUT: Cleanup when leaving the fight
-- ============================================================
local baldurPlayerDeath = CreatureEvent("BaldurPlayerDeath")

function baldurPlayerDeath.onPrepareDeath(player, killer, realDamage)
	cleanupPlayer(player)
	return true
end

baldurPlayerDeath:register()

local baldurPlayerLogout = CreatureEvent("BaldurPlayerLogout")

function baldurPlayerLogout.onLogout(player)
	cleanupPlayer(player)
	return true
end

baldurPlayerLogout:register()

-- ============================================================
-- FIGHT START / STOP
-- ============================================================
function BaldurBoss.start(bossCreature)
	BaldurBoss.reset()

	BaldurBoss._bossId = bossCreature:getId()
	BaldurBoss._shieldLevel = 0
	BaldurBoss._doomCounter = DOOM_COUNTER_TOTAL
	BaldurBoss._debuffLevel = 0
	BaldurBoss._active = true

	BaldurBoss._minionEvent = addEvent(spawnMinion, MINION_SPAWN_INTERVAL)
	BaldurBoss._shieldEvent = addEvent(shieldTick, SHIELD_TICK_INTERVAL)
	-- Delay doom counter by 15s so sentinel and debuff mechanics never overlap
	BaldurBoss._doomEvent = addEvent(doomCounterTick, 15000 + DOOM_TICK_INTERVAL)

	local players = getPlayersInRoom()
	for _, player in ipairs(players) do
		player:registerEvent("BaldurPlayerDeath")
		player:registerEvent("BaldurPlayerLogout")
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "[Baldur] The Allfather awakens! Kill his Rune Sentinels to break his shield! Watch the doom counter!")
	end

	bossCreature:say("Mortals dare enter MY realm? Face the wrath of the Allfather!", TALKTYPE_MONSTER_SAY)
end

function BaldurBoss.stop()
	removeSkillDebuff()
	removeBearer()

	if BaldurBoss._conduitId then
		local conduit = Creature(BaldurBoss._conduitId)
		if conduit then
			conduit:remove()
		end
	end

	local cx = math.floor((ROOM_FROM.x + ROOM_TO.x) / 2)
	local cy = math.floor((ROOM_FROM.y + ROOM_TO.y) / 2)
	local rx = math.ceil((ROOM_TO.x - ROOM_FROM.x) / 2)
	local ry = math.ceil((ROOM_TO.y - ROOM_FROM.y) / 2)
	local specs = Game.getSpectators(Position(cx, cy, ROOM_FROM.z), false, false, rx, rx, ry, ry)
	for _, spec in ipairs(specs) do
		if spec:isMonster() then
			local name = spec:getName()
			if name == "Allfather's Rune Sentinel" or name == "Allfather's Divine Conduit" or name == "Allfather's Runic Bearer" then
				spec:remove()
			end
		elseif spec:isPlayer() then
			cleanupPlayer(spec)
		end
	end

	BaldurBoss.reset()
end

-- ============================================================
-- SPELLS: Divine Spear & Runic Wave
-- ============================================================
local divineSpear = Spell("instant")

function divineSpear.onCastSpell(creature, variant)
	local target = creature:getTarget()
	if not target or not target:isPlayer() then
		return false
	end

	local bossPos = creature:getPosition()
	local targetPos = target:getPosition()

	creature:say("Gungnir, strike true!", TALKTYPE_MONSTER_SAY)
	bossPos:sendDistanceEffect(targetPos, CONST_ANI_HOLY)

	addEvent(function(tId, cId)
		local t = Creature(tId)
		local c = Creature(cId)
		if not t or not c then return end

		local tPos = t:getPosition()
		doTargetCombatHealth(cId, t, COMBAT_HOLYDAMAGE, -8000, -14000, CONST_ME_HOLYDAMAGE)

		for dx = -1, 1 do
			for dy = -1, 1 do
				local areaPos = Position(tPos.x + dx, tPos.y + dy, tPos.z)
				areaPos:sendMagicEffect(CONST_ME_HOLYAREA)
			end
		end

		addEvent(function(areaCenter, attackerId)
			local attacker = Creature(attackerId)
			if not attacker then return end
			local aPos = Position(areaCenter.x, areaCenter.y, areaCenter.z)
			local areaSpecs = Game.getSpectators(aPos, false, true, 1, 1, 1, 1)
			for _, spec in ipairs(areaSpecs) do
				if spec:isPlayer() then
					local specPos = spec:getPosition()
					if math.abs(specPos.x - aPos.x) <= 1 and math.abs(specPos.y - aPos.y) <= 1 then
						doTargetCombatHealth(attackerId, spec, COMBAT_HOLYDAMAGE, -40000, -70000, CONST_ME_HOLYDAMAGE)
					end
				end
			end
		end, 1500, tPos, cId)
	end, 400, target:getId(), creature:getId())

	return true
end

divineSpear:name("baldur_divine_spear")
divineSpear:words("###750")
divineSpear:isAggressive(true)
divineSpear:blockWalls(true)
divineSpear:needLearn(true)
divineSpear:register()

local runicWave = Spell("instant")

function runicWave.onCastSpell(creature, variant)
	local bossId = creature:getId()
	local bossPos = creature:getPosition()

	creature:say("By the runes of the ancients... BE JUDGED!", TALKTYPE_MONSTER_SAY)
	bossPos:sendMagicEffect(CONST_ME_HOLYAREA)

	local rootCond = Condition(CONDITION_ROOTED)
	rootCond:setParameter(CONDITION_PARAM_TICKS, 2500)
	creature:addCondition(rootCond)

	local maxRadius = 5
	local waveDelay = 400

	addEvent(function(centerPos, cId)
		local boss = Creature(cId)
		if not boss then return end

		for radius = 1, maxRadius do
			addEvent(function(center, r, attackerId)
				local attacker = Creature(attackerId)
				if not attacker then return end

				for x = -r, r do
					for y = -r, r do
						if math.abs(x) == r or math.abs(y) == r then
							local wavePos = Position(center.x + x, center.y + y, center.z)
							wavePos:sendMagicEffect(CONST_ME_HOLYDAMAGE)

							local specs = Game.getSpectators(wavePos, false, true, 0, 0, 0, 0)
							for _, t in ipairs(specs) do
								if t:isPlayer() then
									local tPos = t:getPosition()
									if tPos.x == wavePos.x and tPos.y == wavePos.y and tPos.z == wavePos.z then
										local dmg = math.max(-30000, -100000 + (r * 10000))
										doTargetCombatHealth(attackerId, t, COMBAT_HOLYDAMAGE, dmg, dmg * 0.8, CONST_ME_HOLYDAMAGE)
									end
								end
							end
						end
					end
				end
			end, radius * waveDelay, centerPos, radius, cId)
		end
	end, 2000, bossPos, bossId)

	return true
end

runicWave:name("baldur_runic_wave")
runicWave:words("###751")
runicWave:isAggressive(true)
runicWave:blockWalls(true)
runicWave:needLearn(true)
runicWave:register()

-- ============================================================
-- EXIT TELEPORT: Cleanup when player steps on exit TP
-- ============================================================
local baldurExitTP = MoveEvent()

function baldurExitTP.onStepIn(creature, item, position, fromPosition)
	if not creature:isPlayer() then
		return true
	end

	cleanupPlayer(creature)
	return true
end

baldurExitTP:position(Position(3047, 3109, 4))
baldurExitTP:register()

print(">> Baldur the Allfather mechanics loaded successfully!")
