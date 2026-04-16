local internalNpcName = "The Master Healer"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 1722,
	lookHead = 57,
	lookBody = 2,
	lookLegs = 132,
	lookFeet = 114,
	lookAddons = 3,
}

npcConfig.flags = {
	floorchange = false,
}

npcConfig.voices = {
	interval = 15000,
	chance = 50,
	{ text = "There is still hope." },
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

local function creatureSayCallback(npc, creature, type, message)
	local player = Player(creature)
	local playerId = player:getId()

	if not npcHandler:checkInteraction(npc, creature) then
		return false
	end
	if MsgContains(message, "mission") then
		if player:getStorageValue(Storage.TheMasterHealer.QuestLine) == -1 then
			npcHandler:say({ "If you seek to enhance the power of your healing potions, know that the path is deeper than mere alchemy. It resides within the Vital Essence, the very energy that pulses through wild life. For your potions to truly transcend, you must prove your connection to this primal force.",
				"Your first task is to cleanse your soul at ten Life Fountains scattered across our Kingdom. These sacred springs bubble forth in secret havens, often guarded by elemental earth creatures.",
				"Find each fountain, humble yourself before its power, and let its pristine waters wash over your spirit. Return to me once you have received the blessing of all ten. Go now, and find your purification!" }, npc, creature)
			player:setStorageValue(Storage.TheMasterHealer.QuestLine, Storage.TheMasterHealer.QuestLine + 1)
			player:setStorageValue(Storage.TheMasterHealer.Mission01, 1)
			player:setStorageValue(Storage.TheMasterHealer.Fountains, 0)
			return true
		end

		if player:getStorageValue(Storage.TheMasterHealer.QuestLine) == 0 then
			npcHandler:say("You have already started your mission. Find all life fountains and cleanse your soul.", npc, creature)
			return true
		end

		if player:getStorageValue(Storage.TheMasterHealer.QuestLine) == 1 then
			npcHandler:say("Ready for your next mission?", npc, creature)
			npcHandler:setTopic(playerId, 1)
			return true
		end

		if player:getStorageValue(Storage.TheMasterHealer.QuestLine) == 3 then
			npcHandler:say("Ready for your last mission?", npc, creature)
			npcHandler:setTopic(playerId, 2)
			return true
		end

		if player:getStorageValue(Storage.TheMasterHealer.QuestLine) == 4 then
			npcHandler:say("I have no more quests for you.", npc, creature)
			npcHandler:setTopic(playerId, 2)
			return true
		end
	end
	if MsgContains(message, "yes") then
		if npcHandler:getTopic(playerId) == 1 then
			npcHandler:say("Find the Sacred Tree of Life and cleanse your body of the poison of the darkness.", npc, creature)
			player:setStorageValue(Storage.TheMasterHealer.Mission02, 1)
			player:setStorageValue(Storage.TheMasterHealer.QuestLine, Storage.TheMasterHealer.QuestLine + 1)
			npcHandler:setTopic(playerId, 0)
			return true
		end
		if npcHandler:getTopic(playerId) == 2 then
			npcHandler:say("Kill 10000 creatures in that continent automatically your will earn the Nature God's bleesing and your potions will improved to stage 2 with 20% of bonus healing points.", npc, creature)
			player:setStorageValue(Storage.TheMasterHealer.QuestLine, Storage.TheMasterHealer.QuestLine + 1)
			player:setStorageValue(Storage.TheMasterHealer.Mission03, 0)
			player:setStorageValue(Storage.TheMasterHealer.KillCount, 0)
			npcHandler:setTopic(playerId, 0)
			return true
		end
	end

	return true
end

keywordHandler:addGreetKeyword({ "hi" }, { npcHandler = npcHandler, text = "Greetings, adventurer. A flicker of curiosity I see in your eyes... or perhaps it is the weariness of your journeys? Either way, welcome. What brings you to this humble sanctuary of peace?" })
keywordHandler:addAliasKeyword({ "hello" })

npcHandler:setMessage(MESSAGE_GREET, "Hello")
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
