local internalNpcName = "Galdor"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 1207,
	lookHead = 10,
	lookBody = 94,
	lookLegs = 95,
	lookFeet = 132,
	lookAddons = 3,
}

npcConfig.flags = {
	floorchange = false,
}

npcConfig.currency = 60083

npcConfig.voices = {
	interval = 15000,
	chance = 50,
	{ text = "Come on and share some stories!" },
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


npcHandler:setMessage(MESSAGE_GREET, "Welcome, want to {trade} some task coins?")
npcHandler:setMessage(MESSAGE_FAREWELL, "Please come back from time to time.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Please come back from time to time.")

npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

npcConfig.shop = {
	{ itemName = "bag you desire", clientId = 34109, buy = 20 },
	{ itemName = "primal bag", clientId = 39546, buy = 30 },
	{ itemName = "brainstealer bag", clientId = 60409, buy = 10 },
	{ itemName = "falcon bag", clientId = 60410, buy = 10 },
	{ itemName = "lion bag", clientId = 60411, buy = 10 },
	{ itemName = "ratmiral bag", clientId = 60412, buy = 10 },
	{ itemName = "scarlett bag", clientId = 60413, buy = 10 },
	{ itemName = "timira bag", clientId = 60414, buy = 10 },
	{ itemName = "monster bag", clientId = 60408, buy = 10 },
	{ itemName = "death matter", clientId = 60676, buy = 150, sell = 150 },
	{ itemName = "ice matter", clientId = 60677, buy = 150, sell = 150 },
	{ itemName = "holy matter", clientId = 60678, sell = 150 },
	{ itemName = "fire matter", clientId = 60679, buy = 150, sell = 150 },
	{ itemName = "physical matter", clientId = 60680, buy = 150, sell = 150 },
	{ itemName = "energy matter", clientId = 60681, buy = 150, sell = 150 },
	{ itemName = "earth matter", clientId = 60682, buy = 150, sell = 150 },
	{ itemName = "boosted exercise token", clientId = 60648, buy = 50 },
}
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
