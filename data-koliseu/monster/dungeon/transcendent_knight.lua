local mType = Game.createMonsterType("Transcendent Knight")
local monster = {}

monster.description = "a transcendent knight"
monster.experience = 0
monster.outfit = {
	lookType = 991, -- Knight outfit
	lookHead = 95,
	lookBody = 94,
	lookLegs = 95,
	lookFeet = 94,
	lookAddons = 3,
	lookMount = 0,
}

monster.health = 76500
monster.maxHealth = 76500
monster.race = "blood"
monster.corpse = 0
monster.speed = 250
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 10,
}

monster.strategiesTarget = {
	nearest = 80,
	health = 10,
	damage = 5,
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
	canPushCreatures = false,
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
	level = 3,
	color = 215,
}

monster.voices = {
	interval = 6000,
	chance = 15,
	{ text = "You cannot withstand my blade!", yell = false },
	{ text = "I am beyond your comprehension!", yell = true },
	{ text = "Steel and fury, eternal!", yell = false },
	{ text = "Face the might of a transcendent warrior!", yell = false },
}

monster.loot = {}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -1040, maxDamage = -1690 },
	-- Whirlwind (AoE ao redor)
	{ name = "combat", interval = 3000, chance = 30, type = COMBAT_PHYSICALDAMAGE, minDamage = -910, maxDamage = -1365, radius = 2, effect = CONST_ME_HITAREA, target = false },
	-- Berserk thrust (cone à frente)
	{ name = "combat", interval = 4000, chance = 25, type = COMBAT_PHYSICALDAMAGE, minDamage = -1170, maxDamage = -1755, length = 5, spread = 1, effect = CONST_ME_EXPLOSIONAREA, target = false },
	-- Ground smash (AoE terra ao redor)
	{ name = "combat", interval = 4500, chance = 20, type = COMBAT_EARTHDAMAGE, minDamage = -650, maxDamage = -975, radius = 3, effect = CONST_ME_GROUNDSHAKER, target = false },
}

monster.defenses = {
	defense = 21,
	armor = 21,
	mitigation = 0.38,
	{ name = "combat", interval = 3000, chance = 20, type = COMBAT_HEALING, minDamage = 50, maxDamage = 125, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 15 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -10 },
	{ type = COMBAT_EARTHDAMAGE, percent = 5 },
	{ type = COMBAT_FIREDAMAGE, percent = 5 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -10 },
	{ type = COMBAT_HOLYDAMAGE, percent = 5 },
	{ type = COMBAT_DEATHDAMAGE, percent = -5 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
