-- Jacquin Boss Mechanics - Food Quest Stage 2
--
-- Flow:
-- 1. Player steps on TP at end of monster room -> checks if Jacquin is alive
--    - If alive: teleport player to boss room
--    - If not alive: spawn Jacquin, then teleport player to boss room
-- 2. Jacquin summons Enraged Potatoes at 75%, 50%, 25% HP
--    - Potatoes have a 10s fuse. If not killed in time, they explode (3x3 death AoE)
--    - If killed before timer, no explosion
-- 3. On Jacquin death:
--    - A portal spawns at boss corpse position -> leads to reward room
--    - All players in monster room are teleported outside the quest
--    - Portal disappears after 60 seconds

-- ======================
-- Configuration (TODO: fill real positions)
-- ======================
local CONFIG = {
	bossName = "Jacquin",
	potatoName = "Enraged Potato",

	-- TP at end of monster room (set ActionID on the tile in map editor)
	tpActionId = 53110, -- TODO: set actionid on the TP tile

	-- Where the player lands inside the boss room
	bossRoomEntry = Position(800, 1625, 8), -- TODO: replace

	-- Where Jacquin spawns
	bossSpawnPos = Position(800, 1622, 8), -- TODO: replace

	-- Boss room boundaries (to detect players inside)
	bossRoomTopLeft = Position(793, 1618, 8), -- TODO: replace
	bossRoomBottomRight = Position(807, 1629, 8), -- TODO: replace

	-- Monster room boundaries (to kick players on boss death)
	monsterRoomTopLeft = Position(816, 1563, 8), -- TODO: replace
	monsterRoomBottomRight = Position(908, 1673, 8), -- TODO: replace

	-- Where kicked players go (outside the quest)
	questExitPos = Position(897, 1560, 8), -- TODO: replace

	-- Reward room destination (portal after boss death)
	rewardRoomPos = Position(848, 1665, 8), -- TODO: replace

	-- Portal config
	portalDuration = 60, -- seconds before portal disappears
	portalItemId = 1949, -- blue shimmering portal (TODO: adjust if needed)

	-- Potato config
	potatoFuseTime = 10, -- seconds before explosion
	potatoExplosionMin = -30000,
	potatoExplosionMax = -45000,
}

local SUMMON_THRESHOLD_STORAGE = 53100
local THRESHOLDS = { 75, 50, 25 }

-- ======================
-- Helper: check if Jacquin is alive in boss room
-- ======================
local function isBossAlive()
	local centerX = math.floor((CONFIG.bossRoomTopLeft.x + CONFIG.bossRoomBottomRight.x) / 2)
	local centerY = math.floor((CONFIG.bossRoomTopLeft.y + CONFIG.bossRoomBottomRight.y) / 2)
	local center = Position(centerX, centerY, CONFIG.bossRoomTopLeft.z)
	local rangeX = math.ceil((CONFIG.bossRoomBottomRight.x - CONFIG.bossRoomTopLeft.x) / 2)
	local rangeY = math.ceil((CONFIG.bossRoomBottomRight.y - CONFIG.bossRoomTopLeft.y) / 2)

	local spectators = Game.getSpectators(center, false, false, rangeX, rangeX, rangeY, rangeY)
	for _, spec in ipairs(spectators) do
		if spec:isMonster() and spec:getName() == CONFIG.bossName then
			return true
		end
	end
	return false
end

-- ======================
-- Helper: spawn the boss
-- ======================
local function spawnBoss()
	local boss = Game.createMonster(CONFIG.bossName, CONFIG.bossSpawnPos, false, true)
	if boss then
		boss:registerEvent("JacquinThink")
		CONFIG.bossSpawnPos:sendMagicEffect(CONST_ME_TELEPORT)
	end
	return boss
end

-- ======================
-- Potato Explosion (timer expired, potato still alive)
-- ======================
local function explodePotato(potatoId)
	local potato = Creature(potatoId)
	if potato then
		local potatoPos = potato:getPosition()
		potatoPos:sendMagicEffect(CONST_ME_MORTAREA)
		potato:say("* BOOM *", TALKTYPE_MONSTER_YELL)

		local spectators = Game.getSpectators(potatoPos, false, false, 1, 1, 1, 1)
		for _, spec in ipairs(spectators) do
			if spec:isPlayer() then
				doTargetCombatHealth(0, spec, COMBAT_DEATHDAMAGE, CONFIG.potatoExplosionMin, CONFIG.potatoExplosionMax, CONST_ME_MORTAREA)
			end
		end

		potato:remove()
	end
end

