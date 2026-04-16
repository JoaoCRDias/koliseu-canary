-- Nebular Warlord - Cosmic Siege 500 Boss
local mType = Game.createMonsterType("Nebular Warlord")
local monster = {}

monster.description = "a nebular warlord"
monster.experience = 0
monster.outfit = {
	lookType = 3109,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.health = 800000
monster.maxHealth = 800000
monster.race = "blood"
monster.corpse = 0
monster.speed = 260
monster.manaCost = 0

monster.changeTarget = {
	interval = 2000,
	chance = 8,
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
	level = 6,
	color = 180,
}

monster.events = {
	"NebularWarlordDeath",
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "Kneel before the nebular might!", yell = true },
	{ text = "I command the stars themselves!", yell = false },
	{ text = "Your resistance is meaningless!", yell = false },
	{ text = "Witness the power of the cosmic void!", yell = true },
	{ text = "I am legion, I am eternal!", yell = false },
}

monster.loot = {
	{ id = BAG_OF_COSMIC_WISHES, chance = 250 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -900, maxDamage = -1600 },
	{ name = "combat", interval = 2000, chance = 18, type = COMBAT_PHYSICALDAMAGE, minDamage = -700, maxDamage = -1300, range = 7, shootEffect = CONST_ANI_LARGEROCK, effect = CONST_ME_EXPLOSIONAREA, target = true },
	{ name = "combat", interval = 2000, chance = 16, type = COMBAT_ENERGYDAMAGE, minDamage = -600, maxDamage = -1100, range = 7, radius = 4, shootEffect = CONST_ANI_ENERGY, effect = CONST_ME_ENERGYAREA, target = true },
	{ name = "combat", interval = 2000, chance = 16, type = COMBAT_ICEDAMAGE, minDamage = -600, maxDamage = -1100, range = 7, radius = 4, shootEffect = CONST_ANI_ICE, effect = CONST_ME_ICEAREA, target = true },
	{ name = "combat", interval = 2000, chance = 14, type = COMBAT_DEATHDAMAGE, minDamage = -800, maxDamage = -1400, length = 8, spread = 3, effect = CONST_ME_MORTAREA, target = false },
	{ name = "combat", interval = 2000, chance = 12, type = COMBAT_HOLYDAMAGE, minDamage = -700, maxDamage = -1200, radius = 4, effect = CONST_ME_HOLYAREA, target = false },
	{ name = "speed", interval = 2000, chance = 12, speedChange = -850, range = 7, effect = CONST_ME_MAGIC_RED, target = true, duration = 8000 },
	-- Special mechanics
	{ name = "nebular_warlord_chains", interval = 4000, chance = 18, target = false },
	{ name = "nebular_warlord_void_collapse", interval = 6000, chance = 12, target = false },
	-- Cosmic Siege mechanics
	{ name = "nebular_warlord_cosmic_mark", interval = 3000, chance = 20, target = true },
	{ name = "nebular_warlord_cosmic_bombardment", interval = 5000, chance = 15, target = false },
}

monster.defenses = {
	defense = 110,
	armor = 110,
	mitigation = 2.75,
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_HEALING, minDamage = 600, maxDamage = 1800, effect = CONST_ME_MAGIC_BLUE, target = false },
	{ name = "speed", interval = 2000, chance = 15, speedChange = 450, effect = CONST_ME_MAGIC_RED, target = false, duration = 6000 },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 15 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 20 },
	{ type = COMBAT_EARTHDAMAGE, percent = 10 },
	{ type = COMBAT_FIREDAMAGE, percent = 10 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 15 },
	{ type = COMBAT_HOLYDAMAGE, percent = 10 },
	{ type = COMBAT_DEATHDAMAGE, percent = 20 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
