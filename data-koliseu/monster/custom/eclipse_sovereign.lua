-- Eclipse Sovereign - Cosmic Siege 1000 Boss
local mType = Game.createMonsterType("Eclipse Sovereign")
local monster = {}

monster.description = "an eclipse sovereign"
monster.experience = 0
monster.outfit = {
	lookType = 3110,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.health = 950000
monster.maxHealth = 950000
monster.race = "blood"
monster.corpse = 0
monster.speed = 270
monster.manaCost = 0

monster.changeTarget = {
	interval = 2000,
	chance = 6,
}

monster.strategiesTarget = {
	nearest = 75,
	health = 10,
	damage = 10,
	random = 5,
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
	level = 7,
	color = 1,
}

monster.events = {
	"EclipseSovereignDeath",
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "I am the darkness that consumes all light!", yell = true },
	{ text = "The eclipse rises, and with it, your doom!", yell = false },
	{ text = "Shadows bow to my command!", yell = false },
	{ text = "In my presence, even stars fade!", yell = true },
	{ text = "The cosmic balance shifts in my favor!", yell = false },
}

monster.loot = {
	{ id = BAG_OF_COSMIC_WISHES, chance = 250 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -950, maxDamage = -1700 },
	{ name = "combat", interval = 2000, chance = 18, type = COMBAT_PHYSICALDAMAGE, minDamage = -750, maxDamage = -1350, range = 7, shootEffect = CONST_ANI_LARGEROCK, effect = CONST_ME_EXPLOSIONAREA, target = true },
	{ name = "combat", interval = 2000, chance = 16, type = COMBAT_ENERGYDAMAGE, minDamage = -650, maxDamage = -1200, range = 7, radius = 4, shootEffect = CONST_ANI_ENERGY, effect = CONST_ME_ENERGYAREA, target = true },
	{ name = "combat", interval = 2000, chance = 16, type = COMBAT_FIREDAMAGE, minDamage = -650, maxDamage = -1200, range = 7, radius = 4, shootEffect = CONST_ANI_FIRE, effect = CONST_ME_FIREAREA, target = true },
	{ name = "combat", interval = 2000, chance = 16, type = COMBAT_ICEDAMAGE, minDamage = -650, maxDamage = -1200, range = 7, radius = 4, shootEffect = CONST_ANI_ICE, effect = CONST_ME_ICEAREA, target = true },
	{ name = "combat", interval = 2000, chance = 14, type = COMBAT_DEATHDAMAGE, minDamage = -850, maxDamage = -1450, length = 8, spread = 3, effect = CONST_ME_MORTAREA, target = false },
	{ name = "combat", interval = 2000, chance = 12, type = COMBAT_HOLYDAMAGE, minDamage = -750, maxDamage = -1300, radius = 4, effect = CONST_ME_HOLYAREA, target = false },
	{ name = "speed", interval = 2000, chance = 12, speedChange = -850, range = 7, effect = CONST_ME_MAGIC_RED, target = true, duration = 8000 },
	-- Special mechanics
	{ name = "eclipse_sovereign_shadow_eclipse", interval = 8000, chance = 15, target = false },
	{ name = "eclipse_sovereign_lunar_beams", interval = 5000, chance = 18, target = false },
	-- Cosmic Siege mechanics
	{ name = "eclipse_sovereign_cosmic_mark", interval = 3000, chance = 20, target = true },
	{ name = "eclipse_sovereign_cosmic_bombardment", interval = 5000, chance = 15, target = false },
}

monster.defenses = {
	defense = 115,
	armor = 115,
	mitigation = 2.85,
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_HEALING, minDamage = 600, maxDamage = 1800, effect = CONST_ME_MAGIC_BLUE, target = false },
	{ name = "speed", interval = 2000, chance = 15, speedChange = 450, effect = CONST_ME_MAGIC_RED, target = false, duration = 6000 },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 15 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 20 },
	{ type = COMBAT_EARTHDAMAGE, percent = 10 },
	{ type = COMBAT_FIREDAMAGE, percent = 15 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 15 },
	{ type = COMBAT_HOLYDAMAGE, percent = -10 },
	{ type = COMBAT_DEATHDAMAGE, percent = 20 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
