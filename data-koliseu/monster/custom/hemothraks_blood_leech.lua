-- Hemothrak's Blood Leech - Minion of Hemothrak the Crimson Sovereign
-- Spawns every 25s. Must be killed within 12s or explodes creating 5 extra blood pools.
-- When killed, clears ALL blood pools from the room.
local mType = Game.createMonsterType("Hemothrak's Blood Leech")
local monster = {}

monster.description = "Hemothrak's Blood Leech"
monster.experience = 0
monster.outfit = {
	lookType = 1883, -- PLACEHOLDER: replace with blood-themed creature
	lookHead = 78,
	lookBody = 94,
	lookLegs = 78,
	lookFeet = 94,
	lookAddons = 0,
	lookMount = 0,
}

monster.health = 1500000
monster.maxHealth = 1500000
monster.race = "blood"
monster.corpse = 0
monster.speed = 550
monster.manaCost = 0

monster.changeTarget = {
	interval = 3000,
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
	canPushItems = false,
	canPushCreatures = false,
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
	interval = 3000,
	chance = 30,
	{ text = "The blood hungers...", yell = false },
	{ text = "Feed me!", yell = false },
}

monster.loot = {}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -1500, maxDamage = -3000 },
	{ name = "combat", interval = 2000, chance = 30, type = COMBAT_DEATHDAMAGE, minDamage = -2000, maxDamage = -4000, radius = 2, effect = CONST_ME_DRAWBLOOD, target = false },
}

monster.defenses = {
	defense = 40,
	armor = 40,
	{ name = "speed", interval = 2000, chance = 25, speedChange = 400, effect = CONST_ME_MAGIC_RED, target = false, duration = 4000 },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = -30 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = -20 },
	{ type = COMBAT_DEATHDAMAGE, percent = 80 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = true },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = true },
}

mType:register(monster)
