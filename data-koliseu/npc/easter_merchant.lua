local internalNpcName = "Easter Merchant"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName
npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 7336, -- Easter Rabbit looktype
	lookHead = 95,
	lookBody = 94,
	lookLegs = 114,
	lookFeet = 114,
	lookAddons = 0,
	lookMount = 0,
}

npcConfig.flags = {
	floorchange = false,
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

-- Messages
npcHandler:setMessage(MESSAGE_FAREWELL, "Happy Easter! May you find many eggs!")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Come back with more present tokens!")
npcHandler:setMessage(MESSAGE_SENDTRADE, "Here are my exclusive Easter rewards! All prices are in present tokens.")

-- Custom greet with dynamic egg progress
local function greetCallback(npc, creature)
	local player = creature:getPlayer()
	if not player then
		return false
	end

	local current = EasterEvent:getEggCount()
	local goal = EasterEvent.config.eggGoal
	local remaining = math.max(goal - current, 0)
	local percentage = math.min((current / goal) * 100, 100)

	local progressMsg
	if EasterEvent:isGoalReached() then
		progressMsg = "The community goal has been reached! Enjoy the bonus EXP!"
	else
		progressMsg = string.format("Easter Egg progress: %d / %d (%.1f%%) - %d eggs remaining!", current, goal, percentage, remaining)
	end

	npcHandler:say("Happy Easter, " .. player:getName() .. "! " .. progressMsg .. " I have exclusive rewards in exchange for {present tokens}. Say {trade} to see my offers or ask me about the {eggs}!", npc, creature)
	return true
end

npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- Keywords
keywordHandler:addKeyword({ "job" }, StdModule.say, {
	npcHandler = npcHandler,
	text = "I am the Easter Merchant! I trade exclusive rewards for {present tokens} that drop from Easter Rabbits.",
})

keywordHandler:addKeyword({ "present token" }, StdModule.say, {
	npcHandler = npcHandler,
	text = "Present tokens are rare drops from Easter Rabbits. Bring them to me and I will exchange them for exclusive mounts, outfits and valuable items!",
})

keywordHandler:addKeyword({ "easter" }, StdModule.say, {
	npcHandler = npcHandler,
	text = "Hunt Easter Rabbits across the land! They drop Easter Eggs for the community goal and rare present tokens you can trade with me.",
})

-- Dynamic egg progress keyword (needs custom callback for dynamic text)
local eggProgressCallback = function(npc, player, message, keywords, parameters, node)
	if not npcHandler:checkInteraction(npc, player) then
		return false
	end

	local current = EasterEvent:getEggCount()
	local goal = EasterEvent.config.eggGoal
	local remaining = math.max(goal - current, 0)
	local percentage = math.min((current / goal) * 100, 100)

	local text
	if EasterEvent:isGoalReached() then
		text = string.format("The community goal has been reached! %d / %d eggs collected! Enjoy the bonus EXP!", current, goal)
	else
		text = string.format("Easter Egg progress: %d / %d (%.1f%%). We still need %d more eggs! Use them in the Easter Machine to contribute!", current, goal, percentage, remaining)
	end

	npcHandler:say(text, npc, player)
	return true
end

keywordHandler:addKeyword({ "eggs" }, eggProgressCallback, { npcHandler = npcHandler })
keywordHandler:addKeyword({ "progress" }, eggProgressCallback, { npcHandler = npcHandler })
keywordHandler:addKeyword({ "goal" }, eggProgressCallback, { npcHandler = npcHandler })

-- Shop: Present Token (id 6526) as currency
-- Prices are in present tokens (buy = cost in tokens)
npcConfig.shop = {
	-- Exclusive outfit items
	{ itemName = "PCD Racing Car Key", clientId = 60649, buy = 200 },
	{ itemName = "serenity outfit box", clientId = 9586, buy = 200 },

	-- Upgrade stones
	{ itemName = "basic upgrade stone", clientId = 60429, buy = 5 },
	{ itemName = "medium upgrade stone", clientId = 60428, buy = 10 },
	{ itemName = "epic upgrade stone", clientId = 60427, buy = 15 },

	-- Skill gems
	{ itemName = "paladin skill gem", clientId = 58051, buy = 10 },
	{ itemName = "mage skill gem", clientId = 58052, buy = 10 },
	{ itemName = "knight skill gem", clientId = 58054, buy = 10 },

	-- Potions
	{ itemName = "reflect potion", clientId = 49272, buy = 20 },
	{ itemName = "mitigation potion", clientId = 11372, buy = 30 },
}

-- Custom buy handler: use Present Tokens as currency instead of gold
npcType.onBuyItem = function(npc, player, itemId, subType, amount, ignore, inBackpacks, totalCost)
	local tokenId = 6526 -- present token
	local tokenCount = player:getItemCount(tokenId)

	if tokenCount < totalCost then
		npc:say(
			string.format("You need %d present token(s) but you only have %d.", totalCost, tokenCount),
			TALKTYPE_PRIVATE_NP, false, player, npc:getPosition()
		)
		return false
	end

	-- Remove tokens
	player:removeItem(tokenId, totalCost)

	-- Give item
	local item = player:addItem(itemId, amount)
	if item then
		npc:say(
			string.format("Here you go! %dx %s for %d present token(s). Happy Easter!", amount, ItemType(itemId):getName(), totalCost),
			TALKTYPE_PRIVATE_NP, false, player, npc:getPosition()
		)
		player:getPosition():sendMagicEffect(CONST_ME_GIFT_WRAPS)
	end

	return true
end

npcType.onSellItem = function(npc, player, itemId, subtype, amount, ignore, name, totalCost)
	return false -- NPC doesn't buy items
end

npcType.onCheckItem = function(npc, player, clientId, subType) end

npcType:register(npcConfig)
