local mType = Game.createMonsterType("Cosmic Warden")
local monster = {}

monster.description = "a cosmic warden"
monster.experience = 32000
monster.outfit = {
	lookType = 984, -- PLACEHOLDER: set lookType
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 2775
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
monster.race = "fire"
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
	color = 208,
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "The cosmos shall endure!", yell = false },
	{ text = "I guard the fabric of reality!", yell = false },
}

monster.loot = {
	{ name = "crystal coin", chance = 48000 },
	{ name = "ultimate health potion", chance = 24000, maxCount = 5 },
	{ name = "great spirit potion", chance = 20000, maxCount = 5 },
	{ name = "gold ingot", chance = 16000 },
	{ name = "magma clump", chance = 9500 },
	{ name = "small topaz", chance = 7500, maxCount = 3 },
	{ name = "blue gem", chance = 7000 },
	{ name = "white gem", chance = 6500 },
	{ name = "darklight core", chance = 6000 },
	{ name = "magma amulet", chance = 5000 },
	{ name = "fire sword", chance = 4000 },
	{ name = "magma coat", chance = 3500 },
	{ name = "magma legs", chance = 3000 },
	{ id = 10386, chance = 2000 },
	{ name = "demon shield", chance = 1500 },
	{ name = "mastermind shield", chance = 1000 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -3320 },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_FIREDAMAGE, minDamage = -2710, maxDamage = -3505, length = 8, spread = 3, effect = CONST_ME_FIREAREA, target = false },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_HOLYDAMAGE, minDamage = -2630, maxDamage = -3420, radius = 5, effect = CONST_ME_HOLYDAMAGE, target = true },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_FIREDAMAGE, minDamage = -2320, maxDamage = -2950, radius = 5, effect = CONST_ME_HITBYFIRE, target = false },
	{ name = "extended fire chain", interval = 2000, chance = 10, minDamage = -1700, maxDamage = -2480, target = true },
	{ name = "largepinkring", interval = 3500, chance = 10, minDamage = -2170, maxDamage = -2950, target = false },
}

monster.defenses = {
	defense = 150,
	armor = 150,
	mitigation = 3.30,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 5 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 30 },
	{ type = COMBAT_EARTHDAMAGE, percent = -20 },
	{ type = COMBAT_FIREDAMAGE, percent = 50 },
	{ type = COMBAT_LIFEDRAIN, percent = 100 },
	{ type = COMBAT_MANADRAIN, percent = 100 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -25 },
	{ type = COMBAT_HOLYDAMAGE, percent = 25 },
	{ type = COMBAT_DEATHDAMAGE, percent = -10 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = true },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
