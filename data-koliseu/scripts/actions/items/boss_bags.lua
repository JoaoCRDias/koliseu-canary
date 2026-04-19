-- Boss Bags Action Script
-- Each bag gives a random item from the respective boss's loot table

local BOSS_BAGS = {
	-- Monster Bag (The Monster)
	[60408] = {
		"alchemist's notepad",
		"antler-horn helmet",
		"mutant bone kilt",
		"mutated skin armor",
		"mutated skin legs",
		"stitched mutant hide legs",
		"alchemist's boots",
		"mutant bone boots",
	},

	-- Brainstealer Bag
	[60409] = {
		"eldritch breeches",
		"eldritch cowl",
		"eldritch hood",
		"eldritch bow",
		"eldritch quiver",
		"eldritch claymore",
		"eldritch greataxe",
		"eldritch warmace",
		"eldritch shield",
		"eldritch cuirass",
		"eldritch folio",
		"eldritch tome",
		"eldritch rod",
		"eldritch wand",
		"gilded eldritch claymore",
		"gilded eldritch greataxe",
		"gilded eldritch warmace",
		"gilded eldritch wand",
		"gilded eldritch rod",
		"gilded eldritch bow",
	},

	-- Falcon Bag (Oberon)
	[60410] = {
		"falcon battleaxe",
		"falcon longsword",
		"falcon mace",
		"falcon bow",
		28714,
		"falcon coif",
		"falcon rod",
		"falcon wand",
		"falcon shield",
		"falcon greaves",
		"falcon plate",
	},

	-- Lion Bag (Drume)
	[60411] = {
		"lion spangenhelm",
		"lion plate",
		"lion shield",
		"lion longsword",
		"lion hammer",
		"lion axe",
		"lion longbow",
		"lion spellbook",
		"lion wand",
		"lion amulet",
		"lion rod",
	},

	-- Ratmiral Bag
	[60412] = {
		35523,
		35515,
		35517,
		35516,
		35518,
		35524,
		35514,
		35521,
		35522,
		35519,
		35520,
	},

	-- Cobra Bag (Scarlet Etzel)
	[60413] = {
		"cobra club",
		"cobra axe",
		"cobra crossbow",
		"cobra hood",
		"cobra rod",
		"cobra sword",
		"cobra wand",
		"cobra amulet",
	},

	-- Timira Bag
	[60414] = {
		"dawnfire sherwani",
		"frostflower boots",
		"feverbloom boots",
		39233,
		"midnight tunic",
		"midnight sarong",
		"naga quiver",
		"naga sword",
		"naga axe",
		"naga club",
		"naga wand",
		"naga rod",
		"naga crossbow",
	}
}

local bossBags = Action()

function bossBags.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local bagConfig = BOSS_BAGS[item:getId()]
	if not bagConfig then
		return false
	end

	local rewardIndex = math.random(1, #bagConfig)
	local rewardItemId = bagConfig[rewardIndex]
	if rewardItemId then
		player:addItem(rewardItemId, 1)
		item:remove(1)
		return true
	end

	return false
end

-- Register all boss bags
for bagId, _ in pairs(BOSS_BAGS) do
	bossBags:id(bagId)
end

bossBags:register()
