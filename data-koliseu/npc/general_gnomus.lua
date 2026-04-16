local internalNpcName = "General Gnomus"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 504,
	lookHead = 117,
	lookBody = 94,
	lookLegs = 128,
	lookFeet = 114,
	lookAddons = 2,
}

npcConfig.flags = {
	floorchange = false,
}

npcConfig.currency = 62635

npcConfig.voices = {
	interval = 15000,
	chance = 50,
	{ text = "Buy everithing you need!" },
}

local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)

npcType.onThink = function(npc, interval)
	npcHandler:onThink(npc, interval)
end

npcType.onAppear = function(npc, creature)
	npcHandler:onAppear(npc, creature)
end

npcType.onDisappear = function(npc, creature)
	npcHandler:onDisappear(npc, creature)
end

npcType.onMove = function(npc, creature, fromPosition, toPosition)
	npcHandler:onMove(npc, creature, fromPosition, toPosition)
end

npcType.onSay = function(npc, creature, type, message)
	npcHandler:onSay(npc, creature, type, message)
end

npcType.onCloseChannel = function(npc, creature)
	npcHandler:onCloseChannel(npc, creature)
end

local itemsTable = {
	{ itemName = "exercise axe", clientId = 28553, buy = 350000, subType = 500 },
	{ itemName = "exercise bow", clientId = 28555, buy = 350000, subType = 500 },
	{ itemName = "exercise club", clientId = 28554, buy = 350000, subType = 500 },
	{ itemName = "exercise rod", clientId = 28556, buy = 350000, subType = 500 },
	{ itemName = "exercise sword", clientId = 28552, buy = 350000, subType = 500 },
	{ itemName = "exercise wand", clientId = 28557, buy = 350000, subType = 500 },
	{ itemName = "durable exercise axe", clientId = 35280, buy = 1250000, subType = 1800 },
	{ itemName = "durable exercise bow", clientId = 35282, buy = 1250000, subType = 1800 },
	{ itemName = "durable exercise club", clientId = 35281, buy = 1250000, subType = 1800 },
	{ itemName = "durable exercise rod", clientId = 35283, buy = 1250000, subType = 1800 },
	{ itemName = "durable exercise sword", clientId = 35279, buy = 1250000, subType = 1800 },
	{ itemName = "durable exercise wand", clientId = 35284, buy = 1250000, subType = 1800 },
	{ itemName = "lasting exercise axe", clientId = 35286, buy = 10000000, subType = 14400 },
	{ itemName = "lasting exercise bow", clientId = 35288, buy = 10000000, subType = 14400 },
	{ itemName = "lasting exercise club", clientId = 35287, buy = 10000000, subType = 14400 },
	{ itemName = "lasting exercise rod", clientId = 35289, buy = 10000000, subType = 14400 },
	{ itemName = "lasting exercise sword", clientId = 35285, buy = 10000000, subType = 14400 },
	{ itemName = "lasting exercise wand", clientId = 35290, buy = 10000000, subType = 14400 },
}

local function creatureSayCallback(npc, creature, type, message)
	local player = Player(creature)

	if not npcHandler:checkInteraction(npc, creature) then
		return false
	end

	if MsgContains(message, 'arena') then
		npcHandler:say("I can teleport you to Gnome Arena. Do you want that?", npc, creature)
		npcHandler:setTopic(player:getId(), 1)
		return
	end

	if MsgContains(message, 'yes') and npcHandler:getTopic() == 1 then
		local arenaPosition = Position(1031, 1032, 6) -- Replace with actual arena position
		player:teleportTo(arenaPosition)
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		npcHandler:say("Welcome to the Gnome Arena!", npc, creature)
		npcHandler:setTopic(player:getId(), 0)
		return
	end
end

-- Basic

npcHandler:setMessage(MESSAGE_GREET, "Welcome.  I'm General Gnomus and i can bring you to Gnome Areana also sell some good things.")
npcHandler:setMessage(MESSAGE_FAREWELL, "Please come back from time to time.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Please come back from time to time.")
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

local function onTradeRequest(npc, creature)
	local player = Player(creature)



	npc:openShopWindowTable(player, itemsTable)
	npcHandler:say("Here are all the items available.", npc, creature)

	return true
end

npcHandler:setCallback(CALLBACK_ON_TRADE_REQUEST, onTradeRequest)
-- On buy npc shop message
npcType.onBuyItem = function(npc, player, itemId, subType, amount, ignore, inBackpacks, totalCost)
	npc:sellItem(player, itemId, amount, subType, 0, ignore, inBackpacks)
end
-- On sell npc shop message
npcType.onSellItem = function(npc, player, itemId, subtype, amount, ignore, name, totalCost)
	player:sendTextMessage(MESSAGE_TRADE, string.format("Sold %ix %s for %i gold.", amount, name, totalCost))
end
-- On check npc shop message (look item)
npcType.onCheckItem = function(npc, player, clientId, subType) end

npcType:register(npcConfig)
