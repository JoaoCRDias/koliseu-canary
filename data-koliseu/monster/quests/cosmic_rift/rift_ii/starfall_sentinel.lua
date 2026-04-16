local mType = Game.createMonsterType("Starfall Sentinel")
local monster = {}

monster.description = "a starfall sentinel"
monster.experience = 30250
monster.outfit = {
	lookType = 947, -- PLACEHOLDER: set lookType
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 2774
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
monster.race = "fire"
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
	level = 5,
	color = 208,
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "Stars fall at my command!", yell = false },
	{ text = "Burn in celestial fire!", yell = false },
}

monster.loot = {
	{ name = "crystal coin", chance = 40000 },
	{ name = "ultimate health potion", chance = 22000, maxCount = 5 },
	{ name = "ultimate mana potion", chance = 18000, maxCount = 4 },
	{ name = "gold ingot", chance = 13000 },
	{ name = "magma clump", chance = 9000 },
	{ name = "small emerald", chance = 7500, maxCount = 3 },
	{ name = "small topaz", chance = 7000, maxCount = 3 },
	{ name = "white gem", chance = 6000 },
	{ name = "fire sword", chance = 4500 },
	{ name = "magma coat", chance = 4000 },
	{ name = "magma legs", chance = 3000 },
	{ id = 10385, chance = 2500 }, --zaoan helmet
	{ name = "stone skin amulet", chance = 2000 },
	{ name = "jade hammer", chance = 1500 },
	{ name = "metal bat", chance = 1000 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -3160 },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_FIREDAMAGE, minDamage = -2570, maxDamage = -3335, length = 8, spread = 3, effect = CONST_ME_FIREAREA, target = false },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_FIREDAMAGE, minDamage = -2390, maxDamage = -3120, radius = 5, effect = CONST_ME_HITBYFIRE, target = true },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_HOLYDAMAGE, minDamage = -2570, maxDamage = -3210, radius = 5, effect = CONST_ME_HOLYDAMAGE, target = false },
	{ name = "extended fire chain", interval = 2000, chance = 10, minDamage = -1840, maxDamage = -2570, target = true },
}

monster.defenses = {
	defense = 143,
	armor = 143,
	mitigation = 3.10,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 20 },
	{ type = COMBAT_EARTHDAMAGE, percent = -25 },
	{ type = COMBAT_FIREDAMAGE, percent = 50 },
	{ type = COMBAT_LIFEDRAIN, percent = 100 },
	{ type = COMBAT_MANADRAIN, percent = 100 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -20 },
	{ type = COMBAT_HOLYDAMAGE, percent = 30 },
	{ type = COMBAT_DEATHDAMAGE, percent = -10 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = true },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
