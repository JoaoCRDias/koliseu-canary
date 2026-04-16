-- Voidborn Assailant - Cosmic Siege 500 Monster
local mType = Game.createMonsterType("Voidborn Assailant")
local monster = {}

monster.description = "a voidborn assailant"
monster.experience = 50000
monster.outfit = {
	lookType = 3084,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.health = 40000
monster.maxHealth = 40000
monster.race = "blood"
monster.corpse = 0
monster.speed = 220
monster.manaCost = 0

monster.changeTarget = {
	interval = 2000,
	chance = 15,
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
	color = 180,
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "The void calls for you!", yell = false },
	{ text = "Embrace oblivion!", yell = false },
	{ text = "Your essence will fuel the void!", yell = false },
}

monster.loot = {
	{ name = "crystal coin", chance = 80000, maxCount = 5 },
	{ name = "platinum coin", chance = 100000, maxCount = 50 },
	{ name = "ultimate health potion", chance = 50000, maxCount = 3 },
	{ name = "ultimate mana potion", chance = 50000, maxCount = 3 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -600, maxDamage = -1200 },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_PHYSICALDAMAGE, minDamage = -500, maxDamage = -900, range = 7, shootEffect = CONST_ANI_LARGEROCK, effect = CONST_ME_EXPLOSIONAREA, target = true },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_ENERGYDAMAGE, minDamage = -400, maxDamage = -800, range = 7, radius = 3, shootEffect = CONST_ANI_ENERGY, effect = CONST_ME_ENERGYAREA, target = true },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_DEATHDAMAGE, minDamage = -500, maxDamage = -900, length = 8, spread = 3, effect = CONST_ME_MORTAREA, target = false },
	{ name = "speed", interval = 2000, chance = 12, speedChange = -700, range = 7, effect = CONST_ME_MAGIC_RED, target = true, duration = 7000 },
}

monster.defenses = {
	defense = 80,
	armor = 80,
	mitigation = 2.00,
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_HEALING, minDamage = 300, maxDamage = 800, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 5 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 10 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 5 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 15 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
