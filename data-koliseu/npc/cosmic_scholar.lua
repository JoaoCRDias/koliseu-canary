local internalNpcName = "Cosmic Scholar"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 1202,
	lookHead = 19,
	lookBody = 69,
	lookLegs = 96,
	lookFeet = 19,
	lookAddons = 3,
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

-- Configuration
local COSMIC_REWARD_STORAGE = 920100

local ITEMS = {
	ADDON_DOLL = 8778,
	MOUNT_DOLL = 21948,
}

local REWARD_ADDON_DOLLS = 500
local REWARD_MOUNT_DOLLS = 500

-- All 12 cosmic rift monster raceIds
local ALL_COSMIC_RACE_IDS = {
	2769, 2770, 2771, -- Rift I
	2772, 2773, 2774, -- Rift II
	2775, 2776, 2777, -- Rift III
	2778, 2779, 2780, -- Rift IV
}

local function hasCompletedAllBestiaries(player)
	for _, raceId in ipairs(ALL_COSMIC_RACE_IDS) do
		if not player:isMonsterBestiaryUnlocked(raceId) then
			return false
		end
	end
	return true
end

local function creatureSayCallback(npc, creature, type, message)
	local player = Player(creature)
	local playerId = player:getId()

	if not npcHandler:checkInteraction(npc, creature) then
		return false
	end

	message = message:lower()

	if MsgContains(message, "cosmic") or MsgContains(message, "rift") or MsgContains(message, "mission") then
		if player:getStorageValue(COSMIC_REWARD_STORAGE) == 1 then
			npcHandler:say("You have already proven yourself, adventurer. The cosmos remembers your deeds.", npc, creature)
			return true
		end

		npcHandler:say({
			"The Cosmic Rifts have torn through our reality, unleashing creatures from beyond the stars. ...",
			"There are four rifts, each more dangerous than the last. To enter the first, you must have conquered the bestiaries of Soul War, Gnomprona, and Rotten Blood. ...",
			"Each subsequent rift requires mastery of the creatures from the previous one. ...",
			"If you manage to complete the bestiary of all twelve cosmic creatures across all four rifts, return to me and {report} your accomplishment. A great reward awaits the worthy!"
		}, npc, creature, 200)
		npcHandler:setTopic(playerId, 0)
	elseif MsgContains(message, "report") then
		if player:getStorageValue(COSMIC_REWARD_STORAGE) == 1 then
			npcHandler:say("You have already claimed your reward, adventurer.", npc, creature)
			return true
		end

		if not hasCompletedAllBestiaries(player) then
			npcHandler:say("You have not yet completed the bestiary of all twelve cosmic rift creatures. Keep hunting and return when you are done.", npc, creature)
			return true
		end

		npcHandler:say("Incredible! You have truly conquered all twelve cosmic creatures! Are you ready to receive your reward?", npc, creature)
		npcHandler:setTopic(playerId, 1)
	elseif MsgContains(message, "yes") and npcHandler:getTopic(playerId) == 1 then
		npcHandler:setTopic(playerId, 0)

		local inbox = player:getStoreInbox()
		if not inbox then
			npcHandler:say("Something went wrong with your store inbox. Please try again later.", npc, creature)
			return true
		end

		local remainingAddons = REWARD_ADDON_DOLLS
		while remainingAddons > 0 do
			local amount = math.min(remainingAddons, 100)
			local item = inbox:addItem(ITEMS.ADDON_DOLL, amount)
			if item then
				item:setAttribute(ITEM_ATTRIBUTE_STORE, systemTime())
			end
			remainingAddons = remainingAddons - amount
		end

		local remainingMounts = REWARD_MOUNT_DOLLS
		while remainingMounts > 0 do
			local amount = math.min(remainingMounts, 100)
			local item = inbox:addItem(ITEMS.MOUNT_DOLL, amount)
			if item then
				item:setAttribute(ITEM_ATTRIBUTE_STORE, systemTime())
			end
			remainingMounts = remainingMounts - amount
		end

		player:setStorageValue(COSMIC_REWARD_STORAGE, 1)
		player:getPosition():sendMagicEffect(CONST_ME_HOLYDAMAGE)

		npcHandler:say({
			"The cosmos smiles upon you, " .. player:getName() .. "! ...",
			"I have placed a 500 Addon Dolls, and 500 Mount Dolls in your Store Inbox. ...",
			"May the stars forever guide your path!"
		}, npc, creature, 200)
	elseif MsgContains(message, "no") and npcHandler:getTopic(playerId) == 1 then
		npcHandler:setTopic(playerId, 0)
		npcHandler:say("Very well. Return whenever you are ready.", npc, creature)
	end

	return true
end

npcHandler:setMessage(MESSAGE_GREET, "Greetings, traveler. I study the {cosmic} rifts that have appeared in our world. Do you wish to learn about this {mission}?")
npcHandler:setMessage(MESSAGE_WALKAWAY, "May the stars watch over you.")
npcHandler:setMessage(MESSAGE_FAREWELL, "Farewell, |PLAYERNAME|. May the cosmos guide you.")

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

npcType:register(npcConfig)
