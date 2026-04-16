-- Starforged Ravager - Cosmic Siege 1000 Monster
local mType = Game.createMonsterType("Starforged Ravager")
local monster = {}

monster.description = "a starforged ravager"
monster.experience = 100000
monster.outfit = {
	lookType = 3085,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.health = 140000
monster.maxHealth = 140000
monster.race = "blood"
monster.corpse = 0
monster.speed = 240
monster.manaCost = 0

monster.changeTarget = {
	interval = 2000,
	chance = 12,
}

monster.strategiesTarget = {
	nearest = 65,
	health = 15,
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
	staticAttackChance = 92,
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
	{ text = "Forged in starfire, tempered in war!", yell = false },
	{ text = "Your world will burn!", yell = false },
	{ text = "Feel the heat of a dying star!", yell = true },
}

monster.loot = {
	{ name = "crystal coin", chance = 85000, maxCount = 8 },
	{ name = "platinum coin", chance = 100000, maxCount = 80 },
	{ name = "ultimate health potion", chance = 60000, maxCount = 4 },
	{ name = "ultimate mana potion", chance = 60000, maxCount = 4 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -560, maxDamage = -1050 },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_PHYSICALDAMAGE, minDamage = -489, maxDamage = -770, range = 7, shootEffect = CONST_ANI_LARGEROCK, effect = CONST_ME_EXPLOSIONAREA, target = true },
	{ name = "combat", interval = 2000, chance = 18, type = COMBAT_FIREDAMAGE, minDamage = -420, maxDamage = -700, range = 7, radius = 4, shootEffect = CONST_ANI_FIRE, effect = CONST_ME_FIREAREA, target = true },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_ENERGYDAMAGE, minDamage = -350, maxDamage = -630, range = 7, radius = 3, shootEffect = CONST_ANI_ENERGY, effect = CONST_ME_ENERGYAREA, target = true },
	{ name = "combat", interval = 2000, chance = 12, type = COMBAT_HOLYDAMAGE, minDamage = -420, maxDamage = -700, radius = 4, effect = CONST_ME_HOLYAREA, target = false },
	{ name = "speed", interval = 2000, chance = 12, speedChange = -800, range = 7, effect = CONST_ME_MAGIC_RED, target = true, duration = 7500 },
}

monster.defenses = {
	defense = 90,
	armor = 90,
	mitigation = 2.25,
	{ name = "combat", interval = 2000, chance = 12, type = COMBAT_HEALING, minDamage = 350, maxDamage = 840, effect = CONST_ME_MAGIC_BLUE, target = false },
	{ name = "speed", interval = 2000, chance = 10, speedChange = 350, effect = CONST_ME_MAGIC_RED, target = false, duration = 5000 },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 8 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 12 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 20 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -10 },
	{ type = COMBAT_HOLYDAMAGE, percent = 10 },
	{ type = COMBAT_DEATHDAMAGE, percent = 5 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
