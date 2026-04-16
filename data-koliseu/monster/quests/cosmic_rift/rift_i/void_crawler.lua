local mType = Game.createMonsterType("Void Crawler")
local monster = {}

monster.description = "a void crawler"
monster.experience = 28500
monster.outfit = {
	lookType = 876, -- PLACEHOLDER: set lookType
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 2771
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
monster.race = "blood"
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
	{ text = "Crawling from the abyss...", yell = false },
	{ text = "The void hungers!", yell = false },
}

monster.loot = {
	{ name = "crystal coin", chance = 30000 },
	{ name = "ultimate health potion", chance = 20000, maxCount = 4 },
	{ name = "great spirit potion", chance = 15000, maxCount = 4 },
	{ name = "gold ingot", chance = 11000 },
	{ name = "darklight core", chance = 9000 },
	{ name = "red crystal fragment", chance = 6000 },
	{ name = "white gem", chance = 5500 },
	{ id = 3039, chance = 5000 }, -- red gem
	{ name = "magma clump", chance = 4500 },
	{ name = "titan axe", chance = 3500 },
	{ name = "mercenary sword", chance = 3000 },
	{ name = "crystal mace", chance = 2500 },
	{ name = "fur armor", chance = 2000 },
	{ name = "terra mantle", chance = 1500 },
	{ id = 23531, chance = 1200 }, -- ring of green plasma
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -2970 },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_EARTHDAMAGE, minDamage = -2310, maxDamage = -2970, length = 8, spread = 3, effect = CONST_ME_GREEN_RINGS, target = false },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_PHYSICALDAMAGE, minDamage = -2530, maxDamage = -3135, radius = 5, effect = CONST_ME_GROUNDSHAKER, target = true },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_DEATHDAMAGE, minDamage = -2200, maxDamage = -2750, radius = 5, effect = CONST_ME_MORTAREA, target = false },
	{ name = "largepoisonring", interval = 2000, chance = 10, minDamage = -1980, maxDamage = -2420, target = false },
}

monster.defenses = {
	defense = 134,
	armor = 134,
	mitigation = 2.90,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 15 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -20 },
	{ type = COMBAT_EARTHDAMAGE, percent = 40 },
	{ type = COMBAT_FIREDAMAGE, percent = 10 },
	{ type = COMBAT_LIFEDRAIN, percent = 100 },
	{ type = COMBAT_MANADRAIN, percent = 100 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -10 },
	{ type = COMBAT_HOLYDAMAGE, percent = 5 },
	{ type = COMBAT_DEATHDAMAGE, percent = 30 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = true },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
