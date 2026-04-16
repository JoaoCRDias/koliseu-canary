local mType = Game.createMonsterType("Apocalypse")
local monster = {}

monster.description = "Apocalypse"
monster.experience = 50000000
monster.outfit = {
	lookType = 12,
	lookHead = 38,
	lookBody = 114,
	lookLegs = 0,
	lookFeet = 94,
	lookAddons = 0,
	lookMount = 0,
}

monster.health = 5000000
monster.maxHealth = 5000000
monster.race = "fire"
monster.corpse = 6068
monster.speed = 350
monster.manaCost = 0

monster.changeTarget = {
	interval = 5000,
	chance = 40,
}

monster.strategiesTarget = {
	nearest = 70,
	health = 10,
	damage = 10,
	random = 10,
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
	level = 0,
	color = 0,
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "BOW TO THE POWER OF THE RUTHLESS SEVEN!", yell = true },
	{ text = "DESTRUCTION!", yell = true },
	{ text = "CHAOS!", yell = true },
	{ text = "DEATH TO ALL!", yell = true },
}

monster.loot = {
	{ id = 3025, chance = 13500 }, -- ancient amulet
	{ id = 3116, chance = 19000 }, -- big bone
	{ name = "black pearl", chance = 15000, maxCount = 35 },
	{ name = "boots of haste", chance = 14000 },
	{ id = 3076, chance = 22500 }, -- crystal ball
	{ name = "crystal necklace", chance = 21500 },
	{ id = 3007, chance = 15500 }, -- crystal ring
	{ name = "demon shield", chance = 15500 },
	{ name = "devil helmet", chance = 11000 },
	{ name = "dragon hammer", chance = 34500 },
	{ id = 3051, chance = 13500 }, -- energy ring
	{ name = "fire axe", chance = 17000 },
	{ name = "giant sword", chance = 12500 },
	{ name = "platinum coin", chance = 69900, maxCount = 100 },
	{ name = "platinum coin", chance = 68800, maxCount = 100 },
	{ name = "crystal coin", chance = 47700, maxCount = 40 },
	{ name = "crystal coin", chance = 36600, maxCount = 15 },
	{ name = "gold ring", chance = 28000 },
	{ name = "golden legs", chance = 15000 },
	{ name = "giant ruby", chance = 31500 },
	{ name = "giant sapphire", chance = 31500 },
	{ name = "giant emerald", chance = 31500 },
	{ name = "ice rapier", chance = 27500 },
	{ name = "magic plate armor", chance = 13000 },
	{ name = "mastermind shield", chance = 17500 },
	{ name = "purple tome", chance = 12600 },
	{ name = "ring of the sky", chance = 13500 },
	{ name = "silver dagger", chance = 15500 },
	{ name = "skull staff", chance = 25000 },
	{ name = "talon", chance = 14000, maxCount = 27 },
	{ name = "teddy bear", chance = 10500 },
	{ name = "thunder hammer", chance = 3500 },
	{ id = 3002, chance = 5100 }, -- voodoo doll
	{ name = "white pearl", chance = 12500, maxCount = 35 },
	{ id = 60648, chance = 10000, maxCount = 1 },
	{ id = 60427, chance = 5000, maxCount = 1 },
	{ id = 60428, chance = 5000, maxCount = 1 },
	{ id = 60429, chance = 5000, maxCount = 1 },
	{ id = 58051, chance = 5000, maxCount = 1 },
	{ id = 58052, chance = 5000, maxCount = 1 },
	{ id = 58053, chance = 5000, maxCount = 1 },
	{ id = 58054, chance = 5000, maxCount = 1 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -9000 },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_DEATHDAMAGE, minDamage = -4000, maxDamage = -9000, radius = 9, effect = CONST_ME_MORTAREA, target = false },
	{ name = "speed", interval = 2000, chance = 15, speedChange = -850, radius = 6, effect = CONST_ME_POISONAREA, target = false, duration = 20000 },
	{ name = "combat", interval = 2000, chance = 18, type = COMBAT_FIREDAMAGE, minDamage = -3000, maxDamage = -8000, range = 7, radius = 7, shootEffect = CONST_ANI_FIRE, effect = CONST_ME_FIREAREA, target = true },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_MANADRAIN, minDamage = -2000, maxDamage = -5000, radius = 10, effect = CONST_ME_ENERGYAREA, target = false },
	{ name = "combat", interval = 2000, chance = 18, type = COMBAT_ENERGYDAMAGE, minDamage = -4000, maxDamage = -8000, length = 8, spread = 0, effect = CONST_ME_MAGIC_RED, target = false },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_LIFEDRAIN, minDamage = -3000, maxDamage = -7000, radius = 14, effect = CONST_ME_MAGIC_GREEN, target = false },
}

monster.defenses = {
	defense = 80,
	armor = 80,
	--	mitigation = ???,
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_HEALING, minDamage = 2000, maxDamage = 4000, effect = CONST_ME_MAGIC_BLUE, target = false },
	{ name = "speed", interval = 2000, chance = 15, speedChange = 480, effect = CONST_ME_MAGIC_RED, target = false, duration = 6000 },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 100 },
	{ type = COMBAT_EARTHDAMAGE, percent = 100 },
	{ type = COMBAT_FIREDAMAGE, percent = 100 },
	{ type = COMBAT_LIFEDRAIN, percent = 100 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 10 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 1 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
