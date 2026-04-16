local mType = Game.createMonsterType("Transcendent Paladin")
local monster = {}

monster.description = "a transcendent paladin"
monster.experience = 0
monster.outfit = {
	lookType = 992, -- Paladin outfit
	lookHead = 78,
	lookBody = 79,
	lookLegs = 78,
	lookFeet = 79,
	lookAddons = 3,
	lookMount = 0,
}

monster.health = 63750
monster.maxHealth = 63750
monster.race = "blood"
monster.corpse = 0
monster.speed = 290
monster.manaCost = 0

monster.changeTarget = {
	interval = 5000,
	chance = 15,
}

monster.strategiesTarget = {
	nearest = 60,
	health = 20,
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
	canPushCreatures = false,
	staticAttackChance = 85,
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
	color = 144,
}


monster.voices = {
	interval = 6000,
	chance = 15,
	{ text = "Light shall consume you!", yell = false },
	{ text = "Holy wrath descends!", yell = true },
	{ text = "Divine justice is absolute!", yell = false },
	{ text = "You cannot escape the sacred arrows!", yell = false },
}

monster.loot = {}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -650, maxDamage = -1040 },
	-- Holy cross (cone à frente)
	{ name = "combat", interval = 3500, chance = 30, type = COMBAT_HOLYDAMAGE, minDamage = -910, maxDamage = -1365, length = 5, spread = 1, effect = CONST_ME_HOLYAREA, target = false },
	-- Sacred burst (AoE ao redor)
	{ name = "combat", interval = 5000, chance = 20, type = COMBAT_HOLYDAMAGE, minDamage = -1170, maxDamage = -1755, radius = 4, effect = CONST_ME_HOLYAREA, target = false },
	-- Healing (cura própria)
	{ name = "combat", interval = 6000, chance = 20, type = COMBAT_HEALING, minDamage = 65, maxDamage = 140, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.defenses = {
	defense = 18,
	armor = 18,
	mitigation = 0.33,
	{ name = "speed", interval = 4000, chance = 15, speedChange = 300, effect = CONST_ME_MAGIC_RED, target = false, duration = 4000 },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 10 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 5 },
	{ type = COMBAT_HOLYDAMAGE, percent = 50 },
	{ type = COMBAT_DEATHDAMAGE, percent = -20 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
