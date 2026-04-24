SupremeVocation = {}

SupremeVocation.KV_SCOPE = "supreme-vocation"

SupremeVocation.Positions = {
	mainlandDock = Position(1055, 1016, 6),
	islandDock = Position(96, 95, 6),
}

-- Nature Defender corridor ----------------------------------------------------
SupremeVocation.NatureDefender = {
	-- Inclusive bounding box of the corridor floor (z must be the same).
	from = Position(145, 60, 8),
	to = Position(167, 61, 8),
	z = 8,
	-- Tile transformation while a sqm is "hot" (dealing damage).
	hotItemId = 1020,
	hotEffect = 46, -- magic effect id shown on the hot sqm
	-- Damage as a fraction of the player's max health, applied on each tick a
	-- player stands on a hot tile.
	damageFraction = 0.50,
	-- Cycle cadence in ms.
	tickInterval = 1000,
}

-- Frames are 2 rows x 23 cols binary matrices. Row 1 = north (y=60), col 1 = west (x=145).
-- 1 = sqm becomes hot (damage + visual), 0 = safe.
-- Three frames cycle every tick. Each column sums up to <= 2; some sqms are
-- always safe (refuges) and others alternate, leaving a viable path.
SupremeVocation.NatureDefender.Frames = {
	-- Frame 1
	{
		--   1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16 17 18 19 20 21 22 23
		{   1, 0, 1, 0, 1, 1, 0, 1, 0, 1, 0, 1, 0, 1, 1, 0, 1, 0, 1, 0, 1, 0, 1 }, -- row 1
		{   0, 1, 0, 1, 0, 0, 1, 0, 1, 0, 1, 0, 1, 0, 0, 1, 0, 1, 0, 1, 0, 1, 0 }, -- row 2
	},
	-- Frame 2
	{
		--   1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16 17 18 19 20 21 22 23
		{   0, 1, 0, 1, 0, 1, 1, 0, 1, 0, 1, 0, 1, 0, 1, 1, 0, 1, 0, 1, 0, 1, 0 }, -- row 1
		{   1, 0, 1, 0, 1, 0, 0, 1, 0, 1, 0, 1, 0, 1, 0, 0, 1, 0, 1, 0, 1, 0, 1 }, -- row 2
	},
	-- Frame 3
	{
		--   1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16 17 18 19 20 21 22 23
		{   1, 1, 0, 0, 1, 0, 1, 0, 1, 1, 0, 0, 1, 0, 1, 0, 1, 1, 0, 0, 1, 0, 1 }, -- row 1
		{   0, 0, 1, 1, 0, 1, 0, 1, 0, 0, 1, 1, 0, 1, 0, 1, 0, 0, 1, 1, 0, 1, 0 }, -- row 2
	},
}

-- Lever item transformation.
SupremeVocation.LEVER_INACTIVE = 36709 -- state 0
SupremeVocation.LEVER_ACTIVE = 36710 -- state 1

SupremeVocation.GRID_ROWS = 5
SupremeVocation.GRID_COLS = 4

-- 10 target patterns. Each is a 5-row by 4-col binary matrix.
-- Row 1 is the northernmost row, column 1 is the westernmost column.
-- Player gets one pattern assigned at random; must match it on the lever grid.
SupremeVocation.LeverPatterns = {
	-- Pattern 1: diagonal band
	{
		{ 1, 0, 0, 0 },
		{ 0, 1, 0, 0 },
		{ 0, 0, 1, 0 },
		{ 0, 0, 0, 1 },
		{ 1, 1, 1, 1 },
	},
	-- Pattern 2: hollow rectangle
	{
		{ 1, 1, 1, 1 },
		{ 1, 0, 0, 1 },
		{ 1, 0, 0, 1 },
		{ 1, 0, 0, 1 },
		{ 1, 1, 1, 1 },
	},
	-- Pattern 3: hourglass
	{
		{ 1, 1, 1, 1 },
		{ 0, 1, 1, 0 },
		{ 0, 1, 1, 0 },
		{ 0, 1, 1, 0 },
		{ 1, 1, 1, 1 },
	},
	-- Pattern 4: checkerboard
	{
		{ 1, 0, 1, 0 },
		{ 0, 1, 0, 1 },
		{ 1, 0, 1, 0 },
		{ 0, 1, 0, 1 },
		{ 1, 0, 1, 0 },
	},
	-- Pattern 5: arrow down
	{
		{ 0, 1, 1, 0 },
		{ 0, 1, 1, 0 },
		{ 1, 1, 1, 1 },
		{ 0, 1, 1, 0 },
		{ 0, 0, 1, 0 },
	},
	-- Pattern 6: four corners + mid-cross
	{
		{ 1, 0, 0, 1 },
		{ 0, 0, 0, 0 },
		{ 0, 1, 1, 0 },
		{ 0, 0, 0, 0 },
		{ 1, 0, 0, 1 },
	},
	-- Pattern 7: zigzag
	{
		{ 1, 1, 0, 0 },
		{ 0, 1, 1, 0 },
		{ 0, 0, 1, 1 },
		{ 0, 1, 1, 0 },
		{ 1, 1, 0, 0 },
	},
	-- Pattern 8: double column
	{
		{ 0, 1, 1, 0 },
		{ 1, 0, 0, 1 },
		{ 0, 1, 1, 0 },
		{ 1, 0, 0, 1 },
		{ 0, 1, 1, 0 },
	},
	-- Pattern 9: top-bottom bars
	{
		{ 1, 1, 1, 1 },
		{ 0, 0, 0, 0 },
		{ 1, 1, 1, 1 },
		{ 0, 0, 0, 0 },
		{ 1, 1, 1, 1 },
	},
	-- Pattern 10: inverted pyramid
	{
		{ 1, 1, 1, 1 },
		{ 0, 1, 1, 0 },
		{ 1, 0, 0, 1 },
		{ 0, 1, 1, 0 },
		{ 1, 1, 1, 1 },
	},
}

-- Physical positions of the 20 levers, stored as [row][col].
-- Grid is 5 rows x 4 cols. Row 1 = northmost, col 1 = westmost.
-- Keep all levers on the same z. The order must match LeverPatterns.
SupremeVocation.LeverGrid = {
	-- row 1 (north)
	{ Position(116, 65, 6), Position(118, 65, 6), Position(120, 65, 6), Position(122, 65, 6) },
	-- row 2
	{ Position(116, 66, 6), Position(118, 66, 6), Position(120, 66, 6), Position(122, 66, 6) },
	-- row 3
	{ Position(116, 67, 6), Position(118, 67, 6), Position(120, 67, 6), Position(122, 67, 6) },
	-- row 4
	{ Position(116, 68, 6), Position(118, 68, 6), Position(120, 68, 6), Position(122, 68, 6) },
	-- row 5 (south)
	{ Position(116, 69, 6), Position(118, 69, 6), Position(120, 69, 6), Position(122, 69, 6) },
}

-- Action ids for the supreme vocation quest line. Reserved range 60000-60099.
SupremeVocation.MechanismActionId = 60001
SupremeVocation.EnergyWallActionId = 60004
SupremeVocation.NatureBossSummonActionId = 60006
SupremeVocation.NatureChestActionId = 60007
SupremeVocation.NatureFountainActionId = 60008
SupremeVocation.PoisonBarrierActionId = 60009
SupremeVocation.PoisonMechanismActionId = 60010
SupremeVocation.PoisonEntryActionId = 60011
SupremeVocation.DeathBarrierActionId = 60012
-- Death chamber ---
SupremeVocation.DeathLabyrinthChestActionId = 60013
SupremeVocation.DeathLabyrinthTrapActionId = 60014
SupremeVocation.DeathMuralActionId = 60015
SupremeVocation.DeathTotemActionIds = { 60016, 60017, 60018, 60019 } -- index maps to ghost index
-- Puzzle NPC stage gate: handled via DeathPuzzleSolved storage + MoveEvent on the stair/tile.
SupremeVocation.DeathStairActionId = 60020
SupremeVocation.FireBarrierActionId = 60021
SupremeVocation.FireEntryActionId = 60022
SupremeVocation.WealthBarrierActionId = 60024
SupremeVocation.SummitBarrierActionId = 60025
-- Sealed doors gating the mountain use the engine's quest-door system:
-- set the door's action id in the map editor to Storage.SupremeVocation.MissionAccess (60201).
-- The stock quest_door action opens it for any player whose storage value is not -1.

