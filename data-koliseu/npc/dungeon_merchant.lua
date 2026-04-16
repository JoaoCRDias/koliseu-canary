local internalNpcName = "Dungeon Merchant"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 3249, -- Knight NPC look (trocar conforme preferência visual)
	lookHead = 95,
	lookBody = 94,
	lookLegs = 95,
	lookFeet = 94,
	lookAddons = 0,
}

npcConfig.flags = {
	floorchange = false,
}

local currency = 16128

npcConfig.currency = currency

npcConfig.voices = {
	interval = 15000,
	chance = 30,
	{ text = "Trade your Dungeon Tokens for exclusive rewards!" },
	{ text = "Brave adventurer! I have rewards worthy of dungeon champions." },
	{ text = "Say 'trade' to see what I have in stock." },
}

local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)

npcType.onThink = function(npc, interval) npcHandler:onThink(npc, interval) end
npcType.onAppear = function(npc, creature) npcHandler:onAppear(npc, creature) end
npcType.onDisappear = function(npc, creature) npcHandler:onDisappear(npc, creature) end
npcType.onMove = function(npc, creature, fromPosition, toPosition) npcHandler:onMove(npc, creature, fromPosition, toPosition) end
npcType.onSay = function(npc, creature, type, message) npcHandler:onSay(npc, creature, type, message) end
npcType.onCloseChannel = function(npc, creature) npcHandler:onCloseChannel(npc, creature) end

-- Shop offerings (prices in Dungeon Tokens)
local itemsTable = {
	-- Transfer Tokens
	{ itemName = "tier transfer token", clientId = 60636, buy = 5 },
	{ itemName = "upgrade transfer token", clientId = 60430, buy = 5 },
	{ itemName = "skill transfer token", clientId = 60431, buy = 5 },
	{ itemName = "prey wildcard", clientId = 60101, buy = 15 },

	-- Rare Items
	{ itemName = "grand sanguine potion", clientId = 60619, buy = 40 },
	{ itemName = "cosmic token", clientId = 60535, buy = 1 },
	{ itemName = "exercise token", clientId = 60141, buy = 10 },

	{ itemName = "greater guardian gem", clientId = 44604, buy = 3 },
	{ itemName = "greater marksman gem", clientId = 44607, buy = 3 },
	{ itemName = "greater mystic gem", clientId = 44613, buy = 3 },
	{ itemName = "greater sage gem", clientId = 44610, buy = 3 },

	{ itemName = "stmina extension", clientId = 36725, buy = 10 },
}

local function creatureSayCallback(npc, creature, type, message)
	local player = Player(creature)
	if not npcHandler:checkInteraction(npc, creature) then
		return false
	end

	if MsgContains(message, "trade") or MsgContains(message, "offer") or MsgContains(message, "shop") then
		npc:openShopWindowTable(player, itemsTable)
		npcHandler:say("Here are my offerings — all priced in Dungeon Tokens!", npc, creature)
		return true
	end

	if MsgContains(message, "token") or MsgContains(message, "tokens") then
		local count = player:getItemCount(currency)
		npcHandler:say(string.format("You have %d Dungeon Token%s. Say {trade} to spend them!", count, count ~= 1 and "s" or ""), npc, creature)
		return true
	end

	if MsgContains(message, "dungeon") or MsgContains(message, "help") then
		npcHandler:say({
			"Complete the Solo Dungeons to earn {Dungeon Tokens}.",
			"Easy grants 1 token, Medium grants 2, and Hard grants 4. There is a 20-hour shared cooldown between runs.",
			"Say {trade} to see what I can offer you in exchange!",
		}, npc, creature)
		return true
	end

	return false
end

npcHandler:setMessage(MESSAGE_GREET, "Greetings, dungeon champion! I trade rewards for your {Dungeon Tokens}. Say {trade} to browse or {help} for information.")
npcHandler:setMessage(MESSAGE_FAREWELL, "May your runs be swift and your loot be plentiful!")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Come back when you have more tokens to trade.")
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

local function onTradeRequest(npc, creature)
	local player = Player(creature)
	npc:openShopWindowTable(player, itemsTable)
	npcHandler:say("All prices are in Dungeon Tokens. Choose wisely!", npc, creature)
	return true
end

npcHandler:setCallback(CALLBACK_ON_TRADE_REQUEST, onTradeRequest)

npcType.onBuyItem = function(npc, player, itemId, subType, amount, ignore, inBackpacks, totalCost)
	-- With npcConfig.currency set, totalCost is in Dungeon Tokens
	npc:sellItem(player, itemId, amount, subType, 0, ignore, inBackpacks)
	player:sendTextMessage(MESSAGE_TRADE, string.format("You traded %d Dungeon Token%s for %s.",
		totalCost, totalCost ~= 1 and "s" or "", ItemType(itemId):getName()))
end

npcType.onSellItem = function(npc, player, itemId, subtype, amount, ignore, name, totalCost)
	player:sendTextMessage(MESSAGE_TRADE, "I only sell items for Dungeon Tokens, I do not buy.")
end

npcType.onCheckItem = function(npc, player, clientId, subType) end

npcType:register(npcConfig)
