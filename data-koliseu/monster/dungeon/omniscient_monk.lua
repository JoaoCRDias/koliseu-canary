local mType = Game.createMonsterType("Omniscient Monk")
local monster = {}

monster.description = "an omniscient monk"
monster.experience = 0
monster.outfit = {
	lookType = 1819, -- Monk outfit
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.health = 403750
monster.maxHealth = 403750
monster.race = "blood"
monster.corpse = 0
monster.speed = 350
monster.manaCost = 0

monster.changeTarget = {
	interval = 3000,
	chance = 10,
}

monster.strategiesTarget = {
	nearest = 85,
	health = 8,
	damage = 5,
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
	color = 175,
}

monster.voices = {
	interval = 5000,
	chance = 20,
	{ text = "I have transcended pain itself!", yell = true },
	{ text = "Every fist strike carries the universe's force!", yell = false },
	{ text = "Perfect Form!", yell = true },
	{ text = "Your body will break before my will does!", yell = false },
}

monster.loot = {}

monster.attacks = {
	-- Devastating melee
	{ name = "melee", interval = 1500, chance = 100, minDamage = -3185, maxDamage = -4620 },
	-- Grand fist burst (large AoE physical)
	{ name = "combat", interval = 3000, chance = 35, type = COMBAT_PHYSICALDAMAGE, minDamage = -2870, maxDamage = -4300, radius = 4, effect = CONST_ME_HITAREA, target = false },
	-- Thousand strikes (rapid ranged physical)
	{ name = "combat", interval = 3000, chance = 30, type = COMBAT_PHYSICALDAMAGE, minDamage = -2550, maxDamage = -3825, range = 6, shootEffect = CONST_ANI_THROWINGKNIFE, effect = CONST_ME_HITBYBLOOD, target = true },
	-- Perfect focus (wide cone physical)
	{ name = "combat", interval = 3500, chance = 25, type = COMBAT_PHYSICALDAMAGE, minDamage = -3185, maxDamage = -4780, length = 7, spread = 2, effect = CONST_ME_EXPLOSIONAREA, target = false },
	-- Supreme ki blast (energy + physical combo — ranged AoE)
	{ name = "combat", interval = 4000, chance = 25, type = COMBAT_ENERGYDAMAGE, minDamage = -2550, maxDamage = -3825, range = 7, radius = 3, shootEffect = CONST_ANI_ENERGY, effect = CONST_ME_ENERGYHIT, target = true },
	-- Iron will counter (energy blast AoE around self)
	{ name = "combat", interval = 4500, chance = 20, type = COMBAT_ENERGYDAMAGE, minDamage = -2230, maxDamage = -3345, radius = 3, effect = CONST_ME_ENERGYAREA, target = false },
	-- Supreme counter flow (heavy slow)
	{ name = "speed", interval = 5000, chance = 20, speedChange = -900, range = 8, effect = CONST_ME_MAGIC_RED, target = true, duration = 10000 },
}

monster.defenses = {
	defense = 28,
	armor = 28,
	mitigation = 0.49,
	{ name = "combat", interval = 4000, chance = 20, type = COMBAT_HEALING, minDamage = 320, maxDamage = 640, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 25 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -15 },
	{ type = COMBAT_EARTHDAMAGE, percent = 5 },
	{ type = COMBAT_FIREDAMAGE, percent = -10 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 5 },
	{ type = COMBAT_HOLYDAMAGE, percent = -5 },
	{ type = COMBAT_DEATHDAMAGE, percent = -15 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
