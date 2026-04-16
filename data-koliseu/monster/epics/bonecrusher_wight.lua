local mType = Game.createMonsterType("Bonecrusher Wight")
local monster = {}

monster.description = "a bonecrusher wight"
monster.experience = 44880
monster.outfit = {
	lookType = 87,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 2784
monster.Bestiary = {
	class = "Undead",
	race = BESTY_RACE_UNDEAD,
	toKill = 5000,
	FirstUnlock = 500,
	SecondUnlock = 2500,
	CharmsPoints = 100,
	Stars = 5,
	Occurrence = 0,
	Locations = "Undead Wastelands.",
}

monster.health = 67992
monster.maxHealth = 67992
monster.race = "undead"
monster.corpse = 6068
monster.speed = 275
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

monster.events = {
	"TheMasterOfPotionsCreatureEvent",
}

monster.summon = {}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "Your bones will shatter!", yell = false },
	{ text = "I will grind you to dust!", yell = false },
}

monster.loot = {
	{ name = "crystal coin", chance = 15000, maxCount = 1 },
	{ name = "platinum coin", chance = 70000, maxCount = 8 },
	{ name = "small ruby", chance = 4000, maxCount = 3 },
	{ name = "bonebreaker", chance = 5000 },
	{ name = "war axe", chance = 3500 },
	{ name = "demon shield", chance = 3000 },
	{ id = 43854, chance = 100 }, -- tainted heart (1 in 1000)
	{ id = 43855, chance = 100 }, -- darklight heart (1 in 1000)
	{ id = 34109, chance = 20 }, -- bag you desire (1 in 5000)
	{ id = 39546, chance = 20 }, -- primal bag (1 in 5000)
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, type = COMBAT_PHYSICALDAMAGE, minDamage = 0, maxDamage = -4860 },
	{ name = "combat", interval = 2000, chance = 17, type = COMBAT_DEATHDAMAGE, minDamage = -3950, maxDamage = -5130, range = 7, shootEffect = CONST_ANI_SUDDENDEATH, effect = CONST_ME_MORTAREA, target = true },
	{ name = "combat", interval = 2000, chance = 14, type = COMBAT_PHYSICALDAMAGE, minDamage = -3950, maxDamage = -5130, radius = 3, effect = CONST_ME_GROUNDSHAKER, target = false },
}

monster.defenses = {
	defense = 176,
	armor = 176,
	mitigation = 4.10,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 10 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -10 },
	{ type = COMBAT_EARTHDAMAGE, percent = 15 },
	{ type = COMBAT_FIREDAMAGE, percent = -10 },
	{ type = COMBAT_LIFEDRAIN, percent = 100 },
	{ type = COMBAT_MANADRAIN, percent = 100 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 10 },
	{ type = COMBAT_HOLYDAMAGE, percent = -25 },
	{ type = COMBAT_DEATHDAMAGE, percent = 100 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
