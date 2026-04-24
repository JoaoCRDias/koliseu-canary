local mType = Game.createMonsterType("Hailstorm Brute")
local monster = {}

monster.description = "a hailstorm brute"
monster.experience = 0

monster.outfit = {
	lookType = 267,
	lookHead = 0, lookBody = 95, lookLegs = 95, lookFeet = 95, lookAddons = 0, lookMount = 0,
}

monster.health = 150000
monster.maxHealth = 150000
monster.race = "undead"
monster.corpse = 0
monster.speed = 200

monster.faction = FACTION_MARID
monster.enemyFactions = { FACTION_EFREET }

monster.changeTarget = { interval = 2000, chance = 15 }
monster.strategiesTarget = { nearest = 40, health = 10, damage = 10, random = 40 }

monster.flags = {
	summonable = false, attackable = true, hostile = true, convinceable = false,
	pushable = false, rewardBoss = false, illusionable = false,
	canPushItems = true, canPushCreatures = true, staticAttackChance = 96,
	targetDistance = 1, runHealth = 0, healthHidden = false, isBlockable = false,
	canWalkOnEnergy = true, canWalkOnFire = true, canWalkOnPoison = true,
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -2000, maxDamage = -3500 },
	{ name = "combat", interval = 2000, chance = 30, type = COMBAT_ICEDAMAGE, minDamage = -2000, maxDamage = -3500, radius = 3, effect = CONST_ME_ICEAREA, target = false },
}

monster.defenses = { defense = 100, armor = 100, mitigation = 2.20 }

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 10 },
	{ type = COMBAT_FIREDAMAGE, percent = -30 },
	{ type = COMBAT_ICEDAMAGE, percent = 100 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = true },
}

monster.events = { "SvFrostMobSmash" }

mType:register(monster)
