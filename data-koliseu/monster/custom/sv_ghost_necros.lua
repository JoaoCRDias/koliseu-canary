local mType = Game.createMonsterType("Necros")
local monster = {}

monster.description = "Necros"
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
	{ name = "combat", interval = 2000, chance = 22, type = COMBAT_DEATHDAMAGE, minDamage = -2000, maxDamage = -32000, range = 7, radius = 4, shootEffect = CONST_ANI_SUDDENDEATH, effect = CONST_ME_MORTAREA, target = true },
	{ name = "combat", interval = 2000, chance = 18, type = COMBAT_DEATHDAMAGE, minDamage = -1500, maxDamage = -25000, radius = 3, effect = CONST_ME_BLACKSMOKE, target = false },
}

monster.defenses = { defense = 100, armor = 100, mitigation = 2.30 }

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 10 },
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
