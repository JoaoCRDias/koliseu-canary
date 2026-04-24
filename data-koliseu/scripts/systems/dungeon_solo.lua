-- Dungeon Solo System
-- 5 independent instances, one per vocation
-- 3 stages per run (Gauntlet progression), shared cooldown

if DungeonSolo then
	return
end

DungeonSolo = {}

-- ─────────────────────────────────────────────
-- CONSTANTS
-- ─────────────────────────────────────────────

local DUNGEON_COOLDOWN_STORAGE = 54001 -- Storage.DungeonSolo.Cooldown

-- Vocation IDs (must match data/XML/vocations.xml)
-- Base: Sorcerer=1, Druid=2, Paladin=3, Knight=4
-- Promoted: Master Sorcerer=5, Elder Druid=6, Royal Paladin=7, Elite Knight=8
local VOC_SORCERER = 1
local VOC_DRUID = 2
local VOC_PALADIN = 3
local VOC_KNIGHT = 4

-- Monster storage key used to identify which dungeon instance the monster belongs to
local MONSTER_VOC_STORAGE = 54010

-- ─────────────────────────────────────────────
-- CONFIG
-- ─────────────────────────────────────────────

DungeonSolo.CONFIG = {
	cooldown = serverEnvironment ~= "PRD" and 1 or 20 * 60 * 60, -- 20 hours (shared across all difficulties)

	-- Lobby totems: one per vocation
	-- playerSqm: the exact tile the player must stand on to activate the totem
	-- actionId: action ID registered in dungeon_totem.lua
	totems = {
		[VOC_KNIGHT] = { actionId = 54100, playerSqm = Position(1097, 549, 6) },
		[VOC_PALADIN] = { actionId = 54101, playerSqm = Position(1097, 554, 6) },
		[VOC_SORCERER] = { actionId = 54102, playerSqm = Position(1075, 554, 6) },
		[VOC_DRUID] = { actionId = 54103, playerSqm = Position(1075, 549, 6) },
	},

	-- Monster names per vocation (stages 1 & 2)
	monsterNames = {
		[VOC_KNIGHT] = "Transcendent Knight",
		[VOC_PALADIN] = "Transcendent Paladin",
		[VOC_SORCERER] = "Transcendent Sorcerer",
		[VOC_DRUID] = "Transcendent Druid",
	},

	-- Boss names per vocation (stage 3)
	bossMonsterNames = {
		[VOC_KNIGHT] = "Omniscient Knight",
		[VOC_PALADIN] = "Omniscient Paladin",
		[VOC_SORCERER] = "Omniscient Sorcerer",
		[VOC_DRUID] = "Omniscient Druid",
	},

	-- Vocation names for messages
	vocationNames = {
		[VOC_KNIGHT] = "Knight",
		[VOC_PALADIN] = "Paladin",
		[VOC_SORCERER] = "Sorcerer",
		[VOC_DRUID] = "Druid",
	},

	-- Difficulty configuration
	-- hpScale: multiplier applied to monster max HP via CONDITION_PARAM_STAT_MAXHITPOINTS
	difficulty = {
		very_easy = {
			label = "Very Easy",
			levelRange = "200-500",
			damageDealt = 60,
			damageReceived = 150,
			speedBonus = 0,
			hpScale = 15, -- 15% of base HP
			monsters = { [1] = 50, [2] = 75, [3] = 1 },
			stageTimes = { [1] = 240, [2] = 360, [3] = 600 },
			tokens = 1,
			monsterIcon = CreatureIconModifications_ReducedHealth,
			conditionSubId = 54020,
		},
		easy = {
			label = "Easy",
			levelRange = "500-1000",
			damageDealt = 75,
			damageReceived = 130,
			speedBonus = 0,
			hpScale = 35, -- 35% of base HP
			monsters = { [1] = 50, [2] = 75, [3] = 1 },
			stageTimes = { [1] = 240, [2] = 360, [3] = 600 },
			tokens = 2,
			monsterIcon = CreatureIconModifications_ReducedHealth,
			conditionSubId = 54021,
		},
		medium = {
			label = "Medium",
			levelRange = "1000-2000",
			damageDealt = 105,
			damageReceived = 110,
			speedBonus = 0,
			hpScale = 55, -- 55% of base HP
			monsters = { [1] = 50, [2] = 75, [3] = 1 },
			stageTimes = { [1] = 240, [2] = 360, [3] = 600 },
			tokens = 3,
			monsterIcon = CreatureIconModifications_ReducedHealth,
			conditionSubId = 54022,
		},
		hard = {
			label = "Hard",
			levelRange = "2000-3500",
			damageDealt = 300,
			damageReceived = 60,
			speedBonus = 25,
			hpScale = 120, -- 120% of base HP
			monsters = { [1] = 50, [2] = 75, [3] = 1 },
			stageTimes = { [1] = 240, [2] = 360, [3] = 600 },
			tokens = 5,
			monsterIcon = CreatureIconModifications_ReducedHealth,
			conditionSubId = 54023,
		},
		very_hard = {
			label = "Very Hard",
			levelRange = "3500-5000",
			damageDealt = 900,
			damageReceived = 50,
			speedBonus = 50,
			hpScale = 150, -- 150% of base HP
			monsters = { [1] = 50, [2] = 75, [3] = 1 },
			stageTimes = { [1] = 240, [2] = 360, [3] = 600 },
			tokens = 8,
			monsterIcon = CreatureIconModifications_ReducedHealth,
			conditionSubId = 54024,
		},
		epic = {
			label = "Epic",
			levelRange = "5000+",
			damageDealt = 1800,
			damageReceived = 40,
			speedBonus = 80,
			hpScale = 180, -- 180% of base HP
			monsters = { [1] = 50, [2] = 75, [3] = 1 },
			stageTimes = { [1] = 240, [2] = 360, [3] = 600 },
			tokens = 12,
			monsterIcon = CreatureIconModifications_ReducedHealth,
			conditionSubId = 54025,
		},
	},

	-- Stage 2 condition multiplier (scales on top of base difficulty)
	stage2Multiplier = 1.25, -- stage 2 monsters deal 50% more damage than stage 1

	-- Single exit action ID. Place this AID on any dungeon exit teleporter tile.
	-- Stepping on it cleans up the run for whichever player steps on it.
	exitActionId = 54110,

	-- Room positions per vocation.
	-- Stages 1 and 2 share the SAME room ([1]). Stage 3 is the boss room.
	--
	-- from / to     : bounding box — monsters spawn on random walkable tiles inside
	-- playerEntry   : tile the player teleports to when entering/re-entering the room
	--
	-- Destinations are automatic:
	--   stages 1 & 2 cleared → nextStage() uses [3].playerEntry
	--   stage 3 cleared      → finish() uses lobbyExit

	rooms = {
		[VOC_KNIGHT] = {
			[1] = { from = Position(1119, 390, 6), to = Position(1205, 473, 6), playerEntry = Position(1171, 398, 6) },
			-- [2] intentionally absent — shares [1]
			[3] = { from = Position(1152, 425, 7), to = Position(1175, 441, 7), playerEntry = Position(1162, 429, 7) },
		},
		[VOC_PALADIN] = {
			[1] = { from = Position(1015, 392, 6), to = Position(1103, 470, 6), playerEntry = Position(1070, 398, 6) },
			[3] = { from = Position(1049, 428, 7), to = Position(1073, 447, 7), playerEntry = Position(1060, 434, 7) },
		},
		[VOC_SORCERER] = {
			[1] = { from = Position(918, 392, 6), to = Position(1003, 469, 6), playerEntry = Position(969, 399, 6) },
			[3] = { from = Position(961, 424, 7), to = Position(984, 441, 7), playerEntry = Position(971, 429, 7) },
		},
		[VOC_DRUID] = {
			[1] = { from = Position(921, 484, 6), to = Position(1002, 561, 6), playerEntry = Position(970, 488, 6) },
			[3] = { from = Position(956, 517, 7), to = Position(979, 534, 7), playerEntry = Position(967, 522, 7) },
		},
	},

	lobbyExit = Position(1086, 551, 6), -- lobby position after completing or failing
}

