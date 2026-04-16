local mType = Game.createMonsterType("Omniscient Knight")
local monster = {}

monster.description = "an omniscient knight"
monster.experience = 0
monster.outfit = {
	lookType = 1365, -- Knight outfit (boss variant)
	lookHead = 94,
	lookBody = 113,
	lookLegs = 94,
	lookFeet = 113,
	lookAddons = 3,
	lookMount = 0,
}

monster.health = 425000
monster.maxHealth = 425000
monster.race = "blood"
monster.corpse = 0
monster.speed = 300
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 10,
}

monster.strategiesTarget = {
	nearest = 90,
	health = 5,
	damage = 3,
	random = 2,
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
	color = 215,
}

monster.voices = {
	interval = 5000,
	chance = 20,
	{ text = "I have mastered every strike known to man!", yell = true },
	{ text = "Your armor is nothing to me!", yell = false },
	{ text = "Omniscience grants me power beyond reckoning!", yell = true },
	{ text = "Feel the weight of a true knight's wrath!", yell = false },
}

monster.loot = {}

monster.attacks = {
	{ name = "melee", interval = 1600, chance = 100, minDamage = -3185, maxDamage = -4780 },
	-- Grand whirlwind (AoE ao redor)
	{ name = "combat", interval = 3000, chance = 35, type = COMBAT_PHYSICALDAMAGE, minDamage = -2870, maxDamage = -4300, radius = 4, effect = CONST_ME_HITAREA, target = false },
	-- Stomp (cone à frente)
	{ name = "combat", interval = 3500, chance = 30, type = COMBAT_PHYSICALDAMAGE, minDamage = -3185, maxDamage = -4780, length = 6, spread = 3, effect = CONST_ME_EXPLOSIONAREA, target = false },
	-- Ground slam (AoE terra ao redor)
	{ name = "combat", interval = 5000, chance = 20, type = COMBAT_EARTHDAMAGE, minDamage = -2230, maxDamage = -3345, radius = 3, effect = CONST_ME_GROUNDSHAKER, target = false },
}

monster.defenses = {
	defense = 30,
	armor = 30,
	mitigation = 0.53,
	{ name = "combat", interval = 4000, chance = 20, type = COMBAT_HEALING, minDamage = 320, maxDamage = 640, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 30 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -5 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = -10 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = -10 },
	{ type = COMBAT_DEATHDAMAGE, percent = -15 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
