local mType = Game.createMonsterType("Saurian Reaper")
local monster = {}

monster.description = "Saurian Reaper"
monster.experience = 600000
monster.outfit = {
	lookType = 3345,
	lookHead = 0, lookBody = 0, lookLegs = 0, lookFeet = 0, lookAddons = 0, lookMount = 0,
}

monster.raceId = 2818
monster.Bestiary = {
	class = "Dragon",
	race = BESTY_RACE_DRAGON,
	toKill = 5000,
	FirstUnlock = 500,
	SecondUnlock = 1000,
	CharmsPoints = 100,
	Stars = 5,
	Occurrence = 0,
	Locations = "Prehistoric Caves.",
}

monster.health = 565000
monster.maxHealth = 565000
monster.race = "blood"
monster.corpse = 0
monster.speed = 460
monster.manaCost = 0

monster.changeTarget = { interval = 2000, chance = 12 }
monster.strategiesTarget = { nearest = 80, health = 10, damage = 5, random = 5 }

monster.flags = {
	summonable = false, attackable = true, hostile = true, convinceable = false,
	pushable = false, rewardBoss = false, illusionable = false,
	canPushItems = true, canPushCreatures = true, staticAttackChance = 96,
	targetDistance = 1, runHealth = 0, healthHidden = false, isBlockable = false,
	canWalkOnEnergy = true, canWalkOnFire = true, canWalkOnPoison = true,
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -18000, maxDamage = -30000 },
	{ name = "combat", interval = 2000, chance = 28, type = COMBAT_DEATHDAMAGE, minDamage = -22000, maxDamage = -32000, length = 6, spread = 3, effect = CONST_ME_MORTAREA, target = false },
	{ name = "combat", interval = 2000, chance = 22, type = COMBAT_PHYSICALDAMAGE, minDamage = -20000, maxDamage = -28000, range = 4, radius = 3, effect = CONST_ME_GROUNDSHAKER, target = true },
	{ name = "combat", interval = 2000, chance = 14, type = COMBAT_LIFEDRAIN, minDamage = -16000, maxDamage = -22000, radius = 2, effect = CONST_ME_BLACKSMOKE, target = false },
}

monster.defenses = { defense = 360, armor = 360, mitigation = 3.50 }

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 30 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 100 },
	{ type = COMBAT_MANADRAIN, percent = 100 },
	{ type = COMBAT_DROWNDAMAGE, percent = 100 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = 100 },
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
