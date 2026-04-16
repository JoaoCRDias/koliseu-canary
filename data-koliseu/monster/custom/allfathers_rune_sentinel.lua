-- Allfather's Rune Sentinel - Minion of Baldur the Allfather
-- Spawns every 30s in center of room. Must be killed within 5s or transforms into Divine Conduit.
-- Drops "Runic Essence" on death (used to reset the doom counter).
local mType = Game.createMonsterType("Allfather's Rune Sentinel")
local monster = {}

monster.description = "Allfather's Rune Sentinel"
monster.experience = 0
monster.outfit = {
	lookType = 1586,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.health = 1500000
monster.maxHealth = 1500000
monster.race = "blood"
monster.corpse = 0
monster.speed = 450
monster.manaCost = 0

monster.changeTarget = {
	interval = 5000,
	chance = 0,
}

monster.strategiesTarget = {
	nearest = 100,
	health = 0,
	damage = 0,
	random = 0,
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
	level = 6,
	color = 215,
}

monster.voices = {
	interval = 3000,
	chance = 30,
	{ text = "The runes pulse with divine energy...", yell = false },
}

monster.loot = {}

monster.attacks = {
	{ name = "combat", interval = 2000, chance = 30, type = COMBAT_HOLYDAMAGE, minDamage = -1000, maxDamage = -2000, radius = 3, effect = CONST_ME_HOLYAREA, target = false },
}

monster.defenses = {
	defense = 50,
	armor = 50,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = -20 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = 80 },
	{ type = COMBAT_DEATHDAMAGE, percent = -30 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = true },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = true },
}

mType:register(monster)
