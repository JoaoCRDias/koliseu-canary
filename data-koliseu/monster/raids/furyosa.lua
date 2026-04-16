local mType = Game.createMonsterType("Furyosa")
local monster = {}

monster.description = "Furyosa"
monster.experience = 35000000
monster.outfit = {
	lookType = 149,
	lookHead = 94,
	lookBody = 79,
	lookLegs = 77,
	lookFeet = 3,
	lookAddons = 3,
	lookMount = 0,
}

monster.health = 5000000
monster.maxHealth = 5000000
monster.race = "blood"
monster.corpse = 18118
monster.speed = 200
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 10,
}

monster.bosstiary = {
	bossRaceId = 987,
	bossRace = RARITY_NEMESIS,
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
	canPushCreatures = true,
	staticAttackChance = 70,
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

monster.summon = {
	maxSummons = 4,
	summons = {
		{ name = "Fury", chance = 10, interval = 2000, count = 4 },
	},
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "MUHAHA!", yell = false },
	{ text = "Back in black!", yell = false },
	{ text = "Die!", yell = false },
	{ text = "Dieeee!", yell = false },
	{ text = "Caaarnaaage!", yell = false },
	{ text = "Ahhhhrrrr!", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 100000, maxCount = 200 }, -- gold coin
	{ id = 8016, chance = 100000, maxCount = 5 }, -- jalapeno pepper
	{ id = 19083, chance = 45000 }, -- silver raid token
	{ id = 3035, chance = 85000, maxCount = 25 }, -- platinum coin
	{ id = 6558, chance = 35000, maxCount = 3 }, -- flask of demonic blood
	{ id = 6499, chance = 22500 }, -- demonic essence
	{ id = 5911, chance = 4000 }, -- red piece of cloth
	{ id = 5944, chance = 21500 }, -- soul orb
	{ id = 5944, chance = 50 }, -- soul orb
	{ id = 3007, chance = 410 }, -- crystal ring
	{ id = 6300, chance = 60 }, -- death ring
	{ id = 3439, chance = 100 }, -- phoenix shield
	{ id = 19391, chance = 100 }, -- furious frock
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
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_DEATHDAMAGE, minDamage = -3000, maxDamage = -6000, radius = 6, effect = CONST_ME_MORTAREA, target = false },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_MANADRAIN, minDamage = -1000, maxDamage = -4000, length = 8, spread = 0, effect = CONST_ME_BLOCKHIT, target = false },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_FIREDAMAGE, minDamage = -3000, maxDamage = -6000, length = 8, spread = 0, effect = CONST_ME_EXPLOSIONAREA, target = false },
	{ name = "combat", interval = 2000, chance = 5, type = COMBAT_DEATHDAMAGE, minDamage = -3000, maxDamage = -7000, length = 8, spread = 0, effect = CONST_ME_MORTAREA, target = false },
	{ name = "combat", interval = 3000, chance = 18, type = COMBAT_PHYSICALDAMAGE, minDamage = -2000, maxDamage = -5000, radius = 5, effect = CONST_ME_GROUNDSHAKER, target = true },
	{ name = "fury skill reducer", interval = 2000, chance = 5, target = false },
}

monster.defenses = {
	defense = 55,
	armor = 50,
	{ name = "invisible", interval = 2000, chance = 10, effect = CONST_ME_MAGIC_BLUE },
	{ name = "combat", interval = 7000, chance = 20, type = COMBAT_HEALING, minDamage = 1500, maxDamage = 3000, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 10 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 10 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 100 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 40 },
	{ type = COMBAT_HOLYDAMAGE, percent = 40 },
	{ type = COMBAT_DEATHDAMAGE, percent = 10 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
