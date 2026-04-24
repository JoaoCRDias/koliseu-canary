local internalNpcName = "Ascenar"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 0
npcConfig.walkRadius = 0

npcConfig.outfit = {
	lookType = 963,
	lookHead = 0, lookBody = 94, lookLegs = 94, lookFeet = 0, lookAddons = 0, lookMount = 0,
}

npcConfig.flags = { floorchange = false }

npcConfig.voices = {
	interval = 30000,
	chance = 15,
	{ text = "The summit does not suffer the unworthy." },
	{ text = "Five demons fell so your kind could ascend." },
}

local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)

npcType.onThink = function(npc, interval) npcHandler:onThink(npc, interval) end
npcType.onAppear = function(npc, creature) npcHandler:onAppear(npc, creature) end
npcType.onDisappear = function(npc, creature) npcHandler:onDisappear(npc, creature) end
npcType.onMove = function(npc, creature, fromPosition, toPosition) npcHandler:onMove(npc, creature, fromPosition, toPosition) end
npcType.onSay = function(npc, creature, type, message) npcHandler:onSay(npc, creature, type, message) end
npcType.onCloseChannel = function(npc, creature) npcHandler:onCloseChannel(npc, creature) end

local function creatureSayCallback(npc, creature, type, message)
	local player = Player(creature)
	if not player or not npcHandler:checkInteraction(npc, creature) then
		return false
	end

	local playerId = player:getId()
	local text = message:lower()

	-- Already promoted: just acknowledge.
	if SupremeVocation.hasSupremeVocationGranted(player) then
		npcHandler:say("The summit burns in your blood already. Go - the mountain has nothing more to give you.", npc, creature)
		return true
	end

	if MsgContains(text, "promote") or MsgContains(text, "ascend") or MsgContains(text, "vocation") or MsgContains(text, "summit") then
		local baseId = player:getVocation():getId()
		local supremeId = SupremeVocation.Summit.supremeVocationByBase[baseId]
		if not supremeId then
			npcHandler:say("Your vocation is not one the summit may lift. Speak to me when you bear the right one.", npc, creature)
			return true
		end

		local supremeName = SupremeVocation.Summit.supremeNameByVocId[supremeId]
		npcHandler:setTopic(playerId, 1)
		npcHandler:say({
			string.format("You will become %s, the shape the summit grants your kind.", supremeName),
			"Say {yes} to take the mantle. There is no going back.",
		}, npc, creature)
		return true
	end

	if MsgContains(text, "yes") and npcHandler:getTopic(playerId) == 1 then
		if SupremeVocation.grantSupremeVocation(player) then
			npcHandler:say({
				"It is done. You are no longer what you were.",
				"Leave this place. The mountain has taken its due.",
			}, npc, creature)
			player:getPosition():sendMagicEffect(CONST_ME_GIFT_WRAPS)
		else
			npcHandler:say("Something refuses the promotion. Check your vocation and speak to me again.", npc, creature)
		end
		npcHandler:setTopic(playerId, 0)
		return true
	end

	return false
end

npcHandler:setMessage(MESSAGE_GREET, "I am Ascenar. Those who reach me wish to be {promoted} - if they killed what must be killed.")
npcHandler:setMessage(MESSAGE_FAREWELL, "Climb down, supreme.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "...")
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

npcType:register(npcConfig)
