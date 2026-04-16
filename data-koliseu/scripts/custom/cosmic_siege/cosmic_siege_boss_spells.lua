-- Cosmic Siege - Shared Boss Spells
-- Parametrized spells that can be used by all siege bosses

-- ============================================================
-- SPELL 1: Cosmic Mark (Target Player)
-- Renders a 3x3 area centered on the player with effect 612
-- After 2 seconds, deals massive holy damage with effect 535
-- ============================================================

-- Shared damage application function
local function applyCosmicMarkDamage(centerPos, minDamage, maxDamage, markerItems)
	local hitPlayers = {} -- Track players already hit to prevent duplicate damage

	-- Apply damage and effect to the 3x3 area
	for x = -1, 1 do
		for y = -1, 1 do
			local pos = Position(centerPos.x + x, centerPos.y + y, centerPos.z)
			local tile = Tile(pos)
			if tile then
				-- Send damage effect
				pos:sendMagicEffect(535)

				-- Deal massive holy damage only to players on this exact position
				local specs = Game.getSpectators(pos, false, true, 0, 0, 0, 0)
				for _, creature in ipairs(specs) do
					if creature:isPlayer() then
						local playerId = creature:getId()
						if not hitPlayers[playerId] then
							local playerPos = creature:getPosition()
							-- Only damage if player is exactly on this sqm
							if playerPos.x == pos.x and playerPos.y == pos.y and playerPos.z == pos.z then
								doTargetCombatHealth(0, creature, COMBAT_HOLYDAMAGE, minDamage, maxDamage, 535)
								hitPlayers[playerId] = true
							end
						end
					end
				end
			end
		end
	end

	-- Remove marker items after damage
	if markerItems then
		for _, item in ipairs(markerItems) do
			if item and item:isItem() then
				item:remove()
			end
		end
	end
end

-- Shared warning render function
local function renderCosmicMark(centerPos, minDamage, maxDamage)
	-- Create marker items to force effect visibility
	local markerItems = {}

	-- Render warning effect 612 in 3x3 area and place markers
	for x = -1, 1 do
		for y = -1, 1 do
			local pos = Position(centerPos.x + x, centerPos.y + y, centerPos.z)
			local tile = Tile(pos)
			if tile then
				-- Create a temporary marker item (magic forcefield - ID 1387)
				local item = Game.createItem(50982, 1, pos)
				if item then
					table.insert(markerItems, item)
				end
				pos:sendMagicEffect(612)
			end
		end
	end

	-- Schedule damage after 2 seconds
	addEvent(applyCosmicMarkDamage, 2000, centerPos, minDamage, maxDamage, markerItems)
end

-- Create Cosmic Mark spell with parameters
local function createCosmicMarkSpell(spellName, spellWords, minDamage, maxDamage)
	local spell = Spell("instant")

	function spell.onCastSpell(creature, variant)
		local target = creature:getTarget()
		if not target or not target:isPlayer() then
			return false
		end

		local targetPos = target:getPosition()
		renderCosmicMark(targetPos, minDamage, maxDamage)

		return true
	end

	spell:name(spellName)
	spell:words(spellWords)
	spell:isAggressive(true)
	spell:blockWalls(true)
	spell:needLearn(true)
	spell:register()
end

-- ============================================================
-- SPELL 2: Cosmic Bombardment (Random Area)
-- Randomly marks 35-45% of walkable tiles in boss area
-- Shows effect 612 as warning, then deals massive holy damage after 2 seconds
-- ============================================================

-- Shared bombardment damage function
local function applyBombardmentDamage(positionsData, minDamage, maxDamage)
	local hitPlayers = {} -- Track players already hit to prevent duplicate damage

	for _, data in ipairs(positionsData) do
		local pos = data.position
		local markerItem = data.marker

		-- Send damage effect
		pos:sendMagicEffect(535)

		-- Deal massive holy damage only to players on this exact position
		local specs = Game.getSpectators(pos, false, true, 0, 0, 0, 0)
		for _, creature in ipairs(specs) do
			if creature:isPlayer() then
				local playerId = creature:getId()
				-- Only damage if player is exactly on this sqm and hasn't been hit yet
				if not hitPlayers[playerId] then
					local playerPos = creature:getPosition()
					if playerPos.x == pos.x and playerPos.y == pos.y and playerPos.z == pos.z then
						doTargetCombatHealth(0, creature, COMBAT_HOLYDAMAGE, minDamage, maxDamage, 535)
						hitPlayers[playerId] = true
					end
				end
			end
		end

		-- Remove marker item
		if markerItem and markerItem:isItem() then
			markerItem:remove()
		end
	end
