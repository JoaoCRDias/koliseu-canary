-- Supreme Vocation — Fire chamber driver.
--
-- Runs a 1-second tick while the chamber is active. Handles:
--   * waiting  -> counts down to seal
--   * sealed   -> spawns frost mobs in phases, schedules logs and random
--                 events, regenerates the bonfire, checks win/fail conditions
--
-- Monsters' AI (moving toward the bonfire, attacking it) lives outside this
-- driver: each frost mob has its own onThink callback (see sv_frost_ai).

local TICK_MS = 1000

local function cfg() return SupremeVocation.FireChamber end

-- ---- Spawn helpers ---------------------------------------------------------

local function getActivePhase(elapsed)
	local phases = cfg().phases
	local active = phases[1]
	for _, p in ipairs(phases) do
		if elapsed >= p.fromSec then active = p end
	end
	return active
end

local function pickRandomMobType(weights)
	local total = 0
	for _, w in pairs(weights) do total = total + w end
	local roll = math.random(1, total)
	local acc = 0
	for name, w in pairs(weights) do
		acc = acc + w
		if roll <= acc then return name end
	end
	return next(weights)
end

local function randomSpawnPosition()
	local c = cfg()
	for _ = 1, 10 do
		local x = math.random(c.from.x, c.to.x)
		local y = math.random(c.from.y, c.to.y)
		local pos = Position(x, y, c.bonfirePosition.z)
		-- Spawn at least 3 sqms away from the bonfire so mobs actually have to walk to it.
		local dist = math.max(math.abs(pos.x - c.bonfirePosition.x), math.abs(pos.y - c.bonfirePosition.y))
		if dist >= 3 then
			local tile = Tile(pos)
			if tile and tile:isWalkable(false, false, false, false, true) and not tile:getTopCreature() then
				return pos
			end
		end
	end
	return nil
end

local function spawnWave(phase)
	for _ = 1, phase.waveSize do
		local pos = randomSpawnPosition()
		if pos then
			local name = pickRandomMobType(phase.types)
			local m = Game.createMonster(name, pos, false, true)
			if m then
				if SupremeVocation.fireChamberIsBlizzard() then
					m:changeSpeed(cfg().blizzardSpeedBonus)
				end
				pos:sendMagicEffect(CONST_ME_ICEAREA)
			end
		end
	end
end

-- ---- Random events --------------------------------------------------------

local function broadcast(text)
	for _, p in ipairs(SupremeVocation.fireChamberGetPlayers()) do
		p:sendTextMessage(MESSAGE_EVENT_ADVANCE, text)
	end
end

local function triggerBlizzard()
	local c = cfg()
	FireChamber.blizzardUntil = os.time() + c.blizzardDurationSeconds
	broadcast("A blizzard howls through the chamber! Frost mobs surge.")
	-- Apply speed bonus to existing frost mobs.
	for _, creature in ipairs(Game.getSpectators(c.bonfirePosition, false, false,
			c.bonfirePosition.x - c.from.x, c.to.x - c.bonfirePosition.x,
			c.bonfirePosition.y - c.from.y, c.to.y - c.bonfirePosition.y)) do
		local m = creature:getMonster()
		if m then
			local name = m:getName()
			if name == "Frost Crawler" or name == "Frost Stalker" or name == "Frost Elder" or name == "Hailstorm Brute" then
				m:changeSpeed(c.blizzardSpeedBonus)
			end
		end
	end
end

local function triggerSummerEcho()
	local c = cfg()
	FireChamber.summerEchoUntil = os.time() + c.summerEchoDurationSeconds
	broadcast("A summer echo pulses from the bonfire — the flames push the cold back.")
end

local function triggerHailstormBrute()
	local c = cfg()
	local pos = randomSpawnPosition()
	if pos then
		Game.createMonster(c.hailstormBruteMonster, pos, false, true)
		pos:sendMagicEffect(CONST_ME_ICEAREA)
		broadcast("A Hailstorm Brute crashes into the chamber!")
	end
