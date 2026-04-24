local mType = Game.createMonsterType("Pyre Sunbreaker")
local monster = {}

monster.description = "Pyre Sunbreaker"
monster.experience = 600000
monster.outfit = {
	lookType = 3033,
	lookHead = 0, lookBody = 0, lookLegs = 0, lookFeet = 0, lookAddons = 0, lookMount = 0,
}

monster.raceId = 2816
monster.Bestiary = {
	class = "Elemental",
	race = BESTY_RACE_ELEMENTAL,
	toKill = 5000,
	FirstUnlock = 500,
	SecondUnlock = 1000,
	CharmsPoints = 100,
	Stars = 5,
	Occurrence = 0,
	Locations = "Hell Vulcan.",
}

monster.health = 565000
monster.maxHealth = 565000
monster.race = "fire"
monster.corpse = 0
monster.speed = 440
monster.manaCost = 0

monster.changeTarget = { interval = 2000, chance = 14 }
monster.strategiesTarget = { nearest = 60, health = 10, damage = 15, random = 15 }

monster.flags = {
	summonable = false, attackable = true, hostile = true, convinceable = false,
	pushable = false, rewardBoss = false, illusionable = false,
	canPushItems = true, canPushCreatures = true, staticAttackChance = 96,
	targetDistance = 4, runHealth = 0, healthHidden = false, isBlockable = false,
	canWalkOnEnergy = true, canWalkOnFire = true, canWalkOnPoison = true,
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -10000, maxDamage = -20000 },
	{ name = "combat", interval = 2000, chance = 30, type = COMBAT_FIREDAMAGE, minDamage = -22000, maxDamage = -32000, range = 7, radius = 4, shootEffect = CONST_ANI_FIRE, effect = CONST_ME_FIREAREA, target = true },
	{ name = "combat", interval = 2000, chance = 22, type = COMBAT_ENERGYDAMAGE, minDamage = -18000, maxDamage = -27000, length = 8, spread = 3, effect = CONST_ME_PURPLEENERGY, target = false },
	{ name = "combat", interval = 2000, chance = 18, type = COMBAT_FIREDAMAGE, minDamage = -19000, maxDamage = -26000, radius = 3, effect = CONST_ME_HITBYFIRE, target = false },
}

monster.defenses = { defense = 320, armor = 320, mitigation = 3.50 }

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 10 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -5 },
	{ type = COMBAT_EARTHDAMAGE, percent = 10 },
	{ type = COMBAT_FIREDAMAGE, percent = 60 },
	{ type = COMBAT_LIFEDRAIN, percent = 100 },
	{ type = COMBAT_MANADRAIN, percent = 100 },
	{ type = COMBAT_DROWNDAMAGE, percent = 100 },
	{ type = COMBAT_ICEDAMAGE, percent = -15 },
	{ type = COMBAT_HOLYDAMAGE, percent = -5 },
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

monster.loot = {
	{ name = "crystal coin", chance = 70000, maxCount = 3 },
	{ name = "gold ingot", chance = 35000, maxCount = 2 },
	{ name = "violet gem", chance = 18000 },
	{ name = "blue gem", chance = 18000 },
	{ name = "green gem", chance = 18000 },
	{ name = "yellow gem", chance = 14000 },
	{ name = "giant sapphire", chance = 8000 },
	{ name = "giant emerald", chance = 8000 },
	{ name = "giant ruby", chance = 8000 },
	{ name = "giant amethyst", chance = 8000 },
	{ name = "giant topaz", chance = 8000 },
	{ id = 44602, chance = 50 },
	{ id = 44605, chance = 50 },
	{ id = 44608, chance = 50 },
	{ id = 44611, chance = 50 },
	{ id = 49371, chance = 50 },
}

mType:register(monster)
