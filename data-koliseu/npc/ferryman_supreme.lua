local internalNpcName = "Ferryman Caelis"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 0
npcConfig.walkRadius = 0

npcConfig.outfit = {
	lookType = 155,
	lookHead = 0,
	lookBody = 94,
	lookLegs = 94,
	lookFeet = 0,
	lookAddons = 0,
}

npcConfig.flags = {
	floorchange = false,
}

npcConfig.voices = {
	interval = 20000,
	chance = 40,
	{ text = "The tide waits for no one. If you seek the forsaken isle, speak with me." },
	{ text = "Only the worthy sail to the mountain's shadow. Are you one of them?" },
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

local TRAVEL_COST = 0

local function addTravelKeyword(keyword, text, destination)
	local node = keywordHandler:addKeyword({ keyword }, StdModule.say, { npcHandler = npcHandler, text = text })
	node:addChildKeyword({ "yes" }, StdModule.travel, { npcHandler = npcHandler, premium = false, text = "Hold tight, the sea is restless.", cost = TRAVEL_COST, destination = destination })
	node:addChildKeyword({ "no" }, StdModule.say, { npcHandler = npcHandler, text = "Then the isle remains beyond your reach.", reset = true })
end

addTravelKeyword("island", "Do you wish to sail to the forsaken isle?", SupremeVocation.Positions.islandDock)
addTravelKeyword("mainland", "Do you wish to return to the mainland?", SupremeVocation.Positions.mainlandDock)
addTravelKeyword("return", "Do you wish to return to the mainland?", SupremeVocation.Positions.mainlandDock)

keywordHandler:addKeyword({ "sail" }, StdModule.say, { npcHandler = npcHandler, text = "I can take you to the {island} where the mountain looms, or back to the {mainland}." })
keywordHandler:addKeyword({ "job" }, StdModule.say, { npcHandler = npcHandler, text = "I ferry the bold across these waters. I've seen many go. Fewer return." })
keywordHandler:addKeyword({ "mountain" }, StdModule.say, { npcHandler = npcHandler, text = "The mountain holds the trial of the supreme vocations. Only the old warrior on the isle can speak of it." })

npcHandler:setMessage(MESSAGE_GREET, "Greetings, |PLAYERNAME|. I can {sail} you to the {island} or take you back to the {mainland}. Where to?")
npcHandler:setMessage(MESSAGE_FAREWELL, "Fair winds.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Fair winds.")
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

npcType:register(npcConfig)
