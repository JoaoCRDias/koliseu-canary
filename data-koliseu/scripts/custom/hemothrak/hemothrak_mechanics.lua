-- ============================================================
-- Hemothrak, The Crimson Sovereign - Boss Mechanics
-- ============================================================
-- Mechanic 1: Blood Tide - Corrupts tiles every 20s, Blood Leech clears them
-- Mechanic 2: Sanguine Link - Marks 2 players, must approach each other in 8s
-- Mechanic 3: Crimson Frenzy - 3 phases based on HP (100-60%, 60-30%, 30-0%)
--   Phase 2: +30% attack speed, double Blood Tide/Leeches, Hemorrhage spell
--   Phase 3: +50% attack speed, +25% dmg, triple Blood Tide, Blood Nova w/ Crimson Crystal
-- ============================================================

-- PLACEHOLDER: Adjust positions to your map
local ROOM_CENTER = Position(3014, 3104, 4)
local ROOM_FROM = Position(3007, 3095, 4)
local ROOM_TO = Position(3021, 3114, 4)

local CONDID_SANGUINE_LINK = 55030
local CONDID_SANGUINE_BUFF = 55031
local CONDID_PHASE_BOOST = 55032

-- Blood pool item
local BLOOD_POOL_ITEM_ID = 43929

-- Timings
local BLOOD_TIDE_INTERVAL = 6000
local LEECH_SPAWN_INTERVAL = 25000
local LEECH_ALIVE_TIME = 12000
local SANGUINE_LINK_INTERVAL = 35000
local SANGUINE_LINK_TIMEOUT = 8000
local BLOOD_NOVA_INTERVAL = 45000
local BLOOD_POOL_DAMAGE_INTERVAL = 1000

-- Damage values
local SANGUINE_FAIL_DRAIN_PERCENT = 25
local SANGUINE_FAIL_BOSS_HEAL = 3000000
local BLOOD_POOL_DAMAGE_PERCENT = 25
local LEECH_EXTRA_HP_PHASE3 = 500000

-- ============================================================
-- STATE MANAGEMENT
-- ============================================================
HemothrakBoss = HemothrakBoss or {}

function HemothrakBoss.reset()
	if HemothrakBoss._bloodTideEvent then stopEvent(HemothrakBoss._bloodTideEvent) end
	if HemothrakBoss._leechSpawnEvent then stopEvent(HemothrakBoss._leechSpawnEvent) end
	if HemothrakBoss._leechExplodeEvent then stopEvent(HemothrakBoss._leechExplodeEvent) end
	if HemothrakBoss._sanguineLinkEvent then stopEvent(HemothrakBoss._sanguineLinkEvent) end
	if HemothrakBoss._sanguineTimeoutEvent then stopEvent(HemothrakBoss._sanguineTimeoutEvent) end
	if HemothrakBoss._bloodNovaEvent then stopEvent(HemothrakBoss._bloodNovaEvent) end
	if HemothrakBoss._bloodNovaDetonateEvent then stopEvent(HemothrakBoss._bloodNovaDetonateEvent) end
	if HemothrakBoss._poolDamageEvent then stopEvent(HemothrakBoss._poolDamageEvent) end
	if HemothrakBoss._linkVisualEvent then stopEvent(HemothrakBoss._linkVisualEvent) end

	HemothrakBoss._bossId = nil
	HemothrakBoss._bloodPools = {}
	HemothrakBoss._leechCount = 0
	HemothrakBoss._crystalId = nil
	HemothrakBoss._linkedPlayers = {}
	HemothrakBoss._phase = 1
	HemothrakBoss._bloodTideEvent = nil
	HemothrakBoss._leechSpawnEvent = nil
	HemothrakBoss._leechExplodeEvent = nil
	HemothrakBoss._sanguineLinkEvent = nil
	HemothrakBoss._sanguineTimeoutEvent = nil
	HemothrakBoss._bloodNovaEvent = nil
	HemothrakBoss._bloodNovaDetonateEvent = nil
	HemothrakBoss._poolDamageEvent = nil
	HemothrakBoss._novaChanneling = false
	HemothrakBoss._linkVisualEvent = nil
	HemothrakBoss._active = false
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
	if not HemothrakBoss._bossId then return nil end
	local boss = Creature(HemothrakBoss._bossId)
	if boss and boss:getHealth() > 0 then
		return boss
	end
	return nil
end

local function getPhase()
	local boss = getBoss()
	if not boss then return 1 end
	local healthPercent = (boss:getHealth() / boss:getMaxHealth()) * 100
	if healthPercent > 60 then return 1 end
	if healthPercent > 30 then return 2 end
	return 3
end

-- ============================================================
-- PHASE MANAGEMENT
-- ============================================================
local function applyPhaseBoost(boss, phase)
	boss:removeCondition(CONDITION_ATTRIBUTES, CONDITIONID_COMBAT, CONDID_PHASE_BOOST)

	if phase <= 1 then return end

	local cond = Condition(CONDITION_ATTRIBUTES)
	cond:setParameter(CONDITION_PARAM_TICKS, -1)
	cond:setParameter(CONDITION_PARAM_SUBID, CONDID_PHASE_BOOST)

	if phase == 2 then
		cond:setParameter(CONDITION_PARAM_BUFF_DAMAGEDEALT, 100)
	elseif phase == 3 then
		cond:setParameter(CONDITION_PARAM_BUFF_DAMAGEDEALT, 125)
	end

	boss:addCondition(cond)
