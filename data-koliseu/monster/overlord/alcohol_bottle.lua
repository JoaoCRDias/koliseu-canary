local mType = Game.createMonsterType("Alcohol Bottle")
local monster = {}

monster.description = "an alcohol bottle"
monster.experience = 870000
monster.outfit = {
	lookTypeEx = 6106,
}

monster.raceId = 2744
monster.Bestiary = {
	class = "Demon",
	race = BESTY_RACE_DEMON,
	toKill = 5000,
	FirstUnlock = 500,
	SecondUnlock = 1000,
	CharmsPoints = 100,
	Stars = 5,
	Occurrence = 0,
	Locations = "Gloomcaster Sanctum.",
}

monster.health = 1000000
monster.maxHealth = 1000000
monster.race = "blood"
monster.corpse = 6068
monster.speed = 855
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
	{ text = "DRINK UNTIL YOU DROWN!", yell = true },
	{ text = "THE SPIRITS HUNGER FOR YOUR SOUL!", yell = true },
}

monster.loot = {
	{ name = "crystal coin", chance = 60000, maxCount = 5 },
	{ name = "gold ingot", chance = 30000, maxCount = 2 },
	{ name = "violet gem", chance = 10000 },
	{ name = "blue gem", chance = 10000 },
	{ name = "green gem", chance = 10000 },
	{ name = "yellow gem", chance = 10000 },
	{ name = "giant sapphire", chance = 5000 },
	{ name = "giant emerald", chance = 3000 },
	{ name = "giant ruby", chance = 3000 },
	{ name = "giant amethyst", chance = 3000 },
	{ name = "giant topaz", chance = 3000 },
	{ name = "boots of haste", chance = 15000 },
	{ name = "demonic essence", chance = 30000, maxCount = 2 },
	{ name = "soul orb", chance = 60000, maxCount = 3 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -6210 },
	{ name = "combat", interval = 2000, chance = 25, type = COMBAT_FIREDAMAGE, minDamage = -5047, maxDamage = -6555, range = 7, radius = 3, shootEffect = CONST_ANI_FIRE, effect = CONST_ME_FIREAREA, target = false },
	{ name = "combat", interval = 2000, chance = 22, type = COMBAT_POISONDAMAGE, minDamage = -5047, maxDamage = -6555, range = 7, radius = 2, shootEffect = CONST_ANI_POISONARROW, effect = CONST_ME_POISONAREA, target = false },
	{ name = "combat", interval = 2000, chance = 18, type = COMBAT_DEATHDAMAGE, minDamage = -5047, maxDamage = -6555, range = 7, radius = 2, shootEffect = CONST_ANI_DEATH, effect = CONST_ME_MORTAREA, target = false },
}

monster.defenses = {
	defense = 281,
	armor = 281,
	mitigation = 32.00,
	{ name = "combat", interval = 2000, chance = 38, type = COMBAT_HEALING, minDamage = 7500, maxDamage = 15000, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 10 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 10 },
	{ type = COMBAT_EARTHDAMAGE, percent = 60 },
	{ type = COMBAT_FIREDAMAGE, percent = -15 },
	{ type = COMBAT_LIFEDRAIN, percent = 100 },
	{ type = COMBAT_MANADRAIN, percent = 100 },
	{ type = COMBAT_DROWNDAMAGE, percent = 100 },
	{ type = COMBAT_ICEDAMAGE, percent = -5 },
	{ type = COMBAT_HOLYDAMAGE, percent = -5 },
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
