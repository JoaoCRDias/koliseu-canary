local mType = Game.createMonsterType("Vault Guardian")
local monster = {}

monster.description = "a vault guardian"
monster.experience = 75000
monster.outfit = {
	lookType = 3232,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 2767
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

monster.health = 113720
monster.maxHealth = 113720
monster.race = "blood"
monster.corpse = 6068
monster.speed = 820
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 15,
}

monster.strategiesTarget = {
	nearest = 80,
	health = 10,
	damage = 5,
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
	{ text = "THE VAULT SHALL NOT BE BREACHED!", yell = true },
	{ text = "TRESPASSERS WILL BE CRUSHED!", yell = true },
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
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -7803 },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_PHYSICALDAMAGE, minDamage = -6342, maxDamage = -8237, range = 7, radius = 3, shootEffect = CONST_ANI_LARGEROCK, effect = CONST_ME_STONES, target = false },
	{ name = "combat", interval = 2000, chance = 18, type = COMBAT_EARTHDAMAGE, minDamage = -6342, maxDamage = -8237, range = 7, radius = 2, shootEffect = CONST_ANI_SMALLEARTH, effect = CONST_ME_GREEN_RINGS, target = false },
}

monster.defenses = {
	defense = 353,
	armor = 353,
	mitigation = 26.68,
	{ name = "combat", interval = 2000, chance = 40, type = COMBAT_HEALING, minDamage = 7500, maxDamage = 15000, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 20 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -20 },
	{ type = COMBAT_EARTHDAMAGE, percent = 35 },
	{ type = COMBAT_FIREDAMAGE, percent = -25 },
	{ type = COMBAT_LIFEDRAIN, percent = 100 },
	{ type = COMBAT_MANADRAIN, percent = 100 },
	{ type = COMBAT_DROWNDAMAGE, percent = 100 },
	{ type = COMBAT_ICEDAMAGE, percent = -15 },
	{ type = COMBAT_HOLYDAMAGE, percent = -20 },
	{ type = COMBAT_DEATHDAMAGE, percent = 20 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
