local mType = Game.createMonsterType("Crimson Buccaneer")
local monster = {}

monster.description = "a crimson buccaneer"
monster.experience = 65700
monster.outfit = {
	lookType = 3220,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 2747
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

monster.health = 99550
monster.maxHealth = 99550
monster.race = "blood"
monster.corpse = 6068
monster.speed = 855
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
	{ text = "BLOOD PAINTS THE SEA RED!", yell = true },
	{ text = "NONE SHALL SURVIVE!", yell = true },
}

monster.loot = {
	{ name = "crystal coin", chance = 78000, maxCount = 3 },
	{ name = "gold ingot", chance = 33000, maxCount = 1 },
	{ name = "violet gem", chance = 15000 },
	{ name = "blue gem", chance = 15000 },
	{ name = "green gem", chance = 15000 },
	{ name = "yellow gem", chance = 13000 },
	{ name = "giant sapphire", chance = 9000 },
	{ name = "giant emerald", chance = 5500 },
	{ name = "giant ruby", chance = 5500 },
	{ name = "giant amethyst", chance = 5500 },
	{ name = "giant topaz", chance = 5500 },
	{ name = "boots of haste", chance = 25000 },
	{ name = "demonic essence", chance = 45000, maxCount = 2 },
	{ name = "soul orb", chance = 75000, maxCount = 3 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -6831 },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_BLOODDRAIN, minDamage = -5552, maxDamage = -7211, range = 7, radius = 2, shootEffect = CONST_ANI_DEATH, effect = CONST_ME_MORTAREA, target = false },
	{ name = "combat", interval = 2000, chance = 18, type = COMBAT_PHYSICALDAMAGE, minDamage = -5552, maxDamage = -7211, range = 7, radius = 2, shootEffect = CONST_ANI_LARGEROCK, effect = CONST_ME_STONES, target = false },
}

monster.defenses = {
	defense = 309,
	armor = 309,
	mitigation = 21.50,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 10 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -15 },
	{ type = COMBAT_EARTHDAMAGE, percent = 15 },
	{ type = COMBAT_FIREDAMAGE, percent = -25 },
	{ type = COMBAT_LIFEDRAIN, percent = 100 },
	{ type = COMBAT_MANADRAIN, percent = 100 },
	{ type = COMBAT_DROWNDAMAGE, percent = 100 },
	{ type = COMBAT_ICEDAMAGE, percent = -10 },
	{ type = COMBAT_HOLYDAMAGE, percent = -25 },
	{ type = COMBAT_DEATHDAMAGE, percent = 25 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
