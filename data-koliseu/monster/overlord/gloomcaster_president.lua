local mType = Game.createMonsterType("Gloomcaster President")
local monster = {}

monster.description = "a gloomcaster president"
monster.experience = 1000000
monster.outfit = {
	lookType = 3191,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 2752
monster.Bestiary = {
	class = "Demon",
	race = BESTY_RACE_DEMON,
	toKill = 5000,
	FirstUnlock = 500,
	SecondUnlock = 1000,
	CharmsPoints = 100,
	Stars = 5,
	Occurrence = 0,
	Locations = "Gloomcaster Sanctum.",
}

monster.health = 1150000
monster.maxHealth = 1150000
monster.race = "blood"
monster.corpse = 6068
monster.speed = 870
monster.manaCost = 0

monster.changeTarget = {
	interval = 3000,
	chance = 25,
}

monster.strategiesTarget = {
	nearest = 60,
	health = 15,
	damage = 15,
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
	{ text = "I RULE THE GLOOM AND ALL WHO DWELL WITHIN!", yell = true },
	{ text = "YOUR RESISTANCE IS AN INSULT TO MY OFFICE!", yell = true },
	{ text = "THE GLOOMCASTERS ANSWER TO ME ALONE!", yell = true },
}

monster.loot = {
	{ name = "crystal coin", chance = 60000, maxCount = 5 },
	{ name = "gold ingot", chance = 30000, maxCount = 2 },
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
	{ name = "melee", interval = 2000, chance = 100, minDamage = -14000, maxDamage = -25000 },
	{ name = "combat", interval = 2000, chance = 25, type = COMBAT_DEATHDAMAGE, minDamage = -22000, maxDamage = -34000, range = 7, radius = 3, shootEffect = CONST_ANI_DEATH, effect = CONST_ME_MORTAREA, target = false },
	{ name = "combat", interval = 2000, chance = 22, type = COMBAT_ENERGYDAMAGE, minDamage = -22000, maxDamage = -34000, range = 7, radius = 3, shootEffect = CONST_ANI_ENERGY, effect = CONST_ME_ENERGYAREA, target = false },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_EARTHDAMAGE, minDamage = -22000, maxDamage = -34000, range = 7, radius = 3, shootEffect = CONST_ANI_POISONARROW, effect = CONST_ME_BIGPLANTS, target = false },
	{ name = "combat", interval = 3000, chance = 18, type = COMBAT_FIREDAMAGE, minDamage = -22000, maxDamage = -34000, range = 7, radius = 3, shootEffect = CONST_ANI_FIRE, effect = CONST_ME_FIREAREA, target = false },
	{ name = "combat", interval = 3000, chance = 15, type = COMBAT_MANADRAIN, minDamage = -22000, maxDamage = -34000, range = 7, shootEffect = CONST_ANI_ENERGY, target = true },
}

monster.defenses = {
	defense = 320,
	armor = 320,
	mitigation = 4.50,
	{ name = "combat", interval = 2000, chance = 40, type = COMBAT_HEALING, minDamage = 12000, maxDamage = 25000, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 10 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 10 },
	{ type = COMBAT_EARTHDAMAGE, percent = 60 },
	{ type = COMBAT_FIREDAMAGE, percent = -15 },
	{ type = COMBAT_LIFEDRAIN, percent = 100 },
	{ type = COMBAT_MANADRAIN, percent = 100 },
	{ type = COMBAT_DROWNDAMAGE, percent = 100 },
	{ type = COMBAT_ICEDAMAGE, percent = -5 },
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