-- ======================
-- Helper: kick all players from monster room
-- ======================
local function kickMonsterRoomPlayers()
	local centerX = math.floor((CONFIG.monsterRoomTopLeft.x + CONFIG.monsterRoomBottomRight.x) / 2)
	local centerY = math.floor((CONFIG.monsterRoomTopLeft.y + CONFIG.monsterRoomBottomRight.y) / 2)
	local center = Position(centerX, centerY, CONFIG.monsterRoomTopLeft.z)
	local rangeX = math.ceil((CONFIG.monsterRoomBottomRight.x - CONFIG.monsterRoomTopLeft.x) / 2)
	local rangeY = math.ceil((CONFIG.monsterRoomBottomRight.y - CONFIG.monsterRoomTopLeft.y) / 2)

	local spectators = Game.getSpectators(center, false, true, rangeX, rangeX, rangeY, rangeY)
	for _, spec in ipairs(spectators) do
		if spec:isPlayer() then
			spec:teleportTo(CONFIG.questExitPos)
			spec:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
			spec:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Jacquin has been defeated! You have been removed from the quest area.")
		end
	end
end

-- ======================
-- Helper: spawn reward portal at position
-- ======================
local function spawnRewardPortal(pos)
	local tile = Tile(pos)
	if not tile then
		return
	end

	local portal = Game.createItem(CONFIG.portalItemId, 1, pos)
	if portal then
		portal:setActionId(CONFIG.tpActionId + 1) -- unique AID for reward portal
		pos:sendMagicEffect(CONST_ME_TELEPORT)
	end

	-- Remove portal after duration
	addEvent(function(px, py, pz, itemId)
		local t = Tile(Position(px, py, pz))
		if t then
			local item = t:getItemById(itemId)
			if item then
				item:remove()
				Position(px, py, pz):sendMagicEffect(CONST_ME_POFF)
			end
		end
	end, CONFIG.portalDuration * 1000, pos.x, pos.y, pos.z, CONFIG.portalItemId)
end

-- ======================
-- TP Entry: player steps on TP at end of monster room
-- ======================
local tpEntry = MoveEvent()

function tpEntry.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	if not isBossAlive() then
		spawnBoss()
	end

	player:teleportTo(CONFIG.bossRoomEntry)
	player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	return true
end

tpEntry:type("stepin")
tpEntry:aid(CONFIG.tpActionId)
tpEntry:register()

-- ======================
-- Reward Portal: player steps on portal after boss death
-- ======================
local rewardPortal = MoveEvent()

function rewardPortal.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	player:teleportTo(CONFIG.rewardRoomPos)
	player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	return true
end

rewardPortal:type("stepin")
rewardPortal:aid(CONFIG.tpActionId + 1)
rewardPortal:register()

-- ======================
-- Enraged Potato Death (defused — no explosion)
-- ======================
local potatoDeath = CreatureEvent("EnragedPotatoDeath")

function potatoDeath.onDeath(creature, corpse, killer, mostDamageKiller, lastHitUnjustified, mostDamageUnjustified)
	local pos = creature:getPosition()
	pos:sendMagicEffect(CONST_ME_POFF)
	return true
end

potatoDeath:register()

-- ======================
-- Jacquin Death: portal + kick monster room players
-- ======================
local jacquinDeath = CreatureEvent("JacquinDeath")

function jacquinDeath.onDeath(creature, corpse, killer, mostDamageKiller, lastHitUnjustified, mostDamageUnjustified)
	local pos = creature:getPosition()

	-- Remove remaining potatoes
	local spectators = Game.getSpectators(pos, false, false, 14, 14, 14, 14)
	for _, spec in ipairs(spectators) do
		if spec:isMonster() and spec:getName() == CONFIG.potatoName then
			spec:remove()
		end
	end

	-- Spawn reward portal at boss death position
	spawnRewardPortal(pos)

	-- Kick all players from monster room
	kickMonsterRoomPlayers()

	return true
end

jacquinDeath:register()

-- ======================
-- Jacquin Think: summon potatoes at HP thresholds
-- ======================
local jacquinThink = CreatureEvent("JacquinThink")

function jacquinThink.onThink(creature, interval)
	if not creature or creature:getName() ~= CONFIG.bossName then
		return true
	end

	local hpPercent = math.ceil((creature:getHealth() / creature:getMaxHealth()) * 100)
	local triggered = creature:getStorageValue(SUMMON_THRESHOLD_STORAGE)
	if triggered < 0 then
		triggered = 0
	end

	for i, threshold in ipairs(THRESHOLDS) do
		if hpPercent <= threshold and triggered < i then
			triggered = i
			creature:setStorageValue(SUMMON_THRESHOLD_STORAGE, triggered)

			local bossPos = creature:getPosition()
			creature:say("ORDER UP! Get them, my potatoes!", TALKTYPE_MONSTER_YELL)
			bossPos:sendMagicEffect(CONST_ME_FIREAREA)

			for _ = 1, 2 do
				local summonPos = Position(
					bossPos.x + math.random(-3, 3),
					bossPos.y + math.random(-3, 3),
					bossPos.z
				)
				local tile = Tile(summonPos)
				if tile and tile:isWalkable() then
					local potato = Game.createMonster(CONFIG.potatoName, summonPos, false, true)
					if potato then
						potato:registerEvent("EnragedPotatoDeath")
						summonPos:sendMagicEffect(CONST_ME_TELEPORT)

						local potatoId = potato:getId()
						addEvent(explodePotato, CONFIG.potatoFuseTime * 1000, potatoId)
					end
				end
			end
		end
	end

	return true
end

jacquinThink:register()