end

local function checkPhaseTransition()
	if not HemothrakBoss._active then return end
	local boss = getBoss()
	if not boss then return end

	local newPhase = getPhase()
	local oldPhase = HemothrakBoss._phase

	if newPhase == oldPhase then return end

	HemothrakBoss._phase = newPhase
	applyPhaseBoost(boss, newPhase)

	local players = getPlayersInRoom()

	if newPhase == 2 then
		boss:say("You've drawn enough of my blood... Now I THIRST!", TALKTYPE_MONSTER_SAY)
		ROOM_CENTER:sendMagicEffect(CONST_ME_DRAWBLOOD)

		for _, player in ipairs(players) do
			player:sendTextMessage(MESSAGE_GAME_HIGHLIGHT, "[Hemothrak] PHASE 2: The Crimson Sovereign enters a blood frenzy! Attack speed increased, blood tide intensifies!")
		end
	elseif newPhase == 3 then
		boss:say("ENOUGH! The crimson abyss shall consume you ALL!", TALKTYPE_MONSTER_SAY)
		ROOM_CENTER:sendMagicEffect(CONST_ME_MORTAREA)

		for _, player in ipairs(players) do
			player:sendTextMessage(MESSAGE_GAME_HIGHLIGHT, "[Hemothrak] PHASE 3: Blood Ecstasy! Maximum power! Watch for the Blood Nova!")
		end

		-- Start Blood Nova cycle in phase 3
		if not HemothrakBoss._bloodNovaEvent then
			HemothrakBoss._bloodNovaEvent = addEvent(bloodNovaCycle, BLOOD_NOVA_INTERVAL)
		end
	end
end

-- ============================================================
-- MECHANIC 1: Blood Tide (blood pools on floor)
-- ============================================================
local function getRandomRoomPos()
	local x = math.random(ROOM_FROM.x + 1, ROOM_TO.x - 1)
	local y = math.random(ROOM_FROM.y + 1, ROOM_TO.y - 1)
	return Position(x, y, ROOM_FROM.z)
end

local function addBloodPool(pos)
	local tile = Tile(pos)
	if not tile then return false end

	-- Don't place on walls or already-pooled tiles
	if not tile:isWalkable() then return false end

	for _, existingPos in ipairs(HemothrakBoss._bloodPools) do
		if existingPos.x == pos.x and existingPos.y == pos.y and existingPos.z == pos.z then
			return false
		end
	end

	local pool = Game.createItem(BLOOD_POOL_ITEM_ID, 1, pos)
	if pool then
		pool:setActionId(59001)
		table.insert(HemothrakBoss._bloodPools, pos)
		pos:sendMagicEffect(CONST_ME_DRAWBLOOD)
		return true
	end
	return false
end

local function removeBloodPoolItem(pos)
	local tile = Tile(pos)
	if tile then
		local items = tile:getItems()
		if items then
			for _, item in ipairs(items) do
				if item:getId() == BLOOD_POOL_ITEM_ID and item:getActionId() == 59001 then
					item:remove()
				end
			end
		end
	end
	pos:sendMagicEffect(CONST_ME_MAGIC_GREEN)
end

local function clearAllBloodPools()
	for _, pos in ipairs(HemothrakBoss._bloodPools) do
		removeBloodPoolItem(pos)
	end
	HemothrakBoss._bloodPools = {}
end

local function clearHalfBloodPools()
	local total = #HemothrakBoss._bloodPools
	if total == 0 then return 0 end

	local toRemove = math.ceil(total / 2)

	-- Shuffle pool indices to pick random ones
	local indices = {}
	for i = 1, total do indices[i] = i end
	for i = total, 2, -1 do
		local j = math.random(i)
		indices[i], indices[j] = indices[j], indices[i]
	end

	-- Mark which indices to remove
	local removeSet = {}
	for i = 1, toRemove do
		removeSet[indices[i]] = true
	end

	-- Remove items and build new pool list
	local remaining = {}
	for i, pos in ipairs(HemothrakBoss._bloodPools) do
		if removeSet[i] then
			removeBloodPoolItem(pos)
		else
			table.insert(remaining, pos)
		end
	end
	HemothrakBoss._bloodPools = remaining
	return toRemove
end

local function bloodPoolDamageTick()
	if not HemothrakBoss._active then return end

	local players = getPlayersInRoom()
	for _, player in ipairs(players) do
		local pPos = player:getPosition()
		for _, poolPos in ipairs(HemothrakBoss._bloodPools) do
			if pPos.x == poolPos.x and pPos.y == poolPos.y and pPos.z == poolPos.z then
				local dmg = math.floor(player:getMaxHealth() * BLOOD_POOL_DAMAGE_PERCENT / 100)
				doTargetCombatHealth(0, player, COMBAT_AGONYDAMAGE, -dmg, -dmg, CONST_ME_AGONY)
				break
			end
		end
	end

	HemothrakBoss._poolDamageEvent = addEvent(bloodPoolDamageTick, BLOOD_POOL_DAMAGE_INTERVAL)