-- ─────────────────────────────────────────────
-- TILE CACHE (built once on first use per room)
-- ─────────────────────────────────────────────

-- Cache: _tileCache[vocationId][roomKey] = { Position, ... }
-- Populated lazily on the first spawnStage call for each room.
-- Avoids rescanning the bounding box on every dungeon run.
-- Tile availability is verified at spawn time before placing creatures.
DungeonSolo._tileCache = {}

-- ─────────────────────────────────────────────
-- INSTANCE STATE (one entry per vocation)
-- ─────────────────────────────────────────────

DungeonSolo._instances = {}
for _, voc in ipairs({ VOC_SORCERER, VOC_DRUID, VOC_PALADIN, VOC_KNIGHT }) do
	DungeonSolo._instances[voc] = {
		occupied = false,
		player = nil,
		difficulty = nil,
		stage = 0,
		monstersCount = 0,
		timerSeconds = 0,
		timerEvent = nil,
	}
end

-- ─────────────────────────────────────────────
-- HELPERS
-- ─────────────────────────────────────────────

-- Maps every vocation ID (base or promoted) to its dungeon instance key
local VOCATION_TO_INSTANCE = {
	[1] = VOC_SORCERER, -- Sorcerer
	[2] = VOC_DRUID, -- Druid
	[3] = VOC_PALADIN, -- Paladin
	[4] = VOC_KNIGHT, -- Knight
	[5] = VOC_SORCERER, -- Master Sorcerer (promoted)
	[6] = VOC_DRUID, -- Elder Druid (promoted)
	[7] = VOC_PALADIN, -- Royal Paladin (promoted)
	[8] = VOC_KNIGHT, -- Elite Knight (promoted)
}

