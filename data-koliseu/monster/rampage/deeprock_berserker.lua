local mType = Game.createMonsterType("Deeprock Berserker")
local monster = {}

monster.description = "a deeprock berserker"
monster.experience = 75800
monster.outfit = {
	lookType = 3231,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 2749
monster.Bestiary = {
	class = "Humanoid",
	race = BESTY_RACE_HUMANOID,
	toKill = 5000,
	FirstUnlock = 500,
	SecondUnlock = 1000,
	CharmsPoints = 100,
	Stars = 5,
	Occurrence = 0,
	Locations = "Deeprock Mines.",
}

monster.health = 114890
monster.maxHealth = 114890
monster.race = "blood"
monster.corpse = 6068
monster.speed = 845
monster.manaCost = 0

monster.changeTarget = {
	interval = 3000,
	chance = 25,
}

monster.strategiesTarget = {
	nearest = 80,
	health = 5,
	damage = 10,
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
	level = 0,
	color = 0,
}

monster.summon = {}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "RAGE OF THE DEEP CONSUME YOU!", yell = true },
	{ text = "I FEEL NO PAIN!", yell = true },
}

monster.loot = {
	{ name = "crystal coin", chance = 95000, maxCount = 5 },
	{ name = "gold ingot", chance = 50000, maxCount = 2 },
	{ name = "violet gem", chance = 22000 },
	{ name = "blue gem", chance = 22000 },
	{ name = "green gem", chance = 22000 },
	{ name = "yellow gem", chance = 18000 },
	{ name = "giant sapphire", chance = 16000 },
	{ name = "giant emerald", chance = 10000 },
	{ name = "giant ruby", chance = 10000 },
	{ name = "giant amethyst", chance = 10000 },
	{ name = "giant topaz", chance = 10000 },
	{ name = "boots of haste", chance = 35000 },
	{ name = "demonic essence", chance = 60000, maxCount = 3 },
	{ name = "soul orb", chance = 85000, maxCount = 5 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -7884 },
	{ name = "combat", interval = 2000, chance = 22, type = COMBAT_EARTHDAMAGE, minDamage = -6408, maxDamage = -8322, range = 7, radius = 3, shootEffect = CONST_ANI_SMALLEARTH, effect = CONST_ME_GREEN_RINGS, target = false },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_PHYSICALDAMAGE, minDamage = -6408, maxDamage = -8322, range = 7, radius = 2, shootEffect = CONST_ANI_LARGEROCK, effect = CONST_ME_STONES, target = false },
}

monster.defenses = {
	defense = 356,
	armor = 356,
	mitigation = 26.45,
	{ name = "combat", interval = 2000, chance = 40, type = COMBAT_HEALING, minDamage = 7500, maxDamage = 15000, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 15 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -20 },
	{ type = COMBAT_EARTHDAMAGE, percent = 40 },
	{ type = COMBAT_FIREDAMAGE, percent = -30 },
	{ type = COMBAT_LIFEDRAIN, percent = 100 },
	{ type = COMBAT_MANADRAIN, percent = 100 },
	{ type = COMBAT_DROWNDAMAGE, percent = 100 },
	{ type = COMBAT_ICEDAMAGE, percent = -20 },
	{ type = COMBAT_HOLYDAMAGE, percent = -20 },
	{ type = COMBAT_DEATHDAMAGE, percent = 25 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
