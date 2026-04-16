local internalNpcName = "Titanium Merchant"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 3060, -- Merchant outfit
	lookHead = 114,
	lookBody = 94,
	lookLegs = 78,
	lookFeet = 94,
	lookAddons = 3,
}

npcConfig.flags = {
	floorchange = false,
}

-- Use Titanium Token (22724) as currency
npcConfig.currency = 22724

npcConfig.voices = {
	interval = 15000,
	chance = 30,
	{ text = "I buy rare boss items for Titanium Tokens!" },
	{ text = "Bring me your boss loot for great rewards!" },
	{ text = "Say 'trade' to sell your boss items." },
}

local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)

npcType.onThink = function(npc, interval) npcHandler:onThink(npc, interval) end
npcType.onAppear = function(npc, creature) npcHandler:onAppear(npc, creature) end
npcType.onDisappear = function(npc, creature) npcHandler:onDisappear(npc, creature) end
npcType.onMove = function(npc, creature, fromPosition, toPosition) npcHandler:onMove(npc, creature, fromPosition, toPosition) end
npcType.onSay = function(npc, creature, type, message) npcHandler:onSay(npc, creature, type, message) end
npcType.onCloseChannel = function(npc, creature) npcHandler:onCloseChannel(npc, creature) end

-- ============================================================================
-- BOSS ITEMS SHOP CONFIGURATION
-- ============================================================================
-- Add/edit items here. The NPC will BUY these items from players.
-- Format: { itemName = "name", clientId = ITEM_ID, sell = TOKEN_AMOUNT }
-- 'sell' = how many Titanium Tokens the player receives when selling this item
-- ============================================================================