end

local function bloodTideTick()
	if not HemothrakBoss._active then return end
	local boss = getBoss()
	if not boss then return end

	local phase = HemothrakBoss._phase
	local poolCount = 4
	if phase == 2 then poolCount = 6 end
	if phase == 3 then poolCount = 8 end

	local placed = 0
	local attempts = 0
	while placed < poolCount and attempts < 20 do
		local pos = getRandomRoomPos()
		if addBloodPool(pos) then
			placed = placed + 1
		end
		attempts = attempts + 1
	end

	if placed > 0 then
		boss:say("The crimson tide spreads!", TALKTYPE_MONSTER_SAY)
		local players = getPlayersInRoom()
		for _, player in ipairs(players) do
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("[Hemothrak] %d blood pool(s) appeared! Total: %d. Kill the Blood Leech to cleanse them!", placed, #HemothrakBoss._bloodPools))
		end
	end

	HemothrakBoss._bloodTideEvent = addEvent(bloodTideTick, BLOOD_TIDE_INTERVAL)
end

-- ============================================================
-- MECHANIC 1b: Blood Leech spawn/explode
-- ============================================================
local function onLeechDied()
	if not HemothrakBoss._active then return end

	HemothrakBoss._leechCount = HemothrakBoss._leechCount - 1
	if HemothrakBoss._leechCount < 0 then HemothrakBoss._leechCount = 0 end

	if HemothrakBoss._leechCount == 0 then
		-- Cancel explode timer if active
		if HemothrakBoss._leechExplodeEvent then
			stopEvent(HemothrakBoss._leechExplodeEvent)
			HemothrakBoss._leechExplodeEvent = nil
		end

		-- Remove half blood pools randomly
		local removed = clearHalfBloodPools()

		local players = getPlayersInRoom()
		for _, player in ipairs(players) do
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("[Hemothrak] All Blood Leeches destroyed! %d blood pools cleansed! %d remaining.", removed, #HemothrakBoss._bloodPools))
		end
	else
		local players = getPlayersInRoom()
		for _, player in ipairs(players) do
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("[Hemothrak] Blood Leech destroyed! %d leech(es) remaining.", HemothrakBoss._leechCount))
		end
	end
end

local function onLeechExplode()
	if not HemothrakBoss._active then return end
	HemothrakBoss._leechExplodeEvent = nil

	-- Find and explode ALL remaining leeches in the room
	local cx = math.floor((ROOM_FROM.x + ROOM_TO.x) / 2)
	local cy = math.floor((ROOM_FROM.y + ROOM_TO.y) / 2)
	local rx = math.ceil((ROOM_TO.x - ROOM_FROM.x) / 2)
	local ry = math.ceil((ROOM_TO.y - ROOM_FROM.y) / 2)
	local specs = Game.getSpectators(Position(cx, cy, ROOM_FROM.z), false, false, rx, rx, ry, ry)

	local exploded = 0
	for _, spec in ipairs(specs) do
		if spec:isMonster() and spec:getName() == "Hemothrak's Blood Leech" then
			local leechPos = spec:getPosition()
			leechPos:sendMagicEffect(CONST_ME_MORTAREA)
			spec:say("The leech EXPLODES in a fountain of blood!", TALKTYPE_MONSTER_SAY)
			spec:unregisterEvent("HemothrakMinionDeath")
			spec:remove()
			exploded = exploded + 1
			HemothrakBoss._leechCount = HemothrakBoss._leechCount - 1
		end
	end
	if HemothrakBoss._leechCount < 0 then HemothrakBoss._leechCount = 0 end

	if exploded > 0 then
		-- Create 15 extra blood pools per leech that exploded
		local totalToPlace = 15 * exploded
		local placed = 0
		local attempts = 0
		while placed < totalToPlace and attempts < totalToPlace * 4 do
			local pos = getRandomRoomPos()
			if addBloodPool(pos) then
				placed = placed + 1
			end
			attempts = attempts + 1
		end

		local players = getPlayersInRoom()
		for _, player in ipairs(players) do
			player:sendTextMessage(MESSAGE_GAME_HIGHLIGHT, string.format("[Hemothrak] %d Blood Leech(es) exploded! %d extra blood pools flooded the room! Total: %d", exploded, placed, #HemothrakBoss._bloodPools))
			player:getPosition():sendMagicEffect(CONST_ME_DRAWBLOOD)
		end
	end
end

local function spawnLeech()
	if not HemothrakBoss._active then return end
	local boss = getBoss()
	if not boss then return end

	if HemothrakBoss._leechExplodeEvent then
		stopEvent(HemothrakBoss._leechExplodeEvent)
		HemothrakBoss._leechExplodeEvent = nil
	end

	local phase = HemothrakBoss._phase
	local leechCount = 1
	if phase >= 2 then leechCount = 2 end

	local bossPos = boss:getPosition()

	for i = 1, leechCount do
		-- Try to spawn near boss (radius 3), fallback to room random
		local leech = nil
		local spawnPos = nil
		for attempt = 1, 15 do
			local dx = math.random(-3, 3)
			local dy = math.random(-3, 3)
			local tryPos = Position(bossPos.x + dx, bossPos.y + dy, bossPos.z)

			-- Ensure within room bounds
			if tryPos.x >= ROOM_FROM.x + 1 and tryPos.x <= ROOM_TO.x - 1
					and tryPos.y >= ROOM_FROM.y + 1 and tryPos.y <= ROOM_TO.y - 1 then
				local tile = Tile(tryPos)
				if tile and tile:isWalkable() and not tile:getTopCreature() then
					leech = Game.createMonster("Hemothrak's Blood Leech", tryPos, false, true)
					if leech then
						spawnPos = tryPos
						break
					end
				end
			end
		end

		if leech and spawnPos then
			if phase == 3 then
				leech:addHealth(LEECH_EXTRA_HP_PHASE3)
			end

			leech:registerEvent("HemothrakMinionDeath")
			spawnPos:sendMagicEffect(CONST_ME_DRAWBLOOD)
			leech:say("A Blood Leech emerges from the crimson floor!", TALKTYPE_MONSTER_SAY)

			HemothrakBoss._leechCount = HemothrakBoss._leechCount + 1
		end
	end

	-- Explode timer for this wave
	HemothrakBoss._leechExplodeEvent = addEvent(onLeechExplode, LEECH_ALIVE_TIME)

	local players = getPlayersInRoom()
	for _, player in ipairs(players) do
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("[Hemothrak] %d Blood Leech(es) appeared! Kill them within 12 seconds or they explode! Total alive: %d", leechCount, HemothrakBoss._leechCount))
	end

	HemothrakBoss._leechSpawnEvent = addEvent(spawnLeech, LEECH_SPAWN_INTERVAL)
end

-- ============================================================
-- MECHANIC 2: Sanguine Link
-- ============================================================
local LINK_VISUAL_INTERVAL = 2000
local LINK_VISUAL_MISSILE = 41

local function stopLinkVisual()
	if HemothrakBoss._linkVisualEvent then
		stopEvent(HemothrakBoss._linkVisualEvent)
		HemothrakBoss._linkVisualEvent = nil
	end
end

local function linkVisualTick()
	if not HemothrakBoss._active then return end

	local linked = HemothrakBoss._linkedPlayers
	if not linked or #linked < 2 then
		stopLinkVisual()
		return
	end

	local p1 = Player(linked[1])
	local p2 = Player(linked[2])

	if not p1 or not p2 or p1:getHealth() <= 0 or p2:getHealth() <= 0 then
		stopLinkVisual()
		return
	end

	local pos1 = p1:getPosition()
	local pos2 = p2:getPosition()

	-- Only send if on same floor and within visible range (~15 tiles)
	if pos1.z == pos2.z then
		local dist = math.max(math.abs(pos1.x - pos2.x), math.abs(pos1.y - pos2.y))
		if dist <= 15 then
			pos1:sendDistanceEffect(pos2, LINK_VISUAL_MISSILE)
			pos2:sendDistanceEffect(pos1, LINK_VISUAL_MISSILE)
		end
	end

	HemothrakBoss._linkVisualEvent = addEvent(linkVisualTick, LINK_VISUAL_INTERVAL)
end

local function checkSanguineLink()
	if not HemothrakBoss._active then return end

	local linked = HemothrakBoss._linkedPlayers
	if #linked < 2 then
		HemothrakBoss._linkedPlayers = {}
		HemothrakBoss._sanguineTimeoutEvent = nil
		return
	end

	local boss = getBoss()
	local players = getPlayersInRoom()

	-- Check if linked players are close enough (distance <= 3)
	local p1 = Player(linked[1])
	local p2 = Player(linked[2])

	if p1 and p2 and p1:getHealth() > 0 and p2:getHealth() > 0 then
		local pos1 = p1:getPosition()
		local pos2 = p2:getPosition()
		local dist = math.max(math.abs(pos1.x - pos2.x), math.abs(pos1.y - pos2.y))

		if dist <= 3 then
			-- SUCCESS: Players linked in time
			pos1:sendMagicEffect(CONST_ME_MAGIC_GREEN)
			pos2:sendMagicEffect(CONST_ME_MAGIC_GREEN)

			-- Apply +15% damage buff for 10 seconds
			local buffCond = Condition(CONDITION_ATTRIBUTES)
			buffCond:setParameter(CONDITION_PARAM_TICKS, 10000)
			buffCond:setParameter(CONDITION_PARAM_SUBID, CONDID_SANGUINE_BUFF)
			buffCond:setParameter(CONDITION_PARAM_BUFF_DAMAGEDEALT, 115)
			p1:addCondition(buffCond)
			p2:addCondition(buffCond)

			for _, player in ipairs(players) do
				player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("[Hemothrak] %s and %s completed the Sanguine Link! +15%% damage for 10 seconds!", p1:getName(), p2:getName()))
			end
		else
			-- FAILURE: Players too far apart
			pos1:sendMagicEffect(CONST_ME_MORTAREA)
			pos2:sendMagicEffect(CONST_ME_MORTAREA)

			-- Drain 25% max HP from both
			local drain1 = math.floor(p1:getMaxHealth() * SANGUINE_FAIL_DRAIN_PERCENT / 100)
			local drain2 = math.floor(p2:getMaxHealth() * SANGUINE_FAIL_DRAIN_PERCENT / 100)
			doTargetCombatHealth(0, p1, COMBAT_DEATHDAMAGE, -drain1, -drain1, CONST_ME_DRAWBLOOD)
			doTargetCombatHealth(0, p2, COMBAT_DEATHDAMAGE, -drain2, -drain2, CONST_ME_DRAWBLOOD)

			-- Boss heals
			if boss then
				boss:addHealth(SANGUINE_FAIL_BOSS_HEAL)
				boss:getPosition():sendMagicEffect(CONST_ME_MAGIC_RED)
			end

			for _, player in ipairs(players) do
				player:sendTextMessage(MESSAGE_GAME_HIGHLIGHT, string.format("[Hemothrak] %s and %s FAILED the Sanguine Link! Both drained 25%% HP! Boss healed 3,000,000!", p1:getName(), p2:getName()))
			end
		end
	end

	-- Stop visual missile effect
	stopLinkVisual()

	-- Remove link icons
	if p1 then p1:removeIcon("sanguine_link") end
	if p2 then p2:removeIcon("sanguine_link") end

	HemothrakBoss._linkedPlayers = {}
	HemothrakBoss._sanguineTimeoutEvent = nil
end

local function sanguineLinkTick()
	if not HemothrakBoss._active then return end
	local boss = getBoss()
	if not boss then return end

	local players = getPlayersInRoom()
	if #players < 2 then
		HemothrakBoss._sanguineLinkEvent = addEvent(sanguineLinkTick, SANGUINE_LINK_INTERVAL)
		return
	end

	-- Pick 2 random players
	local shuffled = {}
	for _, p in ipairs(players) do table.insert(shuffled, p) end
	for i = #shuffled, 2, -1 do
		local j = math.random(i)
		shuffled[i], shuffled[j] = shuffled[j], shuffled[i]
	end

	local p1 = shuffled[1]
	local p2 = shuffled[2]

	HemothrakBoss._linkedPlayers = { p1:getId(), p2:getId() }

	-- Visual: red icon on linked players
	p1:setIcon("sanguine_link", CreatureIconCategory_Quests, CreatureIconQuests_ExclamationMark, 1)
	p2:setIcon("sanguine_link", CreatureIconCategory_Quests, CreatureIconQuests_ExclamationMark, 1)

	p1:getPosition():sendMagicEffect(CONST_ME_MAGIC_RED)
	p2:getPosition():sendMagicEffect(CONST_ME_MAGIC_RED)

	-- Send initial distance effect and start repeating visual missile
	p1:getPosition():sendDistanceEffect(p2:getPosition(), LINK_VISUAL_MISSILE)
	p2:getPosition():sendDistanceEffect(p1:getPosition(), LINK_VISUAL_MISSILE)
	stopLinkVisual()
	HemothrakBoss._linkVisualEvent = addEvent(linkVisualTick, LINK_VISUAL_INTERVAL)

	boss:say("Your blood is bound! Seek each other... or PERISH!", TALKTYPE_MONSTER_SAY)

	for _, player in ipairs(players) do
		player:sendTextMessage(MESSAGE_GAME_HIGHLIGHT, string.format("[Hemothrak] SANGUINE LINK! %s and %s are linked! They must get within 3 tiles of each other within 8 seconds!", p1:getName(), p2:getName()))
	end

	-- Set timeout check
	HemothrakBoss._sanguineTimeoutEvent = addEvent(checkSanguineLink, SANGUINE_LINK_TIMEOUT)

	HemothrakBoss._sanguineLinkEvent = addEvent(sanguineLinkTick, SANGUINE_LINK_INTERVAL)
end

-- ============================================================
-- MECHANIC 3 (Phase 3): Blood Nova + Crimson Crystal
-- ============================================================
local BLOOD_NOVA_TELEPORT_POS = Position(3014, 3097, 4)
local BLOOD_NOVA_EFFECT = 524
local BLOOD_NOVA_WAVE_INTERVAL = 2000 -- 2s between each wave
local BLOOD_NOVA_WAVES = 4 -- 4 warning waves before detonation
local BLOOD_NOVA_DOOM_PERCENT = 80 -- 80% max HP as agony damage

local function getNovaAuraPositions(centerPos)
	local positions = {}
	for dx = -1, 1 do
		for dy = -1, 1 do
			if dx ~= 0 or dy ~= 0 then
				table.insert(positions, Position(centerPos.x + dx, centerPos.y + dy, centerPos.z))
			end
		end
	end
	return positions
end

local function bloodNovaWaveTick(waveNumber)
	if not HemothrakBoss._active then return end
	HemothrakBoss._novaChanneling = true

	local boss = getBoss()
	if not boss then
		HemothrakBoss._novaChanneling = false
		return
	end

	-- Check if crystal was already destroyed (cancelled by death event)
	if not HemothrakBoss._crystalId then
		-- Crystal was destroyed, nova already cancelled by death handler
		HemothrakBoss._novaChanneling = false
		return
	end

	local bossPos = boss:getPosition()
	local auraPositions = getNovaAuraPositions(bossPos)

	if waveNumber <= BLOOD_NOVA_WAVES then
		-- Warning waves: effect 524 around boss
		for _, pos in ipairs(auraPositions) do
			pos:sendMagicEffect(BLOOD_NOVA_EFFECT)
		end
		bossPos:sendMagicEffect(CONST_ME_MAGIC_RED)

		boss:say(string.format("The blood surges... %d!", BLOOD_NOVA_WAVES - waveNumber + 1), TALKTYPE_MONSTER_SAY)

		local players = getPlayersInRoom()
		for _, player in ipairs(players) do
			player:sendTextMessage(MESSAGE_GAME_HIGHLIGHT, string.format("[Hemothrak] BLOOD NOVA CHARGING! Wave %d/%d! Destroy the Crimson Crystal!", waveNumber, BLOOD_NOVA_WAVES))
		end

		-- Schedule next wave
		HemothrakBoss._bloodNovaDetonateEvent = addEvent(bloodNovaWaveTick, BLOOD_NOVA_WAVE_INTERVAL, waveNumber + 1)
	else
		-- 4th tick: DETONATION - crystal was NOT destroyed
		local crystal = Creature(HemothrakBoss._crystalId)
		if crystal and crystal:getHealth() > 0 then
			crystal:remove()
		end
		HemothrakBoss._crystalId = nil
		HemothrakBoss._novaChanneling = false

		boss:say("THE CRIMSON ABYSS CONSUMES ALL!", TALKTYPE_MONSTER_SAY)

		-- Visual: explosion across whole room
		for x = ROOM_FROM.x, ROOM_TO.x, 2 do
			for y = ROOM_FROM.y, ROOM_TO.y, 2 do
				Position(x, y, ROOM_FROM.z):sendMagicEffect(CONST_ME_AGONY)
			end
		end
		for _, pos in ipairs(auraPositions) do
			pos:sendMagicEffect(BLOOD_NOVA_EFFECT)
		end

		-- Deal exactly 80% max HP (bypasses hazard, resistances, boosts)
		local players = getPlayersInRoom()
		for _, player in ipairs(players) do
			local dmg = math.floor(player:getMaxHealth() * BLOOD_NOVA_DOOM_PERCENT / 100)
			player:addHealth(-dmg)
			player:getPosition():sendMagicEffect(CONST_ME_AGONY)
			player:sendTextMessage(MESSAGE_GAME_HIGHLIGHT, "[Hemothrak] BLOOD NOVA detonated! The crimson doom consumes you!")
		end

		-- Schedule next Blood Nova cycle
		if HemothrakBoss._phase >= 3 then
			HemothrakBoss._bloodNovaEvent = addEvent(bloodNovaCycle, BLOOD_NOVA_INTERVAL)
		end
	end
end

function bloodNovaCycle()
	if not HemothrakBoss._active then return end
	if HemothrakBoss._phase < 3 then return end
	local boss = getBoss()
	if not boss then return end

	HemothrakBoss._novaChanneling = true
	HemothrakBoss._bloodNovaEvent = nil

	-- Teleport boss to fixed position
	boss:teleportTo(BLOOD_NOVA_TELEPORT_POS, true)
	BLOOD_NOVA_TELEPORT_POS:sendMagicEffect(CONST_ME_TELEPORT)

	-- Root boss during entire channeling (3 waves × 2s + detonation = ~8s)
	local totalChannelTime = (BLOOD_NOVA_WAVES + 1) * BLOOD_NOVA_WAVE_INTERVAL
	local rootCond = Condition(CONDITION_ROOTED)
	rootCond:setParameter(CONDITION_PARAM_TICKS, totalChannelTime)
	boss:addCondition(rootCond)

	boss:say("The crimson energy builds... THE ABYSS OPENS!", TALKTYPE_MONSTER_SAY)

	-- Spawn Crimson Crystal at random position
	local crystalPos = Position(3014, 3093, 4)
	local crystal = Game.createMonster("Hemothrak's Crimson Crystal", crystalPos, false, true)
	if crystal then
		HemothrakBoss._crystalId = crystal:getId()
		crystal:registerEvent("HemothrakMinionDeath")
		crystalPos:sendMagicEffect(CONST_ME_FIREAREA)

		local players = getPlayersInRoom()
		for _, player in ipairs(players) do
			player:sendTextMessage(MESSAGE_GAME_HIGHLIGHT, "[Hemothrak] BLOOD NOVA INITIATED! Destroy the Crimson Crystal before the 4th wave or suffer 80%% HP doom!")
		end
	end

	-- Start wave 1
	HemothrakBoss._bloodNovaDetonateEvent = addEvent(bloodNovaWaveTick, BLOOD_NOVA_WAVE_INTERVAL, 1)
end

-- ============================================================
-- MINION DEATH EVENT
-- ============================================================
local minionDeath = CreatureEvent("HemothrakMinionDeath")

function minionDeath.onDeath(creature)
	if not HemothrakBoss._active then return true end

	local creatureName = creature:getName()
	local deathPos = creature:getPosition()
	local creatureId = creature:getId()

	-- Blood Leech killed by players: decrement counter, clear half pools when counter reaches 0
	if creatureName == "Hemothrak's Blood Leech" then
		deathPos:sendMagicEffect(CONST_ME_MAGIC_GREEN)
		onLeechDied()
		return true
	end

	-- Crimson Crystal killed: cancel Blood Nova and stun boss
	if creatureName == "Hemothrak's Crimson Crystal" then
		if HemothrakBoss._crystalId and creatureId == HemothrakBoss._crystalId then
			HemothrakBoss._crystalId = nil

			-- Cancel the detonation
			if HemothrakBoss._bloodNovaDetonateEvent then
				stopEvent(HemothrakBoss._bloodNovaDetonateEvent)
				HemothrakBoss._bloodNovaDetonateEvent = nil
			end
			HemothrakBoss._novaChanneling = false

			deathPos:sendMagicEffect(CONST_ME_MAGIC_GREEN)

			-- Stun boss for 4 seconds (root + remove target)
			local boss = getBoss()
			if boss then
				local stunCond = Condition(CONDITION_ROOTED)
				stunCond:setParameter(CONDITION_PARAM_TICKS, 4000)
				boss:addCondition(stunCond)
				boss:say("NO! The crimson energy dissipates!", TALKTYPE_MONSTER_SAY)
				boss:getPosition():sendMagicEffect(CONST_ME_MAGIC_GREEN)
			end

			local players = getPlayersInRoom()
			for _, player in ipairs(players) do
				player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "[Hemothrak] Crimson Crystal destroyed! Blood Nova CANCELLED! Boss stunned for 4 seconds!")
			end

			-- Schedule next Blood Nova
			if HemothrakBoss._phase >= 3 then
				HemothrakBoss._bloodNovaEvent = addEvent(bloodNovaCycle, BLOOD_NOVA_INTERVAL)
			end
		end
		return true
	end

	return true
