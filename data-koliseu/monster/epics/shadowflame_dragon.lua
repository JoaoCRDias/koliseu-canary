local mType = Game.createMonsterType("Shadowflame Dragon")
local monster = {}

monster.description = "a shadowflame dragon"
monster.experience = 47640
monster.outfit = {
	lookType = 3011,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 2713
monster.Bestiary = {
	class = "Demon",
	race = BESTY_RACE_DEMON,
	toKill = 5000,
	FirstUnlock = 500,
	SecondUnlock = 1000,
	CharmsPoints = 100,
	Stars = 5,
	Occurrence = 0,
	Locations = "Teleports Room.",
}

monster.health = 72240
monster.maxHealth = 72240
monster.race = "fire"
monster.corpse = 6068
monster.speed = 330
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
	{ text = "From shadows I rise... in flames you will fall!", yell = false },
	{ text = "I am the shadowflame dragon!", yell = false },
	{ text = "I will not be broken!", yell = false },
}

monster.events = {
	"TheMasterOfPotionsCreatureEvent",
}

monster.loot = {
	{ name = "crystal coin", chance = 15000, maxCount = 1 },
	{ name = "boots of haste", chance = 2560 },
	{ name = "piece of hell steel", chance = 10260, maxCount = 3 },
	{ name = "blue gem", chance = 10260 },
	{ name = "green gem", chance = 10260 },
	{ name = "lightning legs", chance = 7690 },
	{ name = "small emerald", chance = 25640, maxCount = 10 },
	{ name = "small amethyst", chance = 25640, maxCount = 12 },
	{ name = "small topaz", chance = 20510, maxCount = 10 },
	{ name = "small ruby", chance = 17950, maxCount = 18 },
	{ name = "spellbook of warding", chance = 15380 },
	{ id = 43854, chance = 100 }, -- tainted heart (1 in 1000)
	{ id = 43855, chance = 100 }, -- darklight heart (1 in 1000)
	{ id = 34109, chance = 20 }, -- bag you desire (1 in 5000)
	{ id = 39546, chance = 20 }, -- primal bag (1 in 5000)
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -5164 },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_FIREDAMAGE, minDamage = -4198, maxDamage = -5452, range = 7, shootEffect = CONST_ANI_FIRE, effect = CONST_ME_FIREAREA, target = true },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_ENERGYDAMAGE, minDamage = -4198, maxDamage = -5452, range = 7, radius = 4, shootEffect = CONST_ANI_FIRE, effect = CONST_ME_FIREAREA, target = true },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_EARTHDAMAGE, minDamage = -4198, maxDamage = -5452, radius = 5, effect = CONST_ME_BLOCKHIT, target = false },
	{ name = "condition", type = CONDITION_FIRE, interval = 2000, chance = 15, minDamage = -4198, maxDamage = -5452, radius = 5, effect = CONST_ME_FIREAREA, target = false },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_FIREDAMAGE, minDamage = -4198, maxDamage = -5452, length = 9, spread = 4, effect = CONST_ME_FIREAREA, target = false },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_FIREDAMAGE, minDamage = -4198, maxDamage = -5452, length = 9, spread = 3, effect = CONST_ME_HITBYFIRE, target = false },
}

monster.defenses = {
	defense = 187,
	armor = 187,
	mitigation = 8.28,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 100 },
	{ type = COMBAT_MANADRAIN, percent = 100 },
	{ type = COMBAT_DROWNDAMAGE, percent = 100 },
	{ type = COMBAT_ICEDAMAGE, percent = -10 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
