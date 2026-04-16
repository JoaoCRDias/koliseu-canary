local mType = Game.createMonsterType("Cinder Behemoth")
local monster = {}

monster.description = "a cinder behemoth"
monster.experience = 49800
monster.outfit = {
	lookType = 490,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 2785
monster.Bestiary = {
	class = "Elemental",
	race = BESTY_RACE_ELEMENTAL,
	toKill = 5000,
	FirstUnlock = 500,
	SecondUnlock = 2500,
	CharmsPoints = 100,
	Stars = 5,
	Occurrence = 0,
	Locations = "Molten Depths.",
}

monster.health = 75552
monster.maxHealth = 75552
monster.race = "fire"
monster.corpse = 6068
monster.speed = 345
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
	{ text = "CINDER AND ASH!", yell = true },
	{ text = "The volcano feeds my power!", yell = false },
}

monster.loot = {
	{ name = "crystal coin", chance = 15000, maxCount = 1 },
	{ name = "platinum coin", chance = 50000, maxCount = 10 },
	{ name = "violet gem", chance = 10000 },
	{ name = "yellow gem", chance = 8000 },
	{ name = "fire axe", chance = 4000 },
	{ name = "magma legs", chance = 2500 },
	{ name = "boots of haste", chance = 7000 },
	{ id = 43854, chance = 100 }, -- tainted heart (1 in 1000)
	{ id = 43855, chance = 100 }, -- darklight heart (1 in 1000)
	{ id = 34109, chance = 20 }, -- bag you desire (1 in 5000)
	{ id = 39546, chance = 20 }, -- primal bag (1 in 5000)
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, type = COMBAT_FIREDAMAGE, minDamage = 0, maxDamage = -5400 },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_FIREDAMAGE, minDamage = -4389, maxDamage = -5700, radius = 5, effect = CONST_ME_FIREAREA, target = false },
	{ name = "combat", interval = 2000, chance = 17, type = COMBAT_EARTHDAMAGE, minDamage = -4389, maxDamage = -5700, range = 7, shootEffect = CONST_ANI_FIRE, effect = CONST_ME_HITBYFIRE, target = true },
	{ name = "combat", interval = 2000, chance = 12, type = COMBAT_PHYSICALDAMAGE, minDamage = -4389, maxDamage = -5700, length = 7, spread = 0, effect = CONST_ME_GROUNDSHAKER, target = false },
}

monster.defenses = {
	defense = 195,
	armor = 195,
	mitigation = 5.60,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 5 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 25 },
	{ type = COMBAT_FIREDAMAGE, percent = 100 },
	{ type = COMBAT_LIFEDRAIN, percent = 100 },
	{ type = COMBAT_MANADRAIN, percent = 100 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -30 },
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