end

minionDeath:register()

-- ============================================================
-- SPELLS: Hemorrhage (Phase 2+) & Blood Nova (handled above via cycle)
-- ============================================================
local hemorrhageSpell = Spell("instant")

function hemorrhageSpell.onCastSpell(creature, variant)
	if not HemothrakBoss._active then return false end
	if HemothrakBoss._phase < 2 then return false end

	local target = creature:getTarget()
	if not target or not target:isPlayer() then return false end

	local bossPos = creature:getPosition()
	local targetPos = target:getPosition()

	creature:say("HEMORRHAGE!", TALKTYPE_MONSTER_SAY)

	-- Cone attack toward target
	local dirX = targetPos.x - bossPos.x
	local dirY = targetPos.y - bossPos.y

	-- Normalize direction
	if dirX ~= 0 then dirX = dirX / math.abs(dirX) end
	if dirY ~= 0 then dirY = dirY / math.abs(dirY) end

	-- Create cone of damage tiles
	for dist = 1, 6 do
		addEvent(function(cId, dX, dY, d, bX, bY, bZ)
			local attacker = Creature(cId)
			if not attacker then return end

			for spread = -1, 1 do
				local hitX, hitY
				if dX ~= 0 and dY ~= 0 then
					hitX = bX + (dX * d) + (spread * dY)
					hitY = bY + (dY * d) + (spread * dX)
				elseif dX ~= 0 then
					hitX = bX + (dX * d)
					hitY = bY + spread
				else
					hitX = bX + spread
					hitY = bY + (dY * d)
				end

				local hitPos = Position(hitX, hitY, bZ)
				hitPos:sendMagicEffect(CONST_ME_DRAWBLOOD)

				local specs = Game.getSpectators(hitPos, false, true, 0, 0, 0, 0)
				for _, spec in ipairs(specs) do
					if spec:isPlayer() then
						local sPos = spec:getPosition()
						if sPos.x == hitPos.x and sPos.y == hitPos.y and sPos.z == hitPos.z then
							doTargetCombatHealth(cId, spec, COMBAT_DEATHDAMAGE, -50000, -90000, CONST_ME_DRAWBLOOD)
						end
					end
				end
			end
		end, dist * 150, creature:getId(), dirX, dirY, dist, bossPos.x, bossPos.y, bossPos.z)
	end

	return true