-- Returns the dungeon instance key for a player's vocation
function DungeonSolo.getBaseVocation(player)
	local voc = player:getVocation():getId()
	return VOCATION_TO_INSTANCE[voc]
end

function DungeonSolo.getInstance(vocationId)
	return DungeonSolo._instances[vocationId]
end

function DungeonSolo.isOccupied(vocationId)
	local inst = DungeonSolo._instances[vocationId]
	return inst and inst.occupied
end

function DungeonSolo.isPlayerInDungeon(player)
	local voc = DungeonSolo.getBaseVocation(player)
	local inst = DungeonSolo._instances[voc]
	if not inst or not inst.occupied then
		return false
	end
	return inst.player and inst.player:getId() == player:getId()
end

local function removePlayerIcons(player)
	if not player then return end
	player:removeIcon("dungeon_timer")
	player:removeIcon("dungeon_monsters")
end

local function updateTimerIcon(player, seconds)
	if not player then return end
	-- Display minutes remaining (capped at 999 for icon limit)
	local display = math.min(999, seconds)
	player:setIcon("dungeon_timer", CreatureIconCategory_Quests, CreatureIconQuests_GreenShield, display)
end

local function updateMonsterIcon(player, count)
	if not player then return end
	local display = math.min(999, count)
	player:setIcon("dungeon_monsters", CreatureIconCategory_Quests, CreatureIconQuests_RedBall, display)
end

