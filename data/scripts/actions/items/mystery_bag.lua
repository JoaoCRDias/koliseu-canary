-- Mystery Bag (60077)
-- Random reward system - all items have equal chance
-- Player transforms into the item for 5 seconds (like chameleon rune)
-- Based on RubinOT Mystic Bag

local MYSTERY_BAG_ID = 60077
local MYSTERY_BAG_STORAGE = 45890 -- Storage to track mystery bag transformation

-- Complete list of Mystery Bag rewards (items with equal probability)
-- IDs extracted from items.xml
local mysteryBagRewards = {
	{ id = 7414, name = "abyss hammer" },
	{ id = 39149, name = "alicorn headguard" },
	{ id = 39150, name = "alicorn quiver" },
	{ id = 21168, name = "alloy legs" },
	{ id = 47375, name = "amber axe" },
	{ id = 47370, name = "amber bludgeon" },
	{ id = 47371, name = "amber bow" },
	{ id = 47377, name = "amber crossbow" },
	{ id = 47376, name = "amber cudgel" },
	{ id = 47369, name = "amber greataxe" },
	{ id = 47373, name = "amber rod" },
	{ id = 47374, name = "amber sabre" },
	{ id = 47368, name = "amber slayer" },
	{ id = 7426, name = "amber staff" },
	{ id = 47372, name = "amber wand" },
	{ id = 7436, name = "angelic axe" },
	{ id = 40588, name = "antler-horn helmet" },
	{ id = 5803, name = "arbalest" },
	{ id = 39153, name = "arboreal crown" },
	{ id = 39154, name = "arboreal tome" },
	{ id = 39152, name = "arcanomancer folio" },
	{ id = 39151, name = "arcanomancer regalia" },
	{ id = 7404, name = "assassin dagger" },
	{ id = 27451, name = "axe of destruction" },
	{ id = 22086, name = "badger boots" },
	{ id = 35517, name = "bast legs" },
	{ id = 9103, name = "batwing hat" },
	{ id = 31578, name = "bear skin" },
	{ id = 3344, name = "beastslayer axe" },
	{ id = 11693, name = "blade of corruption" },
	{ id = 27449, name = "blade of destruction" },
	{ id = 7428, name = "bonebreaker" },
	{ id = 3408, name = "bonelord helmet" },
	{ id = 3079, name = "boots of haste" },
	{ id = 31581, name = "bow of cataclysm" },
	{ id = 27455, name = "bow of destruction" },
	{ id = 29426, name = "brain in a jar" },
	{ id = 3359, name = "brass armor" },
	{ id = 3372, name = "brass legs" },
	{ id = 14086, name = "calopteryx cape" },
	{ id = 14088, name = "carapace shield" },
	{ id = 3358, name = "chain armor" },
	{ id = 39181, name = "charged alicorn ring" },
	{ id = 39187, name = "charged arboreal ring" },
	{ id = 39184, name = "charged arcanomancer sigil" },
	{ id = 39178, name = "charged spiritthorn ring" },
	{ id = 27452, name = "chopper of destruction" },
	{ id = 30396, name = "cobra axe" },
	{ id = 30394, name = "cobra boots" },
	{ id = 30395, name = "cobra club" },
	{ id = 30393, name = "cobra crossbow" },
	{ id = 30397, name = "cobra hood" },
	{ id = 30400, name = "cobra rod" },
	{ id = 30398, name = "cobra sword" },
	{ id = 30399, name = "cobra wand" },
	{ id = 8027, name = "composite hornbow" },
	{ id = 3556, name = "crocodile boots" },
	{ id = 3381, name = "crown armor" },
	{ id = 3385, name = "crown helmet" },
	{ id = 3382, name = "crown legs" },
	{ id = 3419, name = "crown shield" },
	{ id = 8050, name = "crystalline armor" },
	{ id = 3328, name = "daramian waraxe" },
	{ id = 39166, name = "dawnfire pantaloons" },
	{ id = 39164, name = "dawnfire sherwani" },
	{ id = 13991, name = "deepling axe" },
	{ id = 28825, name = "deepling ceremonial dagger" },
	{ id = 28826, name = "deepling fork" },
	{ id = 13987, name = "deepling staff" },
	{ id = 3420, name = "demon shield" },
	{ id = 7382, name = "demonrage sword" },
	{ id = 13997, name = "depth calcei" },
	{ id = 14258, name = "depth galea" },
	{ id = 13994, name = "depth lorica" },
	{ id = 13996, name = "depth ocrea" },
	{ id = 13998, name = "depth scutum" },
	{ id = 3356, name = "devil helmet" },
	{ id = 7387, name = "diamond sceptre" },
	{ id = 10391, name = "drachaku" },
	{ id = 3322, name = "dragon hammer" },
	{ id = 3302, name = "dragon lance" },
	{ id = 7402, name = "dragon slayer" },
	{ id = 4033, name = "draken boots" },
	{ id = 10388, name = "drakinata" },
	{ id = 7419, name = "dreaded cleaver" },
	{ id = 49533, name = "dreadfire headpiece" },
	{ id = 29423, name = "dream shroud" },
	{ id = 3323, name = "dwarven axe" },
	{ id = 3396, name = "dwarven helmet" },
	{ id = 36664, name = "eldritch bow" },
	{ id = 36667, name = "eldritch breeches" },
	{ id = 36657, name = "eldritch claymore" },
	{ id = 36670, name = "eldritch cowl" },
	{ id = 36663, name = "eldritch cuirass" },
	{ id = 36672, name = "eldritch folio" },
	{ id = 36661, name = "eldritch greataxe" },
	{ id = 36671, name = "eldritch hood" },
	{ id = 36666, name = "eldritch quiver" },
	{ id = 36674, name = "eldritch rod" },
	{ id = 36656, name = "eldritch shield" },
	{ id = 36673, name = "eldritch tome" },
	{ id = 36668, name = "eldritch wand" },
	{ id = 36659, name = "eldritch warmace" },
	{ id = 11651, name = "elite draken mail" },
	{ id = 3399, name = "elven mail" },
	{ id = 31579, name = "embrace of nature" },
	{ id = 35516, name = "exotic legs" },
	{ id = 32617, name = "fabulous legs" },
	{ id = 28724, name = "falcon battleaxe" },
	{ id = 28718, name = "falcon bow" },
	{ id = 28714, name = "falcon circlet" },
	{ id = 28715, name = "falcon coif" },
	{ id = 28722, name = "falcon escutcheon" },
	{ id = 28720, name = "falcon greaves" },
	{ id = 28723, name = "falcon longsword" },
	{ id = 28725, name = "falcon mace" },
	{ id = 28719, name = "falcon plate" },
	{ id = 28716, name = "falcon rod" },
	{ id = 28721, name = "falcon shield" },
	{ id = 28717, name = "falcon wand" },
	{ id = 39161, name = "feverbloom boots" },
	{ id = 3280, name = "fire sword" },
	{ id = 39158, name = "frostflower boots" },
	{ id = 7457, name = "fur boots" },
	{ id = 32628, name = "ghost chestplate" },
	{ id = 3281, name = "giant sword" },
	{ id = 16105, name = "gill coat" },
	{ id = 16104, name = "gill gugel" },
	{ id = 16106, name = "gill legs" },
	{ id = 823, name = "glacier kilt" },
	{ id = 829, name = "glacier mask" },
	{ id = 824, name = "glacier robe" },
	{ id = 819, name = "glacier shoes" },
	{ id = 7454, name = "glorious axe" },
	{ id = 27647, name = "gnome helmet" },
	{ id = 27649, name = "gnome legs" },
	{ id = 27650, name = "gnome shield" },
	{ id = 27651, name = "gnome sword" },
	{ id = 3360, name = "golden armor" },
	{ id = 3364, name = "golden legs" },
	{ id = 43875, name = "grand sanguine battleaxe" },
	{ id = 43865, name = "grand sanguine blade" },
	{ id = 43873, name = "grand sanguine bludgeon" },
	{ id = 43878, name = "grand sanguine bow" },
	{ id = 43883, name = "grand sanguine coil" },
	{ id = 43880, name = "grand sanguine crossbow" },
	{ id = 43867, name = "grand sanguine cudgel" },
	{ id = 43869, name = "grand sanguine hatchet" },
	{ id = 43871, name = "grand sanguine razor" },
	{ id = 43886, name = "grand sanguine rod" },
	{ id = 14087, name = "grasshopper legs" },
	{ id = 10323, name = "guardian boots" },
	{ id = 27454, name = "hammer of destruction" },
	{ id = 3332, name = "hammer of wrath" },
	{ id = 7407, name = "haunted blade" },
	{ id = 3340, name = "heavy mace" },
	{ id = 12683, name = "heavy trident" },
	{ id = 17852, name = "helmet of the lost" },
	{ id = 14246, name = "hive bow" },
	{ id = 14089, name = "hive scythe" },
	{ id = 49522, name = "inferniarch arbalest" },
	{ id = 49523, name = "inferniarch battleaxe" },
	{ id = 49527, name = "inferniarch blade" },
	{ id = 49520, name = "inferniarch bow" },
	{ id = 49525, name = "inferniarch flail" },
	{ id = 49524, name = "inferniarch greataxe" },
	{ id = 49529, name = "inferniarch rod" },
	{ id = 49530, name = "inferniarch slayer" },
	{ id = 49526, name = "inferniarch warhammer" },
	{ id = 7422, name = "jade hammer" },
	{ id = 10451, name = "jade hat" },
	{ id = 35518, name = "jungle bow" },
	{ id = 35514, name = "jungle flail" },
	{ id = 35521, name = "jungle rod" },
	{ id = 35522, name = "jungle wand" },
	{ id = 3370, name = "knight armor" },
	{ id = 7461, name = "krimhorn helmet" },
	{ id = 3374, name = "legion helmet" },
	{ id = 3404, name = "leopard armor" },
	{ id = 820, name = "lightning boots" },
	{ id = 828, name = "lightning headband" },
	{ id = 822, name = "lightning legs" },
	{ id = 825, name = "lightning robe" },
	{ id = 34158, name = "lion amulet" },
	{ id = 34253, name = "lion axe" },
	{ id = 34254, name = "lion hammer" },
	{ id = 34150, name = "lion longbow" },
	{ id = 34155, name = "lion longsword" },
	{ id = 34157, name = "lion plate" },
	{ id = 34151, name = "lion rod" },
	{ id = 34154, name = "lion shield" },
	{ id = 34156, name = "lion spangenhelm" },
	{ id = 34153, name = "lion spellbook" },
	{ id = 34152, name = "lion wand" },
	{ id = 29418, name = "living armor" },
	{ id = 29417, name = "living vine bow" },
	{ id = 818, name = "magma boots" },
	{ id = 826, name = "magma coat" },
	{ id = 35519, name = "makeshift boots" },
	{ id = 3436, name = "medusa shield" },
	{ id = 7386, name = "mercenary sword" },
	{ id = 21169, name = "metal spats" },
	{ id = 31580, name = "mortal mace" },
	{ id = 16117, name = "muck rod" },
	{ id = 40593, name = "mutant bone boots" },
	{ id = 40595, name = "mutant bone kilt" },
	{ id = 40591, name = "mutated skin armor" },
	{ id = 40590, name = "mutated skin legs" },
	{ id = 16164, name = "mycological bow" },
	{ id = 39156, name = "naga axe" },
	{ id = 39157, name = "naga club" },
	{ id = 39159, name = "naga crossbow" },
	{ id = 39160, name = "naga quiver" },
	{ id = 39163, name = "naga rod" },
	{ id = 39155, name = "naga sword" },
	{ id = 39162, name = "naga wand" },
	{ id = 3314, name = "naginata" },
	{ id = 7418, name = "nightmare blade" },
	{ id = 7456, name = "noble axe" },
	{ id = 22172, name = "ogre choppa" },
	{ id = 7421, name = "onyx flail" },
	{ id = 22195, name = "onyx pendant" },
	{ id = 21981, name = "oriental shoes" },
	{ id = 13993, name = "ornate chestplate" },
	{ id = 14247, name = "ornate crossbow" },
	{ id = 13999, name = "ornate legs" },
	{ id = 34098, name = "pair of soulstalkers" },
	{ id = 34097, name = "pair of soulwalkers" },
	{ id = 8063, name = "paladin armor" },
	{ id = 32616, name = "phantasmal axe" },
	{ id = 5461, name = "pirate boots" },
	{ id = 16110, name = "prismatic armor" },
	{ id = 16112, name = "prismatic boots" },
	{ id = 16109, name = "prismatic helmet" },
	{ id = 16116, name = "prismatic shield" },
	{ id = 7383, name = "relic sword" },
	{ id = 29419, name = "resizer" },
	{ id = 22866, name = "rift bow" },
	{ id = 22867, name = "rift crossbow" },
	{ id = 22727, name = "rift lance" },
	{ id = 22726, name = "rift shield" },
	{ id = 27458, name = "rod of destruction" },
	{ id = 3392, name = "royal helmet" },
	{ id = 21165, name = "rubber cap" },
	{ id = 6553, name = "ruthless axe" },
	{ id = 43874, name = "sanguine battleaxe" },
	{ id = 43864, name = "sanguine blade" },
	{ id = 43872, name = "sanguine bludgeon" },
	{ id = 43884, name = "sanguine boots" },
	{ id = 43877, name = "sanguine bow" },
	{ id = 43879, name = "sanguine crossbow" },
	{ id = 43866, name = "sanguine cudgel" },
	{ id = 43887, name = "sanguine galoshes" },
	{ id = 43881, name = "sanguine greaves" },
	{ id = 43868, name = "sanguine hatchet" },
	{ id = 43876, name = "sanguine legs" },
	{ id = 43870, name = "sanguine razor" },
	{ id = 43885, name = "sanguine rod" },
	{ id = 3377, name = "scale armor" },
	{ id = 7451, name = "shadow sceptre" },
	{ id = 29420, name = "shoulder plate" },
	{ id = 5741, name = "skull helmet" },
	{ id = 8061, name = "skullcracker armor" },
	{ id = 27450, name = "slayer of destruction" },
	{ id = 34099, name = "soulbastion" },
	{ id = 34084, name = "soulbiter" },
	{ id = 34088, name = "soulbleeder" },
	{ id = 34086, name = "soulcrusher" },
	{ id = 34082, name = "soulcutter" },
	{ id = 34085, name = "souleater" },
	{ id = 34091, name = "soulhexer" },
	{ id = 34087, name = "soulmaimer" },
	{ id = 34095, name = "soulmantle" },
	{ id = 34089, name = "soulpiercer" },
	{ id = 34092, name = "soulshanks" },
	{ id = 34094, name = "soulshell" },
	{ id = 34083, name = "soulshredder" },
	{ id = 34096, name = "soulshroud" },
	{ id = 34093, name = "soulstrider" },
	{ id = 34090, name = "soultainter" },
	{ id = 10438, name = "spellweaver's robe" },
	{ id = 39147, name = "spiritthorn armor" },
	{ id = 39148, name = "spiritthorn helmet" },
	{ id = 3554, name = "steel boots" },
	{ id = 3378, name = "studded armor" },
	{ id = 29421, name = "summerblade" },
	{ id = 8052, name = "swamplair armor" },
	{ id = 31614, name = "tagralt blade" },
	{ id = 813, name = "terra boots" },
	{ id = 31577, name = "terra helmet" },
	{ id = 812, name = "terra legs" },
	{ id = 811, name = "terra mantle" },
	{ id = 35515, name = "throwing axe" },
	{ id = 7413, name = "titan axe" },
	{ id = 31583, name = "toga mortis" },
	{ id = 10389, name = "traditional sai" },
	{ id = 39235, name = "turtle amulet" },
	{ id = 11657, name = "twiceslicer" },
	{ id = 20072, name = "umbral master axe" },
	{ id = 20084, name = "umbral master bow" },
	{ id = 20075, name = "umbral master chopper" },
	{ id = 20087, name = "umbral master crossbow" },
	{ id = 20081, name = "umbral master hammer" },
	{ id = 20078, name = "umbral master mace" },
	{ id = 20069, name = "umbral master slayer" },
	{ id = 20066, name = "umbral masterblade" },
	{ id = 3434, name = "vampire shield" },
	{ id = 7388, name = "vile axe" },
	{ id = 16096, name = "wand of defiance" },
	{ id = 27457, name = "wand of destruction" },
	{ id = 16115, name = "wand of everblazing" },
	{ id = 3342, name = "war axe" },
	{ id = 3369, name = "warrior helmet" },
	{ id = 14040, name = "warrior's axe" },
	{ id = 31617, name = "winged boots" },
	{ id = 29422, name = "winterblade" },
	{ id = 10384, name = "zaoan armor" },
	{ id = 10385, name = "zaoan helmet" },
	{ id = 10387, name = "zaoan legs" },
	{ id = 10386, name = "zaoan shoes" },
	{ id = 10390, name = "zaoan sword" },

	-- Additional helmets
	{ id = 3365, name = "golden helmet" },
	{ id = 3390, name = "horned helmet" },
	{ id = 3368, name = "winged helmet" },
	{ id = 3387, name = "demon helmet" },
	{ id = 3395, name = "ceremonial mask" },
	{ id = 3400, name = "dragon scale helmet" },
	{ id = 11689, name = "elite draken helmet" },
	{ id = 22062, name = "werewolf helmet" },
	{ id = 3391, name = "crusader helmet" },
	{ id = 44636, name = "stoic iks casque" },
	{ id = 44637, name = "stoic iks headpiece" },
	{ id = 3393, name = "amazon helmet" },
	{ id = 29427, name = "dark whispers" },
	{ id = 31582, name = "galea mortis" },

	-- Additional armors
	{ id = 3366, name = "magic plate armor" },
	{ id = 3388, name = "demon armor" },
	{ id = 8862, name = "yalahari armor" },
	{ id = 11686, name = "royal draken mail" },
	{ id = 27648, name = "gnome armor" },
	{ id = 39165, name = "midnight tunic" },
	{ id = 22518, name = "fireheart cuirass" },
	{ id = 22519, name = "fireheart hauberk" },
	{ id = 22520, name = "fireheart platemail" },
	{ id = 22521, name = "earthheart cuirass" },
	{ id = 22522, name = "earthheart hauberk" },
	{ id = 22523, name = "earthheart platemail" },
	{ id = 22524, name = "thunderheart cuirass" },
	{ id = 22525, name = "thunderheart hauberk" },
	{ id = 22526, name = "thunderheart platemail" },
	{ id = 22527, name = "frostheart cuirass" },
	{ id = 22528, name = "frostheart hauberk" },
	{ id = 22529, name = "frostheart platemail" },
	{ id = 22530, name = "firesoul tabard" },
	{ id = 22531, name = "earthsoul tabard" },
	{ id = 22532, name = "thundersoul tabard" },
	{ id = 22533, name = "frostsoul tabard" },

	-- Additional legs
	{ id = 3363, name = "dragon scale legs" },
	{ id = 3389, name = "demon legs" },
	{ id = 3371, name = "knight legs" },
	{ id = 821, name = "magma legs" },
	{ id = 8863, name = "yalahari leg piece" },
	{ id = 16111, name = "prismatic legs" },
	{ id = 3398, name = "dwarven legs" },
	{ id = 3557, name = "plate legs" },
	{ id = 32618, name = "soulful legs" },
	{ id = 39167, name = "midnight sarong" },
	{ id = 44642, name = "stoic iks culet" },
	{ id = 44643, name = "stoic iks faulds" },
	{ id = 645, name = "blue legs" },
	{ id = 19366, name = "icy culottes" },

	-- Additional shields
	{ id = 3423, name = "blessed shield" },
	{ id = 3422, name = "great shield" },
	{ id = 3414, name = "mastermind shield" },
	{ id = 6390, name = "nightmare shield" },
	{ id = 6432, name = "necromancer shield" },
	{ id = 3442, name = "tempest shield" },
	{ id = 14000, name = "ornate shield" },
	{ id = 3439, name = "phoenix shield" },
	{ id = 3428, name = "tower shield" },
	{ id = 3437, name = "amazon shield" },
	{ id = 3438, name = "eagle shield" },
	{ id = 3416, name = "dragon shield" },
	{ id = 19363, name = "runic ice shield" },
	{ id = 21175, name = "mino shield" },
	{ id = 3415, name = "guardian shield" },
	{ id = 3433, name = "griffin shield" },
	{ id = 3418, name = "bonelord shield" },
	{ id = 8079, name = "icy rainbow shield" },
	{ id = 8078, name = "fiery rainbow shield" },
	{ id = 8080, name = "sparking rainbow shield" },
	{ id = 8081, name = "terran rainbow shield" },
	{ id = 29430, name = "ectoplasmic shield" },
	{ id = 22758, name = "death gaze" },
	{ id = 19373, name = "haunted mirror piece" },

	-- Additional boots
	{ id = 3555, name = "golden boots" },
	{ id = 10200, name = "crystal boots" },
	{ id = 10201, name = "dragon scale boots" },
	{ id = 35520, name = "make-do boots" },
	{ id = 44648, name = "stoic iks boots" },
	{ id = 44649, name = "stoic iks sandals" },

	-- Common/Trash items (50 items for the "Russian roulette" effect)
	{ id = 3600, name = "bread" },
	{ id = 3582, name = "ham" },
	{ id = 3585, name = "dragon ham" },
	{ id = 3577, name = "meat" },
	{ id = 3578, name = "fish" },
	{ id = 3587, name = "banana" },
	{ id = 3595, name = "carrot" },
	{ id = 3607, name = "cheese" },
	{ id = 6278, name = "cake" },
	{ id = 3003, name = "rope" },
	{ id = 3457, name = "shovel" },
	{ id = 3456, name = "pick" },
	{ id = 2920, name = "torch" },
	{ id = 3267, name = "dagger" },
	{ id = 3274, name = "axe" },
	{ id = 3277, name = "spear" },
	{ id = 3294, name = "short sword" },
	{ id = 3298, name = "throwing knife" },
	{ id = 3265, name = "two handed sword" },
	{ id = 3378, name = "studded armor" },
	{ id = 3359, name = "brass armor" },
	{ id = 3358, name = "chain armor" },
	{ id = 3372, name = "brass legs" },
	{ id = 3374, name = "legion helmet" },
	{ id = 3396, name = "dwarven helmet" },
	{ id = 3412, name = "wooden shield" },
	{ id = 3410, name = "plate shield" },
	{ id = 3552, name = "leather boots" },
	{ id = 5921, name = "heaven blossom" },
}

