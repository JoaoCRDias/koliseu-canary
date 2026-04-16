local mType = Game.createMonsterType("Carrion Monarch")
local monster = {}

monster.description = "a carrion monarch"
monster.experience = 48240
monster.outfit = {
	lookType = 3075,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 2700
monster.Bestiary = {
	class = "Demon",
	race = BESTY_RACE_DEMON,
	toKill = 5000,
	FirstUnlock = 500,
	SecondUnlock = 2500,
	CharmsPoints = 100,
	Stars = 5,
	Occurrence = 0,
	Locations = "Teleports Room.",
}

monster.events = {
	"TheMasterOfPotionsCreatureEvent",
}

monster.health = 73188
monster.maxHealth = 73188
monster.race = "undead"
monster.corpse = 6068
monster.speed = 350
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
	{ text = "SSSSHRRR...", yell = false },
	{ text = "*twiggle*", yell = false },
}

monster.loot = {
	{ name = "golden legs", chance = 5000 },
	{ name = "small emerald", chance = 20000, maxCount = 10 },
	{ name = "crystal coin", chance = 15000, maxCount = 1 },
	{ name = "demonic essence", chance = 14630 },
	{ name = "demon shield", chance = 7400 },
	{ name = "demonrage sword", chance = 7000 },
	{ id = 43854, chance = 100 }, -- tainted heart (1 in 1000)
	{ id = 43855, chance = 100 }, -- darklight heart (1 in 1000)
	{ id = 34109, chance = 20 }, -- bag you desire (1 in 5000)
	{ id = 39546, chance = 20 }, -- primal bag (1 in 5000)
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -5232 },
	{ name = "combat", interval = 1700, chance = 15, type = COMBAT_EARTHDAMAGE, minDamage = -4253, maxDamage = -5523, radius = 3, shootEffect = CONST_ANI_ENVENOMEDARROW, effect = CONST_ME_HITBYPOISON, target = true },
	{ name = "combat", interval = 1700, chance = 25, type = COMBAT_ENERGYDAMAGE, minDamage = -4253, maxDamage = -5523, length = 4, spread = 0, effect = CONST_ME_ENERGYHIT, target = false },
	{ name = "combat", interval = 1700, chance = 35, type = COMBAT_DEATHDAMAGE, minDamage = -4253, maxDamage = -5523, radius = 3, effect = CONST_ME_MORTAREA, target = false },
	{ name = "combat", interval = 1700, chance = 35, type = COMBAT_HOLYDAMAGE, minDamage = -4253, maxDamage = -5523, radius = 3, effect = CONST_ME_HOLYAREA, target = false },
	{ name = "combat", interval = 1700, chance = 13, type = COMBAT_ENERGYDAMAGE, minDamage = -4253, maxDamage = -5523, range = 4, radius = 4, effect = CONST_ME_ENERGYAREA, target = true },
	{ name = "kingdom skill reducer", interval = 2000, chance = 20, target = false },
}

monster.defenses = {
	defense = 189,
	armor = 189,
	mitigation = 2.28,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 50 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -20 },
	{ type = COMBAT_EARTHDAMAGE, percent = -20 },
	{ type = COMBAT_FIREDAMAGE, percent = -20 },
	{ type = COMBAT_LIFEDRAIN, percent = 100 },
	{ type = COMBAT_MANADRAIN, percent = 100 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -20 },
	{ type = COMBAT_HOLYDAMAGE, percent = 50 },
	{ type = COMBAT_DEATHDAMAGE, percent = -20 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
