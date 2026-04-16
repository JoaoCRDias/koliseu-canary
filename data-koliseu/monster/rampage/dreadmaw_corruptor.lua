local mType = Game.createMonsterType("Dreadmaw Corruptor")
local monster = {}

monster.description = "a dreadmaw corruptor"
monster.experience = 63300
monster.outfit = {
	lookType = 1262,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 2727
monster.Bestiary = {
	class = "Undead",
	race = BESTY_RACE_UNDEAD,
	toKill = 5000,
	FirstUnlock = 500,
	SecondUnlock = 1000,
	CharmsPoints = 100,
	Stars = 5,
	Occurrence = 0,
	Locations = "Plaguefiend Depths.",
}

monster.health = 96010
monster.maxHealth = 96010
monster.race = "undead"
monster.corpse = 6068
monster.speed = 820
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 20,
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
	rewardBoss = false,
	illusionable = false,
	canPushItems = true,
	canPushCreatures = true,
	staticAttackChance = 70,
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
	{ text = "CORRUPTION SPREADS!", yell = true },
	{ text = "YOUR SOUL IS MINE!", yell = true },
}

monster.loot = {
	{ name = "crystal coin", chance = 57000, maxCount = 3 },
	{ name = "gold ingot", chance = 23000, maxCount = 1 },
	{ name = "violet gem", chance = 12000 },
	{ name = "blue gem", chance = 12000 },
	{ name = "green gem", chance = 12000 },
	{ name = "yellow gem", chance = 12000 },
	{ name = "giant sapphire", chance = 6000 },
	{ name = "giant emerald", chance = 3500 },
	{ name = "giant ruby", chance = 3500 },
	{ name = "giant amethyst", chance = 3500 },
	{ name = "giant topaz", chance = 3500 },
	{ name = "boots of haste", chance = 17000 },
	{ name = "demonic essence", chance = 35000, maxCount = 2 },
	{ name = "soul orb", chance = 65000, maxCount = 3 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -6588 },
	{ name = "combat", interval = 2000, chance = 17, type = COMBAT_DEATHDAMAGE, minDamage = -5355, maxDamage = -6954, range = 7, shootEffect = CONST_ANI_DEATH, effect = CONST_ME_MORTAREA, target = false },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_EARTHDAMAGE, minDamage = -5355, maxDamage = -6954, range = 7, radius = 3, shootEffect = CONST_ANI_POISONARROW, effect = CONST_ME_BIGPLANTS, target = false },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_PHYSICALDAMAGE, minDamage = -5355, maxDamage = -6954, range = 7, radius = 2, shootEffect = CONST_ANI_LARGEROCK, effect = CONST_ME_STONES, target = false },
}

monster.defenses = {
	defense = 298,
	armor = 298,
	mitigation = 20.15,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 5 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -15 },
	{ type = COMBAT_EARTHDAMAGE, percent = 40 },
	{ type = COMBAT_FIREDAMAGE, percent = -20 },
	{ type = COMBAT_LIFEDRAIN, percent = 100 },
	{ type = COMBAT_MANADRAIN, percent = 100 },
	{ type = COMBAT_DROWNDAMAGE, percent = 100 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = -25 },
	{ type = COMBAT_DEATHDAMAGE, percent = 40 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
