local mType = Game.createMonsterType("Astral Leech")
local monster = {}

monster.description = "an astral leech"
monster.experience = 28500
monster.outfit = {
	lookType = 712, -- PLACEHOLDER: set lookType
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 2769
monster.Bestiary = {
	class = "Cosmic",
	race = BESTY_RACE_MAGICAL,
	toKill = 5000,
	FirstUnlock = 200,
	SecondUnlock = 2000,
	CharmsPoints = 100,
	Stars = 5,
	Occurrence = 0,
	Locations = "Cosmic Rift I.",
}

monster.events = {}

monster.health = 43280
monster.maxHealth = 43280
monster.race = "undead"
monster.corpse = 6068 -- PLACEHOLDER: set corpse id
monster.speed = 225
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 10,
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
	staticAttackChance = 90,
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
	color = 215,
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "Your life force... is mine!", yell = false },
	{ text = "I feed on your essence!", yell = false },
}

monster.loot = {
	{ name = "crystal coin", chance = 28000 },
	{ name = "ultimate mana potion", chance = 20000, maxCount = 4 },
	{ name = "ultimate health potion", chance = 16000, maxCount = 3 },
	{ id = 282, chance = 8000 }, -- giant shimmering pearl
	{ name = "blue crystal shard", chance = 6500 },
	{ name = "small diamond", chance = 6000, maxCount = 2 },
	{ name = "green gem", chance = 5500 },
	{ name = "hailstorm rod", chance = 4500 },
	{ name = "wand of voodoo", chance = 4000 },
	{ name = "rotten roots", chance = 3000 },
	{ name = "noble axe", chance = 2500 },
	{ name = "glacier kilt", chance = 2000 },
	{ name = "wood cape", chance = 1500 },
	{ name = "diabolic skull", chance = 1000 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -2970 },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_LIFEDRAIN, minDamage = -2420, maxDamage = -3080, radius = 5, effect = CONST_ME_MAGIC_RED, target = true },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_ICEDAMAGE, minDamage = -2310, maxDamage = -2970, length = 8, spread = 3, effect = CONST_ME_ICEATTACK, target = false },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_DEATHDAMAGE, minDamage = -2530, maxDamage = -3135, radius = 5, effect = CONST_ME_SMALLCLOUDS, target = false },
	{ name = "ice chain", interval = 2000, chance = 10, minDamage = -1650, maxDamage = -2310, range = 7 },
}

monster.defenses = {
	defense = 134,
	armor = 134,
	mitigation = 2.90,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = -5 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 10 },
	{ type = COMBAT_EARTHDAMAGE, percent = -15 },
	{ type = COMBAT_FIREDAMAGE, percent = -20 },
	{ type = COMBAT_LIFEDRAIN, percent = 100 },
	{ type = COMBAT_MANADRAIN, percent = 100 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 45 },
	{ type = COMBAT_HOLYDAMAGE, percent = -10 },
	{ type = COMBAT_DEATHDAMAGE, percent = 35 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = true },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