-- Scans all tiles inside the bounding box [from, to] and returns a list
-- of walkable positions that have no creature on them.
local function getWalkableTiles(from, to)
	local tiles = {}
	for x = from.x, to.x do
		for y = from.y, to.y do
			local pos = Position(x, y, from.z)
			local tile = Tile(pos)
			if tile and tile:isWalkable() and not tile:getTopCreature() and not tile:getItemById(60385) then
				tiles[#tiles+1] = pos
			end
		end
	end
	return tiles
end

-- Returns a room-stage key: stages 1 and 2 both use the [1] room config.
local function getRoomStageKey(stage)
	return (stage <= 2) and 1 or stage
end

local function applyMonsterCondition(monster, diffConfig, stageMult, stage)
	local mult = stageMult or 1.0
	local dmgDealt = math.floor(diffConfig.damageDealt * mult)
	-- damage received scales inversely: multiply reduction symmetrically
	local dmgReceived = diffConfig.damageReceived
	if mult > 1.0 then
		-- On stage 2: make it slightly harder to kill too (receives less damage)
		dmgReceived = math.max(10, math.floor(dmgReceived / mult))
	end

	local cond = Condition(CONDITION_ATTRIBUTES)
	cond:setParameter(CONDITION_PARAM_TICKS, -1)
	cond:setParameter(CONDITION_PARAM_SUBID, diffConfig.conditionSubId)
	cond:setParameter(CONDITION_PARAM_BUFF_DAMAGEDEALT, dmgDealt)
	cond:setParameter(CONDITION_PARAM_BUFF_DAMAGERECEIVED, dmgReceived)
	monster:addCondition(cond)

	-- Scale max HP by difficulty (hpScale = % of base HP to use)
	if diffConfig.hpScale and diffConfig.hpScale < 100 then
		local scaledHp = math.max(1, math.floor(monster:getMaxHealth() * diffConfig.hpScale / 100))
		monster:setMaxHealth(scaledHp)
		monster:addHealth(-(monster:getHealth() - scaledHp))
	end

	if diffConfig.speedBonus > 0 then
		monster:changeSpeed(diffConfig.speedBonus)
	end

	-- Icon displays the current stage number
	monster:setIcon("dungeon_power", CreatureIconCategory_Modifications, diffConfig.monsterIcon, stage or 1)
end

-- ─────────────────────────────────────────────
-- CORE FUNCTIONS
-- ─────────────────────────────────────────────

function DungeonSolo.start(player, vocationId, difficultyKey)
	local inst = DungeonSolo._instances[vocationId]
	if not inst then return end

	local diffConfig = DungeonSolo.CONFIG.difficulty[difficultyKey]
	if not diffConfig then return end

	inst.occupied = true
	inst.player = player
	inst.playerGuid = player:getGuid()
	inst.difficulty = difficultyKey
	inst.stage = 1
	inst.monstersCount = 0
	inst.timerSeconds = diffConfig.stageTimes[1]
	inst.timerEvent = nil

	player:registerEvent("DungeonPlayerDeath")

	local vocName = DungeonSolo.CONFIG.vocationNames[vocationId] or "?"
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE,
		string.format("[Dungeon] Entering %s dungeon - Stage 1/3 - Difficulty: %s", vocName, diffConfig.label))

	local roomConfig = DungeonSolo.CONFIG.rooms[vocationId][1]
	player:teleportTo(roomConfig.playerEntry, true)
	player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)

	DungeonSolo.spawnStage(vocationId)
	DungeonSolo.startTimer(vocationId)
end