local bossItemsTable = {


	-- ========================================
	-- ADD YOUR CUSTOM BOSS ITEMS BELOW:
	-- ========================================
	-- Example format:
	-- { itemName = "boss item name", clientId = ITEM_ID, sell = TOKEN_AMOUNT },

	-- Uncomment and edit these examples:
	-- { itemName = "legendary sword", clientId = 12345, sell = 1500 },
	-- { itemName = "mythic armor", clientId = 12346, sell = 2000 },
	-- { itemName = "ancient shield", clientId = 12347, sell = 1200 },

	-- AUTO-GENERATED TITANIUM ITEMS START
	-- Generated via scripts/update_titanium_items.py
	{ itemName = "brain in a jar", clientId = 29426, sell = 1 }, -- level 180
	{ itemName = "exotic legs", clientId = 35516, sell = 1 }, -- level 180
	{ itemName = "bambus jo", clientId = 50270, sell = 1 }, -- level 180
	{ itemName = "bast legs", clientId = 35517, sell = 1 }, -- level 180
	{ itemName = "plague bite", clientId = 22759, sell = 1 }, -- level 180
	{ itemName = "dark vision bandana", clientId = 50190, sell = 1 }, -- level 180
	{ itemName = "dark whispers", clientId = 29427, sell = 1 }, -- level 180
	{ itemName = "deepling ceremonial dagger", clientId = 28825, sell = 1 }, -- level 180
	{ itemName = "dream shroud", clientId = 29423, sell = 1 }, -- level 180
	{ itemName = "ectoplasmic shield", clientId = 29430, sell = 1 }, -- level 180
	{ itemName = "enchanted pendulet", clientId = 30344, sell = 1 }, -- level 180
	{ itemName = "enchanted pendulet", clientId = 30345, sell = 1 }, -- level 180
	{ itemName = "enchanted sleep shawl", clientId = 30342, sell = 1 }, -- level 180
	{ itemName = "enchanted sleep shawl", clientId = 30343, sell = 1 }, -- level 180
	{ itemName = "energized limb", clientId = 29425, sell = 1 }, -- level 180
	{ itemName = "exotic amulet", clientId = 35523, sell = 1 }, -- level 180
	{ itemName = "living armor", clientId = 29418, sell = 1 }, -- level 180
	{ itemName = "pair of dreamwalkers", clientId = 29424, sell = 1 }, -- level 180
	{ itemName = "pendulet", clientId = 29429, sell = 1 }, -- level 180
	{ itemName = "phantasmal axe", clientId = 32616, sell = 1 }, -- level 180
	{ itemName = "shoulder plate", clientId = 29420, sell = 1 }, -- level 180
	{ itemName = "sleep shawl", clientId = 29428, sell = 1 }, -- level 180
	{ itemName = "soulful legs", clientId = 32618, sell = 1 }, -- level 180
	{ itemName = "spirit guide", clientId = 29431, sell = 1 }, -- level 180
	{ itemName = "ornate legs", clientId = 13999, sell = 2 }, -- level 185
	{ itemName = "axe of destruction", clientId = 27451, sell = 2 }, -- level 200
	{ itemName = "biscuit barrier", clientId = 45643, sell = 2 }, -- level 200
	{ itemName = "blade of destruction", clientId = 27449, sell = 2 }, -- level 200
	{ itemName = "bow of destruction", clientId = 27455, sell = 2 }, -- level 200
	{ itemName = "candy-coated quiver", clientId = 45644, sell = 2 }, -- level 200
	{ itemName = "chopper of destruction", clientId = 27452, sell = 2 }, -- level 200
	{ itemName = "cocoa grimoire", clientId = 45639, sell = 2 }, -- level 200
	{ itemName = "creamy grimoire", clientId = 45640, sell = 2 }, -- level 200
	{ itemName = "crossbow of destruction", clientId = 27456, sell = 2 }, -- level 200
	{ itemName = "death gaze", clientId = 22758, sell = 2 }, -- level 200
	{ itemName = "earthheart cuirass", clientId = 22521, sell = 2 }, -- level 200
	{ itemName = "earthheart hauberk", clientId = 22522, sell = 2 }, -- level 200
	{ itemName = "earthheart platemail", clientId = 22523, sell = 2 }, -- level 200
	{ itemName = "earthmind raiment", clientId = 22535, sell = 2 }, -- level 200
	{ itemName = "earthsoul tabard", clientId = 22531, sell = 2 }, -- level 200
	{ itemName = "enchanted merudri brooch", clientId = 50154, sell = 2 }, -- level 200
	{ itemName = "enchanted merudri brooch", clientId = 50155, sell = 2 }, -- level 200
	{ itemName = "enchanted ring of souls", clientId = 32621, sell = 2 }, -- level 200
	{ itemName = "enchanted ring of souls", clientId = 32635, sell = 2 }, -- level 200
	{ itemName = "enchanted turtle amulet", clientId = 39233, sell = 2 }, -- level 200
	{ itemName = "enchanted turtle amulet", clientId = 39234, sell = 2 }, -- level 200
	{ itemName = "energy robe", clientId = 50279, sell = 2 }, -- level 200
	{ itemName = "Fireheart cuirass", clientId = 22518, sell = 2 }, -- level 200
	{ itemName = "fireheart hauberk", clientId = 22519, sell = 2 }, -- level 200
	{ itemName = "fireheart platemail", clientId = 22520, sell = 2 }, -- level 200
	{ itemName = "firemind raiment", clientId = 22534, sell = 2 }, -- level 200
	{ itemName = "firesoul tabard", clientId = 22530, sell = 2 }, -- level 200
	{ itemName = "frostheart cuirass", clientId = 22527, sell = 2 }, -- level 200
	{ itemName = "frostheart hauberk", clientId = 22528, sell = 2 }, -- level 200
	{ itemName = "frostheart platemail", clientId = 22529, sell = 2 }, -- level 200
	{ itemName = "frostmind raiment", clientId = 22537, sell = 2 }, -- level 200
	{ itemName = "frostsoul tabard", clientId = 22533, sell = 2 }, -- level 200
	{ itemName = "gnome armor", clientId = 27648, sell = 2 }, -- level 200
	{ itemName = "gnome helmet", clientId = 27647, sell = 2 }, -- level 200
	{ itemName = "gnome legs", clientId = 27649, sell = 2 }, -- level 200
	{ itemName = "gnome shield", clientId = 27650, sell = 2 }, -- level 200
	{ itemName = "hammer of destruction", clientId = 27454, sell = 2 }, -- level 200
	{ itemName = "ice robe", clientId = 50280, sell = 2 }, -- level 200
	{ itemName = "leaf robe", clientId = 50277, sell = 2 }, -- level 200
	{ itemName = "mace of destruction", clientId = 27453, sell = 2 }, -- level 200
	{ itemName = "magma robe", clientId = 50278, sell = 2 }, -- level 200
	{ itemName = "nunchaku of destruction", clientId = 50168, sell = 2 }, -- level 200
	{ itemName = "ornate chestplate", clientId = 13993, sell = 2 }, -- level 200
	{ itemName = "ring of ending", clientId = 20182, sell = 2 }, -- level 200
	{ itemName = "ring of souls", clientId = 32636, sell = 2 }, -- level 200
	{ itemName = "rod of destruction", clientId = 27458, sell = 2 }, -- level 200
	{ itemName = "slayer of destruction", clientId = 27450, sell = 2 }, -- level 200
	{ itemName = "summerblade", clientId = 29421, sell = 2 }, -- level 200
	{ itemName = "thunderheart cuirass", clientId = 22524, sell = 2 }, -- level 200
	{ itemName = "thunderheart hauberk", clientId = 22525, sell = 2 }, -- level 200
	{ itemName = "thunderheart platemail", clientId = 22526, sell = 2 }, -- level 200
	{ itemName = "thundermind raiment", clientId = 22536, sell = 2 }, -- level 200
	{ itemName = "thundersoul tabard", clientId = 22532, sell = 2 }, -- level 200
	{ itemName = "turtle amulet", clientId = 39235, sell = 2 }, -- level 200
	{ itemName = "wand of destruction", clientId = 27457, sell = 2 }, -- level 200
	{ itemName = "winterblade", clientId = 29422, sell = 2 }, -- level 200
	{ itemName = "jade legs", clientId = 50185, sell = 2 }, -- level 210
	{ itemName = "amulet of theurgy", clientId = 30401, sell = 2 }, -- level 220
	{ itemName = "blister ring", clientId = 31621, sell = 2 }, -- level 220
	{ itemName = "candy necklace", clientId = 45641, sell = 2 }, -- level 220
	{ itemName = "cobra axe", clientId = 30396, sell = 2 }, -- level 220
	{ itemName = "cobra boots", clientId = 30394, sell = 2 }, -- level 220
	{ itemName = "cobra club", clientId = 30395, sell = 2 }, -- level 220
	{ itemName = "cobra crossbow", clientId = 30393, sell = 2 }, -- level 220
	{ itemName = "cobra rod", clientId = 30400, sell = 2 }, -- level 220
	{ itemName = "cobra sword", clientId = 30398, sell = 2 }, -- level 220
	{ itemName = "embrace of nature", clientId = 31579, sell = 2 }, -- level 220
	{ itemName = "enchanted blister ring", clientId = 31557, sell = 2 }, -- level 220
	{ itemName = "enchanted blister ring", clientId = 31616, sell = 2 }, -- level 220
	{ itemName = "enchanted theurgic amulet", clientId = 30402, sell = 2 }, -- level 220
	{ itemName = "enchanted theurgic amulet", clientId = 30403, sell = 2 }, -- level 220
	{ itemName = "galea mortis", clientId = 31582, sell = 2 }, -- level 220
	{ itemName = "lion spellbook", clientId = 34153, sell = 2 }, -- level 220
	{ itemName = "lion wand", clientId = 34152, sell = 2 }, -- level 220
	{ itemName = "living vine bow", clientId = 29417, sell = 2 }, -- level 220
	{ itemName = "jungle flail", clientId = 35514, sell = 2 }, -- level 220
	{ itemName = "jungle bow", clientId = 35518, sell = 2 }, -- level 220
	{ itemName = "jungle rod", clientId = 35521, sell = 2 }, -- level 220
	{ itemName = "jungle wand", clientId = 35522, sell = 2 }, -- level 220
	{ itemName = "jungle quiver", clientId = 35524, sell = 2 }, -- level 220
	{ itemName = "merudri brooch", clientId = 50156, sell = 2 }, -- level 220
	{ itemName = "mortal mace", clientId = 31580, sell = 2 }, -- level 220
	{ itemName = "rainbow amulet", clientId = 31556, sell = 2 }, -- level 220
	{ itemName = "rainbow necklace", clientId = 30323, sell = 2 }, -- level 220
	{ itemName = "toga mortis", clientId = 31583, sell = 2 }, -- level 220
	{ itemName = "winged boots", clientId = 31617, sell = 2 }, -- level 220
	{ itemName = "fabulous legs", clientId = 32617, sell = 2 }, -- level 225
	{ itemName = "bear skin", clientId = 31578, sell = 2 }, -- level 230
	{ itemName = "death oyoroi", clientId = 50260, sell = 2 }, -- level 230
	{ itemName = "deepling fork", clientId = 28826, sell = 2 }, -- level 230
	{ itemName = "ghost chestplate", clientId = 32628, sell = 2 }, -- level 230
	{ itemName = "lion amulet", clientId = 34158, sell = 2 }, -- level 230
	{ itemName = "lion spangenhelm", clientId = 34156, sell = 2 }, -- level 230
	{ itemName = "norcferatu bonehood", clientId = 51261, sell = 2 }, -- level 230
	{ itemName = "norcferatu fleshguards", clientId = 51267, sell = 2 }, -- level 230
	{ itemName = "resizer", clientId = 29419, sell = 2 }, -- level 230
	{ itemName = "terra helmet", clientId = 31577, sell = 2 }, -- level 230
	{ itemName = "alchemist's boots", clientId = 40592, sell = 2 }, -- level 250
	{ itemName = "alchemist's notepad", clientId = 40594, sell = 2 }, -- level 250
	{ itemName = "antler-horn helmet", clientId = 40588, sell = 2 }, -- level 250
	{ itemName = "bow of cataclysm", clientId = 31581, sell = 2 }, -- level 250
	{ itemName = "cobra amulet", clientId = 31631, sell = 2 }, -- level 250
	{ itemName = "cobra bo", clientId = 50167, sell = 2 }, -- level 250
	{ itemName = "eldritch bow", clientId = 36664, sell = 2 }, -- level 250
	{ itemName = "eldritch breeches", clientId = 36667, sell = 2 }, -- level 250
	{ itemName = "eldritch cowl", clientId = 36670, sell = 2 }, -- level 250
	{ itemName = "eldritch crescent moon spade", clientId = 50169, sell = 2 }, -- level 250
	{ itemName = "eldritch cuirass", clientId = 36663, sell = 2 }, -- level 250
	{ itemName = "eldritch hood", clientId = 36671, sell = 2 }, -- level 250
	{ itemName = "eldritch quiver", clientId = 36666, sell = 2 }, -- level 250
	{ itemName = "eldritch rod", clientId = 36674, sell = 2 }, -- level 250
	{ itemName = "eldritch wand", clientId = 36668, sell = 2 }, -- level 250
	{ itemName = "gilded eldritch bow", clientId = 36665, sell = 2 }, -- level 250
	{ itemName = "gilded eldritch crescent moon spade", clientId = 50170, sell = 2 }, -- level 250
	{ itemName = "gilded eldritch rod", clientId = 36675, sell = 2 }, -- level 250
	{ itemName = "gilded eldritch wand", clientId = 36669, sell = 2 }, -- level 250
	{ itemName = "gnome sword", clientId = 27651, sell = 2 }, -- level 250
	{ itemName = "iks footwraps", clientId = 50291, sell = 2 }, -- level 250
	{ itemName = "lion shield", clientId = 34154, sell = 2 }, -- level 250
	{ itemName = "midnight sarong", clientId = 39167, sell = 2 }, -- level 250
	{ itemName = "mutant bone boots", clientId = 40593, sell = 2 }, -- level 250
	{ itemName = "naga quiver", clientId = 39160, sell = 2 }, -- level 250
	{ itemName = "naga rod", clientId = 39163, sell = 2 }, -- level 250
	{ itemName = "naga wand", clientId = 39162, sell = 2 }, -- level 250
	{ itemName = "stoic iks boots", clientId = 44648, sell = 2 }, -- level 250
	{ itemName = "stoic iks casque", clientId = 44636, sell = 2 }, -- level 250
	{ itemName = "stoic iks chestplate", clientId = 44620, sell = 2 }, -- level 250
	{ itemName = "stoic iks cuirass", clientId = 44619, sell = 2 }, -- level 250
	{ itemName = "stoic iks culet", clientId = 44642, sell = 2 }, -- level 250
	{ itemName = "stoic iks faulds", clientId = 44643, sell = 2 }, -- level 250
	{ itemName = "stoic iks headpiece", clientId = 44637, sell = 2 }, -- level 250
	{ itemName = "stoic iks robe", clientId = 50255, sell = 2 }, -- level 250
	{ itemName = "stoic iks sandals", clientId = 44649, sell = 2 }, -- level 250
	{ itemName = "tagralt blade", clientId = 31614, sell = 2 }, -- level 250
	{ itemName = "umbral master axe", clientId = 20072, sell = 2 }, -- level 250
	{ itemName = "umbral master bow", clientId = 20084, sell = 2 }, -- level 250
	{ itemName = "umbral master chopper", clientId = 20075, sell = 2 }, -- level 250
	{ itemName = "umbral master crossbow", clientId = 20087, sell = 2 }, -- level 250
	{ itemName = "umbral master hammer", clientId = 20081, sell = 2 }, -- level 250
	{ itemName = "umbral master katar", clientId = 50165, sell = 2 }, -- level 250
	{ itemName = "umbral master mace", clientId = 20078, sell = 2 }, -- level 250
	{ itemName = "umbral master slayer", clientId = 20069, sell = 2 }, -- level 250
	{ itemName = "umbral master spellbook", clientId = 20090, sell = 2 }, -- level 250
	{ itemName = "umbral masterblade", clientId = 20066, sell = 2 }, -- level 250
	{ itemName = "cobra hood", clientId = 30397, sell = 2 }, -- level 270
	{ itemName = "cobra wand", clientId = 30399, sell = 2 }, -- level 270
	{ itemName = "dawnfire sherwani", clientId = 39164, sell = 2 }, -- level 270
	{ itemName = "eldritch claymore", clientId = 36657, sell = 2 }, -- level 270
	{ itemName = "eldritch greataxe", clientId = 36661, sell = 2 }, -- level 270
	{ itemName = "eldritch shield", clientId = 36656, sell = 2 }, -- level 270
	{ itemName = "eldritch warmace", clientId = 36659, sell = 2 }, -- level 270
	{ itemName = "feverbloom boots", clientId = 39161, sell = 2 }, -- level 270
	{ itemName = "frostflower boots", clientId = 39158, sell = 2 }, -- level 270
	{ itemName = "gilded eldritch claymore", clientId = 36658, sell = 2 }, -- level 270
	{ itemName = "gilded eldritch greataxe", clientId = 36662, sell = 2 }, -- level 270
	{ itemName = "gilded eldritch warmace", clientId = 36660, sell = 2 }, -- level 270
	{ itemName = "lion axe", clientId = 34253, sell = 2 }, -- level 270
	{ itemName = "lion claws", clientId = 50162, sell = 2 }, -- level 270
	{ itemName = "lion hammer", clientId = 34254, sell = 2 }, -- level 270
	{ itemName = "lion longbow", clientId = 34150, sell = 2 }, -- level 270
	{ itemName = "lion longsword", clientId = 34155, sell = 2 }, -- level 270
	{ itemName = "lion plate", clientId = 34157, sell = 2 }, -- level 270
	{ itemName = "lion rod", clientId = 34151, sell = 2 }, -- level 270
	{ itemName = "mutated skin armor", clientId = 40591, sell = 2 }, -- level 270
	{ itemName = "mutated skin legs", clientId = 40590, sell = 2 }, -- level 270
	{ itemName = "naga tanko", clientId = 50262, sell = 2 }, -- level 270
	{ itemName = "norcferatu bloodhide", clientId = 51263, sell = 2 }, -- level 270
	{ itemName = "norcferatu bloodstrider", clientId = 51266, sell = 2 }, -- level 270
	{ itemName = "norcferatu bonecloak", clientId = 51264, sell = 2 }, -- level 270
	{ itemName = "norcferatu fangstompers", clientId = 51269, sell = 2 }, -- level 270
	{ itemName = "norcferatu goretrampers", clientId = 51268, sell = 2 }, -- level 270
	{ itemName = "norcferatu skullguard", clientId = 51260, sell = 2 }, -- level 270
	{ itemName = "norcferatu thornwraps", clientId = 51265, sell = 2 }, -- level 270
	{ itemName = "norcferatu tuskplate", clientId = 51262, sell = 2 }, -- level 270
	{ itemName = "stitched mutant hide legs", clientId = 40589, sell = 2 }, -- level 270
	{ itemName = "arcane dragon robe", clientId = 44623, sell = 3 }, -- level 300
	{ itemName = "dauntless dragon scale armor", clientId = 44621, sell = 3 }, -- level 300
	{ itemName = "dawnfire pantaloons", clientId = 39166, sell = 3 }, -- level 300
	{ itemName = "demon mengu", clientId = 50189, sell = 3 }, -- level 300
	{ itemName = "demonfang mask", clientId = 49534, sell = 3 }, -- level 300
	{ itemName = "draining inferniarch arbalest", clientId = 49862, sell = 3 }, -- level 300
	{ itemName = "draining inferniarch battleaxe", clientId = 49865, sell = 3 }, -- level 300
	{ itemName = "draining inferniarch blade", clientId = 49877, sell = 3 }, -- level 300
	{ itemName = "draining inferniarch bow", clientId = 49859, sell = 3 }, -- level 300
	{ itemName = "draining inferniarch claws", clientId = 50252, sell = 3 }, -- level 300
	{ itemName = "draining inferniarch flail", clientId = 49871, sell = 3 }, -- level 300
	{ itemName = "draining inferniarch greataxe", clientId = 49868, sell = 3 }, -- level 300
	{ itemName = "draining inferniarch rod", clientId = 49886, sell = 3 }, -- level 300
	{ itemName = "draining inferniarch slayer", clientId = 49880, sell = 3 }, -- level 300
	{ itemName = "draining inferniarch wand", clientId = 49883, sell = 3 }, -- level 300
	{ itemName = "draining inferniarch warhammer", clientId = 49874, sell = 3 }, -- level 300
	{ itemName = "dreadfire headpiece", clientId = 49533, sell = 3 }, -- level 300
	{ itemName = "eldritch folio", clientId = 36672, sell = 3 }, -- level 300
	{ itemName = "eldritch monk boots", clientId = 50266, sell = 3 }, -- level 300
	{ itemName = "eldritch tome", clientId = 36673, sell = 3 }, -- level 300
	{ itemName = "falcon battleaxe", clientId = 28724, sell = 3 }, -- level 300
	{ itemName = "falcon bow", clientId = 28718, sell = 3 }, -- level 300
	{ itemName = "falcon circlet", clientId = 28714, sell = 3 }, -- level 300
	{ itemName = "falcon coif", clientId = 28715, sell = 3 }, -- level 300
	{ itemName = "falcon escutcheon", clientId = 28722, sell = 3 }, -- level 300
	{ itemName = "falcon greaves", clientId = 28720, sell = 3 }, -- level 300
	{ itemName = "falcon longsword", clientId = 28723, sell = 3 }, -- level 300
	{ itemName = "falcon mace", clientId = 28725, sell = 3 }, -- level 300
	{ itemName = "falcon plate", clientId = 28719, sell = 3 }, -- level 300
	{ itemName = "falcon rod", clientId = 28716, sell = 3 }, -- level 300
	{ itemName = "falcon sai", clientId = 50161, sell = 3 }, -- level 300
	{ itemName = "falcon shield", clientId = 28721, sell = 3 }, -- level 300
	{ itemName = "falcon wand", clientId = 28717, sell = 3 }, -- level 300
	{ itemName = "hellstalker visor", clientId = 49532, sell = 3 }, -- level 300
	{ itemName = "inferniarch arbalest", clientId = 49522, sell = 3 }, -- level 300
	{ itemName = "inferniarch battleaxe", clientId = 49523, sell = 3 }, -- level 300
	{ itemName = "inferniarch blade", clientId = 49527, sell = 3 }, -- level 300
	{ itemName = "inferniarch bow", clientId = 49520, sell = 3 }, -- level 300
	{ itemName = "inferniarch claws", clientId = 50250, sell = 3 }, -- level 300
	{ itemName = "inferniarch flail", clientId = 49525, sell = 3 }, -- level 300
	{ itemName = "inferniarch greataxe", clientId = 49524, sell = 3 }, -- level 300
	{ itemName = "inferniarch rod", clientId = 49529, sell = 3 }, -- level 300
	{ itemName = "inferniarch slayer", clientId = 49530, sell = 3 }, -- level 300
	{ itemName = "inferniarch wand", clientId = 49528, sell = 3 }, -- level 300
	{ itemName = "inferniarch warhammer", clientId = 49526, sell = 3 }, -- level 300
	{ itemName = "maliceforged helmet", clientId = 49531, sell = 3 }, -- level 300
	{ itemName = "merudri battle mail", clientId = 50264, sell = 3 }, -- level 300
	{ itemName = "midnight tunic", clientId = 39165, sell = 3 }, -- level 300
	{ itemName = "mutant bone kilt", clientId = 40595, sell = 3 }, -- level 300
	{ itemName = "mutant hide trousers", clientId = 50184, sell = 3 }, -- level 300
	{ itemName = "mystical dragon robe", clientId = 44624, sell = 3 }, -- level 300
	{ itemName = "naga axe", clientId = 39156, sell = 3 }, -- level 300
	{ itemName = "naga club", clientId = 39157, sell = 3 }, -- level 300
	{ itemName = "naga crossbow", clientId = 39159, sell = 3 }, -- level 300
	{ itemName = "naga katar", clientId = 50160, sell = 3 }, -- level 300
	{ itemName = "naga sword", clientId = 39155, sell = 3 }, -- level 300
	{ itemName = "rending inferniarch arbalest", clientId = 49861, sell = 3 }, -- level 300
	{ itemName = "rending inferniarch battleaxe", clientId = 49864, sell = 3 }, -- level 300
	{ itemName = "rending inferniarch blade", clientId = 49876, sell = 3 }, -- level 300
	{ itemName = "rending inferniarch bow", clientId = 49858, sell = 3 }, -- level 300
	{ itemName = "rending inferniarch claws", clientId = 50251, sell = 3 }, -- level 300
	{ itemName = "rending inferniarch flail", clientId = 49870, sell = 3 }, -- level 300
	{ itemName = "rending inferniarch greataxe", clientId = 49867, sell = 3 }, -- level 300
	{ itemName = "rending inferniarch rod", clientId = 49885, sell = 3 }, -- level 300
	{ itemName = "rending inferniarch slayer", clientId = 49879, sell = 3 }, -- level 300
	{ itemName = "rending inferniarch wand", clientId = 49882, sell = 3 }, -- level 300
	{ itemName = "rending inferniarch warhammer", clientId = 49873, sell = 3 }, -- level 300
	{ itemName = "siphoning inferniarch arbalest", clientId = 49863, sell = 3 }, -- level 300
	{ itemName = "siphoning inferniarch battleaxe", clientId = 49866, sell = 3 }, -- level 300
	{ itemName = "siphoning inferniarch blade", clientId = 49878, sell = 3 }, -- level 300
	{ itemName = "siphoning inferniarch bow", clientId = 49860, sell = 3 }, -- level 300
	{ itemName = "siphoning inferniarch claws", clientId = 50253, sell = 3 }, -- level 300
	{ itemName = "siphoning inferniarch flail", clientId = 49872, sell = 3 }, -- level 300
	{ itemName = "siphoning inferniarch greataxe", clientId = 49869, sell = 3 }, -- level 300
	{ itemName = "siphoning inferniarch rod", clientId = 49887, sell = 3 }, -- level 300
	{ itemName = "siphoning inferniarch slayer", clientId = 49881, sell = 3 }, -- level 300
	{ itemName = "siphoning inferniarch wand", clientId = 49884, sell = 3 }, -- level 300
	{ itemName = "siphoning inferniarch warhammer", clientId = 49875, sell = 3 }, -- level 300
	{ itemName = "unerring dragon scale armor", clientId = 44622, sell = 3 }, -- level 300
	{ itemName = "amber axe", clientId = 47375, sell = 4 }, -- level 330
	{ itemName = "amber bludgeon", clientId = 47370, sell = 4 }, -- level 330
	{ itemName = "amber bow", clientId = 47371, sell = 4 }, -- level 330
	{ itemName = "amber crossbow", clientId = 47377, sell = 4 }, -- level 330
	{ itemName = "amber cudgel", clientId = 47376, sell = 4 }, -- level 330
	{ itemName = "amber greataxe", clientId = 47369, sell = 4 }, -- level 330
	{ itemName = "amber kusarigama", clientId = 50239, sell = 4 }, -- level 330
	{ itemName = "amber rod", clientId = 47373, sell = 4 }, -- level 330
	{ itemName = "amber sabre", clientId = 47374, sell = 4 }, -- level 330
	{ itemName = "amber slayer", clientId = 47368, sell = 4 }, -- level 330
	{ itemName = "amber wand", clientId = 47372, sell = 4 }, -- level 330
	{ itemName = "alicorn headguard", clientId = 39149, sell = 4 }, -- level 400
	{ itemName = "alicorn quiver", clientId = 39150, sell = 4 }, -- level 400
	{ itemName = "alicorn ring", clientId = 39182, sell = 4 }, -- level 400
	{ itemName = "arboreal crown", clientId = 39153, sell = 4 }, -- level 400
	{ itemName = "arboreal ring", clientId = 39188, sell = 4 }, -- level 400
	{ itemName = "arboreal tome", clientId = 39154, sell = 4 }, -- level 400
	{ itemName = "arcanomancer folio", clientId = 39152, sell = 4 }, -- level 400
	{ itemName = "arcanomancer regalia", clientId = 39151, sell = 4 }, -- level 400
	{ itemName = "arcanomancer sigil", clientId = 39185, sell = 4 }, -- level 400
	{ itemName = "charged alicorn ring", clientId = 39180, sell = 4 }, -- level 400
	{ itemName = "charged alicorn ring", clientId = 39181, sell = 4 }, -- level 400
	{ itemName = "charged arboreal ring", clientId = 39186, sell = 4 }, -- level 400
	{ itemName = "charged arboreal ring", clientId = 39187, sell = 4 }, -- level 400
	{ itemName = "charged arcanomancer sigil", clientId = 39183, sell = 4 }, -- level 400
	{ itemName = "charged arcanomancer sigil", clientId = 39184, sell = 4 }, -- level 400
	{ itemName = "charged ethereal ring", clientId = 50147, sell = 4 }, -- level 400
	{ itemName = "charged ethereal ring", clientId = 50148, sell = 4 }, -- level 400
	{ itemName = "charged spiritthorn ring", clientId = 39177, sell = 4 }, -- level 400
	{ itemName = "charged spiritthorn ring", clientId = 39178, sell = 4 }, -- level 400
	{ itemName = "ethereal coned hat", clientId = 50188, sell = 4 }, -- level 400
	{ itemName = "ethereal ring", clientId = 50149, sell = 4 }, -- level 400
	{ itemName = "pair of soulstalkers", clientId = 34098, sell = 4 }, -- level 400
	{ itemName = "pair of soulwalkers", clientId = 34097, sell = 4 }, -- level 400
	{ itemName = "soulbastion", clientId = 34099, sell = 4 }, -- level 400
	{ itemName = "soulbiter", clientId = 34084, sell = 4 }, -- level 400
	{ itemName = "soulbleeder", clientId = 34088, sell = 4 }, -- level 400
	{ itemName = "soulcrusher", clientId = 34086, sell = 4 }, -- level 400
	{ itemName = "soulcutter", clientId = 34082, sell = 4 }, -- level 400
	{ itemName = "souleater", clientId = 34085, sell = 4 }, -- level 400
	{ itemName = "soulgarb", clientId = 50254, sell = 4 }, -- level 400
	{ itemName = "soulhexer", clientId = 34091, sell = 4 }, -- level 400
	{ itemName = "soulkamas", clientId = 50159, sell = 4 }, -- level 400
	{ itemName = "soulmaimer", clientId = 34087, sell = 4 }, -- level 400
	{ itemName = "soulmantle", clientId = 34095, sell = 4 }, -- level 400
	{ itemName = "soulpiercer", clientId = 34089, sell = 4 }, -- level 400
	{ itemName = "soulshanks", clientId = 34092, sell = 4 }, -- level 400
	{ itemName = "soulshell", clientId = 34094, sell = 4 }, -- level 400
	{ itemName = "soulshredder", clientId = 34083, sell = 4 }, -- level 400
	{ itemName = "soulshroud", clientId = 34096, sell = 4 }, -- level 400
	{ itemName = "soulsoles", clientId = 50240, sell = 4 }, -- level 400
	{ itemName = "soulstrider", clientId = 34093, sell = 4 }, -- level 400
	{ itemName = "soultainter", clientId = 34090, sell = 4 }, -- level 400
	{ itemName = "spiritthorn armor", clientId = 39147, sell = 4 }, -- level 400
	{ itemName = "spiritthorn helmet", clientId = 39148, sell = 4 }, -- level 400
	{ itemName = "spiritthorn ring", clientId = 39179, sell = 4 }, -- level 400
	{ itemName = "sanguine boots", clientId = 43884, sell = 5 }, -- level 500
	{ itemName = "sanguine galoshes", clientId = 43887, sell = 5 }, -- level 500
	{ itemName = "sanguine greaves", clientId = 43881, sell = 5 }, -- level 500
	{ itemName = "sanguine legs", clientId = 43876, sell = 5 }, -- level 500
	{ itemName = "sanguine trousers", clientId = 50146, sell = 5 }, -- level 500
	{ itemName = "grand sanguine battleaxe", clientId = 43875, sell = 5 }, -- level 600
	{ itemName = "grand sanguine blade", clientId = 43865, sell = 5 }, -- level 600
	{ itemName = "grand sanguine bludgeon", clientId = 43873, sell = 5 }, -- level 600
	{ itemName = "grand sanguine bow", clientId = 43878, sell = 5 }, -- level 600
	{ itemName = "grand sanguine claws", clientId = 50158, sell = 5 }, -- level 600
	{ itemName = "grand sanguine coil", clientId = 43883, sell = 5 }, -- level 600
	{ itemName = "grand sanguine crossbow", clientId = 43880, sell = 5 }, -- level 600
	{ itemName = "grand sanguine cudgel", clientId = 43867, sell = 5 }, -- level 600
	{ itemName = "grand sanguine hatchet", clientId = 43869, sell = 5 }, -- level 600
	{ itemName = "grand sanguine razor", clientId = 43871, sell = 5 }, -- level 600
	{ itemName = "grand sanguine rod", clientId = 43886, sell = 5 }, -- level 600
	{ itemName = "sanguine battleaxe", clientId = 43874, sell = 5 }, -- level 600
	{ itemName = "sanguine blade", clientId = 43864, sell = 5 }, -- level 600
	{ itemName = "sanguine bludgeon", clientId = 43872, sell = 5 }, -- level 600
	{ itemName = "sanguine bow", clientId = 43877, sell = 5 }, -- level 600
	{ itemName = "sanguine claws", clientId = 50157, sell = 5 }, -- level 600
	{ itemName = "sanguine coil", clientId = 43882, sell = 5 }, -- level 600
	{ itemName = "sanguine crossbow", clientId = 43879, sell = 5 }, -- level 600
	{ itemName = "sanguine cudgel", clientId = 43866, sell = 5 }, -- level 600
	{ itemName = "sanguine hatchet", clientId = 43868, sell = 5 }, -- level 600
	{ itemName = "sanguine razor", clientId = 43870, sell = 5 }, -- level 600
	{ itemName = "sanguine rod", clientId = 43885, sell = 5 }, -- level 600

	-- AUTO-GENERATED TITANIUM ITEMS END
	{ itemName = "tier utility", clientId = 60533, buy = 8 },
	{ itemName = "exercise token", clientId = 60141, buy = 12 },

	{ itemName = "greater guardian gem", clientId = 44604, buy = 5 },
	{ itemName = "greater marksman gem", clientId = 44607, buy = 5 },
	{ itemName = "greater mystic gem", clientId = 44613, buy = 5 },
	{ itemName = "greater sage gem", clientId = 44610, buy = 5 },
}

