local mType = Game.createMonsterType("Wrathborn Fury")
local monster = {}

monster.description = "a wrathborn fury"
monster.experience = 47640
monster.outfit = {
	lookType = 360,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 2810
monster.Bestiary = {
	class = "Demon",
	race = BESTY_RACE_DEMON,
	toKill = 5000,
	FirstUnlock = 500,
	SecondUnlock = 2500,
	CharmsPoints = 100,
	Stars = 5,
	Occurrence = 0,
	Locations = "Fury Pits.",
}

monster.health = 72240
monster.maxHealth = 72240
monster.race = "fire"
monster.corpse = 6068
monster.speed = 360
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
	{ text = "Wrath consumes all!", yell = false },
	{ text = "SUFFER MY VENGEANCE!", yell = true },
}

monster.loot = {
	{ name = "crystal coin", chance = 15000, maxCount = 1 },
	{ name = "platinum coin", chance = 55000, maxCount = 10 },
	{ name = "violet gem", chance = 10000 },
	{ name = "blue gem", chance = 8000 },
	{ name = "magma legs", chance = 2500 },
	{ name = "demon shield", chance = 3500 },
	{ name = "boots of haste", chance = 5000 },
	{ id = 43854, chance = 100 }, -- tainted heart (1 in 1000)
	{ id = 43855, chance = 100 }, -- darklight heart (1 in 1000)
	{ id = 34109, chance = 20 }, -- bag you desire (1 in 5000)
	{ id = 39546, chance = 20 }, -- primal bag (1 in 5000)
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, type = COMBAT_FIREDAMAGE, minDamage = 0, maxDamage = -5164 },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_FIREDAMAGE, minDamage = -4198, maxDamage = -5452, range = 7, radius = 3, shootEffect = CONST_ANI_FIRE, effect = CONST_ME_FIREAREA, target = false },
	{ name = "combat", interval = 2000, chance = 17, type = COMBAT_DEATHDAMAGE, minDamage = -4198, maxDamage = -5452, radius = 3, effect = CONST_ME_MORTAREA, target = false },
	{ name = "combat", interval = 2000, chance = 12, type = COMBAT_LIFEDRAIN, minDamage = -4198, maxDamage = -5452, length = 7, spread = 0, effect = CONST_ME_MAGIC_RED, target = false },
}

monster.defenses = {
	defense = 187,
	armor = 187,
	mitigation = 5.30,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = -10 },
	{ type = COMBAT_FIREDAMAGE, percent = 100 },
	{ type = COMBAT_LIFEDRAIN, percent = 100 },
	{ type = COMBAT_MANADRAIN, percent = 100 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -25 },
	{ type = COMBAT_HOLYDAMAGE, percent = -20 },
	{ type = COMBAT_DEATHDAMAGE, percent = 15 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
