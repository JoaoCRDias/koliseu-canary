local mType = Game.createMonsterType("Grudge Keeper")
local monster = {}

monster.description = "a grudge keeper"
monster.experience = 77300
monster.outfit = {
	lookType = 3237,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 2754
monster.Bestiary = {
	class = "Humanoid",
	race = BESTY_RACE_HUMANOID,
	toKill = 5000,
	FirstUnlock = 500,
	SecondUnlock = 1000,
	CharmsPoints = 100,
	Stars = 5,
	Occurrence = 0,
	Locations = "Deeprock Mines.",
}

monster.health = 117260
monster.maxHealth = 117260
monster.race = "blood"
monster.corpse = 6068
monster.speed = 830
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
	staticAttackChance = 78,
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
	{ text = "DWARVES NEVER FORGET!", yell = true },
	{ text = "YOUR DEBT WILL BE PAID IN BLOOD!", yell = true },
}

monster.loot = {
	{ name = "crystal coin", chance = 95000, maxCount = 5 },
	{ name = "gold ingot", chance = 50000, maxCount = 2 },
	{ name = "violet gem", chance = 22000 },
	{ name = "blue gem", chance = 22000 },
	{ name = "green gem", chance = 22000 },
	{ name = "yellow gem", chance = 18000 },
	{ name = "giant sapphire", chance = 16000 },
	{ name = "giant emerald", chance = 10000 },
	{ name = "giant ruby", chance = 10000 },
	{ name = "giant amethyst", chance = 10000 },
	{ name = "giant topaz", chance = 10000 },
	{ name = "boots of haste", chance = 35000 },
	{ name = "demonic essence", chance = 60000, maxCount = 3 },
	{ name = "soul orb", chance = 85000, maxCount = 5 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -8046 },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_DEATHDAMAGE, minDamage = -6540, maxDamage = -8493, range = 7, radius = 2, shootEffect = CONST_ANI_DEATH, effect = CONST_ME_MORTAREA, target = false },
	{ name = "combat", interval = 2000, chance = 18, type = COMBAT_EARTHDAMAGE, minDamage = -6540, maxDamage = -8493, range = 7, radius = 2, shootEffect = CONST_ANI_SMALLEARTH, effect = CONST_ME_GREEN_RINGS, target = false },
}

monster.defenses = {
	defense = 364,
	armor = 364,
	mitigation = 27.37,
	{ name = "combat", interval = 2000, chance = 42, type = COMBAT_HEALING, minDamage = 75000, maxDamage = 142000, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 15 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -20 },
	{ type = COMBAT_EARTHDAMAGE, percent = 35 },
	{ type = COMBAT_FIREDAMAGE, percent = -25 },
	{ type = COMBAT_LIFEDRAIN, percent = 100 },
	{ type = COMBAT_MANADRAIN, percent = 100 },
	{ type = COMBAT_DROWNDAMAGE, percent = 100 },
	{ type = COMBAT_ICEDAMAGE, percent = -20 },
	{ type = COMBAT_HOLYDAMAGE, percent = -25 },
	{ type = COMBAT_DEATHDAMAGE, percent = 30 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
