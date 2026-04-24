-- Supreme Vocation summit demon — FIRE element.
local mType = Game.createMonsterType("Ignarion the Cinderborn")
local monster = {}

monster.description = "Ignarion the Cinderborn"
monster.experience = 0

monster.outfit = {
	lookType = 3395,
	lookHead = 0, lookBody = 0, lookLegs = 0, lookFeet = 0, lookAddons = 0, lookMount = 0,
}

monster.health = 800000
monster.maxHealth = 800000
monster.race = "fire"
monster.corpse = 0
monster.speed = 400
monster.manaCost = 0

monster.changeTarget = { interval = 3000, chance = 15 }
monster.strategiesTarget = { nearest = 70, health = 10, damage = 15, random = 5 }

monster.flags = {
	summonable = false, attackable = true, hostile = true, convinceable = false,
	pushable = false, rewardBoss = false, illusionable = false,
	canPushItems = true, canPushCreatures = true, staticAttackChance = 96,
	targetDistance = 1, runHealth = 0, healthHidden = false, isBlockable = false,
	canWalkOnEnergy = true, canWalkOnFire = true, canWalkOnPoison = true,
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -1500, maxDamage = -3000 },
	{ name = "combat", interval = 2000, chance = 30, type = COMBAT_FIREDAMAGE, minDamage = -19500, maxDamage = -25500, range = 7, radius = 4, shootEffect = CONST_ANI_FIRE, effect = CONST_ME_FIREAREA, target = true },
	{ name = "combat", interval = 2000, chance = 25, type = COMBAT_FIREDAMAGE, minDamage = -17500, maxDamage = -22500, length = 8, spread = 3, effect = CONST_ME_FIREAREA, target = false },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_FIREDAMAGE, minDamage = -18000, maxDamage = -23000, radius = 3, effect = CONST_ME_HITBYFIRE, target = false },
}

monster.defenses = { defense = 400, armor = 400, mitigation = 8.00 }

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 40 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 20 },
	{ type = COMBAT_FIREDAMAGE, percent = 100 },
	{ type = COMBAT_LIFEDRAIN, percent = 100 },
	{ type = COMBAT_MANADRAIN, percent = 100 },
	{ type = COMBAT_DROWNDAMAGE, percent = 100 },
	{ type = COMBAT_ICEDAMAGE, percent = -30 },      -- weakness: ice
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 20 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = true },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = true },
}

mType:register(monster)
