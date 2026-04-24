local mType = Game.createMonsterType("Frost Elder")
local monster = {}

monster.description = "a frost elder"
monster.experience = 0

monster.outfit = {
	lookType = 261,
	lookHead = 210, lookBody = 210, lookLegs = 210, lookFeet = 210, lookAddons = 0, lookMount = 0,
}

monster.health = 90000
monster.maxHealth = 90000
monster.race = "undead"
monster.corpse = 0
monster.speed = 240

monster.faction = FACTION_MARID
monster.enemyFactions = { FACTION_EFREET }

monster.changeTarget = { interval = 2000, chance = 15 }
monster.strategiesTarget = { nearest = 60, health = 10, damage = 10, random = 20 }

monster.flags = {
	summonable = false, attackable = true, hostile = true, convinceable = false,
	pushable = false, rewardBoss = false, illusionable = false,
	canPushItems = true, canPushCreatures = true, staticAttackChance = 96,
	targetDistance = 1, runHealth = 0, healthHidden = false, isBlockable = false,
	canWalkOnEnergy = true, canWalkOnFire = true, canWalkOnPoison = true,
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -1500, maxDamage = -2800 },
	{ name = "combat", interval = 2000, chance = 22, type = COMBAT_ICEDAMAGE, minDamage = -1500, maxDamage = -2500, range = 5, radius = 3, shootEffect = CONST_ANI_ICE, effect = CONST_ME_ICEAREA, target = true },
}

monster.defenses = { defense = 80, armor = 80, mitigation = 2.00 }

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 10 },
	{ type = COMBAT_FIREDAMAGE, percent = -20 },
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
