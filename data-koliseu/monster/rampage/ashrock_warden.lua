local mType = Game.createMonsterType("Ashrock Warden")
local monster = {}

monster.description = "an ashrock warden"
monster.experience = 68000
monster.outfit = {
	lookType = 3236,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 2745
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

monster.health = 103090
monster.maxHealth = 103090
monster.race = "blood"
monster.corpse = 6068
monster.speed = 828
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 20,
}

monster.strategiesTarget = {
	nearest = 75,
	health = 10,
	damage = 10,
	random = 5,
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
	staticAttackChance = 75,
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
	{ text = "THE ASH SHALL BURY YOU!", yell = true },
	{ text = "NONE PASS THE ASHROCK!", yell = true },
}

monster.loot = {
	{ name = "crystal coin", chance = 50000, maxCount = 3 },
	{ name = "gold ingot", chance = 20000, maxCount = 1 },
	{ name = "violet gem", chance = 10000 },
	{ name = "blue gem", chance = 10000 },
	{ name = "green gem", chance = 10000 },
	{ name = "yellow gem", chance = 10000 },
	{ name = "giant sapphire", chance = 5000 },
	{ name = "giant emerald", chance = 3000 },
	{ name = "giant ruby", chance = 3000 },
	{ name = "giant amethyst", chance = 3000 },
	{ name = "giant topaz", chance = 3000 },
	{ name = "boots of haste", chance = 15000 },
	{ name = "demonic essence", chance = 30000, maxCount = 2 },
	{ name = "soul orb", chance = 60000, maxCount = 3 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -7074 },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_FIREDAMAGE, minDamage = -5750, maxDamage = -7467, range = 7, radius = 2, shootEffect = CONST_ANI_FIRE, effect = CONST_ME_FIREAREA, target = false },
	{ name = "combat", interval = 2000, chance = 18, type = COMBAT_EARTHDAMAGE, minDamage = -5750, maxDamage = -7467, range = 7, radius = 2, shootEffect = CONST_ANI_SMALLEARTH, effect = CONST_ME_POISONAREA, target = false },
}

monster.defenses = {
	defense = 320,
	armor = 320,
	mitigation = 22.80,
	{ name = "combat", interval = 2000, chance = 38, type = COMBAT_HEALING, minDamage = 40000, maxDamage = 78000, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 15 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -20 },
	{ type = COMBAT_EARTHDAMAGE, percent = 30 },
	{ type = COMBAT_FIREDAMAGE, percent = 40 },
	{ type = COMBAT_LIFEDRAIN, percent = 100 },
	{ type = COMBAT_MANADRAIN, percent = 100 },
	{ type = COMBAT_DROWNDAMAGE, percent = 100 },
	{ type = COMBAT_ICEDAMAGE, percent = -30 },
	{ type = COMBAT_HOLYDAMAGE, percent = -20 },
	{ type = COMBAT_DEATHDAMAGE, percent = 20 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