function DungeonSolo.spawnStage(vocationId)
	local inst = DungeonSolo._instances[vocationId]
	if not inst or not inst.occupied then return end

	local diffConfig = DungeonSolo.CONFIG.difficulty[inst.difficulty]
	local roomKey = getRoomStageKey(inst.stage)
	local roomConfig = DungeonSolo.CONFIG.rooms[vocationId][roomKey]
	local baseName = (inst.stage == 3)
			and DungeonSolo.CONFIG.bossMonsterNames[vocationId]
			or DungeonSolo.CONFIG.monsterNames[vocationId]
	local count = diffConfig.monsters[inst.stage]
	local stageMult = (inst.stage == 2) and DungeonSolo.CONFIG.stage2Multiplier or 1.0

	inst.monstersCount = 0

	-- Use cached walkable tile list (built once per room, reused on every run)
	if not DungeonSolo._tileCache[vocationId] then
		DungeonSolo._tileCache[vocationId] = {}
	end
	if not DungeonSolo._tileCache[vocationId][roomKey] then
		DungeonSolo._tileCache[vocationId][roomKey] = getWalkableTiles(roomConfig.from, roomConfig.to)
	end

	local cached = DungeonSolo._tileCache[vocationId][roomKey]
	if #cached == 0 then
		print(string.format("[DungeonSolo] WARNING: No walkable tiles found for voc %d stage %d", vocationId, inst.stage))
		return
	end

	-- Copy and shuffle so each run has random distribution without mutating cache
	local walkable = {}
	for i = 1, #cached do walkable[i] = cached[i] end
	for i = #walkable, 2, -1 do
		local j = math.random(i)
		walkable[i], walkable[j] = walkable[j], walkable[i]
	end

	local failedSpawns = 0
	for i = 1, count do
		local spawned = false
		-- Try each cached position, skipping tiles that are currently unavailable
		local startIdx = ((i - 1) % #walkable) + 1
		for attempt = 0, #walkable - 1 do
			local idx = ((startIdx - 1 + attempt) % #walkable) + 1
			local pos = walkable[idx]
			-- Verify tile is still available before attempting spawn
			local tile = Tile(pos)
			if tile and tile:isWalkable() and not tile:getTopCreature() then
				local monster = Game.createMonster(baseName, pos, false, true)
				if monster then
					monster:setStorageValue(MONSTER_VOC_STORAGE, vocationId)
					monster:registerEvent("DungeonMonsterDeath")
					applyMonsterCondition(monster, diffConfig, stageMult, inst.stage)
					inst.monstersCount = inst.monstersCount + 1
					spawned = true
					break
				end
			end
		end
		if not spawned then
			failedSpawns = failedSpawns + 1
		end
	end

	if failedSpawns > 0 then
		print(string.format("[DungeonSolo] WARNING: %d/%d monsters failed to spawn for voc %d stage %d",
			failedSpawns, count, vocationId, inst.stage))
	end

	local player = inst.player
	if player then
		updateMonsterIcon(player, inst.monstersCount)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE,
			string.format("[Dungeon] Stage %d/3 - Kill %d monsters!", inst.stage, inst.monstersCount))
	end
end

function DungeonSolo.onMonsterDeath(vocationId)
	local inst = DungeonSolo._instances[vocationId]
	if not inst or not inst.occupied then return end

	inst.monstersCount = inst.monstersCount - 1
	if inst.monstersCount < 0 then inst.monstersCount = 0 end

	local player = inst.player
	if player then
		updateMonsterIcon(player, inst.monstersCount)
	end

	if inst.monstersCount <= 0 then
		-- Stop the timer before advancing
		if inst.timerEvent then
			stopEvent(inst.timerEvent)
			inst.timerEvent = nil
		end
		if inst.stage >= 3 then
			DungeonSolo.finish(vocationId)
		else
			DungeonSolo.nextStage(vocationId)
		end
	end
end

function DungeonSolo.nextStage(vocationId)
	local inst = DungeonSolo._instances[vocationId]
	if not inst or not inst.occupied then return end

	inst.stage = inst.stage + 1

	local diffConfig = DungeonSolo.CONFIG.difficulty[inst.difficulty]
	local roomKey = getRoomStageKey(inst.stage)
	local roomConfig = DungeonSolo.CONFIG.rooms[vocationId][roomKey]
	local player = inst.player

	-- Clean up any leftover monsters before respawning
	DungeonSolo._cleanRoomMonsters(vocationId, roomKey)

	if player then
		-- Teleport back to room entry (same tile for stages 1→2, new tile for stage 3)
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		player:teleportTo(roomConfig.playerEntry, true)
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE,
			string.format("[Dungeon] Stage %d/3 - The enemies grow stronger!", inst.stage))
	end

	inst.timerSeconds = diffConfig.stageTimes[inst.stage]
	DungeonSolo.spawnStage(vocationId)
	DungeonSolo.startTimer(vocationId)
end

