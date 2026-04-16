local mType = Game.createMonsterType("Venomrot Wraith")
local monster = {}

monster.description = "a venomrot wraith"
monster.experience = 61000
monster.outfit = {
	lookType = 676,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 2729
monster.Bestiary = {
	class = "Undead",
	race = BESTY_RACE_UNDEAD,
	toKill = 5000,
	FirstUnlock = 500,
	SecondUnlock = 1000,
	CharmsPoints = 100,
	Stars = 5,
	Occurrence = 0,
	Locations = "Venomrot Crypts.",
}

monster.health = 92470
monster.maxHealth = 92470
monster.race = "undead"
monster.corpse = 6068
monster.speed = 750
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 20,
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

monster.summon = {}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "BREATHE THE PLAGUE!", yell = true },
	{ text = "POISON CONSUMES ALL!", yell = true },
}

monster.loot = {
	{ name = "crystal coin", chance = 46000, maxCount = 3 },
	{ name = "gold ingot", chance = 17000, maxCount = 1 },
	{ name = "violet gem", chance = 9000 },
	{ name = "blue gem", chance = 9000 },
	{ name = "green gem", chance = 9000 },
	{ name = "yellow gem", chance = 9000 },
	{ name = "giant sapphire", chance = 5000 },
	{ name = "giant emerald", chance = 3000 },
	{ name = "giant ruby", chance = 3000 },
	{ name = "giant amethyst", chance = 3000 },
	{ name = "boots of haste", chance = 14000 },
	{ name = "demonic essence", chance = 28000, maxCount = 1 },
	{ name = "soul orb", chance = 55000, maxCount = 2 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -6345 },
	{ name = "combat", interval = 2000, chance = 17, type = COMBAT_DEATHDAMAGE, minDamage = -5157, maxDamage = -6698, range = 7, shootEffect = CONST_ANI_DEATH, effect = CONST_ME_MORTAREA, target = false },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_EARTHDAMAGE, minDamage = -5157, maxDamage = -6698, range = 7, radius = 2, shootEffect = CONST_ANI_POISONARROW, effect = CONST_ME_BIGPLANTS, target = false },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_PHYSICALDAMAGE, minDamage = -5157, maxDamage = -6698, range = 7, radius = 2, shootEffect = CONST_ANI_LARGEROCK, effect = CONST_ME_STONES, target = false },
}

monster.defenses = {
	defense = 287,
	armor = 287,
	mitigation = 16.00,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -10 },
	{ type = COMBAT_EARTHDAMAGE, percent = 30 },
	{ type = COMBAT_FIREDAMAGE, percent = -15 },
	{ type = COMBAT_LIFEDRAIN, percent = 100 },
	{ type = COMBAT_MANADRAIN, percent = 100 },
	{ type = COMBAT_DROWNDAMAGE, percent = 100 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = -20 },
	{ type = COMBAT_DEATHDAMAGE, percent = 30 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