end

hemorrhageSpell:name("hemothrak_hemorrhage")
hemorrhageSpell:words("###760")
hemorrhageSpell:isAggressive(true)
hemorrhageSpell:blockWalls(true)
hemorrhageSpell:needLearn(true)
hemorrhageSpell:register()

-- Blood Nova spell entry (triggers the cycle check)
local bloodNovaSpell = Spell("instant")

function bloodNovaSpell.onCastSpell(creature, variant)
	-- Blood Nova is handled by the cycle system, this spell is just the trigger entry
	-- It only activates in phase 3 and only if not already channeling
	if not HemothrakBoss._active then return false end
	if HemothrakBoss._phase < 3 then return false end
	if HemothrakBoss._novaChanneling then return false end

	-- The actual Blood Nova is triggered by the timed cycle, not the spell directly
	-- This spell entry exists so the monster definition can reference it
	return false
end

bloodNovaSpell:name("hemothrak_blood_nova")
bloodNovaSpell:words("###761")
bloodNovaSpell:isAggressive(true)
bloodNovaSpell:blockWalls(true)
bloodNovaSpell:needLearn(true)
bloodNovaSpell:register()

-- ============================================================
-- ROOM CHECK: GlobalEvent to monitor boss room + phase transitions
-- ============================================================
local bossPositionCheck = GlobalEvent("HemothrakBossPositionCheck")

