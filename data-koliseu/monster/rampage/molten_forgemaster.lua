local mType = Game.createMonsterType("Molten Forgemaster")
local monster = {}

monster.description = "a molten forgemaster"
monster.experience = 77900
monster.outfit = {
	lookType = 3235,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 2756
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

monster.health = 118040
monster.maxHealth = 118040
monster.race = "blood"
monster.corpse = 6068
monster.speed = 835
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
	staticAttackChance = 75,
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
	{ text = "THE MOLTEN FORGE IS MY SOUL!", yell = true },
	{ text = "I WAS BORN IN FIRE AND STONE!", yell = true },
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
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -8100 },
	{ name = "combat", interval = 2000, chance = 22, type = COMBAT_FIREDAMAGE, minDamage = -6584, maxDamage = -8550, range = 7, radius = 3, shootEffect = CONST_ANI_FIRE, effect = CONST_ME_FIREAREA, target = false },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_EARTHDAMAGE, minDamage = -6584, maxDamage = -8550, range = 7, radius = 2, shootEffect = CONST_ANI_SMALLEARTH, effect = CONST_ME_GREEN_RINGS, target = false },
}

monster.defenses = {
	defense = 366,
	armor = 366,
	mitigation = 23.50,
	{ name = "combat", interval = 2000, chance = 42, type = COMBAT_HEALING, minDamage = 7500, maxDamage = 15000, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 15 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -20 },
	{ type = COMBAT_EARTHDAMAGE, percent = 30 },
	{ type = COMBAT_FIREDAMAGE, percent = 50 },
	{ type = COMBAT_LIFEDRAIN, percent = 100 },
	{ type = COMBAT_MANADRAIN, percent = 100 },
	{ type = COMBAT_DROWNDAMAGE, percent = 100 },
	{ type = COMBAT_ICEDAMAGE, percent = -35 },
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
