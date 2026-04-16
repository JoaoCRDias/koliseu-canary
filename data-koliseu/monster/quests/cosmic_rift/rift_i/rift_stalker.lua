local mType = Game.createMonsterType("Rift Stalker")
local monster = {}

monster.description = "a rift stalker"
monster.experience = 28500
monster.outfit = {
	lookType = 675, -- PLACEHOLDER: set lookType
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 2770
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
monster.race = "venom"
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
	{ text = "The rift consumes all...", yell = false },
	{ text = "You cannot escape the void!", yell = false },
}

monster.loot = {
	{ name = "crystal coin", chance = 30000 },
	{ name = "ultimate health potion", chance = 18000, maxCount = 4 },
	{ name = "ultimate mana potion", chance = 18000, maxCount = 3 },
	{ name = "gold ingot", chance = 12000 },
	{ name = "onyx chip", chance = 10000, maxCount = 2 },
	{ name = "violet gem", chance = 6000 },
	{ name = "blue gem", chance = 5500 },
	{ name = "green crystal fragment", chance = 5000 },
	{ name = "cyan crystal fragment", chance = 4500 },
	{ name = "sacred tree amulet", chance = 3500 },
	{ name = "underworld rod", chance = 3000 },
	{ name = "epee", chance = 2500 },
	{ name = "skullcracker armor", chance = 2000 },
	{ name = "stone skin amulet", chance = 1500 },
	{ name = "magma boots", chance = 1200 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -2970 },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_DEATHDAMAGE, minDamage = -2420, maxDamage = -3080, length = 8, spread = 3, effect = CONST_ME_MORTAREA, target = false },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_ENERGYDAMAGE, minDamage = -2530, maxDamage = -3135, radius = 5, effect = CONST_ME_BLUE_ENERGY_SPARK, target = true },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_PHYSICALDAMAGE, minDamage = -2200, maxDamage = -2860, effect = CONST_ME_BIG_SCRATCH, target = true },
	{ name = "extended energy chain", interval = 2000, chance = 10, minDamage = -1650, maxDamage = -2310, target = true },
}

monster.defenses = {
	defense = 134,
	armor = 134,
	mitigation = 2.90,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 5 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -10 },
	{ type = COMBAT_EARTHDAMAGE, percent = 25 },
	{ type = COMBAT_FIREDAMAGE, percent = -15 },
	{ type = COMBAT_LIFEDRAIN, percent = 100 },
	{ type = COMBAT_MANADRAIN, percent = 100 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 30 },
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
