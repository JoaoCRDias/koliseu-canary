 local internalNpcName = "Cryptor"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 3047,
	lookHead = 94,
	lookBody = 132,
	lookLegs = 77,
	lookFeet = 114,
	lookAddons = 3,
	lookMount = 1049,
}

npcConfig.flags = {
	floorchange = false,
}

npcConfig.currency = 60129

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
	{ itemName = "kooldown-aid", clientId = 36723, buy = 30 },
	{ itemName = "strike enhancement", clientId = 36724, buy = 30 },
	{ itemName = "stamina extension", clientId = 36725, buy = 30 },
	{ itemName = "charm upgrade", clientId = 36726, buy = 30 },
	{ itemName = "bestiary betterment", clientId = 36728, buy = 30 },
	{ itemName = "fire resilience", clientId = 36729, buy = 30 },
	{ itemName = "ice resilience", clientId = 36730, buy = 30 },
	{ itemName = "earth resilience", clientId = 36731, buy = 30 },
	{ itemName = "energy resilience", clientId = 36732, buy = 30 },
	{ itemName = "holy resilience", clientId = 36733, buy = 30 },
	{ itemName = "death resilience", clientId = 36734, buy = 30 },
	{ itemName = "physical resilience", clientId = 36735, buy = 30 },
	{ itemName = "fire amplification", clientId = 36736, buy = 30 },
	{ itemName = "ice amplification", clientId = 36737, buy = 30 },
	{ itemName = "earth amplification", clientId = 36738, buy = 30 },
	{ itemName = "energy amplification", clientId = 36739, buy = 30 },
	{ itemName = "holy amplification", clientId = 36740, buy = 30 },
	{ itemName = "death amplification", clientId = 36741, buy = 30 },
	{ itemName = "physical amplification", clientId = 36742, buy = 30 },
	{ itemName = "exercise weapon token", clientId = 60141, buy = 20 },
	{ itemName = "reflect potion", clientId = 49272, buy = 40 },
	{ itemName = "prey wildcard parchment", clientId = 60101, buy = 80 },
	{ itemName = "blessed steak", clientId = 9086, buy = 30 },
	{ itemName = "carrion casserole", clientId = 29414, buy = 30 },
	{ itemName = "carrot cake", clientId = 9087, buy = 30 },
	{ itemName = "consecrated beef", clientId = 29415, buy = 30 },
	{ itemName = "hydra tongue salad", clientId = 9080, buy = 30 },
	{ itemName = "rotworm stew", clientId = 9079, buy = 30 },
	{ itemName = "tropical fried terrorbird", clientId = 9082, buy = 30 },
	{ itemName = "veggie casserole", clientId = 9084, buy = 30 },
	{ itemName = "blueberry cupcake", clientId = 28484, buy = 30 },
	{ itemName = "exercise speed improvement", clientId = 60647, buy = 100 },
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
