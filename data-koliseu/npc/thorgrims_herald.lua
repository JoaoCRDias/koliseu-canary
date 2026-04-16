local internalNpcName = "Thorgrim's Herald"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 3168,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
}

npcConfig.flags = {
	floorchange = false,
}

npcConfig.voices = {
	interval = 15000,
	chance = 50,
	{ text = "The storm awaits those who dare..." },
	{ text = "Prove your worth against the Hammerborn." },
	{ text = "Only the strongest survive the thunder." },
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

-- Hazard config
local HAZARD_NAME = "hazard.edron-kingdom"
local REWARD_HAZARD_LEVEL = 7
local REWARD_ITEM_ID = 0 -- PLACEHOLDER: Item ID do reward
local REWARD_AMOUNT = 1

local function creatureSayCallback(npc, creature, type, message)
	local player = Player(creature)
	local playerId = player:getId()

	if not npcHandler:checkInteraction(npc, creature) then
		return false
	end

	local hazard = Hazard.getByName(HAZARD_NAME)
	if not hazard then
		npcHandler:say("Something is wrong with the hazard system. Please contact an administrator.", npc, creature)
		return true
	end

	local current = hazard:getPlayerCurrentLevel(player)
	local maximum = hazard:getPlayerMaxLevel(player)

	if MsgContains(message, "hazard") then
		npcHandler:say("I can adjust your hazard level for the battles ahead. Your current level is set to " .. current .. " and your maximum unlocked level is {" .. maximum .. "}. What level would you like to set?", npc, creature)
		npcHandler:setTopic(playerId, 1)
	else
		if npcHandler:getTopic(playerId) == 1 then
			local desiredLevel = getMoneyCount(message)
			if desiredLevel <= 0 then
				npcHandler:say("I don't understand. What hazard level would you like to set?", npc, creature)
				npcHandler:setTopic(playerId, 1)
				return true
			end
			if hazard:setPlayerCurrentLevel(player, desiredLevel) then
				npcHandler:say("Your hazard level has been set to " .. desiredLevel .. ". May the thunder guide you!", npc, creature)

				-- Check if player reached reward level
				if desiredLevel >= REWARD_HAZARD_LEVEL and not player:kv():scoped("thorgrim"):get("hazard-reward-claimed") then
					if REWARD_ITEM_ID > 0 then
						local inbox = player:getStoreInbox()
						if inbox then
							local reward = inbox:addItem(REWARD_ITEM_ID, REWARD_AMOUNT)
							if reward then
								player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have proven yourself worthy! A special reward has been sent to your inbox.")
								player:kv():scoped("thorgrim"):set("hazard-reward-claimed", true)
								npcHandler:say("Impressive! You've reached hazard level " .. REWARD_HAZARD_LEVEL .. ". Thorgrim himself acknowledges your strength. Check your inbox for a reward.", npc, creature)
							end
						end
					end
				end
			else
				npcHandler:say("You can't set your hazard level higher than your maximum unlocked level of " .. maximum .. ".", npc, creature)
			end
			npcHandler:setTopic(playerId, 0)
		end
	end
	return true
end

keywordHandler:addGreetKeyword({ "hi" }, { npcHandler = npcHandler, text = "Greetings, warrior. I serve as Thorgrim's herald. If you wish to adjust your {hazard} level, speak the word." })
keywordHandler:addAliasKeyword({ "hello" })

npcHandler:setMessage(MESSAGE_GREET, "Greetings, warrior. I serve as Thorgrim's herald. If you wish to adjust your {hazard} level, speak the word.")
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

npcType:register(npcConfig)
