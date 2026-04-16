local mType = Game.createMonsterType("Saltwater Corsair")
local monster = {}

monster.description = "a saltwater corsair"
monster.experience = 64100
monster.outfit = {
	lookType = 3215,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 2762
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

monster.health = 97190
monster.maxHealth = 97190
monster.race = "blood"
monster.corpse = 6068
monster.speed = 840
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
	{ text = "PLUNDER EVERYTHING!", yell = true },
	{ text = "NO MERCY FOR LANDLUBBERS!", yell = true },
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
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -6669 },
	{ name = "combat", interval = 2000, chance = 18, type = COMBAT_PHYSICALDAMAGE, minDamage = -5421, maxDamage = -7040, range = 7, radius = 2, shootEffect = CONST_ANI_LARGEROCK, effect = CONST_ME_STONES, target = false },
	{ name = "combat", interval = 2000, chance = 18, type = COMBAT_DEATHDAMAGE, minDamage = -5421, maxDamage = -7040, range = 7, radius = 2, shootEffect = CONST_ANI_DEATH, effect = CONST_ME_MORTAREA, target = false },
}

monster.defenses = {
	defense = 301,
	armor = 301,
	mitigation = 20.80,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 5 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -15 },
	{ type = COMBAT_EARTHDAMAGE, percent = 20 },
	{ type = COMBAT_FIREDAMAGE, percent = -20 },
	{ type = COMBAT_LIFEDRAIN, percent = 100 },
	{ type = COMBAT_MANADRAIN, percent = 100 },
	{ type = COMBAT_DROWNDAMAGE, percent = 100 },
	{ type = COMBAT_ICEDAMAGE, percent = -10 },
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
