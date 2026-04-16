local mType = Game.createMonsterType("Dimensional Shade")
local monster = {}

monster.description = "a dimensional shade"
monster.experience = 30250
monster.outfit = {
	lookType = 881, -- PLACEHOLDER: set lookType
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 2772
monster.Bestiary = {
	class = "Cosmic",
	race = BESTY_RACE_MAGICAL,
	toKill = 5000,
	FirstUnlock = 200,
	SecondUnlock = 2000,
	CharmsPoints = 100,
	Stars = 5,
	Occurrence = 0,
	Locations = "Cosmic Rift II.",
}

monster.events = {}

monster.health = 46035
monster.maxHealth = 46035
monster.race = "undead"
monster.corpse = 6068 -- PLACEHOLDER: set corpse id
monster.speed = 232
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
	{ text = "Between worlds... I thrive!", yell = false },
	{ text = "Reality bends to my will!", yell = false },
}

monster.loot = {
	{ name = "crystal coin", chance = 36000 },
	{ name = "ultimate mana potion", chance = 24000, maxCount = 5 },
	{ name = "great spirit potion", chance = 18000, maxCount = 4 },
	{ name = "dark obsidian splinter", chance = 10000 },
	{ name = "small ruby", chance = 7000, maxCount = 3 },
	{ name = "green gem", chance = 6000 },
	{ id = 3039, chance = 5500 }, -- red gem
	{ name = "emerald bangle", chance = 5000 },
	{ id = 7385, chance = 4000 }, -- crimson sword
	{ name = "relic sword", chance = 3500 },
	{ name = "skull staff", chance = 3000 },
	{ name = "terra amulet", chance = 2500 },
	{ name = "boots of haste", chance = 1500 },
	{ name = "demon shield", chance = 1000 },
	{ name = "spellbook of mind control", chance = 800 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -3160 },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_DEATHDAMAGE, minDamage = -2570, maxDamage = -3210, length = 8, spread = 3, effect = CONST_ME_MORTAREA, target = false },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_PHYSICALDAMAGE, minDamage = -2390, maxDamage = -3335, radius = 5, effect = CONST_ME_GROUNDSHAKER, target = true },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_ICEDAMAGE, minDamage = -2200, maxDamage = -2940, radius = 5, effect = CONST_ME_ICEATTACK, target = false },
	{ name = "extended holy chain", interval = 2000, chance = 10, minDamage = -1840, maxDamage = -2570 },
	{ name = "largepinkring", interval = 2500, chance = 10, minDamage = -2200, maxDamage = -2940, target = false },
}

monster.defenses = {
	defense = 143,
	armor = 143,
	mitigation = 3.10,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 10 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -10 },
	{ type = COMBAT_EARTHDAMAGE, percent = 15 },
	{ type = COMBAT_FIREDAMAGE, percent = -25 },
	{ type = COMBAT_LIFEDRAIN, percent = 100 },
	{ type = COMBAT_MANADRAIN, percent = 100 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 35 },
	{ type = COMBAT_HOLYDAMAGE, percent = -15 },
	{ type = COMBAT_DEATHDAMAGE, percent = 50 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = true },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
