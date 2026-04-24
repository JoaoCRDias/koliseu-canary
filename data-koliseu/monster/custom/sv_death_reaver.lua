local mType = Game.createMonsterType("Death Reaver")
local monster = {}

monster.description = "a death reaver"
monster.experience = 0
monster.outfit = {
	lookType = 231,
	lookHead = 0, lookBody = 0, lookLegs = 0, lookFeet = 0, lookAddons = 0, lookMount = 0,
}

monster.health = 180000
monster.maxHealth = 180000
monster.race = "undead"
monster.corpse = 0
monster.speed = 280

monster.changeTarget = { interval = 1500, chance = 20 }
monster.strategiesTarget = { nearest = 80, health = 10, damage = 5, random = 5 }

monster.flags = {
	summonable = false, attackable = true, hostile = true, convinceable = false,
	pushable = false, rewardBoss = false, illusionable = false,
	canPushItems = true, canPushCreatures = true, staticAttackChance = 96,
	targetDistance = 1, runHealth = 0, healthHidden = false, isBlockable = false,
	canWalkOnEnergy = true, canWalkOnFire = true, canWalkOnPoison = true,
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -1500, maxDamage = -12800 },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_DEATHDAMAGE, minDamage = -1200, maxDamage = -12200, range = 5, effect = CONST_ME_MORTAREA, target = true },
}

monster.defenses = { defense = 80, armor = 80, mitigation = 2.00 }

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 10 },
	{ type = COMBAT_HOLYDAMAGE, percent = -20 },
	{ type = COMBAT_DEATHDAMAGE, percent = 100 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = true },
}

mType:register(monster)
