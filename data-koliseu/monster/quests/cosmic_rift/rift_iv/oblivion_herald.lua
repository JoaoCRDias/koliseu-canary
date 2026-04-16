local mType = Game.createMonsterType("Oblivion Herald")
local monster = {}

monster.description = "an oblivion herald"
monster.experience = 33750
monster.outfit = {
	lookType = 1255, --  PLACEHOLDER: set lookType
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 2779
monster.Bestiary = {
	class = "Cosmic",
	race = BESTY_RACE_MAGICAL,
	toKill = 5000,
	FirstUnlock = 200,
	SecondUnlock = 2000,
	CharmsPoints = 100,
	Stars = 5,
	Occurrence = 0,
	Locations = "Cosmic Rift IV.",
}

monster.events = {}

monster.health = 51150
monster.maxHealth = 51150
monster.race = "blood"
monster.corpse = 6068 -- PLACEHOLDER: set corpse id
monster.speed = 248
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 15,
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
	staticAttackChance = 80,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
	canWalkOnFire = true,
	canWalkOnPoison = true,
}

monster.light = {
	level = 4,
	color = 143,
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "Oblivion awaits all!", yell = false },
	{ text = "I herald the end of all things!", yell = true },
}

monster.loot = {
	{ name = "crystal coin", chance = 58000, maxCount = 2 },
	{ name = "ultimate health potion", chance = 26000, maxCount = 6 },
	{ name = "ultimate mana potion", chance = 24000, maxCount = 5 },
	{ name = "gold ingot", chance = 18000 },
	{ id = 282, chance = 11000 }, -- giant shimmering pearl
	{ name = "magma clump", chance = 9500 },
	{ name = "small diamond", chance = 7500, maxCount = 3 },
	{ name = "small sapphire", chance = 7000, maxCount = 3 },
	{ name = "violet gem", chance = 6500 },
	{ name = "blue gem", chance = 6000 },
	{ id = 3039, chance = 5500 }, -- red gem
	{ name = "darklight basalt chunk", chance = 5000 },
	{ name = "magma legs", chance = 4000 },
	{ name = "magma boots", chance = 3500 },
	{ name = "skullcracker armor", chance = 3000 },
	{ name = "glacier kilt", chance = 2500 },
	{ name = "boots of haste", chance = 2000 },
	{ name = "royal helmet", chance = 1500 },
	{ name = "diabolic skull", chance = 800 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -3510 },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_LIFEDRAIN, minDamage = -2860, maxDamage = -3705, radius = 5, effect = CONST_ME_MAGIC_RED, target = true },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_FIREDAMAGE, minDamage = -2730, maxDamage = -3510, length = 8, spread = 3, effect = CONST_ME_FIREAREA, target = false },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_EARTHDAMAGE, minDamage = -2600, maxDamage = -3380, radius = 5, effect = CONST_ME_GREEN_RINGS, target = false },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_DEATHDAMAGE, minDamage = -2400, maxDamage = -3120, radius = 5, effect = CONST_ME_SMALLCLOUDS, target = true },
	{ name = "largepoisonring", interval = 2500, chance = 10, minDamage = -2400, maxDamage = -3120, target = false },
}

monster.defenses = {
	defense = 159,
	armor = 159,
	mitigation = 3.50,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 5 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 15 },
	{ type = COMBAT_EARTHDAMAGE, percent = 35 },
	{ type = COMBAT_FIREDAMAGE, percent = 30 },
	{ type = COMBAT_LIFEDRAIN, percent = 100 },
	{ type = COMBAT_MANADRAIN, percent = 100 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -15 },
	{ type = COMBAT_HOLYDAMAGE, percent = -20 },
	{ type = COMBAT_DEATHDAMAGE, percent = 40 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = true },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
