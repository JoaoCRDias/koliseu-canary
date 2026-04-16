local internalNpcName = "Gnome Quartermaster"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 493, -- gnome-like
	lookHead = 95,
	lookBody = 94,
	lookLegs = 76,
	lookFeet = 114,
	lookAddons = 0,
}

npcConfig.flags = {
	floorchange = false,
}

-- Use Arena Token (62358) as currency
npcConfig.currency = 60133

npcConfig.voices = {
	interval = 15000,
	chance = 30,
	{ text = "Trade your Arena Tokens for valuable gear!" },
	{ text = "Say 'trade' to see my offers." },
}

local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)

npcType.onThink = function(npc, interval) npcHandler:onThink(npc, interval) end
npcType.onAppear = function(npc, creature) npcHandler:onAppear(npc, creature) end
npcType.onDisappear = function(npc, creature) npcHandler:onDisappear(npc, creature) end
npcType.onMove = function(npc, creature, fromPosition, toPosition) npcHandler:onMove(npc, creature, fromPosition, toPosition) end
npcType.onSay = function(npc, creature, type, message) npcHandler:onSay(npc, creature, type, message) end
npcType.onCloseChannel = function(npc, creature) npcHandler:onCloseChannel(npc, creature) end

-- Shop table (fill later). Example entry format:
-- { itemName = "awesome item", clientId = 12345, buy = 10, subType = 1 }
local itemsTable = {
	{ itemName = "lesser exp potion", clientId = 60303, buy = 30 },
	{ itemName = "exp potion", clientId = 60301, buy = 60 },
	{ itemName = "greater exp potion", clientId = 60302, buy = 90 },
	{ itemName = "exercise token", clientId = 60141, buy = 40 },
	{ itemName = "wealth  duplex", clientId = 36727, buy = 60 },
}

local function creatureSayCallback(npc, creature, type, message)
	local player = Player(creature)
	if not npcHandler:checkInteraction(npc, creature) then
		return false
	end

	if MsgContains(message, 'trade') or MsgContains(message, 'offer') or MsgContains(message, 'shop') then
		npc:openShopWindowTable(player, itemsTable)
		npcHandler:say("These are my current offers. Prices are in Arena Tokens.", npc, creature)
		return true
	end

	if MsgContains(message, 'help') then
		npcHandler:say("Earn Arena Tokens in the Gnome Arena. Bring them here to exchange for rewards. Say 'trade' to browse.", npc, creature)
		return true
	end

	return false
end

-- Basic messages
npcHandler:setMessage(MESSAGE_GREET, "Greetings, challenger! I trade rewards for your {Arena Tokens}. Say {trade} to browse.")
npcHandler:setMessage(MESSAGE_FAREWELL, "Good luck in the arena, return with more tokens!")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Until next time, gladiator.")
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
-- Enable standard greeting/focus handling (hi/bye)
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- Trade callbacks
local function onTradeRequest(npc, creature)
	local player = Player(creature)
	npc:openShopWindowTable(player, itemsTable)
	npcHandler:say("These are my current offers. Prices are in Arena Tokens.", npc, creature)
	return true
end

npcHandler:setCallback(CALLBACK_ON_TRADE_REQUEST, onTradeRequest)

npcType.onBuyItem = function(npc, player, itemId, subType, amount, ignore, inBackpacks, totalCost)
	-- With npcConfig.currency set, totalCost is in tokens
	npc:sellItem(player, itemId, amount, subType, 0, ignore, inBackpacks)
end

npcType.onSellItem = function(npc, player, itemId, subtype, amount, ignore, name, totalCost)
	-- Not buying from players by default; message for clarity
	player:sendTextMessage(MESSAGE_TRADE, "I do not buy items, only sell for Arena Tokens.")
end

npcType.onCheckItem = function(npc, player, clientId, subType) end

npcType:register(npcConfig)