function bossPositionCheck.onThink(interval)
	if not HemothrakBoss._active then return true end

	local players = getPlayersInRoom()
	if #players == 0 then
		local boss = getBoss()
		if boss then
			boss:remove()
		end
		HemothrakBoss.stop()
		return true
	end

	-- Check phase transitions
	checkPhaseTransition()

	return true
end

bossPositionCheck:interval(500)
bossPositionCheck:register()

-- ============================================================
-- PLAYER CLEANUP
-- ============================================================
local function cleanupPlayer(player)
	if not player or not player:isPlayer() then return end

	player:removeCondition(CONDITION_ATTRIBUTES, CONDITIONID_COMBAT, CONDID_SANGUINE_LINK, true)
	player:removeCondition(CONDITION_ATTRIBUTES, CONDITIONID_COMBAT, CONDID_SANGUINE_BUFF, true)
	player:removeIcon("sanguine_link")

	player:unregisterEvent("HemothrakPlayerDeath")
	player:unregisterEvent("HemothrakPlayerLogout")
end

local hemothrakPlayerDeath = CreatureEvent("HemothrakPlayerDeath")

function hemothrakPlayerDeath.onPrepareDeath(player, killer, realDamage)
	cleanupPlayer(player)
	return true
end

hemothrakPlayerDeath:register()

