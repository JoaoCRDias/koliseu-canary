local mType = Game.createMonsterType("Event Horizon")
local monster = {}

monster.description = "an event horizon"
monster.experience = 33750
monster.outfit = {
	lookType = 1219, -- PLACEHOLDER: set lookType
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 2778
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
monster.race = "energy"
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
	level = 5,
	color = 180,
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "Beyond this point... there is no return!", yell = false },
	{ text = "Light itself cannot escape!", yell = true },
}

monster.loot = {
	{ name = "crystal coin", chance = 55000, maxCount = 2 },
	{ name = "ultimate health potion", chance = 28000, maxCount = 6 },
	{ name = "ultimate mana potion", chance = 25000, maxCount = 5 },
	{ name = "gold ingot", chance = 18000 },
	{ id = 282, chance = 12000 }, -- giant shimmering pearl
	{ name = "blue crystal shard", chance = 10000 },
	{ name = "onyx chip", chance = 9000, maxCount = 3 },
	{ name = "violet gem", chance = 8000 },
	{ name = "blue gem", chance = 7500 },
	{ name = "rainbow quartz", chance = 6500, maxCount = 3 },
	{ name = "cyan crystal fragment", chance = 6000 },
	{ name = "green crystal fragment", chance = 5500 },
	{ name = "red crystal fragment", chance = 5000 },
	{ name = "rotten roots", chance = 3500 },
	{ name = "royal helmet", chance = 2500 },
	{ name = "boots of haste", chance = 2000 },
	{ name = "alloy legs", chance = 1200 },
	{ name = "mastermind shield", chance = 800 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -3510 },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_ENERGYDAMAGE, minDamage = -2860, maxDamage = -3705, length = 8, spread = 3, effect = CONST_ME_BLUE_ENERGY_SPARK, target = false },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_DEATHDAMAGE, minDamage = -2730, maxDamage = -3510, radius = 5, effect = CONST_ME_MORTAREA, target = true },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_HOLYDAMAGE, minDamage = -2600, maxDamage = -3380, radius = 5, effect = CONST_ME_HOLYDAMAGE, target = false },
	{ name = "extended energy chain", interval = 2000, chance = 10, minDamage = -2050, maxDamage = -2730, target = true },
	{ name = "largepinkring", interval = 3000, chance = 10, minDamage = -2400, maxDamage = -3120, target = false },
}

monster.defenses = {
	defense = 159,
	armor = 159,
	mitigation = 3.50,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 10 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 45 },
	{ type = COMBAT_EARTHDAMAGE, percent = -15 },
	{ type = COMBAT_FIREDAMAGE, percent = -10 },
	{ type = COMBAT_LIFEDRAIN, percent = 100 },
	{ type = COMBAT_MANADRAIN, percent = 100 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 30 },
	{ type = COMBAT_HOLYDAMAGE, percent = 15 },
	{ type = COMBAT_DEATHDAMAGE, percent = 20 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = true },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
