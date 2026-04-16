local mType = Game.createMonsterType("Transcendent Druid")
local monster = {}

monster.description = "a transcendent druid"
monster.experience = 0
monster.outfit = {
	lookType = 993, -- Druid outfit
	lookHead = 57,
	lookBody = 58,
	lookLegs = 57,
	lookFeet = 58,
	lookAddons = 3,
	lookMount = 0,
}

monster.health = 58650
monster.maxHealth = 58650
monster.race = "blood"
monster.corpse = 0
monster.speed = 290
monster.manaCost = 0

monster.changeTarget = {
	interval = 5000,
	chance = 20,
}

monster.strategiesTarget = {
	nearest = 50,
	health = 20,
	damage = 20,
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
	level = 4,
	color = 30,
}


monster.voices = {
	interval = 6000,
	chance = 15,
	{ text = "Nature reclaims all!", yell = false },
	{ text = "The storm and ice obey my will!", yell = true },
	{ text = "Avalanche!", yell = false },
	{ text = "The earth itself turns against you!", yell = false },
}

monster.loot = {}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -455, maxDamage = -715 },
	-- Avalanche (AoE gelo ao redor)
	{ name = "combat", interval = 3000, chance = 30, type = COMBAT_ICEDAMAGE, minDamage = -1040, maxDamage = -1560, radius = 4, effect = CONST_ME_ICEAREA, target = false },
	-- Thunderstorm (AoE energia ao redor)
	{ name = "combat", interval = 3500, chance = 25, type = COMBAT_ENERGYDAMAGE, minDamage = -845, maxDamage = -1270, radius = 3, effect = CONST_ME_ENERGYAREA, target = false },
	-- Ice wave (cone de gelo à frente)
	{ name = "combat", interval = 4500, chance = 20, type = COMBAT_ICEDAMAGE, minDamage = -845, maxDamage = -1270, length = 6, spread = 3, effect = CONST_ME_ICEATTACK, target = false },
	-- Healing (cura própria)
	{ name = "combat", interval = 4000, chance = 25, type = COMBAT_HEALING, minDamage = 75, maxDamage = 155, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.defenses = {
	defense = 15,
	armor = 15,
	mitigation = 0.28,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 5 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -10 },
	{ type = COMBAT_EARTHDAMAGE, percent = 50 },
	{ type = COMBAT_FIREDAMAGE, percent = -10 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 15 },
	{ type = COMBAT_HOLYDAMAGE, percent = -10 },
	{ type = COMBAT_DEATHDAMAGE, percent = -5 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "poison", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
