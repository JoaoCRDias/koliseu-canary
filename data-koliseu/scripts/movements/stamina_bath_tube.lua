local STAMINA_BATH_TUBE_EMPTY = 41610
local STAMINA_BATH_TUBE_OCCUPIED = 41612

local MAX_OCCUPANTS = 2
local REGEN_INTERVAL_MS = 60 * 1000
local OUTFIT_DELAY_MS = 100
local REGEN_AMOUNT = 1
local MAX_STAMINA = 2520
local OUTFIT_SUBID = 7721

local bathOutfit = Condition(CONDITION_OUTFIT)
bathOutfit:setOutfit({ lookTypeEx = STAMINA_BATH_TUBE_OCCUPIED })
bathOutfit:setParameter(CONDITION_PARAM_TICKS, -1)
bathOutfit:setParameter(CONDITION_PARAM_SUBID, OUTFIT_SUBID)

local bathState = {
	occupants = {},
	players = {},
}

local function posKey(pos)
	return string.format("%d:%d:%d", pos.x, pos.y, pos.z)
end

local function getBathItem(position)
	local tile = Tile(position)
	if not tile then
		return nil
	end

	return tile:getItemById(STAMINA_BATH_TUBE_OCCUPIED) or tile:getItemById(STAMINA_BATH_TUBE_EMPTY)
end

local function isBathTile(position)
	return getBathItem(position) ~= nil
end

local function updateBathItem(position, key)
	local item = getBathItem(position)
	if not item then
		return
	end

	local count = bathState.occupants[key] or 0
	if count > 0 and item:getId() == STAMINA_BATH_TUBE_EMPTY then
		item:transform(STAMINA_BATH_TUBE_OCCUPIED)
	elseif count == 0 and item:getId() == STAMINA_BATH_TUBE_OCCUPIED then
		item:transform(STAMINA_BATH_TUBE_EMPTY)
	end
end

local function clearPlayer(playerId)
	local info = bathState.players[playerId]
	if not info then
		return
	end

	local player = Player(playerId)
	if player then
		player:removeCondition(CONDITION_OUTFIT, CONDITIONID_COMBAT, OUTFIT_SUBID)
	end

	if info.event then
		stopEvent(info.event)
	end
	if info.outfitEvent then
		stopEvent(info.outfitEvent)
	end

	bathState.players[playerId] = nil

	local key = info.key
	if key then
		local count = bathState.occupants[key] or 0
		if count > 0 then
			count = count - 1
			if count == 0 then
				bathState.occupants[key] = nil
			else
				bathState.occupants[key] = count
			end
		end
		updateBathItem(info.pos, key)
	end
end

local function regenStamina(playerId)
	local player = Player(playerId)
	if not player then
		clearPlayer(playerId)
		return
	end

	local info = bathState.players[playerId]
	if not info then
		return
	end

	local pos = player:getPosition()
	if pos.x ~= info.pos.x or pos.y ~= info.pos.y or pos.z ~= info.pos.z then
		clearPlayer(playerId)
		return
	end

	if not getBathItem(info.pos) then
		clearPlayer(playerId)
		return
	end

	local stamina = player:getStamina()
	if stamina < MAX_STAMINA then
		player:setStamina(math.min(MAX_STAMINA, stamina + REGEN_AMOUNT))
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You feel more rested. (Bath: +1 minute of stamina)")
	end

	info.event = addEvent(regenStamina, REGEN_INTERVAL_MS, playerId)
	bathState.players[playerId] = info
end

local function applyBathOutfit(playerId)
	local player = Player(playerId)
	if not player then
		return
	end

	local info = bathState.players[playerId]
	if not info then
		return
	end

	local pos = player:getPosition()
	if pos.x ~= info.pos.x or pos.y ~= info.pos.y or pos.z ~= info.pos.z then
		return
	end

	if not getBathItem(info.pos) then
		return
	end

	player:addCondition(bathOutfit)
end

