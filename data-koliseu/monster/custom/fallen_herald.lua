local mType = Game.createMonsterType("Fallen Herald")
local monster = {}

monster.description = "a fallen herald"
monster.experience = 0
monster.outfit = {
	lookType = 1268,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.health = 500000
monster.maxHealth = 500000
monster.race = "undead"
monster.corpse = 0
monster.speed = 170

monster.changeTarget = { interval = 4000, chance = 15 }
monster.strategiesTarget = { nearest = 70, random = 30 }

monster.flags = {
	summonable = false,
	attackable = true,
	hostile = true,
	convinceable = false,
	pushable = false,
	rewardBoss = false,
	illusionable = false,
	canPushItems = true,
	canPushCreatures = true,
	staticAttackChance = 90,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
	canWalkOnFire = true,
	canWalkOnPoison = true,
}

monster.events = {
	"VorothMinionDeath",
}

monster.voices = { interval = 6000, chance = 10 }

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -2600, maxDamage = -4200 },
	-- Paralyzing shockwave to make the fight harder
	{ name = "the voice of ruin paralyze", interval = 6000, chance = 25, target = false },
	{ name = "combat", interval = 2800, chance = 22, type = COMBAT_DEATHDAMAGE, minDamage = -2600, maxDamage = -4200, radius = 3, effect = CONST_ME_MORTAREA, target = false },
}

monster.defenses = { defense = 130, armor = 170 }

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 10 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 10 },
	{ type = COMBAT_EARTHDAMAGE, percent = 10 },
	{ type = COMBAT_FIREDAMAGE, percent = 10 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -10 },
	{ type = COMBAT_HOLYDAMAGE, percent = -10 },
	{ type = COMBAT_DEATHDAMAGE, percent = 40 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
