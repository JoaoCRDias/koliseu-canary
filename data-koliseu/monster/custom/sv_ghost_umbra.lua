local mType = Game.createMonsterType("Umbra")
local monster = {}

monster.description = "Umbra"
monster.experience = 100000
monster.outfit = {
	lookType = 1268,
	lookHead = 0, lookBody = 6, lookLegs = 0, lookFeet = 116, lookAddons = 0, lookMount = 0,
}

monster.health = 800000
monster.maxHealth = 800000
monster.race = "undead"
monster.corpse = 0
monster.speed = 260
monster.manaCost = 0

monster.changeTarget = { interval = 2000, chance = 10 }
monster.strategiesTarget = { nearest = 70, health = 10, damage = 15, random = 5 }

monster.flags = {
	summonable = false, attackable = true, hostile = true, convinceable = false,
	pushable = false, rewardBoss = false, illusionable = false,
	canPushItems = true, canPushCreatures = true, staticAttackChance = 96,
	targetDistance = 1, runHealth = 0, healthHidden = false, isBlockable = false,
	canWalkOnEnergy = true, canWalkOnFire = true, canWalkOnPoison = true,
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -2000, maxDamage = -35000 },
	{ name = "combat", interval = 2000, chance = 22, type = COMBAT_DEATHDAMAGE, minDamage = -18000, maxDamage = -2800, range = 7, radius = 4, shootEffect = CONST_ANI_SUDDENDEATH, effect = CONST_ME_MORTAREA, target = true },
	{ name = "combat", interval = 2000, chance = 18, type = COMBAT_DEATHDAMAGE, minDamage = -15000, maxDamage = -2500, length = 8, spread = 3, effect = CONST_ME_HITBYPOISON, target = false },
}

monster.defenses = { defense = 100, armor = 100, mitigation = 2.30 }

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 10 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = -15 },
	{ type = COMBAT_DEATHDAMAGE, percent = 100 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = true },
}

monster.events = { "SvGhostDeath" }

mType:register(monster)