local function enterBath(player, position, hasAccess)
	local playerId = player:getId()
	local key = posKey(position)

	local existing = bathState.players[playerId]
	if existing then
		if existing.key == key then
			return true
		end
		clearPlayer(playerId)
	end

	local count = bathState.occupants[key] or 0
	if count >= MAX_OCCUPANTS and not hasAccess then
		return false
	end

	bathState.occupants[key] = count + 1
	bathState.players[playerId] = {
		key = key,
		pos = Position(position.x, position.y, position.z),
		event = addEvent(regenStamina, REGEN_INTERVAL_MS, playerId),
	}

	bathState.players[playerId].outfitEvent = addEvent(applyBathOutfit, OUTFIT_DELAY_MS, playerId)
	updateBathItem(position, key)
	player:sendTextMessage(MESSAGE_FAILURE, "Relaxing in the bath. You gain +1 extra stamina per minute while here.")
	return true
end

-- Movement: step in
local bathEnter = MoveEvent()
bathEnter:type("stepin")

function bathEnter.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	local hasAccess = player:getGroup():getAccess()
	if not enterBath(player, position, hasAccess) then
		player:teleportTo(fromPosition, false)
		player:getPosition():sendMagicEffect(CONST_ME_POFF)
		player:sendTextMessage(MESSAGE_FAILURE, "A banheira ja esta cheia.")
	end
	return true
end

bathEnter:id(STAMINA_BATH_TUBE_EMPTY, STAMINA_BATH_TUBE_OCCUPIED)
bathEnter:register()

-- Movement: step out
local bathExit = MoveEvent()
bathExit:type("stepout")

function bathExit.onStepOut(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	clearPlayer(player:getId())
	return true
end

bathExit:id(STAMINA_BATH_TUBE_EMPTY, STAMINA_BATH_TUBE_OCCUPIED)
bathExit:register()

-- Login: handle player logging in on top of a bath
local bathLogin = CreatureEvent("StaminaBathLogin")

function bathLogin.onLogin(player)
	local position = player:getPosition()

	if not isBathTile(position) then
		return true
	end

	local hasAccess = player:getGroup():getAccess()
	local key = posKey(position)
	local count = bathState.occupants[key] or 0

	-- Has room or player has access: enter bath normally
	if count < MAX_OCCUPANTS or hasAccess then
		addEvent(function(playerId)
			local p = Player(playerId)
			if not p then
				return
			end
			if isBathTile(p:getPosition()) then
				enterBath(p, p:getPosition(), p:getGroup():getAccess())
			end
		end, OUTFIT_DELAY_MS, player:getId())
		return true
	end

	-- Bath is full: find a free adjacent tile (not another bath)
	local pos = position
	local directions = {
		{x = pos.x - 1, y = pos.y, z = pos.z},
		{x = pos.x + 1, y = pos.y, z = pos.z},
		{x = pos.x, y = pos.y - 1, z = pos.z},
		{x = pos.x, y = pos.y + 1, z = pos.z},
		{x = pos.x - 1, y = pos.y - 1, z = pos.z},
		{x = pos.x + 1, y = pos.y - 1, z = pos.z},
		{x = pos.x - 1, y = pos.y + 1, z = pos.z},
		{x = pos.x + 1, y = pos.y + 1, z = pos.z},
	}

	for _, dir in ipairs(directions) do
		local adjacentPos = Position(dir.x, dir.y, dir.z)
		local tile = Tile(adjacentPos)
		if tile and not tile:hasFlag(TILESTATE_BLOCKSOLID) and not isBathTile(adjacentPos) then
			player:teleportTo(adjacentPos, false)
			adjacentPos:sendMagicEffect(CONST_ME_TELEPORT)
			player:sendTextMessage(MESSAGE_FAILURE, "A banheira estava cheia. Voce foi movido para fora.")
			return true
		end
	end

	-- No free adjacent tile: send to temple
	local templePos = player:getTown():getTemplePosition()
	player:teleportTo(templePos, false)
	templePos:sendMagicEffect(CONST_ME_TELEPORT)
	player:sendTextMessage(MESSAGE_FAILURE, "A banheira estava cheia. Voce foi enviado ao templo.")
	return true
end

bathLogin:register()
