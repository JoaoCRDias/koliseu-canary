local mType = Game.createMonsterType("Storm Conjurer")
local monster = {}

monster.description = "a storm conjurer"
monster.experience = 64900
monster.outfit = {
	lookType = 3219,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 2766
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

monster.health = 98370
monster.maxHealth = 98370
monster.race = "blood"
monster.corpse = 6068
monster.speed = 835
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 15,
}

monster.strategiesTarget = {
	nearest = 50,
	health = 20,
	damage = 20,
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
	canPushCreatures = false,
	staticAttackChance = 55,
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
	{ text = "THE STORM OBEYS MY WILL!", yell = true },
	{ text = "LIGHTNING STRIKE YOU DOWN!", yell = true },
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
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -6750 },
	{ name = "combat", interval = 2000, chance = 28, type = COMBAT_ENERGYDAMAGE, minDamage = -5486, maxDamage = -7125, range = 7, radius = 3, shootEffect = CONST_ANI_ENERGY, effect = CONST_ME_ENERGYAREA, target = false },
	{ name = "combat", interval = 2000, chance = 22, type = COMBAT_ICEDAMAGE, minDamage = -5486, maxDamage = -7125, range = 7, radius = 2, shootEffect = CONST_ANI_ICE, effect = CONST_ME_ICEAREA, target = false },
	{ name = "combat", interval = 3000, chance = 15, type = COMBAT_MANADRAIN, minDamage = -5486, maxDamage = -7125, range = 7, shootEffect = CONST_ANI_ENERGY, target = true },
}

monster.defenses = {
	defense = 305,
	armor = 305,
	mitigation = 20.30,
	{ name = "combat", interval = 2000, chance = 25, type = COMBAT_HEALING, minDamage = 20000, maxDamage = 40000, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 40 },
	{ type = COMBAT_EARTHDAMAGE, percent = 10 },
	{ type = COMBAT_FIREDAMAGE, percent = -20 },
	{ type = COMBAT_LIFEDRAIN, percent = 100 },
	{ type = COMBAT_MANADRAIN, percent = 100 },
	{ type = COMBAT_DROWNDAMAGE, percent = 100 },
	{ type = COMBAT_ICEDAMAGE, percent = -15 },
	{ type = COMBAT_HOLYDAMAGE, percent = -20 },
	{ type = COMBAT_DEATHDAMAGE, percent = 10 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
