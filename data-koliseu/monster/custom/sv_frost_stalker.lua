local mType = Game.createMonsterType("Frost Stalker")
local monster = {}

monster.description = "a frost stalker"
monster.experience = 0

monster.outfit = {
	lookType = 257,
	lookHead = 88, lookBody = 88, lookLegs = 88, lookFeet = 88, lookAddons = 0, lookMount = 0,
}

monster.health = 18000
monster.maxHealth = 18000
monster.race = "undead"
monster.corpse = 0
monster.speed = 380

monster.faction = FACTION_MARID
monster.enemyFactions = { FACTION_EFREET }

monster.changeTarget = { interval = 3000, chance = 5 }
monster.strategiesTarget = { nearest = 10, health = 5, damage = 5, random = 80 }

monster.flags = {
	summonable = false, attackable = true, hostile = true, convinceable = false,
	pushable = false, rewardBoss = false, illusionable = false,
	canPushItems = true, canPushCreatures = false, staticAttackChance = 96,
	targetDistance = 1, runHealth = 0, healthHidden = false, isBlockable = false,
	canWalkOnEnergy = true, canWalkOnFire = true, canWalkOnPoison = true,
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -1200, maxDamage = -2000 },
}

monster.defenses = { defense = 60, armor = 40, mitigation = 1.40 }

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
