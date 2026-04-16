local mType = Game.createMonsterType("Nebula Weaver")
local monster = {}

monster.description = "a nebula weaver"
monster.experience = 30250
monster.outfit = {
	lookType = 932, -- PLACEHOLDER: set lookType
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 2773
monster.Bestiary = {
	class = "Cosmic",
	race = BESTY_RACE_MAGICAL,
	toKill = 5000,
	FirstUnlock = 200,
	SecondUnlock = 2000,
	CharmsPoints = 100,
	Stars = 5,
	Occurrence = 0,
	Locations = "Cosmic Rift II.",
}

monster.events = {}

monster.health = 46035
monster.maxHealth = 46035
monster.race = "energy"
monster.corpse = 6068 -- PLACEHOLDER: set corpse id
monster.speed = 232
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
	level = 4,
	color = 215,
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "The stars weep for you...", yell = false },
	{ text = "Entangled in cosmic threads!", yell = false },
}

monster.loot = {
	{ name = "crystal coin", chance = 38000 },
	{ name = "ultimate health potion", chance = 22000, maxCount = 5 },
	{ name = "ultimate mana potion", chance = 20000, maxCount = 4 },
	{ name = "gold ingot", chance = 14000 },
	{ name = "blue crystal shard", chance = 8000 },
	{ name = "onyx chip", chance = 7500, maxCount = 2 },
	{ name = "violet gem", chance = 6500 },
	{ name = "blue gem", chance = 6000 },
	{ name = "rainbow quartz", chance = 5000, maxCount = 3 },
	{ name = "magma amulet", chance = 4500 },
	{ name = "darklight core", chance = 4000 },
	{ name = "war axe", chance = 3500 },
	{ name = "giant sword", chance = 3000 },
	{ name = "royal helmet", chance = 2000 },
	{ name = "alloy legs", chance = 1000 },
	{ name = "mastermind shield", chance = 800 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -3160 },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_ENERGYDAMAGE, minDamage = -2570, maxDamage = -3335, length = 8, spread = 3, effect = CONST_ME_BLUE_ENERGY_SPARK, target = false },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_HOLYDAMAGE, minDamage = -2570, maxDamage = -3335, radius = 5, effect = CONST_ME_HOLYDAMAGE, target = true },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_ENERGYDAMAGE, minDamage = -2300, maxDamage = -2940, radius = 5, effect = CONST_ME_ELECTRICALSPARK, target = false },
	{ name = "extended energy chain", interval = 2000, chance = 10, minDamage = -1840, maxDamage = -2570, target = true },
	{ name = "largepinkring", interval = 3500, chance = 10, minDamage = -2020, maxDamage = -2750, target = false },
}

monster.defenses = {
	defense = 143,
	armor = 143,
	mitigation = 3.10,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = -5 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 45 },
	{ type = COMBAT_EARTHDAMAGE, percent = -20 },
	{ type = COMBAT_FIREDAMAGE, percent = -10 },
	{ type = COMBAT_LIFEDRAIN, percent = 100 },
	{ type = COMBAT_MANADRAIN, percent = 100 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 20 },
	{ type = COMBAT_HOLYDAMAGE, percent = 10 },
	{ type = COMBAT_DEATHDAMAGE, percent = -15 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = true },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