-- Returns how many levels the player should gain from completing a dungeon
local function getDungeonLevelReward(playerLevel)
	if playerLevel < 1000 then return 5 end
	if playerLevel < 2000 then return 4 end
	if playerLevel < 3000 then return 3 end
	if playerLevel < 4000 then return 2 end
	return 1
end

function DungeonSolo.finish(vocationId)
	local inst = DungeonSolo._instances[vocationId]
	if not inst then return end

	local player = inst.player
	local diffConfig = DungeonSolo.CONFIG.difficulty[inst.difficulty]

	-- Safety cleanup: remove any leftover monsters before teleporting player
	DungeonSolo._cleanRoomMonsters(vocationId)

	if player then
		removePlayerIcons(player)

		-- Give dungeon tokens + 1 boosted exercise token (bound to character) in store inbox
		local tokens = diffConfig and diffConfig.tokens or 1
		local inbox = player:getStoreInbox()
		if inbox then
			-- Dungeon tokens
			local dungeonTokenItem = inbox:addItem(16128, tokens)
			if not dungeonTokenItem then
				player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "[Dungeon] Your store inbox is full! Dungeon tokens could not be delivered.")
			end

			-- Boosted exercise token (1 per completion, bound to character)
			local boostedToken = inbox:addItem(60648, 1, INDEX_WHEREEVER, FLAG_NOLIMIT)
			if boostedToken then
				boostedToken:setActionId(IMMOVABLE_ACTION_ID)
				boostedToken:setAttribute(ITEM_ATTRIBUTE_STORE, systemTime())
			else
				player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "[Dungeon] Your store inbox is full! Boosted exercise token could not be delivered.")
			end
		else
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "[Dungeon] Could not access your store inbox. Rewards could not be delivered.")
		end
		player:getPosition():sendMagicEffect(CONST_ME_MAGIC_GREEN)

		-- Give experience (level-based reward)
		local currentLevel = player:getLevel()
		local levelsToGain = getDungeonLevelReward(currentLevel)
		if levelsToGain > 0 then
			local targetLevel = currentLevel + levelsToGain
			local expNeeded = Game.getExperienceForLevel(targetLevel) - player:getExperience()
			if expNeeded > 0 then
				player:addExperience(expNeeded, false)
				player:sendTextMessage(MESSAGE_EVENT_ADVANCE,
					string.format("[Dungeon] You gained %d level%s as a reward!", levelsToGain, levelsToGain ~= 1 and "s" or ""))
			end
		end

		-- Apply cooldown
		player:setStorageValue(DUNGEON_COOLDOWN_STORAGE, os.time() + DungeonSolo.CONFIG.cooldown)

		player:sendTextMessage(MESSAGE_EVENT_ADVANCE,
			string.format("[Dungeon] Completed! You received %d Dungeon Token%s and 1 Boosted Exercise Token.", tokens, tokens ~= 1 and "s" or ""))

		-- Teleport to lobby
		player:teleportTo(DungeonSolo.CONFIG.lobbyExit, true)
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	end

	DungeonSolo._releaseInstance(vocationId)
end

function DungeonSolo.fail(vocationId, reason, playerGuid)
	local inst = DungeonSolo._instances[vocationId]
	if not inst then return end

	-- Clean up remaining monsters BEFORE teleporting player to avoid dragging monsters to PZ
	DungeonSolo._cleanRoomMonsters(vocationId)

	-- Re-resolve by GUID when the caller passed one (death path fires from a
	-- delayed addEvent, so the Player userdata captured there could have been
	-- invalidated if the player logged out between death and teleport).
	local player = playerGuid and Player(playerGuid) or inst.player
	if player then
		removePlayerIcons(player)

		local msg = reason == "death"
				and "[Dungeon] You have died. The dungeon has ended."
				or "[Dungeon] Time's up! You failed to clear the stage in time."

		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, msg)

		player:teleportTo(DungeonSolo.CONFIG.lobbyExit, true)
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	end

	DungeonSolo._releaseInstance(vocationId)
end

