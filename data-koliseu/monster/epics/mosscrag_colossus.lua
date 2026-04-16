local mType = Game.createMonsterType("Mosscrag Colossus")
local monster = {}

monster.description = "a mosscrag colossus"
monster.experience = 48240
monster.outfit = {
	lookType = 1550,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 2794
monster.Bestiary = {
	class = "Reptile",
	race = BESTY_RACE_REPTILE,
	toKill = 5000,
	FirstUnlock = 500,
	SecondUnlock = 2500,
	CharmsPoints = 100,
	Stars = 5,
	Occurrence = 0,
	Locations = "Tortoise Bastion.",
}

monster.health = 73188
monster.maxHealth = 73188
monster.race = "blood"
monster.corpse = 6068
monster.speed = 280
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
	{ text = "THE EARTH TREMBLES!", yell = true },
	{ text = "Moss and stone are eternal!", yell = false },
}

monster.loot = {
	{ name = "crystal coin", chance = 15000, maxCount = 1 },
	{ name = "platinum coin", chance = 55000, maxCount = 10 },
	{ name = "green gem", chance = 10000 },
	{ name = "violet gem", chance = 8000 },
	{ name = "war axe", chance = 4000 },
	{ name = "demonbone amulet", chance = 3000 },
	{ name = "boots of haste", chance = 5000 },
	{ id = 43854, chance = 100 }, -- tainted heart (1 in 1000)
	{ id = 43855, chance = 100 }, -- darklight heart (1 in 1000)
	{ id = 34109, chance = 20 }, -- bag you desire (1 in 5000)
	{ id = 39546, chance = 20 }, -- primal bag (1 in 5000)
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -5232 },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_EARTHDAMAGE, minDamage = -4253, maxDamage = -5523, radius = 5, effect = CONST_ME_BIGPLANTS, target = false },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_PHYSICALDAMAGE, minDamage = -4253, maxDamage = -5523, range = 7, shootEffect = CONST_ANI_LARGEROCK, effect = CONST_ME_STONES, target = true },
	{ name = "combat", interval = 2000, chance = 12, type = COMBAT_ICEDAMAGE, minDamage = -4253, maxDamage = -5523, length = 6, spread = 0, effect = CONST_ME_ICEATTACK, target = false },
}

monster.defenses = {
	defense = 189,
	armor = 189,
	mitigation = 6.30,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 30 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -20 },
	{ type = COMBAT_EARTHDAMAGE, percent = 35 },
	{ type = COMBAT_FIREDAMAGE, percent = -20 },
	{ type = COMBAT_LIFEDRAIN, percent = 100 },
	{ type = COMBAT_MANADRAIN, percent = 100 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 20 },
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
