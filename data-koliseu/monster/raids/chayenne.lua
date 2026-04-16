local mType = Game.createMonsterType("Chayenne")
local monster = {}

monster.description = "Chayenne"
monster.experience = 40000000
monster.outfit = {
	lookType = 155,
	lookHead = 78,
	lookBody = 0,
	lookLegs = 105,
	lookFeet = 99,
	lookAddons = 0,
	lookMount = 0,
}

monster.health = 8000000
monster.maxHealth = 8000000
monster.race = "blood"
monster.corpse = 6081
monster.speed = 150
monster.manaCost = 0

monster.changeTarget = {
	interval = 2000,
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
	{ id = 6571, chance = 100000, maxCount = 2 }, -- surprise bag
	{ id = 281, chance = 100000 }, -- giant shimmering pearl (green)
	{ id = 14681, chance = 100000 }, -- anniversary cake
	{ id = 14682, chance = 100000, unique = true }, -- chayenne's magical key
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
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -8000 },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_MANADRAIN, minDamage = -3000, maxDamage = -7000, radius = 5, effect = CONST_ME_MAGIC_RED, target = false },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_LIFEDRAIN, minDamage = -4000, maxDamage = -8000, range = 7, effect = CONST_ME_MAGIC_RED, target = true },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_DEATHDAMAGE, minDamage = -5000, maxDamage = -9000, length = 8, spread = 3, effect = CONST_ME_MORTAREA, target = false },
	{ name = "combat", interval = 2000, chance = 18, type = COMBAT_ENERGYDAMAGE, minDamage = -4000, maxDamage = -7000, radius = 6, effect = CONST_ME_ENERGYHIT, target = false },
}

monster.defenses = {
	defense = 55,
	armor = 50,
	--	mitigation = ???,
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_HEALING, minDamage = 1500, maxDamage = 3000, effect = CONST_ME_MAGIC_BLUE, target = false },
	{ name = "combat", interval = 3500, chance = 30, type = COMBAT_HEALING, minDamage = 1000, maxDamage = 2000, effect = CONST_ME_MAGIC_BLUE, target = false },
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