function DungeonSolo.startTimer(vocationId)
	local inst = DungeonSolo._instances[vocationId]
	if not inst or not inst.occupied then return end

	local player = inst.player
	if player then
		updateTimerIcon(player, inst.timerSeconds)
	end

	local function tick()
		local i = DungeonSolo._instances[vocationId]
		if not i or not i.occupied then return end

		i.timerSeconds = i.timerSeconds - 1

		local p = i.player
		if p then
			updateTimerIcon(p, i.timerSeconds)
		end

		if i.timerSeconds <= 0 then
			i.timerEvent = nil
			DungeonSolo.fail(vocationId, "timeout")
			return
		end

		i.timerEvent = addEvent(tick, 1000)
	end

	-- Cancel any existing timer first
	if inst.timerEvent then
		stopEvent(inst.timerEvent)
	end

	inst.timerEvent = addEvent(tick, 1000)
end

-- ─────────────────────────────────────────────
-- INTERNAL
-- ─────────────────────────────────────────────

function DungeonSolo._releaseInstance(vocationId)
	local inst = DungeonSolo._instances[vocationId]
	if not inst then return end

	if inst.timerEvent then
		stopEvent(inst.timerEvent)
	end

	-- inst.player may be stale (player died and was removed from the world),
	-- so re-resolve by the GUID stored at start time.
	if inst.playerGuid then
		local livePlayer = Player(inst.playerGuid)
		if livePlayer then
			livePlayer:unregisterEvent("DungeonPlayerDeath")
		end
	end

	inst.occupied = false
	inst.player = nil
	inst.playerGuid = nil
	inst.difficulty = nil
	inst.stage = 0
	inst.monstersCount = 0
	inst.timerSeconds = 0
	inst.timerEvent = nil
end

function DungeonSolo._cleanRoomMonsters(vocationId, roomStage)
	local inst = DungeonSolo._instances[vocationId]
	if not inst then return end

	local key = roomStage or getRoomStageKey(inst.stage)
	local roomConfig = DungeonSolo.CONFIG.rooms[vocationId][key]
	if not roomConfig then return end

	local cx = math.floor((roomConfig.from.x + roomConfig.to.x) / 2)
	local cy = math.floor((roomConfig.from.y + roomConfig.to.y) / 2)
	local rx = math.ceil((roomConfig.to.x - roomConfig.from.x) / 2) + 1
	local ry = math.ceil((roomConfig.to.y - roomConfig.from.y) / 2) + 1
	local center = Position(cx, cy, roomConfig.from.z)

	local specs = Game.getSpectators(center, false, false, rx, rx, ry, ry)
	for _, creature in ipairs(specs) do
		if creature:isMonster() and creature:getStorageValue(MONSTER_VOC_STORAGE) == vocationId then
			creature:remove()
		end
	end
end

-- ─────────────────────────────────────────────
-- PUBLIC: TOTEM CHECK HELPERS
-- ─────────────────────────────────────────────

function DungeonSolo.checkCooldown(player)
	local cooldownEnd = player:getStorageValue(DUNGEON_COOLDOWN_STORAGE)
	if cooldownEnd <= 0 then return false, 0 end
	local remaining = cooldownEnd - os.time()
	if remaining > 0 then
		return true, remaining
	end
	return false, 0
end

