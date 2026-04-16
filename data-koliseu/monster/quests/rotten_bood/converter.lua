local mType = Game.createMonsterType("Converter")
local monster = {}

monster.description = "a converter"
monster.experience = 25710
monster.outfit = {
	lookType = 1623,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 2379
monster.Bestiary = {
	class = "Elemental",
	race = BESTY_RACE_ELEMENTAL,
	toKill = 5000,
	FirstUnlock = 200,
	SecondUnlock = 2000,
	CharmsPoints = 100,
	Stars = 5,
	Occurrence = 0,
	Locations = "Gloom Pillars.",
}

monster.health = 38480
monster.maxHealth = 38480
monster.race = "undead"
monster.corpse = 43567
monster.speed = 250
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
	illusionable = true,
	canPushItems = true,
	canPushCreatures = false,
	staticAttackChance = 80,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
	canWalkOnFire = false,
	canWalkOnPoison = true,
}

monster.light = {
	level = 0,
	color = 0,
}

monster.loot = {
	{ name = "crystal coin", chance = 5334, maxCount = 1 },
	{ name = "darklight obsidian axe", chance = 7102, maxCount = 1 },
	{ name = "darklight matter", chance = 7065, maxCount = 1 },
	{ name = "darklight core", chance = 10929, maxCount = 1 },
	{ name = "wand of starstorm", chance = 8972, maxCount = 1 },
	{ name = "blue gem", chance = 9559, maxCount = 1 },
	{ name = "ultimate health potion", chance = 10047, maxCount = 5 },
	{ name = "focus cape", chance = 7083, maxCount = 1 },
	{ name = "white gem", chance = 14824, maxCount = 1 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -1350 },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_ENERGYDAMAGE, minDamage = -2100, maxDamage = -2850, length = 7, spread = 0, effect = CONST_ME_PINK_ENERGY_SPARK, target = false },
	{ name = "combat", interval = 2500, chance = 20, type = COMBAT_HOLYDAMAGE, minDamage = -2250, maxDamage = -2400, radius = 5, effect = CONST_ME_GHOSTLY_BITE, target = true },
	{ name = "largeholyring", interval = 2000, chance = 15, minDamage = -2100, maxDamage = -2850 },
	{ name = "energy chain", interval = 3200, chance = 20, minDamage = -1200, maxDamage = -1800 },
}

monster.defenses = {
	defense = 100,
	armor = 100,
	mitigation = 3.31,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = -20 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -10 },
	{ type = COMBAT_EARTHDAMAGE, percent = 10 },
	{ type = COMBAT_FIREDAMAGE, percent = 25 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = 35 },
	{ type = COMBAT_DEATHDAMAGE, percent = -15 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
