local mType = Game.createMonsterType("Transcendent Monk")
local monster = {}

monster.description = "a transcendent monk"
monster.experience = 0
monster.outfit = {
	lookType = 1818, -- Monk outfit (ajustar lookType conforme outfit do servidor)
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.health = 71400
monster.maxHealth = 71400
monster.race = "blood"
monster.corpse = 0
monster.speed = 320
monster.manaCost = 0

monster.changeTarget = {
	interval = 3000,
	chance = 15,
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
	color = 180,
}


monster.voices = {
	interval = 6000,
	chance = 15,
	{ text = "Mind. Body. Destruction.", yell = false },
	{ text = "You cannot keep up with my strikes!", yell = true },
	{ text = "Transcendence is pain!", yell = false },
	{ text = "Feel the true power of the fist!", yell = false },
}

monster.loot = {}

monster.attacks = {
	{ name = "melee", interval = 1800, chance = 100, minDamage = -1170, maxDamage = -1820 },
	-- Fist burst (AoE ao redor)
	{ name = "combat", interval = 3000, chance = 30, type = COMBAT_PHYSICALDAMAGE, minDamage = -975, maxDamage = -1465, radius = 2, effect = CONST_ME_HITAREA, target = false },
	-- Focus strike (cone à frente)
	{ name = "combat", interval = 4000, chance = 25, type = COMBAT_PHYSICALDAMAGE, minDamage = -1170, maxDamage = -1755, length = 5, spread = 1, effect = CONST_ME_EXPLOSIONAREA, target = false },
	-- Ki blast (AoE energia ao redor)
	{ name = "combat", interval = 4500, chance = 20, type = COMBAT_ENERGYDAMAGE, minDamage = -845, maxDamage = -1270, radius = 2, effect = CONST_ME_ENERGYHIT, target = false },
}

monster.defenses = {
	defense = 19,
	armor = 19,
	mitigation = 0.36,
	{ name = "combat", interval = 3500, chance = 20, type = COMBAT_HEALING, minDamage = 55, maxDamage = 120, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 20 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -10 },
	{ type = COMBAT_EARTHDAMAGE, percent = 5 },
	{ type = COMBAT_FIREDAMAGE, percent = -5 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 5 },
	{ type = COMBAT_HOLYDAMAGE, percent = -5 },
	{ type = COMBAT_DEATHDAMAGE, percent = -10 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