local function creatureSayCallback(npc, creature, type, message)
	local player = Player(creature)
	if not npcHandler:checkInteraction(npc, creature) then
		return false
	end

	if MsgContains(message, 'trade') or MsgContains(message, 'offer') or MsgContains(message, 'shop') then
		npc:openShopWindowTable(player, bossItemsTable)
		npcHandler:say("Here are the boss items I'm buying! I pay in Titanium Tokens.", npc, creature)
		return true
	end

	if MsgContains(message, 'help') or MsgContains(message, 'info') then
		npcHandler:say({
			"I buy rare boss items and pay you with {Titanium Tokens}!",
			"Simply say {trade} to see which items I'm interested in and their prices.",
			"The more valuable the item, the more tokens you'll receive!"
		}, npc, creature)
		return true
	end

	if MsgContains(message, 'token') or MsgContains(message, 'tokens') then
		local tokenCount = player:getItemCount(22724)
		npcHandler:say(string.format("You currently have %d Titanium Token%s.", tokenCount, tokenCount ~= 1 and "s" or ""), npc, creature)
		return true
	end

	if MsgContains(message, 'titanium') then
		npcHandler:say("Titanium Tokens are precious! Use them wisely. You can trade them with other merchants or save them for special occasions.", npc, creature)
		return true
	end

	return false
