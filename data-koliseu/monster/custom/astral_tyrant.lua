-- Astral Tyrant - Cosmic Siege 1500 Boss
local mType = Game.createMonsterType("Astral Tyrant")
local monster = {}

monster.description = "an astral tyrant"
monster.experience = 0
monster.outfit = {
	lookType = 3108,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.health = 2500000
monster.maxHealth = 2500000
monster.race = "blood"
monster.corpse = 0
monster.speed = 280
monster.manaCost = 0

monster.changeTarget = {
	interval = 2000,
	chance = 5,
}

monster.strategiesTarget = {
	nearest = 80,
	health = 10,
	damage = 10,
	random = 0,
}

monster.flags = {
	summonable = false,
	attackable = true,
	hostile = true,
	convinceable = false,
	pushable = false,
	rewardBoss = true,
	illusionable = false,
	canPushItems = true,
	canPushCreatures = true,
	staticAttackChance = 98,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
	canWalkOnFire = true,
	canWalkOnPoison = true,
}

monster.light = {
	level = 8,
	color = 215,
}

monster.events = {
	"AstralTyrantDeath",
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "I am the ruler of infinite dimensions!", yell = true },
	{ text = "Galaxies tremble at my word!", yell = false },
	{ text = "Your universe is mine to command!", yell = true },
	{ text = "I transcend mortal comprehension!", yell = false },
	{ text = "Bow before the Astral Throne!", yell = true },
	{ text = "Reality bends to my will!", yell = false },
}

monster.loot = {
	{ id = BAG_OF_COSMIC_WISHES, chance = 250 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -4000, maxDamage = -7000 },
	{ name = "combat", interval = 2000, chance = 22, type = COMBAT_PHYSICALDAMAGE, minDamage = -3500, maxDamage = -6000, range = 7, shootEffect = CONST_ANI_LARGEROCK, effect = CONST_ME_EXPLOSIONAREA, target = true },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_ENERGYDAMAGE, minDamage = -3000, maxDamage = -5500, range = 7, radius = 4, shootEffect = CONST_ANI_ENERGY, effect = CONST_ME_ENERGYAREA, target = true },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_FIREDAMAGE, minDamage = -3000, maxDamage = -5500, range = 7, radius = 4, shootEffect = CONST_ANI_FIRE, effect = CONST_ME_FIREAREA, target = true },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_ICEDAMAGE, minDamage = -3000, maxDamage = -5500, range = 7, radius = 4, shootEffect = CONST_ANI_ICE, effect = CONST_ME_ICEAREA, target = true },
	{ name = "combat", interval = 2000, chance = 18, type = COMBAT_DEATHDAMAGE, minDamage = -3500, maxDamage = -6500, length = 8, spread = 3, effect = CONST_ME_MORTAREA, target = false },
	{ name = "combat", interval = 2000, chance = 18, type = COMBAT_HOLYDAMAGE, minDamage = -3500, maxDamage = -6000, radius = 4, effect = CONST_ME_HOLYAREA, target = false },
	{ name = "combat", interval = 2000, chance = 16, type = COMBAT_EARTHDAMAGE, minDamage = -3000, maxDamage = -5000, length = 8, spread = 3, effect = CONST_ME_GREEN_RINGS, target = false },
	{ name = "speed", interval = 2000, chance = 12, speedChange = -900, range = 7, effect = CONST_ME_MAGIC_RED, target = true, duration = 9000 },
	-- Special mechanics
	{ name = "astral_tyrant_reality_fracture", interval = 7000, chance = 16, target = false },
	{ name = "astral_tyrant_astral_judgment", interval = 12000, chance = 10, target = false },
	{ name = "astral_tyrant_dimensional_shift", interval = 20000, chance = 12, target = false },
	-- Cosmic Siege mechanics
	{ name = "astral_tyrant_cosmic_mark", interval = 3000, chance = 20, target = true },
	{ name = "astral_tyrant_cosmic_bombardment", interval = 5000, chance = 15, target = false },
}

monster.defenses = {
	defense = 118,
	armor = 118,
	mitigation = 2.90,
	{ name = "combat", interval = 2000, chance = 16, type = COMBAT_HEALING, minDamage = 700, maxDamage = 1900, effect = CONST_ME_MAGIC_BLUE, target = false },
	{ name = "speed", interval = 2000, chance = 16, speedChange = 480, effect = CONST_ME_MAGIC_RED, target = false, duration = 7000 },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 18 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 22 },
	{ type = COMBAT_EARTHDAMAGE, percent = 12 },
	{ type = COMBAT_FIREDAMAGE, percent = 15 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 18 },
	{ type = COMBAT_HOLYDAMAGE, percent = 12 },
	{ type = COMBAT_DEATHDAMAGE, percent = 22 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