end

local function rollRandomEvent()
	local ev = cfg().events[math.random(1, #cfg().events)]
	if ev == "blizzard" then triggerBlizzard()
	elseif ev == "summer_echo" then triggerSummerEcho()
	elseif ev == "hailstorm_brute" then triggerHailstormBrute() end
end

-- ---- Bonfire regen --------------------------------------------------------

local function regenBonfire()
	local bonfire = SupremeVocation.fireChamberGetBonfire()
	if not bonfire then return end
	local c = cfg()
	local heal = math.floor(bonfire:getMaxHealth() * c.bonfireRegenPercentEvery10s / 100)
	if heal > 0 then
		bonfire:addHealth(heal)
	end
end

-- ---- Summer echo damage to frost mobs in range ----------------------------

local function damageMobsInSummerEchoRange()
	local c = cfg()
	for _, creature in ipairs(Game.getSpectators(c.bonfirePosition, false, false,
			c.summerEchoRadius, c.summerEchoRadius, c.summerEchoRadius, c.summerEchoRadius)) do
		local m = creature:getMonster()
		if m then
			local name = m:getName()
			if name == "Frost Crawler" or name == "Frost Stalker" or name == "Frost Elder" or name == "Hailstorm Brute" then
				doTargetCombatHealth(0, m, COMBAT_FIREDAMAGE, -c.summerEchoTickDamage, -c.summerEchoTickDamage, CONST_ME_FIREAREA)
			end
		end
	end
end

-- ---- Main tick ------------------------------------------------------------

local function tick()
	FireChamber.tickEvent = nil
	if FireChamber.phase == "idle" then return end

	local players = SupremeVocation.fireChamberGetPlayers()
	if #players == 0 then
		SupremeVocation.fireChamberStop("empty")
		return
	end

	local now = os.time()

	-- Waiting phase: count down, warn at 5s, seal at 0.
	if FireChamber.phase == "waiting" then
		local left = FireChamber.waitingUntil - now
		if left == 5 then broadcast("The chamber will seal in 5 seconds.") end
		if now >= FireChamber.waitingUntil then
			SupremeVocation.fireChamberSeal()
		end
		FireChamber.tickEvent = addEvent(tick, TICK_MS)
		return
	end

	-- Sealed phase.
	local elapsed = now - FireChamber.startedAt
	local c = cfg()

	-- Win condition.
	if elapsed >= c.fightDurationSeconds then
		SupremeVocation.fireChamberComplete()
		return
	end

	-- Bonfire check (lose condition handled by CreatureEvent on death too, but double-safety here).
	local bonfire = SupremeVocation.fireChamberGetBonfire()
	if not bonfire then
		SupremeVocation.fireChamberFail()
		return
	end

	-- Periodic warnings.
	if elapsed == 60 or elapsed == 180 or elapsed == 240 then
		broadcast(string.format("Bonfire defense — %ds elapsed.", elapsed))
	end

	-- Mob spawns.
	if now >= FireChamber.nextSpawnAt then
		local phase = getActivePhase(elapsed)
		spawnWave(phase)
		FireChamber.nextSpawnAt = now + phase.intervalSeconds
	end

	-- Random events.
	if now >= FireChamber.nextEventAt then
		rollRandomEvent()
		FireChamber.nextEventAt = now + c.eventIntervalSeconds
	end

	-- Bonfire regen every 10s.
	if now >= FireChamber.nextRegenAt then
		regenBonfire()
		FireChamber.nextRegenAt = now + 10
	end

	-- Summer echo passive damage.
	if SupremeVocation.fireChamberIsSummerEcho() then
		damageMobsInSummerEchoRange()
	end

	FireChamber.tickEvent = addEvent(tick, TICK_MS)
end

function SupremeVocation.fireChamberStartTick()
	if FireChamber.tickEvent then return end
	FireChamber.tickEvent = addEvent(tick, TICK_MS)
end