end

-- Basic messages
npcHandler:setMessage(MESSAGE_GREET, "Greetings, adventurer! I buy rare boss items for {Titanium Tokens}. Say {trade} to sell or {help} for information.")
npcHandler:setMessage(MESSAGE_FAREWELL, "Farewell! Return when you have more boss loot to sell.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Come back with more boss items!")
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

-- Enable standard greeting/focus handling
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- Trade callbacks
local function onTradeRequest(npc, creature)
	local player = Player(creature)
	npc:openShopWindowTable(player, bossItemsTable)
	npcHandler:say("These are the boss items I'm buying. I pay in Titanium Tokens!", npc, creature)
	return true
end

npcHandler:setCallback(CALLBACK_ON_TRADE_REQUEST, onTradeRequest)

npcType.onBuyItem = function(npc, player, itemId, subType, amount, ignore, inBackpacks, totalCost)
	npc:sellItem(player, itemId, amount, subType, 0, ignore, inBackpacks)
end

npcType.onSellItem = function(npc, player, itemId, subtype, amount, ignore, name, totalCost)
	-- Player is selling boss items to NPC, NPC pays with Titanium Tokens
	-- totalCost is automatically in Titanium Tokens because npcConfig.currency = 22724
	player:sendTextMessage(MESSAGE_TRADE, string.format("Sold %dx %s for %d Titanium Token%s!", amount, name, totalCost, totalCost ~= 1 and "s" or ""))
end

npcType.onCheckItem = function(npc, player, clientId, subType) end

npcType:register(npcConfig)