-- How often the active pattern rotates (seconds).
SupremeVocation.PATTERN_ROTATION_SECONDS = 5 * 60

-- KV helpers -----------------------------------------------------------------

local function kv(player)
	return player:kv():scoped(SupremeVocation.KV_SCOPE)
end

function SupremeVocation.hasStartedMountain(player)
	return kv(player):get("mountain-started") == true
end

function SupremeVocation.startMountain(player)
	local scope = kv(player)
	scope:set("mountain-started", true)

	-- Quest log + sealed door access. The engine's quest_door action opens for
	-- players whose storage value at the door's actionid is not -1; setting this
	-- storage here is what grants passage through the sealed door.
	if player:getStorageValue(Storage.SupremeVocation.QuestLine) < 1 then
		player:setStorageValue(Storage.SupremeVocation.QuestLine, 1)
	end
	if player:getStorageValue(Storage.SupremeVocation.MissionAccess) < 1 then
		player:setStorageValue(Storage.SupremeVocation.MissionAccess, 1)
	end
end

function SupremeVocation.hasMountainAccess(player)
	return kv(player):get("mountain-access") == true
end

function SupremeVocation.grantMountainAccess(player)
	kv(player):set("mountain-access", true)
	player:setStorageValue(Storage.SupremeVocation.MissionAccess, 2)
end

-- Global active pattern --------------------------------------------------------
-- Single pattern is active server-wide at any moment, rotating on a timer.
-- Stored in global storage as an integer index into LeverPatterns.

function SupremeVocation.getActivePatternIndex()
	local index = Game.getStorageValue(GlobalStorage.SupremeVocation.ActivePattern)
	if not index or index < 1 or index > #SupremeVocation.LeverPatterns then
		return nil
	end
	return index
end

function SupremeVocation.getActivePattern()
	local index = SupremeVocation.getActivePatternIndex()
	if not index then
		return nil
	end
	return SupremeVocation.LeverPatterns[index]
end

function SupremeVocation.rotateActivePattern()
	local current = SupremeVocation.getActivePatternIndex()
	local count = #SupremeVocation.LeverPatterns
	local next
	if count <= 1 then
		next = 1
	else
		repeat
			next = math.random(1, count)
		until next ~= current
	end
	Game.setStorageValue(GlobalStorage.SupremeVocation.ActivePattern, next)
	SupremeVocation.resetAllLevers()
	return next
end

-- Read current state of the lever grid (0/1 matrix) from the tiles.
function SupremeVocation.readLeverState()
	local state = {}
	for row = 1, SupremeVocation.GRID_ROWS do
		state[row] = {}
		for col = 1, SupremeVocation.GRID_COLS do
			local pos = SupremeVocation.LeverGrid[row][col]
			local tile = Tile(pos)
			if tile and tile:getItemById(SupremeVocation.LEVER_ACTIVE) then
				state[row][col] = 1
			else
				state[row][col] = 0
			end
		end
	end
	return state
end

function SupremeVocation.matchesPattern(state, pattern)
	for row = 1, SupremeVocation.GRID_ROWS do
		for col = 1, SupremeVocation.GRID_COLS do
			if state[row][col] ~= pattern[row][col] then
				return false
			end
		end
	end
	return true
end

-- Count how many cells of the grid match the target pattern. Used to give the
-- player partial feedback on their attempt without revealing which cells differ.
function SupremeVocation.countMatches(state, pattern)
	local matches = 0
	for row = 1, SupremeVocation.GRID_ROWS do
		for col = 1, SupremeVocation.GRID_COLS do
			if state[row][col] == pattern[row][col] then
				matches = matches + 1
			end
		end
	end
	return matches
end

-- Reset every lever on the grid back to the inactive state.
function SupremeVocation.resetAllLevers()
	for row = 1, SupremeVocation.GRID_ROWS do
		for col = 1, SupremeVocation.GRID_COLS do
			local pos = SupremeVocation.LeverGrid[row][col]
			local tile = Tile(pos)
			local active = tile and tile:getItemById(SupremeVocation.LEVER_ACTIVE)
			if active then
				active:transform(SupremeVocation.LEVER_INACTIVE)
			end
		end
	end
end

-- Nature Defender corridor ----------------------------------------------------

-- Stores the original itemid of each "hot-capable" tile so we can restore it
-- after a tick. Keyed by "x,y,z". Populated lazily on first hot transform.
local natureOriginalIds = {}

local function tileKey(pos)
	return pos.x .. "," .. pos.y .. "," .. pos.z
end

local function corridorPosition(row, col)
	local cfg = SupremeVocation.NatureDefender
	return Position(cfg.from.x + (col - 1), cfg.from.y + (row - 1), cfg.z)
end

-- Apply earth damage equal to a fraction of the player's max health.
local function damagePlayerOnHotTile(player)
	local cfg = SupremeVocation.NatureDefender
	local damage = math.floor(player:getMaxHealth() * cfg.damageFraction)
	if damage <= 0 then
		return
	end
	doTargetCombatHealth(0, player, COMBAT_EARTHDAMAGE, -damage, -damage, CONST_ME_NONE)
end

-- Restore every hot tile back to its stored original itemid.
local function restoreAllHotTiles()
	local cfg = SupremeVocation.NatureDefender
	for key, originalId in pairs(natureOriginalIds) do
		local x, y, z = key:match("^(%-?%d+),(%-?%d+),(%-?%d+)$")
		if x then
			local pos = Position(tonumber(x), tonumber(y), tonumber(z))
			local tile = Tile(pos)
			local hotItem = tile and tile:getItemById(cfg.hotItemId)
			if hotItem then
				hotItem:transform(originalId)
			end
		end
	end
end

-- Activate a frame: transform marked sqms to the hot itemid, send the visual
-- effect, and damage any player standing on them.
function SupremeVocation.activateNatureFrame(frameIndex)
	local cfg = SupremeVocation.NatureDefender
	local frame = cfg.Frames[frameIndex]
	if not frame then
		return
	end

	-- Restore previous tick's hot tiles first so the corridor only ever shows
	-- the current frame's danger.
	restoreAllHotTiles()

	for row = 1, #frame do
		local rowData = frame[row]
		for col = 1, #rowData do
			if rowData[col] == 1 then
				local pos = corridorPosition(row, col)
				local tile = Tile(pos)
				if tile then
					local ground = tile:getGround()
					if ground and ground:getId() ~= cfg.hotItemId then
						natureOriginalIds[tileKey(pos)] = ground:getId()
						ground:transform(cfg.hotItemId)
					end
					pos:sendMagicEffect(cfg.hotEffect)

					-- Damage any player currently on this sqm.
					local creatures = tile:getCreatures()
					if creatures then
						for _, creature in ipairs(creatures) do
							local p = creature:getPlayer()
							if p then
								damagePlayerOnHotTile(p)
							end
						end
					end
				end
			end
		end
	end
end

-- Frame index advances by 1 on every tick of the global driver.
local natureFrameIndex = 0