function DungeonSolo.showDifficultyModal(player, vocationId)
	local modal = ModalWindow({
		title = "Dungeon - " .. (DungeonSolo.CONFIG.vocationNames[vocationId] or ""),
		message = "Choose your difficulty. Monsters scale to your power.\nCompleting the dungeon rewards Dungeon Tokens and a Boosted Exercise Token.",
	})

	for _, key in ipairs({ "very_easy", "easy", "medium", "hard", "very_hard", "epic" }) do
		local diff = DungeonSolo.CONFIG.difficulty[key]
		local tokenWord = diff.tokens == 1 and "token" or "tokens"
		local label = string.format("%s (Level %s) - %d %s",
			diff.label, diff.levelRange, diff.tokens, tokenWord)

		modal:addChoice(label, function(p, button, choice)
			if button.name == "Enter" then
				-- Re-validate before starting
				local onCooldown, remaining = DungeonSolo.checkCooldown(p)
				if onCooldown then
					p:sendCancelMessage(string.format("[Dungeon] On cooldown. Try again in %s.", Game.getTimeInWords(remaining)))
					return true
				end
				if DungeonSolo.isOccupied(vocationId) then
					p:sendCancelMessage("[Dungeon] This dungeon room is currently occupied. Try again soon.")
					return true
				end
				DungeonSolo.start(p, vocationId, key)
			end
			return true
		end)
	end

	modal:addButton("Enter")
	modal:addButton("Cancel")
	modal:setDefaultEnterButton(0)
	modal:setDefaultEscapeButton(1)
	modal:sendToPlayer(player)
end

-- Exported vocation constants for use in totem script
DungeonSolo.VOC_KNIGHT = VOC_KNIGHT
DungeonSolo.VOC_PALADIN = VOC_PALADIN
DungeonSolo.VOC_SORCERER = VOC_SORCERER
DungeonSolo.VOC_DRUID = VOC_DRUID

-- ─────────────────────────────────────────────
-- TOTEM ACTION REGISTRATION
-- Register directly here to avoid load-order issues
-- ─────────────────────────────────────────────

local function registerTotem(vocationId, actionId)
	local totem = Action()

	function totem.onUse(player, item, fromPosition, target, toPosition, isHotkey)
		local playerVoc = DungeonSolo.getBaseVocation(player)
		if playerVoc ~= vocationId then
			local vocName = DungeonSolo.CONFIG.vocationNames[vocationId] or "this vocation"
			player:sendCancelMessage(string.format("[Dungeon] This totem is for %s only.", vocName))
			return true
		end

		local totemConfig = DungeonSolo.CONFIG.totems[vocationId]
		local requiredPos = totemConfig.playerSqm
		if requiredPos.x ~= 0 or requiredPos.y ~= 0 or requiredPos.z ~= 0 then
			local playerPos = player:getPosition()
			if playerPos.x ~= requiredPos.x or playerPos.y ~= requiredPos.y or playerPos.z ~= requiredPos.z then
				player:sendCancelMessage("[Dungeon] Stand on the marked tile to use this totem.")
				return true
			end
		end

		if DungeonSolo.isPlayerInDungeon(player) then
			player:sendCancelMessage("[Dungeon] You are already inside a dungeon.")
			return true
		end

		local onCooldown, remaining = DungeonSolo.checkCooldown(player)
		if onCooldown then
			player:sendCancelMessage(string.format("[Dungeon] You must wait %s before entering again.", Game.getTimeInWords(remaining)))
			return true
		end

		if DungeonSolo.isOccupied(vocationId) then
			player:sendCancelMessage("[Dungeon] This dungeon room is currently occupied. Please wait a moment.")
			return true
		end

		DungeonSolo.showDifficultyModal(player, vocationId)
		return true
	end

	totem:aid(actionId)
	totem:register()
end

for vocId, totemConfig in pairs(DungeonSolo.CONFIG.totems) do
	registerTotem(vocId, totemConfig.actionId)
end

-- ─────────────────────────────────────────────
-- EXIT TELEPORT REGISTRATION
-- Register here (not in a separate file) to avoid load-order issues
-- ─────────────────────────────────────────────

local dungeonExit = MoveEvent()

function dungeonExit.onStepIn(creature, _item, _position, _fromPosition)
	local player = creature and creature:getPlayer()
	if not player then
		return true
	end

	if not DungeonSolo.isPlayerInDungeon(player) then
		return true
	end

	local vocationId = DungeonSolo.getBaseVocation(player)
	DungeonSolo.fail(vocationId, "exit")
	return true
end

dungeonExit:type("stepin")
dungeonExit:aid(DungeonSolo.CONFIG.exitActionId)
dungeonExit:register()
