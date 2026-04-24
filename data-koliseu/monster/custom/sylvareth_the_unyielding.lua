local mType = Game.createMonsterType("Sylvareth the Unyielding")
local monster = {}

monster.description = "Sylvareth the Unyielding"
monster.experience = 250000
monster.outfit = {
	lookType = 3306,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.health = 2000000
monster.maxHealth = 2000000
monster.race = "blood"
monster.corpse = 0
monster.speed = 340
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
	staticAttackChance = 96,
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
	color = 60,
}

monster.events = {
	"SylvarethDeath",
	"SylvarethSpawn",
}

monster.voices = {
	interval = 6000,
	chance = 15,
	{ text = "You are not welcome at the fountain.", yell = false },
	{ text = "The root does not yield.", yell = false },
	{ text = "Bleed for the grove.", yell = true },
}

monster.loot = {}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -1800, maxDamage = -3200 },
	{ name = "combat", interval = 2000, chance = 25, type = COMBAT_EARTHDAMAGE, minDamage = -1800, maxDamage = -3000, range = 7, radius = 4, shootEffect = CONST_ANI_POISON, effect = CONST_ME_POISONAREA, target = true },
	{ name = "combat", interval = 2000, chance = 22, type = COMBAT_EARTHDAMAGE, minDamage = -1500, maxDamage = -2800, length = 8, spread = 3, effect = CONST_ME_HITBYPOISON, target = false },
	{ name = "combat", interval = 2000, chance = 18, type = COMBAT_PHYSICALDAMAGE, minDamage = -2000, maxDamage = -3500, radius = 3, effect = CONST_ME_GROUNDSHAKER, target = false },
	{ name = "speed", interval = 2000, chance = 12, speedChange = -500, range = 7, effect = CONST_ME_MAGIC_GREEN, target = true, duration = 6000 },
}

monster.defenses = {
	defense = 100,
	armor = 100,
	mitigation = 2.40,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 100 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -10 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = -10 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
