local mType = Game.createMonsterType("Dark Executioner")
local monster = {}

monster.description = "a dark executioner"
monster.experience = 44880
monster.outfit = {
	lookType = 3073,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 2703
monster.Bestiary = {
	class = "Human",
	race = BESTY_RACE_HUMAN,
	toKill = 5000,
	FirstUnlock = 500,
	SecondUnlock = 2500,
	CharmsPoints = 100,
	Stars = 5,
	Occurrence = 0,
	Locations = "Teleports Room.",
}

monster.health = 67992
monster.maxHealth = 67992
monster.race = "blood"
monster.corpse = 6068
monster.speed = 270
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
	{ text = "You will be executed!", yell = false },
	{ text = "Your soul is mine!", yell = false },
	{ text = "Feel the darkness!", yell = false },

}

monster.loot = {
	{ name = "crystal coin", chance = 15000, maxCount = 1 },
	{ name = "small diamond", chance = 41000, maxCount = 2 },
	{ name = "small emerald", chance = 40000, maxCount = 2 },
	{ name = "small amethyst", chance = 40000, maxCount = 3 },
	{ name = "small ruby", chance = 20700, maxCount = 2 },
	{ name = "small topaz", chance = 20100, maxCount = 2 },
	{ name = "golden armor", chance = 2010 },
	{ name = "mastermind shield", chance = 3010 },
	{ name = "butcher's axe", chance = 1250 },
	{ name = "gold ingot", chance = 3140 },
	{ id = 43854, chance = 100 }, -- tainted heart (1 in 1000)
	{ id = 43855, chance = 100 }, -- darklight heart (1 in 1000)
	{ id = 34109, chance = 20 }, -- bag you desire (1 in 5000)
	{ id = 39546, chance = 20 }, -- primal bag (1 in 5000)
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, type = COMBAT_ENERGYDAMAGE, minDamage = 0, maxDamage = -4860, condition = { type = CONDITION_FIRE, totalDamage = 100, interval = 2000 } },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_DEATHDAMAGE, minDamage = -3950, maxDamage = -5130, range = 7, shootEffect = CONST_ANI_THROWINGKNIFE, target = false },
}

monster.defenses = {
	defense = 176,
	armor = 176,
	mitigation = 5.28,
}

monster.events = {
	"TheMasterOfPotionsCreatureEvent",
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 10 },
	{ type = COMBAT_EARTHDAMAGE, percent = 10 },
	{ type = COMBAT_FIREDAMAGE, percent = -5 },
	{ type = COMBAT_LIFEDRAIN, percent = 100 },
	{ type = COMBAT_MANADRAIN, percent = 100 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -10 },
	{ type = COMBAT_HOLYDAMAGE, percent = -5 },
	{ type = COMBAT_DEATHDAMAGE, percent = -10 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
