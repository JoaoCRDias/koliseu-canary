local mType = Game.createMonsterType("Plunderer Captain")
local monster = {}

monster.description = "a plunderer captain"
monster.experience = 65100
monster.outfit = {
	lookType = 3217,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 2759
monster.Bestiary = {
	class = "Human",
	race = BESTY_RACE_HUMAN,
	toKill = 5000,
	FirstUnlock = 500,
	SecondUnlock = 1000,
	CharmsPoints = 100,
	Stars = 5,
	Occurrence = 0,
	Locations = "Pirate Cove.",
}

monster.health = 98770
monster.maxHealth = 98770
monster.race = "blood"
monster.corpse = 6068
monster.speed = 850
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
	{ text = "I AM THE LAW OF THESE SEAS!", yell = true },
	{ text = "YOUR GOLD BELONGS TO ME!", yell = true },
}

monster.loot = {
	{ name = "crystal coin", chance = 72000, maxCount = 3 },
	{ name = "gold ingot", chance = 30000, maxCount = 1 },
	{ name = "violet gem", chance = 14000 },
	{ name = "blue gem", chance = 14000 },
	{ name = "green gem", chance = 14000 },
	{ name = "yellow gem", chance = 12000 },
	{ name = "giant sapphire", chance = 8000 },
	{ name = "giant emerald", chance = 5000 },
	{ name = "giant ruby", chance = 5000 },
	{ name = "giant amethyst", chance = 5000 },
	{ name = "giant topaz", chance = 5000 },
	{ name = "boots of haste", chance = 22000 },
	{ name = "demonic essence", chance = 40000, maxCount = 2 },
	{ name = "soul orb", chance = 70000, maxCount = 3 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -6777 },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_DEATHDAMAGE, minDamage = -5509, maxDamage = -7154, range = 7, radius = 2, shootEffect = CONST_ANI_DEATH, effect = CONST_ME_MORTAREA, target = false },
	{ name = "combat", interval = 2000, chance = 18, type = COMBAT_PHYSICALDAMAGE, minDamage = -5509, maxDamage = -7154, range = 7, radius = 2, shootEffect = CONST_ANI_LARGEROCK, effect = CONST_ME_STONES, target = false },
}

monster.defenses = {
	defense = 306,
	armor = 306,
	mitigation = 21.20,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 10 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -15 },
	{ type = COMBAT_EARTHDAMAGE, percent = 20 },
	{ type = COMBAT_FIREDAMAGE, percent = -20 },
	{ type = COMBAT_LIFEDRAIN, percent = 100 },
	{ type = COMBAT_MANADRAIN, percent = 100 },
	{ type = COMBAT_DROWNDAMAGE, percent = 100 },
	{ type = COMBAT_ICEDAMAGE, percent = -10 },
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