end

-- Create Cosmic Bombardment spell with parameters
local function createCosmicBombardmentSpell(spellName, spellWords, areaFrom, areaTo, minDamage, maxDamage)
	local spell = Spell("instant")

	function spell.onCastSpell(creature, variant)
		-- Get all positions in the zone
		local allPositions = {}

		-- Collect all walkable positions in the area
		for x = areaFrom.x, areaTo.x do
			for y = areaFrom.y, areaTo.y do
				local pos = Position(x, y, areaFrom.z)
				local tile = Tile(pos)
				if tile then
					local ground = tile:getGround()
					if ground and not tile:hasFlag(TILESTATE_BLOCKSOLID) then
						-- Check if tile is walkable
						local canWalk = true
						local items = tile:getItems()
						if items then
							for _, item in ipairs(items) do
								if item:hasProperty(CONST_PROP_BLOCKSOLID) then
									canWalk = false
									break
								end
							end
						end
						if canWalk then
							table.insert(allPositions, pos)
						end
					end
				end
			end
		end

		if #allPositions == 0 then
			return false
		end

		-- Select random 35-45% of positions
		local percentage = math.random(35, 45) / 100
		local count = math.floor(#allPositions * percentage)
		local selectedPositionsData = {}

		-- Shuffle and select positions with markers
		for i = 1, count do
			local idx = math.random(1, #allPositions)
			local pos = allPositions[idx]

			-- Create marker item to force effect visibility
			local markerItem = Game.createItem(50982, 1, pos)

			-- Store position and marker
			table.insert(selectedPositionsData, {
				position = pos,
				marker = markerItem
			})

			-- Render warning effect
			pos:sendMagicEffect(612)

			table.remove(allPositions, idx)
		end

		-- Schedule damage after 2 seconds
		addEvent(applyBombardmentDamage, 2000, selectedPositionsData, minDamage, maxDamage)

		return true
	end

	spell:name(spellName)
	spell:words(spellWords)
	spell:isAggressive(true)
	spell:blockWalls(true)
	spell:needLearn(true)
	spell:register()
end

-- ============================================================
-- Register spells for each boss
-- ============================================================

-- Siege Defender (Siege 0)
createCosmicMarkSpell("siege_defender_cosmic_mark", "###612", -4000, -10000)
createCosmicBombardmentSpell(
	"siege_defender_cosmic_bombardment",
	"###602",
	Position(851, 736, 7),
	Position(869, 755, 7),
	-40000,
	-60000
)

-- Nebular Warlord (Siege 500)
createCosmicMarkSpell("nebular_warlord_cosmic_mark", "###631", -6000, -12000)
createCosmicBombardmentSpell(
	"nebular_warlord_cosmic_bombardment",
	"###614",
	Position(448, 627, 8),
	Position(468, 651, 8),
	-50000,
	-70000
)

-- Eclipse Sovereign (Siege 1000)
createCosmicMarkSpell("eclipse_sovereign_cosmic_mark", "###615", -8000, -14000)
createCosmicBombardmentSpell(
	"eclipse_sovereign_cosmic_bombardment",
	"###616",
	Position(546, 502, 8),
	Position(564, 515, 8),
	-60000,
	-80000
)

-- Astral Tyrant (Siege 1500)
createCosmicMarkSpell("astral_tyrant_cosmic_mark", "###617", -10000, -16000)
createCosmicBombardmentSpell(
	"astral_tyrant_cosmic_bombardment",
	"###618",
	Position(491, 369, 8),
	Position(508, 387, 8),
	-70000,
	-90000
)

print(">> Cosmic Siege Boss Spells loaded successfully!")
