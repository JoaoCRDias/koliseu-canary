local mType = Game.createMonsterType("Omniscient Sorcerer")
local monster = {}

monster.description = "an omniscient sorcerer"
monster.experience = 0
monster.outfit = {
	lookType = 1367, -- Sorcerer outfit
	lookHead = 79,
	lookBody = 116,
	lookLegs = 79,
	lookFeet = 116,
	lookAddons = 3,
	lookMount = 0,
}

monster.health = 318750
monster.maxHealth = 318750
monster.race = "blood"
monster.corpse = 0
monster.speed = 315
monster.manaCost = 0

monster.changeTarget = {
	interval = 5000,
	chance = 20,
}

monster.strategiesTarget = {
	nearest = 40,
	health = 20,
	damage = 30,
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
	staticAttackChance = 80,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
	canWalkOnFire = true,
	canWalkOnPoison = true,
}

monster.light = {
	level = 7,
	color = 198,
}

monster.voices = {
	interval = 5000,
	chance = 20,
	{ text = "All elements bow before me!", yell = true },
	{ text = "I have studied every spell ever cast!", yell = false },
	{ text = "Annihilation!", yell = true },
	{ text = "Your mind cannot comprehend true magic!", yell = false },
}

monster.loot = {}

monster.attacks = {
	-- Melee backup
	{ name = "melee", interval = 2000, chance = 100, minDamage = -955, maxDamage = -1435 },
	-- Inferno (large fire AoE)
	{ name = "combat", interval = 3000, chance = 35, type = COMBAT_FIREDAMAGE, minDamage = -2870, maxDamage = -4300, radius = 5, effect = CONST_ME_FIREAREA, target = false },
	-- Energy storm (energy AoE)
	{ name = "combat", interval = 3500, chance = 30, type = COMBAT_ENERGYDAMAGE, minDamage = -2550, maxDamage = -3825, radius = 4, effect = CONST_ME_ENERGYAREA, target = false },
	-- Death wave (cone death)
	{ name = "combat", interval = 4000, chance = 25, type = COMBAT_DEATHDAMAGE, minDamage = -2870, maxDamage = -4300, length = 8, spread = 3, effect = CONST_ME_MORTAREA, target = false },
	-- Annihilation bolt (single-target ranged multi-element)
	{ name = "combat", interval = 4000, chance = 30, type = COMBAT_FIREDAMAGE, minDamage = -3185, maxDamage = -4780, range = 7, shootEffect = CONST_ANI_FIRE, effect = CONST_ME_FIREATTACK, target = true },
	-- Energy lance (ranged energy bolt)
	{ name = "combat", interval = 4500, chance = 25, type = COMBAT_ENERGYDAMAGE, minDamage = -2550, maxDamage = -3825, range = 8, shootEffect = CONST_ANI_ENERGY, effect = CONST_ME_ENERGYHIT, target = true },
	-- Mana drain (mass)
	{ name = "combat", interval = 5000, chance = 20, type = COMBAT_MANADRAIN, minDamage = -1910, maxDamage = -2870, radius = 4, effect = CONST_ME_MAGIC_BLUE, target = false },
	-- Death volley (AoE death)
	{ name = "combat", interval = 5500, chance = 20, type = COMBAT_DEATHDAMAGE, minDamage = -2230, maxDamage = -3345, range = 7, radius = 3, shootEffect = CONST_ANI_DEATH, effect = CONST_ME_MORTAREA, target = true },
}

monster.defenses = {
	defense = 21,
	armor = 21,
	mitigation = 0.38,
	{ name = "combat", interval = 4000, chance = 20, type = COMBAT_HEALING, minDamage = 425, maxDamage = 850, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 20 },
	{ type = COMBAT_EARTHDAMAGE, percent = -10 },
	{ type = COMBAT_FIREDAMAGE, percent = 20 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -15 },
	{ type = COMBAT_HOLYDAMAGE, percent = -10 },
	{ type = COMBAT_DEATHDAMAGE, percent = 20 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
