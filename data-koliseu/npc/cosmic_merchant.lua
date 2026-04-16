local internalNpcName = "Cosmic Merchant"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 879, -- Cosmic-themed outfit
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
}

npcConfig.flags = {
	floorchange = false,
}

-- Use Siege Token (60535) as currency
npcConfig.currency = 60535

npcConfig.voices = {
	interval = 15000,
	chance = 30,
	{ text = "Trade your Siege Tokens for cosmic treasures!" },
	{ text = "I have exclusive rewards from the Cosmic Siege!" },
	{ text = "Say 'trade' to see my cosmic offerings." },
}

local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)

npcType.onThink = function(npc, interval) npcHandler:onThink(npc, interval) end
npcType.onAppear = function(npc, creature) npcHandler:onAppear(npc, creature) end
npcType.onDisappear = function(npc, creature) npcHandler:onDisappear(npc, creature) end
npcType.onMove = function(npc, creature, fromPosition, toPosition) npcHandler:onMove(npc, creature, fromPosition, toPosition) end
npcType.onSay = function(npc, creature, type, message) npcHandler:onSay(npc, creature, type, message) end
npcType.onCloseChannel = function(npc, creature) npcHandler:onCloseChannel(npc, creature) end

-- Cosmic Siege shop offerings
local itemsTable = {
	-- Cosmic Transformation
	{ itemName = "scroll of cosmic transformation", clientId = 60540, buy = 600 },

	-- Craft plans
	{ itemName = "silver plan of craft", clientId = 60156, buy = 3000 },
	{ itemName = "golden plan of craft", clientId = 60155, buy = 3000 },

	-- Prey & Exercise
	{ itemName = "exercise token", clientId = 60141, buy = 20 },


	-- Utility items
	-- { itemName = "stamina refiller", clientId = 60117, buy = 200 },

	-- Rare rewards
	-- { itemName = "mount box", clientId = 60107, buy = 1000 },
	-- { itemName = "outfit box", clientId = 60106, buy = 1000 },
}

local function creatureSayCallback(npc, creature, type, message)
	local player = Player(creature)
	if not npcHandler:checkInteraction(npc, creature) then
		return false
	end

	if MsgContains(message, 'trade') or MsgContains(message, 'offer') or MsgContains(message, 'shop') then
		npc:openShopWindowTable(player, itemsTable)
		npcHandler:say("Behold the cosmic treasures I offer! All prices are in Siege Tokens earned from the Cosmic Siege.", npc, creature)
		return true
	end

	if MsgContains(message, 'help') or MsgContains(message, 'siege') then
		npcHandler:say({
			"I trade exclusive rewards for {Siege Tokens}, which you earn by defeating the cosmic bosses in the Cosmic Siege.",
			"Defeat the Nebular Warlord, Eclipse Sovereign, or Astral Tyrant to earn tokens. Say {trade} to browse my offerings!"
		}, npc, creature)
		return true
	end

	if MsgContains(message, 'token') or MsgContains(message, 'tokens') then
		local tokenCount = player:getItemCount(60535)
		npcHandler:say(string.format("You currently have %d Siege Token%s. Say {trade} to spend them!", tokenCount, tokenCount ~= 1 and "s" or ""), npc, creature)
		return true
	end

	return false
end

-- Basic messages
npcHandler:setMessage(MESSAGE_GREET, "Greetings, cosmic warrior! I trade rare treasures for your {Siege Tokens}. Say {trade} to browse or {help} for information.")
npcHandler:setMessage(MESSAGE_FAREWELL, "May the stars guide your path, brave warrior!")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Return when you have more tokens to trade.")
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

-- Enable standard greeting/focus handling
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- Trade callbacks
local function onTradeRequest(npc, creature)
	local player = Player(creature)
	npc:openShopWindowTable(player, itemsTable)
	npcHandler:say("Behold the cosmic treasures I offer! All prices are in Siege Tokens.", npc, creature)
	return true
end

npcHandler:setCallback(CALLBACK_ON_TRADE_REQUEST, onTradeRequest)

npcType.onBuyItem = function(npc, player, itemId, subType, amount, ignore, inBackpacks, totalCost)
	-- With npcConfig.currency set, totalCost is in Siege Tokens
	npc:sellItem(player, itemId, amount, subType, 0, ignore, inBackpacks)
	player:sendTextMessage(MESSAGE_TRADE, string.format("You traded %d Siege Token%s for %s.", totalCost, totalCost ~= 1 and "s" or "", ItemType(itemId):getName()))
end

npcType.onSellItem = function(npc, player, itemId, subtype, amount, ignore, name, totalCost)
	-- Not buying items from players
	player:sendTextMessage(MESSAGE_TRADE, "I do not buy items, only sell cosmic treasures for Siege Tokens.")
end

npcType.onCheckItem = function(npc, player, clientId, subType) end

npcType:register(npcConfig)
