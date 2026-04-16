local mType = Game.createMonsterType("Mawhawk")
local monster = {}

monster.description = "Mawhawk"
monster.experience = 35000000
monster.outfit = {
	lookType = 595,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.bosstiary = {
	bossRaceId = 1028,
	bossRace = RARITY_ARCHFOE,
}

monster.health = 5000000
monster.maxHealth = 5000000
monster.race = "blood"
monster.corpse = 20295
monster.speed = 135
monster.manaCost = 0

monster.changeTarget = {
	interval = 5000,
	chance = 8,
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
	canPushItems = false,
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
	{ text = "Better flee now!", yell = false },
	{ text = "Watch my maws!", yell = false },
}

monster.loot = {
	{ id = 20062, chance = 30000, maxCount = 2 }, -- cluster of solace
	{ id = 20198, chance = 30000 }, -- frazzle tongue
	{ id = 20264, chance = 30000, maxCount = 2, unique = true }, -- unrealized dream
	{ id = 3031, chance = 10000, maxCount = 100 }, -- gold coin
	{ id = 3035, chance = 10000, maxCount = 25 }, -- platinum coin
	{ id = 3280, chance = 10000 }, -- fire sword
	{ id = 5880, chance = 10000 }, -- iron ore
	{ id = 5895, chance = 10000 }, -- fish fin
	{ id = 5911, chance = 10000 }, -- red piece of cloth
	{ id = 5925, chance = 10000 }, -- hardened bone
	{ id = 7404, chance = 10000 }, -- assassin dagger
	{ id = 7407, chance = 10000 }, -- haunted blade
	{ id = 7418, chance = 10000 }, -- nightmare blade
	{ id = 16120, chance = 10000, maxCount = 3 }, -- violet crystal shard
	{ id = 16121, chance = 10000, maxCount = 3 }, -- green crystal shard
	{ id = 16122, chance = 10000, maxCount = 5 }, -- green crystal splinter
	{ id = 16124, chance = 10000, maxCount = 5 }, -- blue crystal splinter
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
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_EARTHDAMAGE, minDamage = -4000, maxDamage = -8000, length = 7, spread = 0, effect = CONST_ME_STONES, target = false },
	{ name = "combat", interval = 2000, chance = 18, type = COMBAT_EARTHDAMAGE, minDamage = -3000, maxDamage = -7000, radius = 6, effect = CONST_ME_BIGPLANTS, target = false },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_PHYSICALDAMAGE, minDamage = -4000, maxDamage = -9000, radius = 5, effect = CONST_ME_HITAREA, target = false },
	{ name = "combat", interval = 2000, chance = 12, type = COMBAT_LIFEDRAIN, minDamage = -3000, maxDamage = -6000, range = 7, shootEffect = CONST_ANI_EARTH, effect = CONST_ME_CARNIPHILA, target = true },
}

monster.defenses = {
	defense = 60,
	armor = 55,
	--	mitigation = ???,
	{ name = "combat", interval = 3000, chance = 25, type = COMBAT_HEALING, minDamage = 1500, maxDamage = 3000, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 20 },
	{ type = COMBAT_FIREDAMAGE, percent = 20 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 15 },
	{ type = COMBAT_HOLYDAMAGE, percent = -5 },
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
