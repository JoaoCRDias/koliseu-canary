-- Voroth Stage Mechanics: phase-based minion spawns + invulnerability and death handling

local shadeSpawns = {
	Position(226, 996, 11),
	Position(236, 996, 11),
	Position(226, 1006, 11),
	Position(236, 1006, 11),
}

local heraldSpawns = {
	Position(231, 994, 11),
	Position(231, 1008, 11),
}

local VorothPhaseHandler = CreatureEvent("VorothPhaseHandler")
local VorothInvulnerable = CreatureEvent("VorothInvulnerable")
local VorothDeath = CreatureEvent("VorothDeath")
local VorothMinionDeath = CreatureEvent("VorothMinionDeath")

local HERALD_RESPAWN_COOLDOWN_S = 30
local HERALD_RESPAWN_COOLDOWN_MS = HERALD_RESPAWN_COOLDOWN_S * 1000

-- Track per-boss state in Lua tables
local phasesSpawned = {} -- bossId -> count (0..3)
local minionCountByBoss = {} -- bossId -> active minion count
local heraldCountByBoss = {} -- bossId -> active heralds
local heraldTimerByBoss = {} -- bossId -> event id of spawner
local heraldCooldownUntilByBoss = {} -- bossId -> os.time() seconds when next herald can spawn

local function getBossId(creature)
	if not creature then return nil end
	return creature:getId()
end

local function cleanVorothState(bossId)
	if not bossId then return end
	phasesSpawned[bossId] = nil
	minionCountByBoss[bossId] = nil
	heraldCountByBoss[bossId] = nil
	heraldCooldownUntilByBoss[bossId] = nil
	local ev = heraldTimerByBoss[bossId]
	if ev then
		stopEvent(ev)
		heraldTimerByBoss[bossId] = nil
	end
end

local function spawnShadesFor(boss)
	local bid = getBossId(boss); if not bid then return end
	local count = 0
	for _, pos in ipairs(shadeSpawns) do
		local m = Game.createMonster("Fallen Shade", pos, true, true)
		if m then
			m:setMaster(boss)
			count = count + 1
		end
	end
	minionCountByBoss[bid] = (minionCountByBoss[bid] or 0) + count
end

local function spawnOneHerald(boss)
	local bid = getBossId(boss); if not bid then return end
	local pos = heraldSpawns[math.random(#heraldSpawns)]
	local m = Game.createMonster("Fallen Herald", pos, true, true)
	if m then
		m:setMaster(boss)
		heraldCountByBoss[bid] = (heraldCountByBoss[bid] or 0) + 1
		minionCountByBoss[bid] = (minionCountByBoss[bid] or 0) + 1
	end
end

local function heraldSpawnerLoop(bossId)
	local boss = Creature(bossId)
	if not boss or boss:isRemoved() or boss:getName() ~= "Voroth The Fallen" then
		heraldTimerByBoss[bossId] = nil
		return
	end
	local now = os.time()
	local nextAllowed = heraldCooldownUntilByBoss[bossId] or 0
	if now < nextAllowed then
		heraldTimerByBoss[bossId] = addEvent(heraldSpawnerLoop, (nextAllowed - now) * 1000, bossId)
		return
	end
	spawnOneHerald(boss)
	heraldTimerByBoss[bossId] = addEvent(heraldSpawnerLoop, HERALD_RESPAWN_COOLDOWN_MS, bossId)
end

function VorothPhaseHandler.onThink(creature)
	if creature:getName() ~= "Voroth The Fallen" then return true end
	local bid = getBossId(creature)
	if not bid then return true end

	local hpPercent = (creature:getHealth() / creature:getMaxHealth()) * 100
	local spawned = phasesSpawned[bid] or 0

	-- Start herald spawner if not running yet
	if not heraldTimerByBoss[bid] then
		heraldTimerByBoss[bid] = addEvent(heraldSpawnerLoop, HERALD_RESPAWN_COOLDOWN_MS, bid)
	end

	-- Trigger at 75%, 50%, 25% (only shades)
	if spawned < 1 and hpPercent <= 75 then
		phasesSpawned[bid] = 1
		creature:say("Shadows, shield me!", TALKTYPE_MONSTER_SAY)
		spawnShadesFor(creature)
	elseif spawned < 2 and hpPercent <= 50 then
		phasesSpawned[bid] = 2
		creature:say("Fade into the dark!", TALKTYPE_MONSTER_SAY)
		spawnShadesFor(creature)
	elseif spawned < 3 and hpPercent <= 25 then
		phasesSpawned[bid] = 3
		creature:say("The abyss rises!", TALKTYPE_MONSTER_SAY)
		spawnShadesFor(creature)
	end
	return true
end

function VorothInvulnerable.onHealthChange(creature, attacker, primaryDamage, primaryType, secondaryDamage, secondaryType)
	if creature:getName() ~= "Voroth The Fallen" then
		return primaryDamage, primaryType, secondaryDamage, secondaryType
	end
	local bid = getBossId(creature)
	local hcount = bid and heraldCountByBoss[bid] or 0
	if hcount and hcount > 0 then
		-- While a Herald is alive: convert incoming damage into healing (rupture-like)
		local heal = 0
		if type(primaryDamage) == 'number' and primaryDamage > 0 then heal = heal + primaryDamage end
		if type(secondaryDamage) == 'number' and secondaryDamage > 0 then heal = heal + secondaryDamage end
		if heal > 0 then
			creature:addHealth(heal)
			creature:getPosition():sendMagicEffect(CONST_ME_MAGIC_GREEN)
		end
		return 0, 0, 0, 0
	end
	return primaryDamage, primaryType, secondaryDamage, secondaryType
end

function VorothDeath.onDeath(creature, corpse, killer, mostDamageKiller, lastHitUnjustified, mostDamageUnjustified)
	if creature:getName() ~= "Voroth The Fallen" then return true end
	local bid = getBossId(creature)

	-- Clean all Voroth state for this boss
	cleanVorothState(bid)

	logger.info("[Voroth] Voroth The Fallen has been defeated!")
	return true
end

function VorothMinionDeath.onDeath(creature)
	-- Try to find bossId from master; if master was already removed, search all tracked bosses
	local bid = nil
	local master = creature:getMaster()
	if master and master:isMonster() and master:getName() == "Voroth The Fallen" then
		bid = master:getId()
	else
		-- Fallback: find the first bossId that has active minion tracking
		for bossId, count in pairs(minionCountByBoss) do
			if count and count > 0 then
				bid = bossId
				break
			end
		end
	end

	if bid then
		minionCountByBoss[bid] = math.max(0, (minionCountByBoss[bid] or 0) - 1)
		if creature:getName() == "Fallen Herald" then
			heraldCountByBoss[bid] = math.max(0, (heraldCountByBoss[bid] or 0) - 1)
			heraldCooldownUntilByBoss[bid] = os.time() + HERALD_RESPAWN_COOLDOWN_S
		end
		if minionCountByBoss[bid] == 0 and master and not master:isRemoved() then
			master:say("Your shadows failed me...", TALKTYPE_MONSTER_SAY)
		end
	end
	return true
end

VorothPhaseHandler:register()
VorothInvulnerable:register()
VorothDeath:register()
VorothMinionDeath:register()
