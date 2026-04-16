local mType = Game.createMonsterType("Reality Fracture")
local monster = {}

monster.description = "a reality fracture"
monster.experience = 33750
monster.outfit = {
	lookType = 1396, -- PLACEHOLDER: set lookType
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 2780
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
monster.race = "undead"
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
	color = 215,
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "Reality shatters around you!", yell = false },
	{ text = "The fracture spreads!", yell = true },
}

monster.loot = {
	{ name = "crystal coin", chance = 52000, maxCount = 2 },
	{ name = "ultimate mana potion", chance = 28000, maxCount = 6 },
	{ name = "great spirit potion", chance = 22000, maxCount = 5 },
	{ name = "gold ingot", chance = 17000 },
	{ name = "dark obsidian splinter", chance = 11000 },
	{ name = "darklight core", chance = 9500 },
	{ name = "small ruby", chance = 8000, maxCount = 3 },
	{ name = "small emerald", chance = 7500, maxCount = 3 },
	{ name = "green gem", chance = 7000 },
	{ id = 3039, chance = 6500 }, -- red gem
	{ name = "white gem", chance = 6000 },
	{ id = 7385, chance = 4000 }, -- crimson sword
	{ name = "relic sword", chance = 3500 },
	{ name = "emerald bangle", chance = 3000 },
	{ name = "demon shield", chance = 2000 },
	{ name = "fur armor", chance = 1500 },
	{ name = "terra mantle", chance = 1200 },
	{ name = "stone skin amulet", chance = 1000 },
	{ name = "spellbook of mind control", chance = 600 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -3510 },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_PHYSICALDAMAGE, minDamage = -2860, maxDamage = -3705, length = 8, spread = 3, effect = CONST_ME_GROUNDSHAKER, target = false },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_ICEDAMAGE, minDamage = -2730, maxDamage = -3510, radius = 5, effect = CONST_ME_ICEATTACK, target = true },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_DEATHDAMAGE, minDamage = -2600, maxDamage = -3380, radius = 5, effect = CONST_ME_MORTAREA, target = false },
	{ name = "extended holy chain", interval = 2000, chance = 10, minDamage = -2050, maxDamage = -2730 },
	{ name = "largepinkring", interval = 2500, chance = 10, minDamage = -2400, maxDamage = -3120, target = false },
}

monster.defenses = {
	defense = 159,
	armor = 159,
	mitigation = 3.50,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 20 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -10 },
	{ type = COMBAT_EARTHDAMAGE, percent = 25 },
	{ type = COMBAT_FIREDAMAGE, percent = -20 },
	{ type = COMBAT_LIFEDRAIN, percent = 100 },
	{ type = COMBAT_MANADRAIN, percent = 100 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 40 },
	{ type = COMBAT_HOLYDAMAGE, percent = -10 },
	{ type = COMBAT_DEATHDAMAGE, percent = 50 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = true },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
