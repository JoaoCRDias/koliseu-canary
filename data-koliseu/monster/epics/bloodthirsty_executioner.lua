local mType = Game.createMonsterType("Bloodthirsty Executioner")
local monster = {}

monster.description = "a bloodthirsty executioner"
monster.experience = 44280
monster.outfit = {
	lookType = 3072,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 2697
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

monster.health = 67044
monster.maxHealth = 67044
monster.race = "blood"
monster.corpse = 6068
monster.speed = 270
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 20,
}

monster.events = {
	"TheMasterOfPotionsCreatureEvent",
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
	{ text = "Feel the blood pain!", yell = false },

}

monster.loot = {
	{ name = "crystal coin", chance = 15000, maxCount = 1 },
	{ name = "small amethyst", chance = 10090, maxCount = 5 },
	{ name = "small topaz", chance = 9790, maxCount = 5 },
	{ name = "small emerald", chance = 9770, maxCount = 5 },
	{ name = "small ruby", chance = 9590, maxCount = 5 },
	{ name = "fire axe", chance = 3520 },
	{ name = "rift lance", chance = 3360 },
	{ name = "rift shield", chance = 3700 },
	{ name = "demon shield", chance = 3700 },
	{ name = "magic plate armor", chance = 1000 },
	{ name = "golden legs", chance = 5000 },
	{ name = "demonrage sword", chance = 3000 },
	{ id = 43854, chance = 100 }, -- tainted heart (1 in 1000)
	{ id = 43855, chance = 100 }, -- darklight heart (1 in 1000)
	{ id = 34109, chance = 20 }, -- bag you desire (1 in 5000)
	{ id = 39546, chance = 20 }, -- primal bag (1 in 5000)
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, type = COMBAT_ENERGYDAMAGE, minDamage = 0, maxDamage = -4793 },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_DEATHDAMAGE, minDamage = -3895, maxDamage = -5059, range = 7, shootEffect = CONST_ANI_SUDDENDEATH, effect = CONST_ME_SMALLCLOUDS, target = false },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_LIFEDRAIN, minDamage = -3895, maxDamage = -5059, length = 8, spread = 3, effect = CONST_ME_MAGIC_RED, target = false },
}

monster.defenses = {
	defense = 173,
	armor = 173,
	mitigation = 5.28,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 15 },
	{ type = COMBAT_EARTHDAMAGE, percent = 15 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 100 },
	{ type = COMBAT_MANADRAIN, percent = 100 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
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
