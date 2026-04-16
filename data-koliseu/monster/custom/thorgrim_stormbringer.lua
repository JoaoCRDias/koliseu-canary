-- Thorgrim's Stormbringer - Summon of Thorgrim the Hammerborn
-- Stats based on Elder Bloodjaw x5
local mType = Game.createMonsterType("Thorgrim's Stormbringer")
local monster = {}

monster.description = "Thorgrim's Stormbringer"
monster.experience = 0
monster.outfit = {
	lookType = 3169,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.health = 500000
monster.maxHealth = 500000
monster.race = "blood"
monster.corpse = 0
monster.speed = 280
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 10,
}

monster.strategiesTarget = {
	nearest = 80,
	health = 10,
	damage = 10,
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
	color = 215,
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "The storm obeys Thorgrim!", yell = false },
	{ text = "Thunder strikes at his command!", yell = false },
	{ text = "You will fall before the Hammerborn!", yell = true },
}

monster.loot = {}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -4450 },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_ENERGYDAMAGE, minDamage = -1100, maxDamage = -2025, range = 7, radius = 1, shootEffect = CONST_ANI_ENERGY, effect = CONST_ME_ENERGYAREA, target = true },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_ENERGYDAMAGE, minDamage = -325, maxDamage = -675, radius = 4, effect = CONST_ME_ENERGYHIT, target = false },
	{ name = "drunk", interval = 6000, chance = 10, radius = 3, effect = CONST_ME_ENERGYHIT, target = false, duration = 5000 },
	{ name = "speed", interval = 2000, chance = 15, speedChange = -500, range = 7, shootEffect = CONST_ANI_ENERGY, target = true, duration = 30000 },
}

monster.defenses = {
	defense = 500,
	armor = 500,
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_HEALING, minDamage = 500, maxDamage = 1500, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = -15 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 50 },
	{ type = COMBAT_EARTHDAMAGE, percent = -15 },
	{ type = COMBAT_FIREDAMAGE, percent = 40 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = 25 },
	{ type = COMBAT_DEATHDAMAGE, percent = -20 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