-- Get random reward (all items have equal probability)
local function getRandomReward()
	local randomIndex = math.random(1, #mysteryBagRewards)
	return mysteryBagRewards[randomIndex]
end

local mysteryBag = Action()

function mysteryBag.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	-- Get random reward (completely random, no rarity system)
	local reward = getRandomReward()
	local itemCount = reward.count or 1

	-- Add item to store inbox (movable = true)
	local rewardItem = player:addItemStoreInbox(reward.id, itemCount, true)
	if not rewardItem then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Failed to add reward to your Store Inbox.")
		return false
	end

	-- Transform player into the item for 5 seconds (like chameleon rune)
	-- Save original outfit only if not already transformed
	local originalOutfit
	local previousEvent = player:getStorageValue(MYSTERY_BAG_STORAGE)

	if previousEvent > 0 then
		-- Already transformed, cancel previous event but keep original outfit
		stopEvent(previousEvent)
		-- Get the saved original outfit from storage
		local savedLookType = player:getStorageValue(MYSTERY_BAG_STORAGE + 1)
		local savedLookHead = player:getStorageValue(MYSTERY_BAG_STORAGE + 2)
		local savedLookBody = player:getStorageValue(MYSTERY_BAG_STORAGE + 3)
		local savedLookLegs = player:getStorageValue(MYSTERY_BAG_STORAGE + 4)
		local savedLookFeet = player:getStorageValue(MYSTERY_BAG_STORAGE + 5)
		local savedLookAddons = player:getStorageValue(MYSTERY_BAG_STORAGE + 6)

		originalOutfit = {
			lookType = savedLookType > 0 and savedLookType or 128,
			lookHead = savedLookHead > 0 and savedLookHead or 0,
			lookBody = savedLookBody > 0 and savedLookBody or 0,
			lookLegs = savedLookLegs > 0 and savedLookLegs or 0,
			lookFeet = savedLookFeet > 0 and savedLookFeet or 0,
			lookAddons = savedLookAddons > 0 and savedLookAddons or 0
		}
	else
		-- Not transformed yet, save current outfit
		originalOutfit = player:getOutfit()
		player:setStorageValue(MYSTERY_BAG_STORAGE + 1, originalOutfit.lookType or 128)
		player:setStorageValue(MYSTERY_BAG_STORAGE + 2, originalOutfit.lookHead or 0)
		player:setStorageValue(MYSTERY_BAG_STORAGE + 3, originalOutfit.lookBody or 0)
		player:setStorageValue(MYSTERY_BAG_STORAGE + 4, originalOutfit.lookLegs or 0)
		player:setStorageValue(MYSTERY_BAG_STORAGE + 5, originalOutfit.lookFeet or 0)
		player:setStorageValue(MYSTERY_BAG_STORAGE + 6, originalOutfit.lookAddons or 0)
	end

	-- Apply transformation
	local itemOutfit = {
		lookTypeEx = reward.id,
	}
	player:setOutfit(itemOutfit)

	-- Send messages
	local itemText = itemCount > 1 and itemCount .. "x " .. reward.name or reward.name
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You received " .. itemText .. "!")
	player:getPosition():sendMagicEffect(CONST_ME_GIFT_WRAPS)

	-- Broadcast message
	local text = player:getName() .. " received " .. itemText .. " from a Mystery Bag!"
	Webhook.sendMessage(":game_die: " .. player:getMarkdownLink() .. " received **" .. itemText .. "** from a _Mystery Bag_!")
	Broadcast(text, function(targetPlayer)
		return targetPlayer ~= player
	end)

	-- Restore original outfit after 5 seconds
	local eventId = addEvent(function(playerId, outfit)
		local p = Player(playerId)
		if p then
			p:setOutfit(outfit)
			p:getPosition():sendMagicEffect(CONST_ME_POFF)
			-- Clear all storages
			p:setStorageValue(MYSTERY_BAG_STORAGE, -1)
			p:setStorageValue(MYSTERY_BAG_STORAGE + 1, -1)
			p:setStorageValue(MYSTERY_BAG_STORAGE + 2, -1)
			p:setStorageValue(MYSTERY_BAG_STORAGE + 3, -1)
			p:setStorageValue(MYSTERY_BAG_STORAGE + 4, -1)
			p:setStorageValue(MYSTERY_BAG_STORAGE + 5, -1)
			p:setStorageValue(MYSTERY_BAG_STORAGE + 6, -1)
		end
	end, 5000, player:getId(), originalOutfit)

	-- Store event ID to cancel if player opens another bag
	player:setStorageValue(MYSTERY_BAG_STORAGE, eventId)

	-- Remove mystery bag
	item:remove(1)
	return true
end

mysteryBag:id(MYSTERY_BAG_ID)
mysteryBag:register()
