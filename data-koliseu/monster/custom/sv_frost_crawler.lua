local mType = Game.createMonsterType("Frost Crawler")
local monster = {}

monster.description = "a frost crawler"
monster.experience = 0

monster.outfit = {
	lookType = 53,
	lookHead = 0, lookBody = 114, lookLegs = 114, lookFeet = 114, lookAddons = 0, lookMount = 0,
}

monster.health = 25000
monster.maxHealth = 25000
monster.race = "undead"
monster.corpse = 0
monster.speed = 180

monster.faction = FACTION_MARID
monster.enemyFactions = { FACTION_EFREET }

monster.changeTarget = { interval = 3000, chance = 5 }
monster.strategiesTarget = { nearest = 20, health = 5, damage = 5, random = 70 }

monster.flags = {
	summonable = false, attackable = true, hostile = true, convinceable = false,
	pushable = false, rewardBoss = false, illusionable = false,
	canPushItems = true, canPushCreatures = false, staticAttackChance = 96,
	targetDistance = 1, runHealth = 0, healthHidden = false, isBlockable = false,
	canWalkOnEnergy = true, canWalkOnFire = true, canWalkOnPoison = true,
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -900, maxDamage = -1800 },
}

monster.defenses = { defense = 50, armor = 50, mitigation = 1.60 }

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 10 },
	{ type = COMBAT_FIREDAMAGE, percent = -20 },
	{ type = COMBAT_ICEDAMAGE, percent = 100 },
}

monster.immunities = {
	{ type = "paralyze", condition = false },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = true },
}

monster.events = { "SvFrostMobSmash" }

mType:register(monster)