local hemothrakPlayerLogout = CreatureEvent("HemothrakPlayerLogout")

function hemothrakPlayerLogout.onLogout(player)
	cleanupPlayer(player)
	return true
end

hemothrakPlayerLogout:register()

-- ============================================================
-- FIGHT START / STOP
-- ============================================================
function HemothrakBoss.start(bossCreature)
	HemothrakBoss.reset()

	HemothrakBoss._bossId = bossCreature:getId()
	HemothrakBoss._bloodPools = {}
	HemothrakBoss._phase = 1
	HemothrakBoss._active = true

	-- Start mechanics
	HemothrakBoss._bloodTideEvent = addEvent(bloodTideTick, BLOOD_TIDE_INTERVAL)
	HemothrakBoss._leechSpawnEvent = addEvent(spawnLeech, LEECH_SPAWN_INTERVAL)
	HemothrakBoss._sanguineLinkEvent = addEvent(sanguineLinkTick, SANGUINE_LINK_INTERVAL)
	HemothrakBoss._poolDamageEvent = addEvent(bloodPoolDamageTick, BLOOD_POOL_DAMAGE_INTERVAL)

	local players = getPlayersInRoom()
	for _, player in ipairs(players) do
		player:registerEvent("HemothrakPlayerDeath")
		player:registerEvent("HemothrakPlayerLogout")
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "[Hemothrak] The Crimson Sovereign awakens! Avoid blood pools! Kill Blood Leeches to cleanse the room! Watch for the Sanguine Link!")
	end

	bossCreature:say("Mortals... your blood called to me. Now it shall ANSWER!", TALKTYPE_MONSTER_SAY)
