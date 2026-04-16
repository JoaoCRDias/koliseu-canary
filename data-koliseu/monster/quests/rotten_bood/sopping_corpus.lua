local mType = Game.createMonsterType("Sopping Corpus")
local monster = {}

monster.description = "a sopping corpus"
monster.experience = 26958
monster.outfit = {
	lookType = 1659,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 2397
monster.Bestiary = {
	class = "Undead",
	race = BESTY_RACE_UNDEAD,
	toKill = 5000,
	FirstUnlock = 200,
	SecondUnlock = 2000,
	CharmsPoints = 100,
	Stars = 5,
	Occurrence = 0,
	Locations = "Jaded Roots.",
}

monster.health = 43420
monster.maxHealth = 43420
monster.race = "undead"
monster.corpse = 43836
monster.speed = 210
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 0,
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
	canPushCreatures = false,
	staticAttackChance = 90,
	targetDistance = 0,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
	canWalkOnFire = true,
	canWalkOnPoison = true,
}

monster.light = {
	level = 0,
	color = 0,
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "*Lessshhh!*", yell = false },
}

monster.loot = {
	{ name = "crystal coin", chance = 43717 },
	{ name = "ultimate mana potion", chance = 43717, minCount = 2, maxCount = 3 },
	{ id = 7385, chance = 14575 }, -- crimson sword
	{ name = "ultimate health potion", chance = 14575, maxCount = 2 },
	{ name = "organic acid", chance = 7831, maxCount = 1 },
	{ name = "rotten roots", chance = 13396, maxCount = 1 },
	{ name = "emerald bangle", chance = 8729, maxCount = 1 },
	{ name = "underworld rod", chance = 8547, maxCount = 1 },
	{ name = "violet gem", chance = 5185, maxCount = 1 },
	{ name = "blue gem", chance = 10004, maxCount = 1 },
	{ name = "relic sword", chance = 7103, maxCount = 1 },
	{ name = "skullcracker armor", chance = 7415, maxCount = 1 },
	{ id = 23531, chance = 3134, maxCount = 1 }, -- ring of green plasma
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -2400 },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_PHYSICALDAMAGE, minDamage = -1950, maxDamage = -2400, length = 8, spread = 3, effect = CONST_ME_GROUNDSHAKER, target = false },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_PHYSICALDAMAGE, minDamage = -1800, maxDamage = -2250, effect = CONST_ME_BIG_SCRATCH, target = true },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_PHYSICALDAMAGE, minDamage = -2100, maxDamage = -2400, radius = 5, effect = CONST_ME_GROUNDSHAKER, target = true },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_EARTHDAMAGE, minDamage = -1800, maxDamage = -2250, length = 8, spread = 3, effect = CONST_ME_GREEN_RINGS, target = false },
	{ name = "largepoisonring", interval = 2000, chance = 10, minDamage = -1500, maxDamage = -1800, target = false },
}

monster.defenses = {
	defense = 112,
	armor = 112,
	mitigation = 3.25,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 40 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -20 },
	{ type = COMBAT_EARTHDAMAGE, percent = 50 },
	{ type = COMBAT_FIREDAMAGE, percent = 30 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -10 },
	{ type = COMBAT_HOLYDAMAGE, percent = 5 },
	{ type = COMBAT_DEATHDAMAGE, percent = 10 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = true },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
