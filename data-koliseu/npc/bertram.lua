local internalNpcName = "Bertram"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 1676,
	lookHead = 117,
	lookBody = 94,
	lookLegs = 128,
	lookFeet = 114,
	lookAddons = 2,
}

npcConfig.flags = {
	floorchange = false,
}

npcConfig.voices = {
	interval = 15000,
	chance = 50,
	{ text = "Buy everithing you need!" },
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

local itemsTable = {
	["exercise weapons"] = {
		{ itemName = "exercise axe", clientId = 28553, buy = 350000, subType = 500 },
		{ itemName = "exercise bow", clientId = 28555, buy = 350000, subType = 500 },
		{ itemName = "exercise club", clientId = 28554, buy = 350000, subType = 500 },
		{ itemName = "exercise rod", clientId = 28556, buy = 350000, subType = 500 },
		{ itemName = "exercise sword", clientId = 28552, buy = 350000, subType = 500 },
		{ itemName = "exercise wand", clientId = 28557, buy = 350000, subType = 500 },
		{ itemName = "exercise wraps", clientId = 50293, buy = 350000, subType = 500 },
		{ itemName = "exercise shield", clientId = 44065, buy = 350000, subType = 500 },
		{ itemName = "durable exercise axe", clientId = 35280, buy = 1250000, subType = 1800 },
		{ itemName = "durable exercise bow", clientId = 35282, buy = 1250000, subType = 1800 },
		{ itemName = "durable exercise club", clientId = 35281, buy = 1250000, subType = 1800 },
		{ itemName = "durable exercise rod", clientId = 35283, buy = 1250000, subType = 1800 },
		{ itemName = "durable exercise sword", clientId = 35279, buy = 1250000, subType = 1800 },
		{ itemName = "durable exercise wand", clientId = 35284, buy = 1250000, subType = 1800 },
		{ itemName = "durable exercise wraps", clientId = 50294, buy = 1250000, subType = 1800 },
		{ itemName = "durable exercise shield", clientId = 44066, buy = 1250000, subType = 1800 },
		{ itemName = "lasting exercise axe", clientId = 35286, buy = 10000000, subType = 14400 },
		{ itemName = "lasting exercise bow", clientId = 35288, buy = 10000000, subType = 14400 },
		{ itemName = "lasting exercise club", clientId = 35287, buy = 10000000, subType = 14400 },
		{ itemName = "lasting exercise rod", clientId = 35289, buy = 10000000, subType = 14400 },
		{ itemName = "lasting exercise sword", clientId = 35285, buy = 10000000, subType = 14400 },
		{ itemName = "lasting exercise wand", clientId = 35290, buy = 10000000, subType = 14400 },
		{ itemName = "lasting exercise wraps", clientId = 50295, buy = 10000000, subType = 14400 },
		{ itemName = "lasting exercise shield", clientId = 44067, buy = 10000000, subType = 14400 },
	},
	["distance"] = {
		{ itemName = "arrow", clientId = 3447, buy = 2 },
		{ itemName = "bolt", clientId = 3446, buy = 4 },
		{ itemName = "crystalline arrow", clientId = 15793, buy = 450 },
		{ itemName = "drill bolt", clientId = 16142, buy = 12 },
		{ itemName = "diamond arrow", clientId = 35901, buy = 130 },
		{ itemName = "earth arrow", clientId = 774, buy = 5 },
		{ itemName = "envenomed arrow", clientId = 16143, buy = 12 },
		{ itemName = "flaming arrow", clientId = 763, buy = 5 },
		{ itemName = "flash arrow", clientId = 761, buy = 5 },
		{ itemName = "onyx arrow", clientId = 7365, buy = 7 },
		{ itemName = "piercing bolt", clientId = 7363, buy = 5 },
		{ itemName = "power bolt", clientId = 3450, buy = 7 },
		{ itemName = "prismatic bolt", clientId = 16141, buy = 20 },
		{ itemName = "quiver", clientId = 35562, buy = 400 },
		{ itemName = "royal spear", clientId = 7378, buy = 15 },
		{ itemName = "shiver arrow", clientId = 762, buy = 5 },
		{ itemName = "sniper arrow", clientId = 7364, buy = 5 },
		{ itemName = "spectral bolt", clientId = 35902, buy = 70 },
		{ itemName = "tarsal arrow", clientId = 14251, buy = 6 },
		{ itemName = "throwing star", clientId = 3287, buy = 42 },
		{ itemName = "vortex bolt", clientId = 14252, buy = 6 },
	},
	["upgrade system"] = {
		{ itemName = "epic upgrade stone", clientId = 60427, buy = 100000000 },
		{ itemName = "medium upgrade stone", clientId = 60428, buy = 65000000 },
		{ itemName = "basic upgrade stone", clientId = 60429, buy = 30000000 },
		{ itemName = "paladin skill gem", clientId = 58051, buy = 30000000 },
		{ itemName = "mage skill gem", clientId = 58052, buy = 30000000 },
		{ itemName = "knight skill gem", clientId = 58054, buy = 30000000 },
	},
	["reflect system"] = {
		{ itemName = "reflect potion", clientId = 49272, buy = 50000000 },
	},

	["rods"] = {
		{ itemName = "hailstorm rod", clientId = 3067, buy = 15000 },
		{ itemName = "moonlight rod", clientId = 3070, buy = 1000 },
		{ itemName = "necrotic rod", clientId = 3069, buy = 5000 },
		{ itemName = "northwind rod", clientId = 8083, buy = 7500 },
		{ itemName = "snakebite rod", clientId = 3066, buy = 500 },
		{ itemName = "springsprout rod", clientId = 8084, buy = 18000 },
		{ itemName = "terra rod", clientId = 3065, buy = 10000 },
		{ itemName = "underworld rod", clientId = 8082, buy = 22000 },
	},
	["wands"] = {
		{ itemName = "wand of cosmic energy", clientId = 3073, buy = 10000 },
		{ itemName = "wand of decay", clientId = 3072, buy = 5000 },
		{ itemName = "wand of draconia", clientId = 8093, buy = 7500 },
		{ itemName = "wand of dragonbreath", clientId = 3075, buy = 1000 },
		{ itemName = "wand of inferno", clientId = 3071, buy = 15000 },
		{ itemName = "wand of starstorm", clientId = 8092, buy = 18000 },
		{ itemName = "wand of voodoo", clientId = 8094, buy = 22000 },
		{ itemName = "wand of vortex", clientId = 3074, buy = 500 },
	},
	["potions"] = {
		{ itemName = "great health potion", clientId = 239, buy = 225 },
		{ itemName = "great mana potion", clientId = 238, buy = 158 },
		{ itemName = "great spirit potion", clientId = 7642, buy = 254 },
		{ itemName = "health potion", clientId = 266, buy = 50 },
		{ itemName = "mana potion", clientId = 268, buy = 56 },
		{ itemName = "magic shield potion", clientId = 35563, buy = 50000 },
		{ itemName = "strong health potion", clientId = 236, buy = 115 },
		{ itemName = "strong mana potion", clientId = 237, buy = 108 },
		{ itemName = "supreme health potion", clientId = 23375, buy = 650 },
		{ itemName = "ultimate health potion", clientId = 7643, buy = 379 },
		{ itemName = "ultimate mana potion", clientId = 23373, buy = 488 },
		{ itemName = "ultimate spirit potion", clientId = 23374, buy = 488 },
		{ itemName = "cosmic health potion", clientId = 60259, buy = 7500 },
		{ itemName = "cosmic mana potion", clientId = 60258, buy = 7500 },
		{ itemName = "cosmic spirit potion", clientId = 60260, buy = 7500 },
	},
	["runes"] = {
		{ itemName = "animate dead rune", clientId = 3203, buy = 375 },
		{ itemName = "avalanche rune", clientId = 3161, buy = 64 },
		{ itemName = "blank rune", clientId = 3147, buy = 10 },
		{ itemName = "chameleon rune", clientId = 3178, buy = 210 },
		{ itemName = "convince creature rune", clientId = 3177, buy = 80 },
		{ itemName = "cure poison rune", clientId = 3153, buy = 65 },
		{ itemName = "destroy field rune", clientId = 3148, buy = 15 },
		{ itemName = "disintegrate rune", clientId = 3197, buy = 26 },
		{ itemName = "energy bomb rune", clientId = 3149, buy = 203 },
		{ itemName = "energy field rune", clientId = 3164, buy = 38 },
		{ itemName = "energy wall rune", clientId = 3166, buy = 85 },
		{ itemName = "explosion rune", clientId = 3200, buy = 31 },
		{ itemName = "fire bomb rune", clientId = 3192, buy = 147 },
		{ itemName = "fire field rune", clientId = 3188, buy = 28 },
		{ itemName = "fire wall rune", clientId = 3190, buy = 61 },
		{ itemName = "fireball rune", clientId = 3189, buy = 30 },
		{ itemName = "great fireball rune", clientId = 3191, buy = 64 },
		{ itemName = "heavy magic missile rune", clientId = 3198, buy = 12 },
		{ itemName = "holy missile rune", clientId = 3182, buy = 16 },
		{ itemName = "icicle rune", clientId = 3158, buy = 30 },
		{ itemName = "intense healing rune", clientId = 3152, buy = 95 },
		{ itemName = "light magic missile rune", clientId = 3174, buy = 4 },
		{ itemName = "magic wall rune", clientId = 3180, buy = 116 },
		{ itemName = "paralyse rune", clientId = 3165, buy = 700 },
		{ itemName = "poison bomb rune", clientId = 3173, buy = 85 },
		{ itemName = "poison field rune", clientId = 3172, buy = 21 },
		{ itemName = "poison wall rune", clientId = 3176, buy = 52 },
		{ itemName = "soulfire rune", clientId = 3195, buy = 46 },
		{ itemName = "stalagmite rune", clientId = 3179, buy = 12 },
		{ itemName = "stone shower rune", clientId = 3175, buy = 41 },
		{ itemName = "sudden death rune", clientId = 3155, buy = 162 },
		{ itemName = "thunderstorm rune", clientId = 3202, buy = 52 },
		{ itemName = "ultimate healing rune", clientId = 3160, buy = 175 },
		{ itemName = "wild growth rune", clientId = 3156, buy = 160 },
	},
	["supplies"] = {
		{ itemName = "brown mushroom", clientId = 3725, buy = 10 },
	},
	["tools"] = {
		{ itemName = "basket", clientId = 2855, buy = 6 },
		{ itemName = "bottle", clientId = 2875, buy = 3 },
		{ itemName = "bucket", clientId = 2873, buy = 4 },
		{ itemName = "torch", clientId = 2920, buy = 2 },
		{ itemName = "fishing rod", clientId = 3483, buy = 150 },
		{ itemName = "vial of water", clientId = 2874, buy = 40 },

	},
	["postal"] = {
		{ itemName = "label", clientId = 3507, buy = 1 },
		{ itemName = "letter", clientId = 3505, buy = 8 },
		{ itemName = "parcel", clientId = 3503, buy = 15 },
	},
	["backpacks"] = {
		{ itemName = "brown backpack", clientId = 2854, buy = 20 },
		{ itemName = "green backpack", clientId = 2865, buy = 20 },
		{ itemName = "yellow backpack", clientId = 2866, buy = 20 },
		{ itemName = "red backpack", clientId = 2867, buy = 20 },
		{ itemName = "purple backpack", clientId = 2868, buy = 20 },
		{ itemName = "blue backpack", clientId = 2869, buy = 20 },
		{ itemName = "grey backpack", clientId = 2870, buy = 20 },
		{ itemName = "golden backpack", clientId = 2871, buy = 20 },
		{ itemName = "camouflage backpack", clientId = 2872, buy = 20 },
		{ itemName = "beach backpack", clientId = 5949, buy = 20 },
		{ itemName = "fur backpack", clientId = 7342, buy = 20 },
		{ itemName = "brocade backpack", clientId = 8860, buy = 20 },
		{ itemName = "demon backpack", clientId = 9601, buy = 20000 },
		{ itemName = "orange backpack", clientId = 9602, buy = 20 },
		{ itemName = "moon backpack", clientId = 9604, buy = 20000 },
		{ itemName = "crown backpack", clientId = 9605, buy = 20000 },
		{ itemName = "heart backpack", clientId = 10202, buy = 20000 },
		{ itemName = "expedition backpack", clientId = 10324, buy = 20000 },
		{ itemName = "dragon backpack", clientId = 10326, buy = 20000 },
		{ itemName = "minotaur backpack", clientId = 10327, buy = 20000 },
		{ itemName = "santa backpack", clientId = 10346, buy = 20000 },
		{ itemName = "deepling backpack", clientId = 14248, buy = 20000 },
		{ itemName = "buggy backpack", clientId = 14249, buy = 20000 },
		{ itemName = "anniversary backpack", clientId = 14674, buy = 20000 },
		{ itemName = "mushroom backpack", clientId = 16099, buy = 20000 },
		{ itemName = "crystal backpack", clientId = 16100, buy = 20000 },
		{ itemName = "pannier backpack", clientId = 19159, buy = 20000 },
		{ itemName = "cake backpack", clientId = 20347, buy = 20000 },
		{ itemName = "glooth backpack", clientId = 21295, buy = 20000 },
		{ itemName = "war backpack", clientId = 21445, buy = 20000 },
		{ itemName = "wolf backpack", clientId = 22084, buy = 20000 },
		{ itemName = "energetic backpack", clientId = 23525, buy = 20000 },
		{ itemName = "pillow backpack", clientId = 24393, buy = 20000 },
		{ itemName = "bithday backpack", clientId = 24395, buy = 20000 },
		{ itemName = "book backpack", clientId = 28571, buy = 20000 },
		{ itemName = "festive backpack", clientId = 30197, buy = 20000 },
		{ itemName = "winged backpack", clientId = 31625, buy = 20000 },
		{ itemName = "ghost backpack", clientId = 32620, buy = 200000 },
		{ itemName = "raccoon backpack", clientId = 35577, buy = 20000 },
		{ itemName = "25 years backpack", clientId = 39693, buy = 20000 },
		{ itemName = "lilypad backpack", clientId = 39754, buy = 20000 },
	},
	['rings'] = {
		{ itemName = "axe ring", clientId = 3092, buy = 2000 },
		{ itemName = "club ring", clientId = 3093, buy = 2000 },
		{ itemName = "sword ring", clientId = 3094, buy = 2000 },
		{ itemName = "dwarven ring", clientId = 3097, buy = 2000 },
		{ itemName = "energy ring", clientId = 3051, buy = 2000 },
		{ itemName = "might ring", clientId = 3048, buy = 100000 },
		{ itemName = "time ring", clientId = 3053, buy = 2000 },
		{ itemName = "ring of blue plasma", clientId = 23529, buy = 10000 },
		{ itemName = "ring of red plasma", clientId = 23533, buy = 10000 },
		{ itemName = "ring of green plasma", clientId = 23531, buy = 10000 },
		{ itemName = "prismatic ring", clientId = 16114, buy = 500000 },
	},
	['amulets'] = {
		{ itemName = "collar of blue plasma", clientId = 23542, buy = 10000 },
		{ itemName = "collar of green plasma", clientId = 23543, buy = 10000 },
		{ itemName = "collar of red plasma", clientId = 23544, buy = 10000 },
		{ itemName = "stone skin amulet", clientId = 3081, buy = 100000 },
		{ itemName = "gill necklace", clientId = 16108, buy = 300000 },
		{ itemName = "garlic necklace", clientId = 3083, buy = 2000 },
	},
	['foods'] = {
		{ itemName = "brown mushroom", clientId = 3725, buy = 10 },
	},
	["flowers"] = {
		{ itemName = "bowl of evergreen flowers", clientId = 8763, buy = 150 },
		{ itemName = "flower bowl", clientId = 2983, buy = 150 },
	},
	["crusher"] = {
		{ itemName = "crusher", clientId = 46627, buy = 100000, subType = 100 },
	},
	["relics"] = {
		{ itemName = "relic revealer", clientId = 60521, buy = 100000000 },
	},
	["mitigation"] = {
		{ itemName = "mitigation potion", clientId = 11372, buy = 100000000 },
	},
}

local function creatureSayCallback(npc, creature, type, message)
	local player = Player(creature)

	if not npcHandler:checkInteraction(npc, creature) then
		return false
	end

	for category, items in pairs(itemsTable) do
		if message == category then
			npcHandler:say("Here are the items for the category " .. category .. ".", npc, creature)
			npc:openShopWindowTable(player, items)
			return
		end
	end
end

-- Basic

local function buildGreetMessage()
	local categories = {}
	for category, _ in pairs(itemsTable) do
		table.insert(categories, "{" .. category .. "}")
	end
	return "Welcome. I sell a selection of " .. table.concat(categories, ", ") .. ", just ask!"
end

npcHandler:setMessage(MESSAGE_GREET, buildGreetMessage())
npcHandler:setMessage(MESSAGE_FAREWELL, "Please come back from time to time.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Please come back from time to time.")
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

local function onTradeRequest(npc, creature)
	local player = Player(creature)

	local allItems = {}
	for _, items in pairs(itemsTable) do
		for _, item in ipairs(items) do
			table.insert(allItems, item)
		end
	end

	npc:openShopWindowTable(player, allItems)
	npcHandler:say("Here are all the items available.", npc, creature)

	return true
end

npcHandler:setCallback(CALLBACK_ON_TRADE_REQUEST, onTradeRequest)
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
