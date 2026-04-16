local internalNpcName = "Birthday Trader"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 471, -- Entrepreneur outfit (festive)
	lookHead = 95,
	lookBody = 113,
	lookLegs = 39,
	lookFeet = 115,
	lookAddons = 3,
}

npcConfig.flags = {
	floorchange = false,
}

-- Use Christmas Token (6526) as currency
npcConfig.currency = 6526

npcConfig.voices = {
	interval = 15000,
	chance = 30,
	{ text = "Happy Birthday to the ADM! Trade your present tokens here!" },
	{ text = "Celebrate with exclusive birthday rewards! Say 'trade'!" },
	{ text = "Gift Goblins stole the presents! Get them back and trade the tokens with me!" },
}

local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)

npcType.onThink = function(npc, interval) npcHandler:onThink(npc, interval) end
npcType.onAppear = function(npc, creature) npcHandler:onAppear(npc, creature) end
npcType.onDisappear = function(npc, creature) npcHandler:onDisappear(npc, creature) end
npcType.onMove = function(npc, creature, fromPosition, toPosition) npcHandler:onMove(npc, creature, fromPosition, toPosition) end
npcType.onSay = function(npc, creature, type, message) npcHandler:onSay(npc, creature, type, message) end
npcType.onCloseChannel = function(npc, creature) npcHandler:onCloseChannel(npc, creature) end

-- Birthday shop offerings
local itemsTable = {
	-- Common
	{ itemName = "silver token", clientId = 22516, buy = 15 },
	{ itemName = "gold token", clientId = 22721, buy = 30 },

	-- Intermediate
	{ itemName = "essence of murcion", clientId = 43501, buy = 40 },
	{ itemName = "essence of ichgahal", clientId = 43502, buy = 40 },
	{ itemName = "essence of vemiath", clientId = 43503, buy = 40 },
	{ itemName = "essence of chagorz", clientId = 43504, buy = 40 },
	{ itemName = "reflect potion", clientId = 49272, buy = 50 },
	{ itemName = "mystery bag", clientId = 60077, buy = 65 },

	-- Rare
	{ itemName = "bakragore's amalgamation", clientId = 43968, buy = 80 },
	{ itemName = "roulette coin", clientId = 60104, buy = 100 },
	{ itemName = "epic upgrade stone", clientId = 60427, buy = 130 },
	{ itemName = "bag of cosmic wishes", clientId = 60626, buy = 160 },

	-- Very Rare
	{ itemName = "boosted exercise token", clientId = 60648, buy = 150 },
	{ itemName = "tier upgrader", clientId = 60022, buy = 200 },
	{ itemName = "exercise speed improvement", clientId = 60647, buy = 250 },
	{ itemName = "unrevealed relic", clientId = 60522, buy = 250 },

	-- Epic
	{ itemName = "serenity outfit box", clientId = 9586, buy = 350 },
	{ itemName = "pcd racing car key", clientId = 60649, buy = 500 },
}

local function creatureSayCallback(npc, creature, type, message)
	local player = Player(creature)
	if not npcHandler:checkInteraction(npc, creature) then
		return false
	end

	if MsgContains(message, "trade") or MsgContains(message, "offer") or MsgContains(message, "shop") then
		npc:openShopWindowTable(player, itemsTable)
		npcHandler:say("Here are the birthday celebration rewards! All prices are in Present Tokens from the Gift Goblins.", npc, creature)
		return true
	end

	if MsgContains(message, "help") or MsgContains(message, "birthday") or MsgContains(message, "event") then
		npcHandler:say({
			"The ADM's birthday is being celebrated! But {Gift Goblins} have stolen the presents!",
			"Defeat them during the raids to collect {Present Tokens}, then say {trade} to exchange them for amazing rewards!",
		}, npc, creature)
		return true
	end

	if MsgContains(message, "token") or MsgContains(message, "tokens") then
		local tokenCount = player:getItemCount(6526)
		npcHandler:say(string.format("You currently have %d Present Token%s. Say {trade} to spend them!", tokenCount, tokenCount ~= 1 and "s" or ""), npc, creature)
		return true
	end

	return false
end

-- Basic messages
npcHandler:setMessage(MESSAGE_GREET, "Welcome to the ADM Birthday Bash! I have exclusive rewards for your {Present Tokens}. Say {trade} to browse or {help} for information.")
npcHandler:setMessage(MESSAGE_FAREWELL, "Happy celebrations! Come back with more tokens!")
npcHandler:setMessage(MESSAGE_WALKAWAY, "See you at the next raid!")
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

-- Enable standard greeting/focus handling
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- Trade callbacks
local function onTradeRequest(npc, creature)
	local player = Player(creature)
	npc:openShopWindowTable(player, itemsTable)
	npcHandler:say("Here are the birthday celebration rewards! All prices are in Present Tokens.", npc, creature)
	return true
end

npcHandler:setCallback(CALLBACK_ON_TRADE_REQUEST, onTradeRequest)

npcType.onBuyItem = function(npc, player, itemId, subType, amount, ignore, inBackpacks, totalCost)
	npc:sellItem(player, itemId, amount, subType, 0, ignore, inBackpacks)
	player:sendTextMessage(MESSAGE_TRADE, string.format("You traded %d Present Token%s for %s.", totalCost, totalCost ~= 1 and "s" or "", ItemType(itemId):getName()))
end

npcType.onSellItem = function(npc, player, itemId, subtype, amount, ignore, name, totalCost)
	player:sendTextMessage(MESSAGE_TRADE, "I do not buy items, only sell birthday rewards for Present Tokens.")
end

npcType.onCheckItem = function(npc, player, clientId, subType) end

npcType:register(npcConfig)
