-- Voroth The Fallen - Siege-style Spells
-- Cosmic Mark (3x3 on target) and Bombardment (random area coverage)
-- Players who stay on marked tiles take massive death damage (HS)

-- ============================================================
-- SPELL 1: Voroth Mark (Target Player)
-- Marks 3x3 area on a player with warning effect
-- After 2 seconds, deals massive death damage
-- ============================================================

local function applyVorothMarkDamage(centerPos, minDamage, maxDamage, markerItems)
	local hitPlayers = {}

	for x = -1, 1 do
		for y = -1, 1 do
			local pos = Position(centerPos.x + x, centerPos.y + y, centerPos.z)
			local tile = Tile(pos)
			if tile then
				pos:sendMagicEffect(CONST_ME_MORTAREA)

				local specs = Game.getSpectators(pos, false, true, 0, 0, 0, 0)
				for _, creature in ipairs(specs) do
					if creature:isPlayer() then
						local playerId = creature:getId()
						if not hitPlayers[playerId] then
							local playerPos = creature:getPosition()
							if playerPos.x == pos.x and playerPos.y == pos.y and playerPos.z == pos.z then
								doTargetCombatHealth(0, creature, COMBAT_DEATHDAMAGE, minDamage, maxDamage, CONST_ME_MORTAREA)
								hitPlayers[playerId] = true
							end
						end
					end
				end
			end
		end
	end

	if markerItems then
		for _, item in ipairs(markerItems) do
			if item and item:isItem() then
				item:remove()
			end
		end
	end
end

local function renderVorothMark(centerPos, minDamage, maxDamage)
	local markerItems = {}

	for x = -1, 1 do
		for y = -1, 1 do
			local pos = Position(centerPos.x + x, centerPos.y + y, centerPos.z)
			local tile = Tile(pos)
			if tile then
				local item = Game.createItem(50982, 1, pos)
				if item then
					table.insert(markerItems, item)
				end
				pos:sendMagicEffect(612)
			end
		end
	end

	addEvent(applyVorothMarkDamage, 2000, centerPos, minDamage, maxDamage, markerItems)
end

local vorothMark = Spell("instant")

function vorothMark.onCastSpell(creature, variant)
	local target = creature:getTarget()
	if not target or not target:isPlayer() then
		return false
	end

	local targetPos = target:getPosition()
	renderVorothMark(targetPos, -5000, -10000)

	return true
end

vorothMark:name("voroth mark")
vorothMark:words("###vorothmark")
vorothMark:isAggressive(true)
vorothMark:blockWalls(true)
vorothMark:needLearn(true)
vorothMark:register()

-- ============================================================
-- SPELL 2: Voroth Bombardment (Random Area)
-- Marks 35-45% of walkable tiles in boss arena
-- After 2 seconds, deals massive death damage
-- ============================================================

local VOROTH_AREA_FROM = Position(220, 987, 11)
local VOROTH_AREA_TO = Position(238, 1008, 11)

local function applyVorothBombardmentDamage(positionsData, minDamage, maxDamage)
	local hitPlayers = {}

	for _, data in ipairs(positionsData) do
		local pos = data.position
		local markerItem = data.marker

		pos:sendMagicEffect(CONST_ME_MORTAREA)

		local specs = Game.getSpectators(pos, false, true, 0, 0, 0, 0)
		for _, creature in ipairs(specs) do
			if creature:isPlayer() then
				local playerId = creature:getId()
				if not hitPlayers[playerId] then
					local playerPos = creature:getPosition()
					if playerPos.x == pos.x and playerPos.y == pos.y and playerPos.z == pos.z then
						doTargetCombatHealth(0, creature, COMBAT_DEATHDAMAGE, minDamage, maxDamage, CONST_ME_MORTAREA)
						hitPlayers[playerId] = true
					end
				end
			end
		end

		if markerItem and markerItem:isItem() then
			markerItem:remove()
		end
	end
end

local vorothBombardment = Spell("instant")

function vorothBombardment.onCastSpell(creature, variant)
	local allPositions = {}

	for x = VOROTH_AREA_FROM.x, VOROTH_AREA_TO.x do
		for y = VOROTH_AREA_FROM.y, VOROTH_AREA_TO.y do
			local pos = Position(x, y, VOROTH_AREA_FROM.z)
			local tile = Tile(pos)
			if tile then
				local ground = tile:getGround()
				if ground and not tile:hasFlag(TILESTATE_BLOCKSOLID) then
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

	local percentage = math.random(35, 45) / 100
	local count = math.floor(#allPositions * percentage)
	local selectedPositionsData = {}

	for i = 1, count do
		local idx = math.random(1, #allPositions)
		local pos = allPositions[idx]

		local markerItem = Game.createItem(50982, 1, pos)

		table.insert(selectedPositionsData, {
			position = pos,
			marker = markerItem,
		})

		pos:sendMagicEffect(612)

		table.remove(allPositions, idx)
	end

	addEvent(applyVorothBombardmentDamage, 2000, selectedPositionsData, -50000, -80000)

	return true
end

vorothBombardment:name("voroth bombardment")
vorothBombardment:words("###vorothbomb")
vorothBombardment:isAggressive(true)
vorothBombardment:blockWalls(true)
vorothBombardment:needLearn(true)
vorothBombardment:register()

print(">> Voroth Siege Spells loaded successfully!")
