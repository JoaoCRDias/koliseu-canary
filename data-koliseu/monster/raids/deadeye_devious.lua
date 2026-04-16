local mType = Game.createMonsterType("Deadeye Devious")
local monster = {}

monster.description = "Deadeye Devious"
monster.experience = 25000000
monster.outfit = {
	lookType = 151,
	lookHead = 115,
	lookBody = 76,
	lookLegs = 33,
	lookFeet = 117,
	lookAddons = 2,
	lookMount = 0,
}

monster.bosstiary = {
	bossRaceId = 0,
	bossRace = RARITY_ARCHFOE,
}

monster.health = 5000000
monster.maxHealth = 5000000
monster.race = "blood"
monster.corpse = 18097
monster.speed = 200
monster.manaCost = 0

monster.changeTarget = {
	interval = 60000,
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
	rewardBoss = true,
	illusionable = false,
	canPushItems = true,
	canPushCreatures = true,
	staticAttackChance = 50,
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
	{ text = "Let's kill 'em", yell = false },
	{ text = "Arrrgh!", yell = false },
	{ text = "You'll never take me alive!", yell = false },
	{ text = "§%§&§! #*$§$!!", yell = false },
	{ text = "You won't get me alive!", yell = false },
}

monster.loot = {
	{ id = 6102, chance = 100000 }, -- deadeye devious' eye patch
	{ id = 3031, chance = 100000, maxCount = 140 }, -- gold coin
	{ id = 3114, chance = 85000, maxCount = 2 }, -- skull
	{ id = 3357, chance = 78000 }, -- plate armor
	{ id = 3577, chance = 42000, maxCount = 3 }, -- meat
	{ id = 3370, chance = 28000 }, -- knight armor
	{ id = 3267, chance = 21000 }, -- dagger
	{ id = 3028, chance = 14000 }, -- small diamond
	{ id = 3275, chance = 7000 }, -- double axe
	{ id = 5926, chance = 7000 }, -- pirate backpack
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
	{ name = "combat", interval = 4000, chance = 60, type = COMBAT_PHYSICALDAMAGE, minDamage = -2000, maxDamage = -5000, shootEffect = CONST_ANI_THROWINGKNIFE, target = false },
}

monster.defenses = {
	defense = 50,
	armor = 45,
	{ name = "combat", interval = 4000, chance = 25, type = COMBAT_HEALING, minDamage = 1000, maxDamage = 2000, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
