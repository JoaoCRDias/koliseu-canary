local internalNpcName = "Captain Accessor"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 3124,
	lookHead = 255,
	lookBody = 1,
	lookLegs = 110,
	lookFeet = 110,
	lookAddons = 3,
}

npcConfig.flags = {
	floorchange = false,
}

npcConfig.voices = {
	interval = 15000,
	chance = 50,
	{ text = "No coin, no passage. The realms I guard are not for the broke or the bold without backing." },
	{ text = "Quests beyond this point demand more than bravery—they demand payment. Do you have what it takes?" },
	{ text = "Only those who value the journey pay the price to begin it. Step forward if your pouch is ready." },
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

local REQUIRED_LEVEL = 1200

local function creatureSayCallback(npc, creature, type, message)
	local player = Player(creature)
	local playerId = player:getId()

	if not npcHandler:checkInteraction(npc, creature) then
		return false
	end

	local ACCESS_PRICE = 30000000 -- 30kk
	message = message:lower()

	if MsgContains(message, "access") then
		if player:getLevel() < REQUIRED_LEVEL then
			npcHandler:say("You must be at least level " .. REQUIRED_LEVEL .. " to access these quests. Come back when you're stronger.", npc, creature)
			return true
		end

		if SecondFloorQuests.hasAccess(player) then
			npcHandler:say("You already have access to the quests I guard. Go forth!", npc, creature)
			return true
		end

		npcHandler:setTopic(playerId, 2)
		npcHandler:say("Access to the quests costs 30kk. Do you want to pay?", npc, creature)
		return true
	end

	if (MsgContains(message, "yes")) then
		if (npcHandler:getTopic(playerId) ~= 2) then
			return false
		end
		if player:getMoney() + player:getBankBalance() >= ACCESS_PRICE then
			player:removeMoney(ACCESS_PRICE)
			SecondFloorQuests.addAccess(player)
			npcHandler:say("Payment received. You now have access to the quests. Don't waste it.", npc, creature)
		else
			npcHandler:say("Access to the quests costs 30kk. Come back when you're rich enough.", npc, creature)
		end
	end

	return true
end

npcHandler:setMessage(MESSAGE_GREET, "Greetings. I am the one who grants access to the quests on this floor. If you're seeking to {access} them, you've come to the right place.")
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
