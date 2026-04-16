local mType = Game.createMonsterType("Tempest Wing")
local monster = {}

monster.description = "a tempest wing"
monster.experience = 47280
monster.outfit = {
	lookType = 3014,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 2717
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

monster.health = 71772
monster.maxHealth = 71772
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
	{ text = "Winds obey, thunder strikes!", yell = false },
	{ text = "Ahhhhhhhhhhhhhh!", yell = false },
	{ text = "I will not be broken!", yell = false }
}

monster.events = {
	"TheMasterOfPotionsCreatureEvent",
}

monster.loot = {
	{ name = "crystal coin", chance = 15000, maxCount = 1 },
	{ name = "spellweaver's robe", chance = 3860 },
	{ name = "divine plate", chance = 4430 },
	{ name = "skullcracker armor", chance = 3290 },
	{ name = "gold ingot", chance = 4570 },
	{ name = "dragon slayer", chance = 2860 },
	{ name = "dragonbone staff", chance = 4000 },
	{ name = "demonic essence", chance = 12460 },
	{ name = "war axe", chance = 3290 },
	{ name = "golden armor", chance = 1860 },
	{ name = "royal helmet", chance = 3720 },
	{ id = 43854, chance = 100 }, -- tainted heart (1 in 1000)
	{ id = 43855, chance = 100 }, -- darklight heart (1 in 1000)
	{ id = 34109, chance = 20 }, -- bag you desire (1 in 5000)
	{ id = 39546, chance = 20 }, -- primal bag (1 in 5000)
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -5130 },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_PHYSICALDAMAGE, minDamage = -4170, maxDamage = -5415, range = 7, radius = 4, effect = CONST_ME_HITAREA, target = true },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_DEATHDAMAGE, minDamage = -4170, maxDamage = -5415, range = 7, shootEffect = CONST_ANI_SUDDENDEATH, effect = CONST_ME_SMALLCLOUDS, target = false },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_EARTHDAMAGE, minDamage = -4170, maxDamage = -5415, range = 7, radius = 4, shootEffect = CONST_ANI_POISON, effect = CONST_ME_POISONAREA, target = true },

	{ name = "undead dragon curse", interval = 2000, chance = 10, target = false },
}

monster.defenses = {
	defense = 185,
	armor = 185,
	mitigation = 8.28,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
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
