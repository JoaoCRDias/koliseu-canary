-- Cosmic Annihilator - Cosmic Siege 1500 Monster
local mType = Game.createMonsterType("Cosmic Annihilator")
local monster = {}

monster.description = "a cosmic annihilator"
monster.experience = 150000
monster.outfit = {
	lookType = 3086,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.health = 200000
monster.maxHealth = 200000
monster.race = "blood"
monster.corpse = 0
monster.speed = 250
monster.manaCost = 0

monster.changeTarget = {
	interval = 2000,
	chance = 10,
}

monster.strategiesTarget = {
	nearest = 70,
	health = 10,
	damage = 15,
	random = 5,
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
	staticAttackChance = 95,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
	canWalkOnFire = true,
	canWalkOnPoison = true,
}

monster.light = {
	level = 6,
	color = 210,
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "Witness the end of all things!", yell = true },
	{ text = "I am the destroyer of worlds!", yell = false },
	{ text = "Annihilation is inevitable!", yell = false },
	{ text = "Your reality crumbles before me!", yell = true },
}

monster.loot = {
	{ name = "crystal coin", chance = 90000, maxCount = 12 },
	{ name = "platinum coin", chance = 100000, maxCount = 100 },
	{ name = "ultimate health potion", chance = 70000, maxCount = 5 },
	{ name = "ultimate mana potion", chance = 70000, maxCount = 5 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -1200, maxDamage = -2100 },
	{ name = "combat", interval = 2000, chance = 18, type = COMBAT_PHYSICALDAMAGE, minDamage = -900, maxDamage = -1650, range = 7, shootEffect = CONST_ANI_LARGEROCK, effect = CONST_ME_EXPLOSIONAREA, target = true },
	{ name = "combat", interval = 2000, chance = 16, type = COMBAT_ENERGYDAMAGE, minDamage = -825, maxDamage = -1500, range = 7, radius = 4, shootEffect = CONST_ANI_ENERGY, effect = CONST_ME_ENERGYAREA, target = true },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_ICEDAMAGE, minDamage = -825, maxDamage = -1500, range = 7, radius = 4, shootEffect = CONST_ANI_ICE, effect = CONST_ME_ICEAREA, target = true },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_FIREDAMAGE, minDamage = -825, maxDamage = -1500, range = 7, radius = 4, shootEffect = CONST_ANI_FIRE, effect = CONST_ME_FIREAREA, target = true },
	{ name = "combat", interval = 2000, chance = 12, type = COMBAT_DEATHDAMAGE, minDamage = -975, maxDamage = -1650, length = 8, spread = 3, effect = CONST_ME_MORTAREA, target = false },
	{ name = "combat", interval = 2000, chance = 12, type = COMBAT_HOLYDAMAGE, minDamage = -825, maxDamage = -1500, radius = 4, effect = CONST_ME_HOLYAREA, target = false },
	{ name = "speed", interval = 2000, chance = 12, speedChange = -800, range = 7, effect = CONST_ME_MAGIC_RED, target = true, duration = 7000 },
}

monster.defenses = {
	defense = 100,
	armor = 100,
	mitigation = 2.50,
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_HEALING, minDamage = 700, maxDamage = 1500, effect = CONST_ME_MAGIC_BLUE, target = false },
	{ name = "speed", interval = 2000, chance = 12, speedChange = 400, effect = CONST_ME_MAGIC_RED, target = false, duration = 6000 },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 10 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 15 },
	{ type = COMBAT_EARTHDAMAGE, percent = 5 },
	{ type = COMBAT_FIREDAMAGE, percent = 15 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 15 },
	{ type = COMBAT_HOLYDAMAGE, percent = 10 },
	{ type = COMBAT_DEATHDAMAGE, percent = 15 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