end

function HemothrakBoss.stop()
	clearAllBloodPools()

	-- Remove linked player icons
	for _, pid in ipairs(HemothrakBoss._linkedPlayers or {}) do
		local p = Player(pid)
		if p then
			p:removeIcon("sanguine_link")
		end
	end

	-- Remove all minions in room
	local cx = math.floor((ROOM_FROM.x + ROOM_TO.x) / 2)
	local cy = math.floor((ROOM_FROM.y + ROOM_TO.y) / 2)
	local rx = math.ceil((ROOM_TO.x - ROOM_FROM.x) / 2)
	local ry = math.ceil((ROOM_TO.y - ROOM_FROM.y) / 2)
	local specs = Game.getSpectators(Position(cx, cy, ROOM_FROM.z), false, false, rx, rx, ry, ry)
	for _, spec in ipairs(specs) do
		if spec:isMonster() then
			local name = spec:getName()
			if name == "Hemothrak's Blood Leech" or name == "Hemothrak's Crimson Crystal" then
				spec:unregisterEvent("HemothrakMinionDeath")
				spec:remove()
			end
		elseif spec:isPlayer() then
			cleanupPlayer(spec)
		end
	end

	HemothrakBoss.reset()
end

-- ============================================================
-- EXIT TELEPORT: Cleanup when player steps on exit TP
-- ============================================================
local hemothrakExitTP = MoveEvent()

function hemothrakExitTP.onStepIn(creature, item, position, fromPosition)
	if not creature:isPlayer() then return true end
	cleanupPlayer(creature)
	return true
end

-- PLACEHOLDER: adjust exit teleport position to your map
hemothrakExitTP:position(Position(3014, 3113, 4))
hemothrakExitTP:register()

print(">> Hemothrak the Crimson Sovereign mechanics loaded successfully!")
