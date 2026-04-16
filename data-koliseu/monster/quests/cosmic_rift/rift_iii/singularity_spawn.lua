local mType = Game.createMonsterType("Singularity Spawn")
local monster = {}

monster.description = "a singularity spawn"
monster.experience = 32000
monster.outfit = {
	lookType = 1064, -- PLACEHOLDER: set lookType
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 2777
monster.Bestiary = {
	class = "Cosmic",
	race = BESTY_RACE_MAGICAL,
	toKill = 5000,
	FirstUnlock = 200,
	SecondUnlock = 2000,
	CharmsPoints = 100,
	Stars = 5,
	Occurrence = 0,
	Locations = "Cosmic Rift III.",
}

monster.events = {}

monster.health = 48400
monster.maxHealth = 48400
monster.race = "energy"
monster.corpse = 6068 -- PLACEHOLDER: set corpse id
monster.speed = 240
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
	level = 5,
	color = 180,
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "The singularity expands!", yell = false },
	{ text = "Nothing escapes my gravity!", yell = false },
}

monster.loot = {
	{ name = "crystal coin", chance = 42000 },
	{ name = "ultimate mana potion", chance = 25000, maxCount = 5 },
	{ name = "ultimate health potion", chance = 20000, maxCount = 4 },
	{ name = "gold ingot", chance = 14000 },
	{ name = "dark obsidian splinter", chance = 9000 },
	{ name = "rainbow quartz", chance = 7500, maxCount = 3 },
	{ name = "green gem", chance = 7000 },
	{ name = "violet gem", chance = 6500 },
	{ name = "small sapphire", chance = 6000, maxCount = 3 },
	{ name = "ice rapier", chance = 4500 },
	{ name = "crystal mace", chance = 4000 },
	{ name = "glacial rod", chance = 3000 },
	{ name = "northwind rod", chance = 2500 },
	{ name = "glacier kilt", chance = 2000 },
	{ name = "goblet of gloom", chance = 1200 },
	{ name = "spellbook of mind control", chance = 800 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -3320 },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_ENERGYDAMAGE, minDamage = -2710, maxDamage = -3505, length = 8, spread = 3, effect = CONST_ME_BLUE_ENERGY_SPARK, target = false },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_ICEDAMAGE, minDamage = -2480, maxDamage = -3270, radius = 5, effect = CONST_ME_ICEATTACK, target = true },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_ENERGYDAMAGE, minDamage = -2320, maxDamage = -3100, radius = 5, effect = CONST_ME_ELECTRICALSPARK, target = false },
	{ name = "ice chain", interval = 2000, chance = 10, minDamage = -1700, maxDamage = -2480, range = 7 },
	{ name = "largepinkring", interval = 2500, chance = 10, minDamage = -2170, maxDamage = -2950, target = false },
}

monster.defenses = {
	defense = 150,
	armor = 150,
	mitigation = 3.30,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = -10 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 50 },
	{ type = COMBAT_EARTHDAMAGE, percent = -10 },
	{ type = COMBAT_FIREDAMAGE, percent = -20 },
	{ type = COMBAT_LIFEDRAIN, percent = 100 },
	{ type = COMBAT_MANADRAIN, percent = 100 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 40 },
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
