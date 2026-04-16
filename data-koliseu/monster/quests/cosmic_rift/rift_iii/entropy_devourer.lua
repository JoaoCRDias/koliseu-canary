local mType = Game.createMonsterType("Entropy Devourer")
local monster = {}

monster.description = "an entropy devourer"
monster.experience = 32000
monster.outfit = {
	lookType = 986, -- PLACEHOLDER: set lookType
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 2776
monster.Bestiary = {
	class = "Cosmic",
	race = BESTY_RACE_MAGICAL,
	toKill = 5000,
	FirstUnlock = 200,
	SecondUnlock = 2000,
	CharmsPoints = 100,
	Stars = 5,
	Occurrence = 0,
	Locations = "Cosmic Rift III.",
}

monster.events = {}

monster.health = 48400
monster.maxHealth = 48400
monster.race = "blood"
monster.corpse = 6068 -- PLACEHOLDER: set corpse id
monster.speed = 240
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 10,
}

monster.strategiesTarget = {
	nearest = 70,
	health = 10,
	damage = 10,
	random = 10,
}

monster.flags = {
	summonable = false,
	attackable = true,
	hostile = true,
	convinceable = false,
	pushable = false,
	rewardBoss = false,
	illusionable = false,
	canPushItems = true,
	canPushCreatures = true,
	staticAttackChance = 90,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
	canWalkOnFire = true,
	canWalkOnPoison = true,
}

monster.light = {
	level = 4,
	color = 215,
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "All matter returns to nothing!", yell = false },
	{ text = "Entropy claims everything!", yell = false },
}

monster.loot = {
	{ name = "crystal coin", chance = 45000 },
	{ name = "ultimate health potion", chance = 25000, maxCount = 5 },
	{ name = "ultimate mana potion", chance = 22000, maxCount = 5 },
	{ name = "gold ingot", chance = 15000 },
	{ id = 282, chance = 10000 }, -- giant shimmering pearl
	{ name = "blue crystal shard", chance = 8500 },
	{ name = "onyx chip", chance = 8000, maxCount = 3 },
	{ name = "violet gem", chance = 7000 },
	{ id = 3039, chance = 6500 }, -- red gem
	{ name = "cyan crystal fragment", chance = 6000 },
	{ name = "red crystal fragment", chance = 5500 },
	{ name = "rotten roots", chance = 4000 },
	{ name = "skullcracker armor", chance = 2500 },
	{ name = "boots of haste", chance = 2000 },
	{ name = "royal helmet", chance = 1500 },
	{ name = "alloy legs", chance = 800 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -3320 },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_DEATHDAMAGE, minDamage = -2710, maxDamage = -3505, length = 8, spread = 3, effect = CONST_ME_MORTAREA, target = false },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_PHYSICALDAMAGE, minDamage = -2480, maxDamage = -3270, radius = 5, effect = CONST_ME_GROUNDSHAKER, target = true },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_LIFEDRAIN, minDamage = -2320, maxDamage = -3100, radius = 5, effect = CONST_ME_MAGIC_RED, target = true },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_EARTHDAMAGE, minDamage = -2170, maxDamage = -2790, length = 8, spread = 3, effect = CONST_ME_GREEN_RINGS, target = false },
	{ name = "largepoisonring", interval = 2000, chance = 10, minDamage = -2170, maxDamage = -2790, target = false },
}

monster.defenses = {
	defense = 150,
	armor = 150,
	mitigation = 3.30,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 15 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -15 },
	{ type = COMBAT_EARTHDAMAGE, percent = 30 },
	{ type = COMBAT_FIREDAMAGE, percent = -10 },
	{ type = COMBAT_LIFEDRAIN, percent = 100 },
	{ type = COMBAT_MANADRAIN, percent = 100 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -20 },
	{ type = COMBAT_HOLYDAMAGE, percent = -5 },
	{ type = COMBAT_DEATHDAMAGE, percent = 45 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = true },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
