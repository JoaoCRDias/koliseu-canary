local mType = Game.createMonsterType("Hirintror")
local monster = {}

monster.description = "Hirintror"
monster.experience = 30000000
monster.outfit = {
	lookType = 261,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.bosstiary = {
	bossRaceId = 967,
	bossRace = RARITY_NEMESIS,
}

monster.health = 5000000
monster.maxHealth = 5000000
monster.race = "undead"
monster.corpse = 7282
monster.speed = 200
monster.manaCost = 0

monster.changeTarget = {
	interval = 2000,
	chance = 5,
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
	rewardBoss = true,
	illusionable = false,
	canPushItems = true,
	canPushCreatures = false,
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
	{ text = "Srk.", yell = false },
	{ text = "Krss!", yell = false },
	{ text = "Chrrk! Krk!", yell = false },
	{ text = "snirr!", yell = false },
}

monster.loot = {
	{ id = 19363, chance = 200 }, -- runic ice shield
	{ id = 3031, chance = 70000, maxCount = 100 }, -- gold coin
	{ id = 19083, chance = 200 }, -- silver raid token
	{ id = 19362, chance = 200 }, -- icicle bow
	{ id = 3373, chance = 1200 }, -- strange helmet
	{ id = 3284, chance = 2200 }, -- ice rapier
	{ id = 7290, chance = 4200 }, -- shard
	{ id = 7441, chance = 2200 }, -- ice cube
	{ id = 819, chance = 3200 }, -- glacier shoes
	{ id = 829, chance = 1200 }, -- glacier mask
	{ id = 7449, chance = 900 }, -- crystal sword
	{ id = 5912, chance = 900 }, -- blue piece of cloth
	{ id = 237, chance = 20000, maxCount = 5 }, -- strong mana potion
	{ id = 236, chance = 2000, maxCount = 5 }, -- strong health potion
	{ id = 3028, chance = 2000, maxCount = 5 }, -- small diamond
	{ id = 3035, chance = 20000 }, -- platinum coin
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
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -7000 },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_ICEDAMAGE, minDamage = -3000, maxDamage = -7000, range = 7, radius = 3, shootEffect = CONST_ANI_ICE, effect = CONST_ME_BLOCKHIT, target = true },
	{ name = "combat", interval = 2000, chance = 18, type = COMBAT_ICEDAMAGE, minDamage = -4000, maxDamage = -8000, length = 8, spread = 3, effect = CONST_ME_ICEATTACK, target = false },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_DEATHDAMAGE, minDamage = -3000, maxDamage = -6000, radius = 5, effect = CONST_ME_MORTAREA, target = false },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_ENERGYDAMAGE, minDamage = -2000, maxDamage = -5000, radius = 4, effect = CONST_ME_ENERGYHIT, target = false },
}

monster.defenses = {
	defense = 55,
	armor = 50,
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_HEALING, minDamage = 1000, maxDamage = 2000, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -20 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 100 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 100 },
	{ type = COMBAT_HOLYDAMAGE, percent = 100 },
	{ type = COMBAT_DEATHDAMAGE, percent = 100 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