function SupremeVocation.advanceNatureFrame()
	local cfg = SupremeVocation.NatureDefender
	natureFrameIndex = (natureFrameIndex % #cfg.Frames) + 1
	return natureFrameIndex
end

function SupremeVocation.getCurrentNatureFrameIndex()
	if natureFrameIndex == 0 then
		return 1
	end
	return natureFrameIndex
end

-- Report & Energy wall -------------------------------------------------------

function SupremeVocation.hasReportedTrial(player)
	return player:getStorageValue(Storage.SupremeVocation.MissionReport) >= 2
end

function SupremeVocation.completeReport(player)
	if player:getStorageValue(Storage.SupremeVocation.MissionReport) < 2 then
		player:setStorageValue(Storage.SupremeVocation.MissionReport, 2)
	end
	if player:getStorageValue(Storage.SupremeVocation.EnergyWallAccess) < 1 then
		player:setStorageValue(Storage.SupremeVocation.EnergyWallAccess, 1)
	end
	if player:getStorageValue(Storage.SupremeVocation.MissionBasinRitual) < 1 then
		player:setStorageValue(Storage.SupremeVocation.MissionBasinRitual, 1)
	end
end

-- Flag the "Report" mission as in-progress the moment the player completes the
-- trial of access. Called from the mechanism action on success.
function SupremeVocation.startReport(player)
	if player:getStorageValue(Storage.SupremeVocation.MissionReport) < 1 then
		player:setStorageValue(Storage.SupremeVocation.MissionReport, 1)
	end
end

-- Plant extraction -----------------------------------------------------------
--
-- Four plants are scattered across the continent. Each one has a uniqueId set
-- in the map editor that matches an entry below, and grants a single extract
-- item when used. The plant then enters a 4h cooldown for that player.

SupremeVocation.PLANT_COOLDOWN_SECONDS = 4 * 60 * 60

-- uniqueId (map editor) -> extractItemId handed out on interaction.
SupremeVocation.Plants = {
	[60301] = 7245,
	[60302] = 7251,
	[60303] = 7248,
	[60304] = 7249,
}

-- Full set of extract item ids, used by the basin ritual validator.
SupremeVocation.BASIN_EXTRACT_IDS = { 7245, 7251, 7248, 7249 }

local function plantCooldownKey(uniqueId)
	return "plant-cd-" .. uniqueId
end

function SupremeVocation.getPlantCooldownRemaining(player, uniqueId)
	local expires = kv(player):get(plantCooldownKey(uniqueId)) or 0
	local remaining = expires - os.time()
	return remaining > 0 and remaining or 0
end

function SupremeVocation.setPlantCooldown(player, uniqueId)
	kv(player):set(plantCooldownKey(uniqueId), os.time() + SupremeVocation.PLANT_COOLDOWN_SECONDS)
end

-- Basin ritual ---------------------------------------------------------------
--
-- The four basins live in the nature sanctum. The player places one extract
-- item on top of each basin, then uses the central mechanism. If all four
-- distinct extracts are present (one per basin, any order), the mechanism
-- spawns the portal for a limited window.

SupremeVocation.BasinRitual = {
	-- Fill these with the actual map positions of the four basin sqms.
	basinPositions = {
		Position(142, 62, 7),
		Position(142, 66, 7),
		Position(148, 62, 7),
		Position(148, 66, 7),
	},
	mechanismActionId = 60005,
	portalItemId = 775,
	portalPosition = Position(145, 63, 7),
	portalDestination = Position(144, 69, 8),
	portalDurationSeconds = 60,
}

-- Scan each basin tile and return the list of extract ids found (one per
-- basin, nil if that basin is empty or holds a non-extract item).
local function readBasinExtracts()
	local cfg = SupremeVocation.BasinRitual
	local found = {}
	for i, pos in ipairs(cfg.basinPositions) do
		local tile = Tile(pos)
		local extract = nil
		if tile then
			for _, extractId in ipairs(SupremeVocation.BASIN_EXTRACT_IDS) do
				if tile:getItemById(extractId) then
					extract = extractId
					break
				end
			end
		end
		found[i] = extract
	end
	return found
end

-- True when each basin holds a different extract and all four extracts are
-- present.
function SupremeVocation.validateBasins()
	local found = readBasinExtracts()
	local seen = {}
	for i = 1, 4 do
		if not found[i] or seen[found[i]] then
			return false
		end
		seen[found[i]] = true
	end
	return true
end

-- Consume (remove) the extracts placed on the basins after a successful ritual.
function SupremeVocation.consumeBasinExtracts()
	local cfg = SupremeVocation.BasinRitual
	for _, pos in ipairs(cfg.basinPositions) do
		local tile = Tile(pos)
		if tile then
			for _, extractId in ipairs(SupremeVocation.BASIN_EXTRACT_IDS) do
				local item = tile:getItemById(extractId)
				if item then
					item:remove()
					pos:sendMagicEffect(CONST_ME_MAGIC_GREEN)
					break
				end
			end
		end
	end
end

-- Spawn the portal at the configured position for the configured duration.
-- If a portal is already there (previous ritual still active) its timer is
-- effectively extended since we leave it alone and schedule a new removal.
function SupremeVocation.openBasinPortal()
	local cfg = SupremeVocation.BasinRitual
	local tile = Tile(cfg.portalPosition)
	local existing = tile and tile:getItemById(cfg.portalItemId)
	if not existing then
		local item = Game.createItem(cfg.portalItemId, 1, cfg.portalPosition)
		if item and item:isTeleport() then
			item:setDestination(cfg.portalDestination)
		end
	end
	cfg.portalPosition:sendMagicEffect(CONST_ME_TELEPORT)

	addEvent(function(pos, itemId)
		local t = Tile(pos)
		local portal = t and t:getItemById(itemId)
		if portal then
			portal:remove()
			pos:sendMagicEffect(CONST_ME_POFF)
		end
	end, cfg.portalDurationSeconds * 1000, cfg.portalPosition, cfg.portalItemId)
end

-- Mark basin ritual as "portal opened" on success (state 2 of the mission).
function SupremeVocation.markBasinRitualOpened(player)
	if player:getStorageValue(Storage.SupremeVocation.MissionBasinRitual) < 2 then
		player:setStorageValue(Storage.SupremeVocation.MissionBasinRitual, 2)
	end
end

-- Nature boss (Sylvareth the Unyielding) -------------------------------------

-- Item handed out by the nature-sanctum chest to purify the fountain.
SupremeVocation.FOUNTAIN_PURIFIER_ITEM_ID = 133

SupremeVocation.NatureBoss = {
	name = "Sylvareth the Unyielding",
	spawnPosition = Position(169, 71, 8),
	areaFrom = Position(163, 63, 8),
	areaTo = Position(175, 76, 8),
	-- Tick cadence of the boss mechanic driver.
	tickIntervalMs = 1000,
	-- Purify-phase trigger.
	triggerCheckIntervalMs = 10000, -- every 10s roll a check
	triggerChance = 50, -- 15% on each check
	-- Purify phase parameters.
	phaseDurationSeconds = 30,
	stepsRequired = 3,
	stepSwapIntervalMs = 5000,
	stepItemId = 23728,
	stepEffect = CONST_ME_GREEN_RINGS,
	-- Candidate step positions; one is active at a time, shuffled every swap.
	stepPositions = {
		Position(167, 67, 8),
		Position(171, 70, 8),
		Position(170, 72, 8),
		Position(166, 72, 8),
		Position(165, 69, 8),
		Position(169, 70, 8),
		Position(166, 67, 8),
	},
	-- Reflect multiplier on the attacker while the phase is active.
	reflectMultiplier = 2,
	-- Timeout punishment (phase expired without all steps completed).
	timeoutAgonyFraction = 0.95, -- damage as % of player max health
	timeoutHealFraction = 0.10, -- % of max health the boss recovers
	timeoutEnrageSeconds = 15,
	timeoutEnrageDamageBonus = 50, -- percent
	-- Slow while in the phase (additive delta to the boss's current speed).
	-- Boss base speed is 340; -170 leaves ~half speed so the player can outpace it.
	phaseSpeedPenalty = -170,
}

-- Runtime state (single instance; only one boss allowed in the area at a time).
NatureBoss = NatureBoss or {
	bossId = nil,
	phaseActive = false,
	phaseStepsLeft = 0,
	phaseSecondsLeft = 0,
	currentStepPos = nil,
	tickEvent = nil,
	swapEvent = nil,
	enrageUntil = 0,
	originalSpeed = nil,
}

function SupremeVocation.isBossAreaClear()
	return NatureBoss.bossId == nil or not Creature(NatureBoss.bossId)
end

function SupremeVocation.isBossPhaseActive()
	return NatureBoss.phaseActive == true
end

function SupremeVocation.getBossReflectMultiplier()
	return SupremeVocation.NatureBoss.reflectMultiplier
end

function SupremeVocation.isBossEnraged()
	return NatureBoss.enrageUntil > os.time()
end

function SupremeVocation.getBossEnrageBonusPercent()
	return SupremeVocation.NatureBoss.timeoutEnrageDamageBonus
end

function SupremeVocation.grantNatureBossReward(playerId)
	local player = Player(playerId)
	if not player then
		return
	end
	if player:getStorageValue(Storage.SupremeVocation.NatureBossKilled) < 1 then
		player:setStorageValue(Storage.SupremeVocation.NatureBossKilled, 1)
	end
end

-- Fountain purification ------------------------------------------------------

function SupremeVocation.hasPurifiedFountain(player)
	return player:getStorageValue(Storage.SupremeVocation.MissionBasinRitual) >= 3
end

function SupremeVocation.markFountainPurified(player)
	if player:getStorageValue(Storage.SupremeVocation.MissionBasinRitual) < 3 then
		player:setStorageValue(Storage.SupremeVocation.MissionBasinRitual, 3)
	end
end

function SupremeVocation.hasCompletedNatureStage(player)
	return player:getStorageValue(Storage.SupremeVocation.NatureStageComplete) >= 1
end

function SupremeVocation.completeNatureStage(player)
	if player:getStorageValue(Storage.SupremeVocation.NatureStageComplete) < 1 then
		player:setStorageValue(Storage.SupremeVocation.NatureStageComplete, 1)
	end
	if player:getStorageValue(Storage.SupremeVocation.PoisonStageAccess) < 1 then
		player:setStorageValue(Storage.SupremeVocation.PoisonStageAccess, 1)
	end
end

-- Poison stage helpers -------------------------------------------------------

function SupremeVocation.hasClearedPoisonRoom(player)
	return player:getStorageValue(Storage.SupremeVocation.PoisonRoomCleared) >= 1
end

function SupremeVocation.hasPoisonReportPending(player)
	return player:getStorageValue(Storage.SupremeVocation.MissionPoisonReport) == 1
end

function SupremeVocation.hasCompletedPoisonStage(player)
	return player:getStorageValue(Storage.SupremeVocation.PoisonStageComplete) >= 1
end

function SupremeVocation.completePoisonStage(player)
	if player:getStorageValue(Storage.SupremeVocation.PoisonStageComplete) < 1 then
		player:setStorageValue(Storage.SupremeVocation.PoisonStageComplete, 1)
	end
	-- Mark the report mission as completed (state 2 in the quest log).
	if player:getStorageValue(Storage.SupremeVocation.MissionPoisonReport) < 2 then
		player:setStorageValue(Storage.SupremeVocation.MissionPoisonReport, 2)
	end
end

-- Poison room (Cogumelos + Maldição + Inundação) -----------------------------

SupremeVocation.PoisonRoom = {
	-- Bounding box of the room (inclusive).
	from = Position(70, 170, 8),
	to = Position(84, 184, 8),
	-- Center of the room: pedestal/mechanism sits here.
	center = Position(77, 177, 8),
	-- Where the player lands after stepping on the entry teleport in the hub.
	dropPosition = Position(77, 179, 8),
	-- Where players are sent after the chamber is cleared.
	hubReturnPosition = Position(186, 82, 7),

	-- Items.
	floodItemId = 105,               -- client id of the field item placed on top of the ground
	mushroomLookTypeEx = 43587,      -- visual carried by the explosive mushroom
	antidoteItemId = 21188,          -- vial dropped by exploding mushrooms
	mushroomMonsterName = "Gloom Spore",

	-- Curse: DOT escalates each tier.
	curseTiers = { 1, 2, 4, 8, 16, 32, 50 }, -- percent of maxHP per DOT tick
	curseTierIntervalSeconds = 15,            -- how often curse tier escalates
	curseDotIntervalSeconds = 1,              -- DOT pulse interval
	curseSpeedPenalty = -200,             -- speed delta applied at the cap tier
	curseHealingPenalty = -50,            -- % healing reduction at the cap tier (informational; applied via stat condition)

	-- Mushroom spawns.
	mushroomSpawnIntervalSeconds = 4,
	mushroomFuseSeconds = 2,         -- delay between spawn and explosion
	mushroomExplosionRadius = 2,     -- 5x5 area centred on the mushroom
	mushroomDamageFraction = 0.50,   -- damage as % of player's max health
	mushroomDropChance = 15,         -- percent for antidote drop
	antidoteDecaySeconds = 30,       -- seconds the antidote vial stays on the floor
	mushroomSpawnRingMin = 2,
	mushroomSpawnRingMax = 5,
	mushroomsPerPlayer = 4,          -- mushrooms spawned per player on each tick

	-- Quadrant flooding.
	quadrantCycleSeconds = 10,
	quadrantWarnSeconds = 2,         -- warn-only window before flooding
	quadrantFloodDotPercentPerSecond = 35,  -- percent maxHP per second standing in a flooded quadrant
	quadrantWeights = { -- count -> weight
		[1] = 20,
		[2] = 50,
		[3] = 30,
	},

	-- Mechanism progression.
	mechanismRequired = 10,
	mechanismDecayIntervalSeconds = 60,

	-- Antidote behaviour.
	antidoteDrinkCooldownSeconds = 5,

	-- Catastrophic timeout.
	timeoutSeconds = 5 * 60,
	timeoutAgonyFraction = 0.95,
}

-- Runtime singleton state for the poison room. Only one fight at a time.
-- phase: "idle" (no fight, accepting entries)
--        "waiting" (someone entered, 10s pre-seal window, accepting entries)
--        "sealed" (mechanics running, entries rejected)
PoisonRoom = PoisonRoom or {
	phase = "idle",
	waitingUntil = 0,        -- os.time() when waiting ends and sealing begins
	startedAt = 0,           -- os.time() when sealed phase started
	mechanismCount = 0,
	lastDepositAt = 0,
	currentQuadrants = {},   -- list of quadrant indexes currently flooded
	warningQuadrants = {},   -- being warned (not yet flooded)
	tickEvent = nil,
	nextMushroomAt = 0,
	nextQuadrantAt = 0,
	nextDecayAt = 0,
	playerStates = {},       -- [playerId] = { curseTier, nextEscalateAt, nextDotAt, lastDrinkAt, joinedAt }
}

SupremeVocation.PoisonRoom.waitingSeconds = 10

local function poisonKey(pos)
	return pos.x .. "," .. pos.y .. "," .. pos.z
end

local function poisonCfg()
	return SupremeVocation.PoisonRoom
end

-- Geometry helpers -----------------------------------------------------------

-- Quadrant indexing (centered on the mechanism center):
-- 1 = NW, 2 = NE, 3 = SW, 4 = SE
local function quadrantBounds(index)
	local cfg = poisonCfg()
	local cx, cy = cfg.center.x, cfg.center.y
	if index == 1 then     -- NW
		return cfg.from.x, cfg.from.y, cx - 1, cy - 1
	elseif index == 2 then -- NE
		return cx + 1, cfg.from.y, cfg.to.x, cy - 1
	elseif index == 3 then -- SW
		return cfg.from.x, cy + 1, cx - 1, cfg.to.y
	else                   -- SE
		return cx + 1, cy + 1, cfg.to.x, cfg.to.y
	end
end

local function quadrantOf(pos)
	local cfg = poisonCfg()
	if pos.z ~= cfg.center.z then return nil end
	if pos.x < cfg.from.x or pos.x > cfg.to.x then return nil end
	if pos.y < cfg.from.y or pos.y > cfg.to.y then return nil end
	if pos.x == cfg.center.x or pos.y == cfg.center.y then return nil end -- center cross is neutral
	if pos.x < cfg.center.x and pos.y < cfg.center.y then return 1
	elseif pos.x > cfg.center.x and pos.y < cfg.center.y then return 2
	elseif pos.x < cfg.center.x and pos.y > cfg.center.y then return 3
	else return 4 end
end

local function getRoomPlayers()
	local cfg = poisonCfg()
	local players = {}
	for _, creature in ipairs(Game.getSpectators(cfg.center, false, true,
			cfg.center.x - cfg.from.x, cfg.to.x - cfg.center.x,
			cfg.center.y - cfg.from.y, cfg.to.y - cfg.center.y)) do
		if creature:isPlayer() then
			players[#players + 1] = creature
		end
	end
	return players
end

function SupremeVocation.poisonRoomQuadrantOf(pos)
	return quadrantOf(pos)
end

function SupremeVocation.poisonRoomIsFlooded(pos)
	local q = quadrantOf(pos)
	if not q then return false end
	for _, active in ipairs(PoisonRoom.currentQuadrants) do
		if active == q then return true end
	end
	return false
end

function SupremeVocation.poisonRoomGetPlayers()
	return getRoomPlayers()
end

-- Curse helpers --------------------------------------------------------------

function SupremeVocation.poisonRoomEnsurePlayerState(player)
	local id = player:getId()
	local state = PoisonRoom.playerStates[id]
	if not state then
		state = {
			curseTier = 1,
			nextEscalateAt = os.time() + poisonCfg().curseTierIntervalSeconds,
			nextDotAt = os.time() + poisonCfg().curseDotIntervalSeconds,
			lastDrinkAt = 0,
			joinedAt = os.time(),
		}
		PoisonRoom.playerStates[id] = state
	end
	return state
end

function SupremeVocation.poisonRoomResetPlayerCurse(player)
	local state = SupremeVocation.poisonRoomEnsurePlayerState(player)
	state.curseTier = 1
	state.nextEscalateAt = os.time() + poisonCfg().curseTierIntervalSeconds
	state.nextDotAt = os.time() + poisonCfg().curseDotIntervalSeconds
end

function SupremeVocation.poisonRoomGetPlayerCurseTier(playerId)
	local state = PoisonRoom.playerStates[playerId]
	return state and state.curseTier or 0
end

function SupremeVocation.poisonRoomCanDrink(player)
	local state = SupremeVocation.poisonRoomEnsurePlayerState(player)
	local now = os.time()
	return (now - state.lastDrinkAt) >= poisonCfg().antidoteDrinkCooldownSeconds
end

function SupremeVocation.poisonRoomMarkDrink(player)
	local state = SupremeVocation.poisonRoomEnsurePlayerState(player)
	state.lastDrinkAt = os.time()
end

-- Mechanism progression ------------------------------------------------------

function SupremeVocation.poisonRoomDeposit(player)
	if PoisonRoom.phase ~= "sealed" then return false end
	if PoisonRoom.mechanismCount >= poisonCfg().mechanismRequired then return false end
	PoisonRoom.mechanismCount = PoisonRoom.mechanismCount + 1
	PoisonRoom.lastDepositAt = os.time()
	return true
end

function SupremeVocation.poisonRoomGetMechanismCount()
	return PoisonRoom.mechanismCount
end

function SupremeVocation.poisonRoomComplete()
	local hub = poisonCfg().hubReturnPosition
	for _, p in ipairs(getRoomPlayers()) do
		if p:getStorageValue(Storage.SupremeVocation.PoisonRoomCleared) < 1 then
			p:setStorageValue(Storage.SupremeVocation.PoisonRoomCleared, 1)
		end
		-- Mark the report-pending mission so the quest log advances.
		if p:getStorageValue(Storage.SupremeVocation.MissionPoisonReport) < 1 then
			p:setStorageValue(Storage.SupremeVocation.MissionPoisonReport, 1)
		end
		p:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The pedestal pulses, the curse fades. The chamber falls silent.")
		p:teleportTo(hub, true)
		hub:sendMagicEffect(CONST_ME_TELEPORT)
		p:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Return to the elder warrior to report your trial.")
	end
	SupremeVocation.poisonRoomStop("completed")
end

function SupremeVocation.poisonRoomStop(reason)
	PoisonRoom.phase = "idle"
	if PoisonRoom.tickEvent then
		stopEvent(PoisonRoom.tickEvent)
		PoisonRoom.tickEvent = nil
	end
	-- Remove any lingering flood items inside the room.
	local cfg = poisonCfg()
	for x = cfg.from.x, cfg.to.x do
		for y = cfg.from.y, cfg.to.y do
			local tile = Tile(Position(x, y, cfg.center.z))
			if tile then
				local fld = tile:getItemById(cfg.floodItemId)
				if fld then
					fld:remove()
				end
			end
		end
	end
	PoisonRoom.currentQuadrants = {}
	PoisonRoom.warningQuadrants = {}
	PoisonRoom.playerStates = {}
	PoisonRoom.mechanismCount = 0
	PoisonRoom.lastDepositAt = 0
	PoisonRoom.startedAt = 0
	PoisonRoom.waitingUntil = 0
end

function SupremeVocation.poisonRoomIsActive()
	return PoisonRoom.phase ~= "idle"
end

function SupremeVocation.poisonRoomGetPhase()
	return PoisonRoom.phase
end

function SupremeVocation.poisonRoomCanEnter()
	return PoisonRoom.phase == "idle" or PoisonRoom.phase == "waiting"
end

-- Begin the waiting window. Idempotent: subsequent entries during the window
-- just join the room.
function SupremeVocation.poisonRoomBeginWaiting()
	if PoisonRoom.phase ~= "idle" then return end
	local now = os.time()
	PoisonRoom.phase = "waiting"
	PoisonRoom.waitingUntil = now + poisonCfg().waitingSeconds
	PoisonRoom.mechanismCount = 0
	PoisonRoom.lastDepositAt = 0
	PoisonRoom.currentQuadrants = {}
	PoisonRoom.warningQuadrants = {}
	PoisonRoom.playerStates = {}
end

-- Switch from waiting to sealed; mechanics start ticking now.
function SupremeVocation.poisonRoomSeal()
	if PoisonRoom.phase ~= "waiting" then return end
	local now = os.time()
	PoisonRoom.phase = "sealed"
	PoisonRoom.startedAt = now
	PoisonRoom.lastDepositAt = now
	PoisonRoom.nextMushroomAt = now + poisonCfg().mushroomSpawnIntervalSeconds
	PoisonRoom.nextQuadrantAt = now + poisonCfg().quadrantCycleSeconds
	PoisonRoom.nextDecayAt = now + poisonCfg().mechanismDecayIntervalSeconds
	for _, p in ipairs(getRoomPlayers()) do
		p:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The chamber seals shut. The trial begins!")
	end
end

-- Death chamber --------------------------------------------------------------

SupremeVocation.DeathChamber = {
	-- Terrace bounding box (for finding players during events / spawning mobs).
	terraceFrom = Position(210, 47, 4),
	terraceTo = Position(224, 67, 4),
	terraceCenter = Position(217, 57, 4),
	-- Sign that displays the ghost release order.
	muralPosition = Position(217, 50, 4),
	muralItemId = 5359,

	-- Labyrinth start position (tile that traps teleport the player back to).
	labyrinthStart = Position(217, 66, 5),
	labyrinthKeyItemId = 21192,

	-- Position players are teleported to after clearing the whole chamber.
	exitPosition = Position(213, 76, 7),

	-- Ghosts in their cells. One totem (action id) per ghost, in the same order.
	-- totemActionIds[i] releases ghosts[i]. cellPosition is the centre of the
	-- 3x3 cell the ghost spawns into. cardinal is what the mural shows to the
	-- player instead of the ghost name (since totems look identical in-game).
	ghosts = {
		{ name = "Umbra",  cellPosition = Position(211, 48, 4), cardinal = "NW" },
		{ name = "Morvai", cellPosition = Position(223, 48, 4), cardinal = "NE" },
		{ name = "Shael",  cellPosition = Position(211, 66, 4), cardinal = "SW" },
		{ name = "Necros", cellPosition = Position(223, 66, 4), cardinal = "SE" },
	},

	-- Punishment wave: mobs spawned across the terrace on a wrong totem use.
	punishmentMonsterName = "Death Reaver",
	punishmentCount = 40,
}

-- Runtime state for the terrace stage. Not persistent; resets at every entry.
DeathTerrace = DeathTerrace or {
	expectedOrder = {}, -- sequence of ghost indexes (1..4) the player must release
	progress = 0,       -- how many ghosts correctly released and killed so far
	activeGhostId = nil, -- creature id of the ghost currently released and alive
	active = false,
}

-- Puzzle NPC state ----------------------------------------------------------

-- Solution (deliberate, matches the dialogue in the NPC files):
-- Order (1..8) players must speak the names to the master skeleton:
SupremeVocation.DeathPuzzleOrder = {
	"Eorl", "Cael", "Halric", "Aldric",
	"Fyodor", "Brennan", "Garrick", "Daven",
}
SupremeVocation.DeathPuzzleMasterName = "Halric"

function SupremeVocation.hasSolvedDeathPuzzle(player)
	return player:getStorageValue(Storage.SupremeVocation.DeathPuzzleSolved) >= 1
end

function SupremeVocation.markDeathPuzzleSolved(player)
	if player:getStorageValue(Storage.SupremeVocation.DeathPuzzleSolved) < 1 then
		player:setStorageValue(Storage.SupremeVocation.DeathPuzzleSolved, 1)
	end
end

function SupremeVocation.hasTakenLabyrinthKey(player)
	return player:getStorageValue(Storage.SupremeVocation.DeathLabyrinthKeyTaken) >= 1
end

function SupremeVocation.markLabyrinthKeyTaken(player)
	player:setStorageValue(Storage.SupremeVocation.DeathLabyrinthKeyTaken, 1)
end

function SupremeVocation.hasClearedDeathChamber(player)
	return player:getStorageValue(Storage.SupremeVocation.DeathChamberCleared) >= 1
end

function SupremeVocation.markDeathChamberCleared(player)
	if player:getStorageValue(Storage.SupremeVocation.DeathChamberCleared) < 1 then
		player:setStorageValue(Storage.SupremeVocation.DeathChamberCleared, 1)
	end
	if player:getStorageValue(Storage.SupremeVocation.MissionDeathReport) < 1 then
		player:setStorageValue(Storage.SupremeVocation.MissionDeathReport, 1)
	end
end

function SupremeVocation.hasReportedDeathChamber(player)
	return player:getStorageValue(Storage.SupremeVocation.MissionDeathReport) == 1
end

function SupremeVocation.completeDeathStage(player)
	if player:getStorageValue(Storage.SupremeVocation.DeathStageComplete) < 1 then
		player:setStorageValue(Storage.SupremeVocation.DeathStageComplete, 1)
	end
	if player:getStorageValue(Storage.SupremeVocation.MissionDeathReport) < 2 then
		player:setStorageValue(Storage.SupremeVocation.MissionDeathReport, 2)
	end
	if player:getStorageValue(Storage.SupremeVocation.FireStageAccess) < 1 then
		player:setStorageValue(Storage.SupremeVocation.FireStageAccess, 1)
	end
end

function SupremeVocation.hasCompletedDeathStage(player)
	return player:getStorageValue(Storage.SupremeVocation.DeathStageComplete) >= 1
end

-- Terrace helpers ------------------------------------------------------------

function SupremeVocation.deathTerraceGetPlayers()
	local cfg = SupremeVocation.DeathChamber
	local players = {}
	for _, creature in ipairs(Game.getSpectators(cfg.terraceCenter, false, true,
			cfg.terraceCenter.x - cfg.terraceFrom.x, cfg.terraceTo.x - cfg.terraceCenter.x,
			cfg.terraceCenter.y - cfg.terraceFrom.y, cfg.terraceTo.y - cfg.terraceCenter.y)) do
		if creature:isPlayer() then
			players[#players + 1] = creature
		end
	end
	return players
end

-- Picks a fresh random order and updates the mural text.
function SupremeVocation.deathTerraceBegin()
	local pool = { 1, 2, 3, 4 }
	local order = {}
	for _ = 1, 4 do
		local idx = math.random(1, #pool)
		order[#order + 1] = pool[idx]
		table.remove(pool, idx)
	end
	DeathTerrace.expectedOrder = order
	DeathTerrace.progress = 0
	DeathTerrace.activeGhostId = nil
	DeathTerrace.active = true
end

function SupremeVocation.deathTerraceGetExpectedOrderNames()
	local names = {}
	for _, idx in ipairs(DeathTerrace.expectedOrder) do
		names[#names + 1] = SupremeVocation.DeathChamber.ghosts[idx].cardinal
	end
	return names
end

function SupremeVocation.deathTerraceExpectedAt(step)
	return DeathTerrace.expectedOrder[step]
end

function SupremeVocation.deathTerraceSpawnGhost(ghostIndex)
	local cfg = SupremeVocation.DeathChamber
	local ghost = cfg.ghosts[ghostIndex]
	if not ghost then return nil end
	local monster = Game.createMonster(ghost.name, ghost.cellPosition, false, true)
	if monster then
		ghost.cellPosition:sendMagicEffect(CONST_ME_MORTAREA)
		DeathTerrace.activeGhostId = monster:getId()
	end
	return monster
end

function SupremeVocation.deathTerraceAdvance()
	DeathTerrace.progress = DeathTerrace.progress + 1
	DeathTerrace.activeGhostId = nil
	if DeathTerrace.progress >= 4 then
		SupremeVocation.deathTerraceComplete()
	end
end

function SupremeVocation.deathTerraceComplete()
	local cfg = SupremeVocation.DeathChamber
	for _, p in ipairs(SupremeVocation.deathTerraceGetPlayers()) do
		SupremeVocation.markDeathChamberCleared(p)
		p:teleportTo(cfg.exitPosition, true)
		cfg.exitPosition:sendMagicEffect(CONST_ME_TELEPORT)
		p:sendTextMessage(MESSAGE_EVENT_ADVANCE,
			"The four spectres fall silent. Return to the elder warrior to report your trial.")
	end
	DeathTerrace.active = false
	DeathTerrace.progress = 0
	DeathTerrace.expectedOrder = {}
	DeathTerrace.activeGhostId = nil
end

function SupremeVocation.deathTerracePunish()
	local cfg = SupremeVocation.DeathChamber
	for _ = 1, cfg.punishmentCount do
		local dx = math.random(cfg.terraceFrom.x, cfg.terraceTo.x)
		local dy = math.random(cfg.terraceFrom.y, cfg.terraceTo.y)
		Game.createMonster(cfg.punishmentMonsterName, Position(dx, dy, cfg.terraceCenter.z), false, true)
	end
	-- Remove any ghost that is still alive from the previous attempt.
	if DeathTerrace.activeGhostId then
		local c = Creature(DeathTerrace.activeGhostId)
		if c then c:remove() end
		DeathTerrace.activeGhostId = nil
	end
	-- Reset progress but keep the same mural order — player re-runs from step 1.
	DeathTerrace.progress = 0
	cfg.terraceCenter:sendMagicEffect(CONST_ME_MORTAREA)
end

function SupremeVocation.deathTerraceIsActive()
	return DeathTerrace.active == true
end

function SupremeVocation.deathTerraceProgress()
	return DeathTerrace.progress
end

function SupremeVocation.deathTerraceActiveGhostId()
	return DeathTerrace.activeGhostId
end

-- Fire chamber ---------------------------------------------------------------

SupremeVocation.FireChamber = {
	-- Bounding box.
	from = Position(219, 66, 8),
	to = Position(232, 79, 8),
	-- Bonfire position (centre).
	bonfirePosition = Position(226, 72, 8),
	-- Where players land after the entry step-in.
	dropPosition = Position(226, 78, 8),
	-- Where players are teleported after clearing the chamber.
	exitPosition = Position(245, 70, 7),

	-- Waiting window (seconds) before the chamber seals.
	waitingSeconds = 10,
	-- Fight duration (seconds). The bonfire must survive this long.
	fightDurationSeconds = 5 * 60,
	-- Tick cadence of the driver (ms).
	tickIntervalMs = 1000,

	-- Bonfire.
	bonfireMonsterName = "Supreme Bonfire",
	bonfireMaxHealth = 20000,
	bonfireRegenPercentEvery10s = 1,
	bonfireAttackDamage = { min = -500, max = -1200 }, -- damage a mob deals when it hits the bonfire

	-- Fire-damage healing: every time a player hits the bonfire with fire
	-- damage it absorbs it as healing. Healing equals `fireHealMultiplier` x
	-- the incoming damage. A short cooldown blocks further heals after a
	-- direct hit; fire-field ticks ignore the cooldown.
	fireHealMultiplier = 10,
	fireHealCooldownSeconds = 5,

	-- Mob spawn phases. Each entry applies from `fromSec` until the next phase begins.
	-- `types` maps mob names to their relative weight for that phase.
	phases = {
		{ fromSec = 0,   intervalSeconds = 8, waveSize = 2, types = { ["Frost Crawler"] = 100 } },
		{ fromSec = 60,  intervalSeconds = 6, waveSize = 2, types = { ["Frost Crawler"] = 100 } },
		{ fromSec = 120, intervalSeconds = 5, waveSize = 3, types = { ["Frost Crawler"] = 70, ["Frost Stalker"] = 30 } },
		{ fromSec = 180, intervalSeconds = 4, waveSize = 3, types = { ["Frost Crawler"] = 50, ["Frost Stalker"] = 30, ["Frost Elder"] = 20 } },
		{ fromSec = 240, intervalSeconds = 3, waveSize = 4, types = { ["Frost Crawler"] = 40, ["Frost Stalker"] = 35, ["Frost Elder"] = 25 } },
	},

	-- Random events.
	eventIntervalSeconds = 90,
	events = { "blizzard", "summer_echo", "hailstorm_brute" },
	blizzardDurationSeconds = 10,
	blizzardSpeedBonus = 100,            -- delta applied to frost mobs during blizzard
	summerEchoDurationSeconds = 15,
	summerEchoRadius = 3,
	summerEchoTickDamage = 500,          -- damage per second to frost mobs inside the aura
	hailstormBruteMonster = "Hailstorm Brute",

	-- Failure catastrophe.
	failurePlayerDamageFraction = 0.80,
}

FireChamber = FireChamber or {
	phase = "idle",     -- "idle" | "waiting" | "sealed"
	waitingUntil = 0,
	startedAt = 0,
	tickEvent = nil,
	bonfireId = nil,
	fireHealReadyAt = 0, -- os.time() when the bonfire can accept another fire heal
	nextSpawnAt = 0,
	nextEventAt = 0,
	nextRegenAt = 0,
	blizzardUntil = 0,
	summerEchoUntil = 0,
}

local function fireCfg()
	return SupremeVocation.FireChamber
end

function SupremeVocation.fireChamberGetPhase()
	return FireChamber.phase
end

function SupremeVocation.fireChamberIsActive()
	return FireChamber.phase ~= "idle"
end

function SupremeVocation.fireChamberCanEnter()
	return FireChamber.phase == "idle" or FireChamber.phase == "waiting"
end

function SupremeVocation.fireChamberGetPlayers()
	local cfg = fireCfg()
	local players = {}
	for _, creature in ipairs(Game.getSpectators(cfg.bonfirePosition, false, true,
			cfg.bonfirePosition.x - cfg.from.x, cfg.to.x - cfg.bonfirePosition.x,
			cfg.bonfirePosition.y - cfg.from.y, cfg.to.y - cfg.bonfirePosition.y)) do
		if creature:isPlayer() then
			players[#players + 1] = creature
		end
	end
	return players
end

function SupremeVocation.fireChamberGetBonfire()
	if not FireChamber.bonfireId then return nil end
	local c = Creature(FireChamber.bonfireId)
	if not c then
		FireChamber.bonfireId = nil
		return nil
	end
	return c
end

function SupremeVocation.fireChamberCanHeal()
	return FireChamber.fireHealReadyAt <= os.time()
end

function SupremeVocation.fireChamberMarkHealDone()
	FireChamber.fireHealReadyAt = os.time() + SupremeVocation.FireChamber.fireHealCooldownSeconds
end

function SupremeVocation.fireChamberIsBlizzard()
	return FireChamber.blizzardUntil > os.time()
end

function SupremeVocation.fireChamberIsSummerEcho()
	return FireChamber.summerEchoUntil > os.time()
end

function SupremeVocation.hasClearedFireChamber(player)
	return player:getStorageValue(Storage.SupremeVocation.FireChamberCleared) >= 1
end

function SupremeVocation.markFireChamberCleared(player)
	if player:getStorageValue(Storage.SupremeVocation.FireChamberCleared) < 1 then
		player:setStorageValue(Storage.SupremeVocation.FireChamberCleared, 1)
	end
	if player:getStorageValue(Storage.SupremeVocation.MissionFireReport) < 1 then
		player:setStorageValue(Storage.SupremeVocation.MissionFireReport, 1)
	end
end

-- Starts the waiting window. Idempotent.
function SupremeVocation.fireChamberBeginWaiting()
	if FireChamber.phase ~= "idle" then return end
	local cfg = fireCfg()
	local now = os.time()
	FireChamber.phase = "waiting"
	FireChamber.waitingUntil = now + cfg.waitingSeconds
	FireChamber.startedAt = 0
	FireChamber.fireHealReadyAt = 0
	FireChamber.blizzardUntil = 0
	FireChamber.summerEchoUntil = 0
end

-- Transitions from waiting to sealed and spawns the bonfire.
function SupremeVocation.fireChamberSeal()
	if FireChamber.phase ~= "waiting" then return end
	local cfg = fireCfg()
	local now = os.time()
	FireChamber.phase = "sealed"
	FireChamber.startedAt = now
	FireChamber.nextSpawnAt = now + (cfg.phases[1] and cfg.phases[1].intervalSeconds or 8)
	FireChamber.nextEventAt = now + cfg.eventIntervalSeconds
	FireChamber.nextRegenAt = now + 10

	-- Spawn the bonfire monster.
	local bonfire = Game.createMonster(cfg.bonfireMonsterName, cfg.bonfirePosition, false, true)
	if bonfire then
		FireChamber.bonfireId = bonfire:getId()
		cfg.bonfirePosition:sendMagicEffect(CONST_ME_FIREAREA)
	end

	for _, p in ipairs(SupremeVocation.fireChamberGetPlayers()) do
		p:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The chamber seals. Defend the bonfire for 5 minutes!")
	end
end

function SupremeVocation.fireChamberStop(reason)
	FireChamber.phase = "idle"
	if FireChamber.tickEvent then
		stopEvent(FireChamber.tickEvent)
		FireChamber.tickEvent = nil
	end
	-- Remove the bonfire if still alive (cleanup).
	local bonfire = SupremeVocation.fireChamberGetBonfire()
	if bonfire then
		bonfire:remove()
	end
	FireChamber.bonfireId = nil
	FireChamber.fireHealReadyAt = 0
	FireChamber.blizzardUntil = 0
	FireChamber.summerEchoUntil = 0
	FireChamber.waitingUntil = 0
	FireChamber.startedAt = 0
end

-- Called by the driver when the bonfire survives the full duration.
function SupremeVocation.fireChamberComplete()
	local cfg = fireCfg()
	for _, p in ipairs(SupremeVocation.fireChamberGetPlayers()) do
		SupremeVocation.markFireChamberCleared(p)
		p:teleportTo(cfg.exitPosition, true)
		cfg.exitPosition:sendMagicEffect(CONST_ME_TELEPORT)
		p:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The bonfire roars on. Return to the elder warrior to report your trial.")
	end
	SupremeVocation.fireChamberStop("completed")
end

-- Called by the driver when the bonfire dies.
function SupremeVocation.fireChamberFail()
	local cfg = fireCfg()
	for _, p in ipairs(SupremeVocation.fireChamberGetPlayers()) do
		local dmg = math.floor(p:getMaxHealth() * cfg.failurePlayerDamageFraction)
		if dmg > 0 then
			doTargetCombatHealth(0, p, COMBAT_ICEDAMAGE, -dmg, -dmg, CONST_ME_ICEAREA)
		end
		p:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The bonfire falls silent. Cold sweeps through.")
		-- Survivors are teleported out; dead players go to temple as usual.
		if p:getHealth() > 0 then
			p:teleportTo(cfg.exitPosition, true)
			cfg.exitPosition:sendMagicEffect(CONST_ME_TELEPORT)
		end
	end
	SupremeVocation.fireChamberStop("failed")
end

function SupremeVocation.hasReportedFireChamber(player)
	return player:getStorageValue(Storage.SupremeVocation.MissionFireReport) == 1
end

function SupremeVocation.completeFireStage(player)
	if player:getStorageValue(Storage.SupremeVocation.MissionFireReport) < 2 then
		player:setStorageValue(Storage.SupremeVocation.MissionFireReport, 2)
	end
	if player:getStorageValue(Storage.SupremeVocation.FireStageComplete) < 1 then
		player:setStorageValue(Storage.SupremeVocation.FireStageComplete, 1)
	end
	if player:getStorageValue(Storage.SupremeVocation.WealthStageAccess) < 1 then
		player:setStorageValue(Storage.SupremeVocation.WealthStageAccess, 1)
	end
end

function SupremeVocation.hasCompletedFireStage(player)
	return player:getStorageValue(Storage.SupremeVocation.FireStageComplete) >= 1
end

-- Wealth chamber -------------------------------------------------------------

SupremeVocation.WealthChamber = {
	entryFeeCoppers = 10000000000, -- 10kkk (10B gold) paid once to unlock Goldmouth's game
	rollFeeCoppers = 25000000,      -- 25kk paid for each dice roll
	requiredStreak = 5,             -- consecutive wins needed to clear the stage
}

function SupremeVocation.hasPaidWealthFee(player)
	return player:getStorageValue(Storage.SupremeVocation.WealthFeePaid) >= 1
end

function SupremeVocation.markWealthFeePaid(player)
	if player:getStorageValue(Storage.SupremeVocation.WealthFeePaid) < 1 then
		player:setStorageValue(Storage.SupremeVocation.WealthFeePaid, 1)
	end
end

function SupremeVocation.getWealthStreak(player)
	local v = player:kv():scoped(SupremeVocation.KV_SCOPE):get("wealth-streak")
	return v or 0
end

function SupremeVocation.setWealthStreak(player, n)
	player:kv():scoped(SupremeVocation.KV_SCOPE):set("wealth-streak", n)
end

function SupremeVocation.resetWealthStreak(player)
	player:kv():scoped(SupremeVocation.KV_SCOPE):remove("wealth-streak")
end

function SupremeVocation.hasClearedWealthChamber(player)
	return player:getStorageValue(Storage.SupremeVocation.WealthChamberCleared) >= 1
end

function SupremeVocation.markWealthChamberCleared(player)
	if player:getStorageValue(Storage.SupremeVocation.WealthChamberCleared) < 1 then
		player:setStorageValue(Storage.SupremeVocation.WealthChamberCleared, 1)
	end
	if player:getStorageValue(Storage.SupremeVocation.MissionWealthReport) < 1 then
		player:setStorageValue(Storage.SupremeVocation.MissionWealthReport, 1)
	end
end

function SupremeVocation.hasReportedWealthChamber(player)
	return player:getStorageValue(Storage.SupremeVocation.MissionWealthReport) == 1
end

function SupremeVocation.completeWealthStage(player)
	if player:getStorageValue(Storage.SupremeVocation.WealthStageComplete) < 1 then
		player:setStorageValue(Storage.SupremeVocation.WealthStageComplete, 1)
	end
	if player:getStorageValue(Storage.SupremeVocation.MissionWealthReport) < 2 then
		player:setStorageValue(Storage.SupremeVocation.MissionWealthReport, 2)
	end
	SupremeVocation.grantSummitAccess(player)
end

function SupremeVocation.hasCompletedWealthStage(player)
	return player:getStorageValue(Storage.SupremeVocation.WealthStageComplete) >= 1
end

-- Summit (final fight + promotion) -------------------------------------------

SupremeVocation.Summit = {
	-- Supreme vocation id per base vocation id (from vocations.xml).
	-- keys: player base voc id, value: supreme voc id.
	supremeVocationByBase = {
		[1] = 11, [5] = 11, -- Sorcerer / Master Sorcerer -> Arcane Sorcerer
		[2] = 12, [6] = 12, -- Druid   / Elder Druid      -> Primal Druid
		[3] = 13, [7] = 13, -- Paladin / Royal Paladin    -> Celestial Paladin
		[4] = 14, [8] = 14, -- Knight  / Elite Knight     -> Titan Knight
	},
	supremeNameByVocId = {
		[11] = "Arcane Sorcerer",
		[12] = "Primal Druid",
		[13] = "Celestial Paladin",
		[14] = "Titan Knight",
	},
}

-- Called when completeWealthStage runs - also opens the summit.
function SupremeVocation.grantSummitAccess(player)
	if player:getStorageValue(Storage.SupremeVocation.SummitAccess) < 1 then
		player:setStorageValue(Storage.SupremeVocation.SummitAccess, 1)
	end
end

function SupremeVocation.hasSupremeVocationGranted(player)
	return player:getStorageValue(Storage.SupremeVocation.SupremeVocationGranted) >= 1
end

function SupremeVocation.grantSupremeVocation(player)
	local baseId = player:getVocation():getId()
	local supremeId = SupremeVocation.Summit.supremeVocationByBase[baseId]
	if not supremeId then return false end
	player:setVocation(Vocation(supremeId))
	player:setStorageValue(Storage.SupremeVocation.SupremeVocationGranted, 1)
	if player:getStorageValue(Storage.SupremeVocation.MissionSummitReport) < 1 then
		player:setStorageValue(Storage.SupremeVocation.MissionSummitReport, 1)
	end
	return true
end

