local mType = Game.createMonsterType("Crossbow Rifleman")
local monster = {}

monster.description = "a crossbow rifleman"
monster.experience = 74500
monster.outfit = {
	lookType = 3230,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 2748
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

monster.health = 112920
monster.maxHealth = 112920
monster.race = "blood"
monster.corpse = 6068
monster.speed = 835
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 15,
}

monster.strategiesTarget = {
	nearest = 60,
	health = 15,
	damage = 15,
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
	staticAttackChance = 60,
	targetDistance = 5,
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
	{ text = "STEADY AIM, QUICK KILL!", yell = true },
	{ text = "YOU CANNOT HIDE FROM MY BOLTS!", yell = true },
}

monster.loot = {
	{ name = "crystal coin", chance = 90000, maxCount = 4 },
	{ name = "gold ingot", chance = 45000, maxCount = 2 },
	{ name = "violet gem", chance = 20000 },
	{ name = "blue gem", chance = 20000 },
	{ name = "green gem", chance = 20000 },
	{ name = "yellow gem", chance = 15000 },
	{ name = "giant sapphire", chance = 14000 },
	{ name = "giant emerald", chance = 8000 },
	{ name = "giant ruby", chance = 8000 },
	{ name = "giant amethyst", chance = 8000 },
	{ name = "giant topaz", chance = 8000 },
	{ name = "boots of haste", chance = 32000 },
	{ name = "demonic essence", chance = 55000, maxCount = 3 },
	{ name = "soul orb", chance = 80000, maxCount = 4 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -7749 },
	{ name = "combat", interval = 2000, chance = 28, type = COMBAT_PHYSICALDAMAGE, minDamage = -6299, maxDamage = -8180, range = 7, shootEffect = CONST_ANI_BOLT, effect = CONST_ME_STONES, target = true },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_EARTHDAMAGE, minDamage = -6299, maxDamage = -8180, range = 7, radius = 2, shootEffect = CONST_ANI_POISONARROW, effect = CONST_ME_GREEN_RINGS, target = false },
}

monster.defenses = {
	defense = 350,
	armor = 350,
	mitigation = 21.80,
	{ name = "combat", interval = 2000, chance = 30, type = COMBAT_HEALING, minDamage = 45000, maxDamage = 90000, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 10 },
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
