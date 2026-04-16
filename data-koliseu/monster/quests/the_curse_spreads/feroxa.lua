local mType = Game.createMonsterType("Feroxa")
local monster = {}

monster.description = "Feroxa"
monster.experience = 45000000
monster.outfit = {
	lookType = 158,
	lookHead = 57,
	lookBody = 76,
	lookLegs = 77,
	lookFeet = 57,
	lookAddons = 0,
	lookMount = 0,
}

monster.health = 5000000
monster.maxHealth = 5000000
monster.race = "blood"
monster.corpse = 0
monster.speed = 175
monster.manaCost = 0

monster.changeTarget = {
	interval = 2000,
	chance = 2,
}

monster.bosstiary = {
	bossRaceId = 1149,
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
	rewardBoss = false,
	illusionable = false,
	canPushItems = true,
	canPushCreatures = true,
	staticAttackChance = 90,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
	canWalkOnFire = false,
	canWalkOnPoison = false,
}

monster.events = {}

monster.light = {
	level = 0,
	color = 0,
}

monster.voices = {
	interval = 5000,
	chance = 10,
}

monster.loot = {
	{ id = 16119, chance = 10000, maxCount = 5 }, -- blue crystal shard
	{ id = 16120, chance = 10000, maxCount = 5 }, -- violet crystal shard
	{ id = 16124, chance = 10000, maxCount = 5 }, -- blue crystal splinter
	{ id = 3041, chance = 2500 }, -- blue gem
	{ id = 3039, chance = 2500 }, -- red gem
	{ id = 3079, chance = 1500 }, -- boots of haste
	{ id = 3035, chance = 100000, maxCount = 50 }, -- platinum coin
	{ id = 7643, chance = 10000, maxCount = 5 }, -- ultimate health potion
	{ id = 238, chance = 10000, maxCount = 5 }, -- great mana potion
	{ id = 239, chance = 10000, maxCount = 5 }, -- great health potion
	{ id = 22062, chance = 10000, unique = true }, -- werewolf helmet
	{ id = 22060, chance = 1500 }, -- werewolf amulet
	{ id = 22084, chance = 1500 }, -- wolf backpack
	{ id = 7436, chance = 1500 }, -- angelic axe
	{ id = 7419, chance = 1500 }, -- dreaded cleaver
	{ id = 22085, chance = 1500 }, -- fur armor
	{ id = 22086, chance = 1500 }, -- badger boots
	{ id = 22104, chance = 12000 }, -- trophy of feroxa
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
	{ name = "melee", interval = 2000, chance = 100, minDamage = -4000, maxDamage = -8000 },
	{ name = "combat", interval = 2000, chance = 22, type = COMBAT_DEATHDAMAGE, minDamage = -4000, maxDamage = -8000, radius = 6, effect = CONST_ME_MORTAREA, target = false },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_MANADRAIN, minDamage = -3000, maxDamage = -7000, radius = 5, effect = CONST_ME_ICETORNADO, target = true },
	{ name = "combat", interval = 2000, chance = 18, type = COMBAT_EARTHDAMAGE, minDamage = -3000, maxDamage = -7000, range = 6, shootEffect = CONST_ANI_ARROW, effect = CONST_ME_EXPLOSIONAREA, target = true },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_ICEDAMAGE, minDamage = -4000, maxDamage = -9000, length = 8, spread = 3, effect = CONST_ME_ICEATTACK, target = false },
}

monster.defenses = {
	defense = 65,
	armor = 60,
	{ name = "speed", interval = 2000, chance = 15, speedChange = 700, effect = CONST_ME_THUNDER, target = false, duration = 10000 },
	{ name = "combat", interval = 3000, chance = 25, type = COMBAT_HEALING, minDamage = 2000, maxDamage = 3500, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 30 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 30 },
	{ type = COMBAT_EARTHDAMAGE, percent = 30 },
	{ type = COMBAT_FIREDAMAGE, percent = 30 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 30 },
	{ type = COMBAT_HOLYDAMAGE, percent = 30 },
	{ type = COMBAT_DEATHDAMAGE, percent = 30 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
