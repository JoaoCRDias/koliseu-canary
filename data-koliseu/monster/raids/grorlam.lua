local mType = Game.createMonsterType("Grorlam")
local monster = {}

monster.description = "Grorlam"
monster.experience = 25000000
monster.outfit = {
	lookType = 205,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.bosstiary = {
	bossRaceId = 205,
	bossRace = RARITY_NEMESIS,
}

monster.health = 5000000
monster.maxHealth = 5000000
monster.race = "blood"
monster.corpse = 6005
monster.speed = 200
monster.manaCost = 0

monster.changeTarget = {
	interval = 5000,
	chance = 3,
}

monster.strategiesTarget = {
	nearest = 100,
}

monster.flags = {
	summonable = false,
	attackable = true,
	hostile = true,
	convinceable = false,
	pushable = false,
	rewardBoss = true,
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
	level = 0,
	color = 0,
}

monster.voices = {
	interval = 5000,
	chance = 10,
}

monster.loot = {
	{ id = 3031, chance = 100000, maxCount = 20 }, -- gold coin
	{ id = 3377, chance = 10000 }, -- scale armor
	{ id = 1781, chance = 20000, maxCount = 5 }, -- small stone
	{ id = 3283, chance = 2500 }, -- carlin sword
	{ id = 60648, chance = 10000, maxCount = 1 },
	{ id = 60427, chance = 5000, maxCount = 1 },
	{ id = 60428, chance = 5000, maxCount = 1 },
	{ id = 60429, chance = 5000, maxCount = 1 },
	{ id = 58051, chance = 5000, maxCount = 1 },
	{ id = 58052, chance = 5000, maxCount = 1 },
	{ id = 58053, chance = 5000, maxCount = 1 },
	{ id = 58054, chance = 5000, maxCount = 1 },

}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -6000 },
	{ name = "combat", interval = 1000, chance = 15, type = COMBAT_PHYSICALDAMAGE, minDamage = -2000, maxDamage = -5000, range = 7, shootEffect = CONST_ANI_LARGEROCK, target = false },
	{ name = "combat", interval = 2000, chance = 18, type = COMBAT_EARTHDAMAGE, minDamage = -2000, maxDamage = -5000, radius = 5, effect = CONST_ME_SMALLPLANTS, target = false },
}

monster.defenses = {
	defense = 50,
	armor = 45,
	{ name = "combat", interval = 1000, chance = 25, type = COMBAT_HEALING, minDamage = 1000, maxDamage = 2000, effect = CONST_ME_MAGIC_BLUE, target = false },
	{ name = "speed", interval = 1000, chance = 6, speedChange = 270, effect = CONST_ME_MAGIC_RED, target = false, duration = 6000 },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 30 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 20 },
	{ type = COMBAT_EARTHDAMAGE, percent = 100 },
	{ type = COMBAT_FIREDAMAGE, percent = -10 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = 20 },
	{ type = COMBAT_DEATHDAMAGE, percent = -1 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
