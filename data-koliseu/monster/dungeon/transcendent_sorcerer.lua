local mType = Game.createMonsterType("Transcendent Sorcerer")
local monster = {}

monster.description = "a transcendent sorcerer"
monster.experience = 0
monster.outfit = {
	lookType = 994, -- Sorcerer outfit
	lookHead = 114,
	lookBody = 115,
	lookLegs = 114,
	lookFeet = 115,
	lookAddons = 3,
	lookMount = 0,
}

monster.health = 56100
monster.maxHealth = 56100
monster.race = "blood"
monster.corpse = 0
monster.speed = 270
monster.manaCost = 0

monster.changeTarget = {
	interval = 6000,
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
	level = 5,
	color = 198,
}


monster.voices = {
	interval = 6000,
	chance = 15,
	{ text = "The arcane arts are limitless!", yell = false },
	{ text = "BURN!", yell = true },
	{ text = "Your mind cannot comprehend this power!", yell = false },
	{ text = "Death wave incoming!", yell = false },
}

monster.loot = {}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -325, maxDamage = -555 },
	-- Energy wave (cone à frente)
	{ name = "combat", interval = 3000, chance = 30, type = COMBAT_ENERGYDAMAGE, minDamage = -1170, maxDamage = -1755, length = 6, spread = 2, effect = CONST_ME_ENERGYAREA, target = false },
	-- Death wave (cone à frente)
	{ name = "combat", interval = 4000, chance = 25, type = COMBAT_DEATHDAMAGE, minDamage = -1040, maxDamage = -1560, length = 6, spread = 2, effect = CONST_ME_MORTAREA, target = false },
	-- Arcane burst (AoE ao redor)
	{ name = "combat", interval = 5000, chance = 20, type = COMBAT_ENERGYDAMAGE, minDamage = -1300, maxDamage = -1950, radius = 3, effect = CONST_ME_ENERGYHIT, target = false },
}

monster.defenses = {
	defense = 14,
	armor = 14,
	mitigation = 0.25,
	{ name = "combat", interval = 5000, chance = 15, type = COMBAT_HEALING, minDamage = 38, maxDamage = 75, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = -10 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 25 },
	{ type = COMBAT_EARTHDAMAGE, percent = -10 },
	{ type = COMBAT_FIREDAMAGE, percent = 20 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -15 },
	{ type = COMBAT_HOLYDAMAGE, percent = -5 },
	{ type = COMBAT_DEATHDAMAGE, percent = 15 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "energy", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
