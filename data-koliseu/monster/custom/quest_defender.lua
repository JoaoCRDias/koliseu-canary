local mType = Game.createMonsterType("Quest Defender")
local monster = {}

monster.name = "Quest Defender"
monster.description = "a quest defender"
monster.experience = 0
monster.outfit = {
	lookType= 1841,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.health = 500000
monster.maxHealth = monster.health
monster.race = "blood"
monster.corpse = 0
monster.speed = 0

monster.changeTarget = {
	interval = 1000,
	chance = 0,
}

monster.flags = {
	summonable = false,
	pushable = false,
	attackable = true,
	hostile = true,
	convinceable = false,
	illusionable = false,
	canPushItems = true,
	canPushCreatures = true,
	targetDistance = 1,
	staticAttackChance = 100,
}

monster.summons = {}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "No step forward without destruction.", yell = false },
	{ text = "The path remains sealed until strength breaks it.", yell = false },
	{ text = "You wish to pass? Then destroy me.", yell = false },
	{ text = "No passage without force.", yell = false },
}

monster.loot = {}

monster.attacks = {
}

monster.defenses = {
	defense = 20,
	armor = 55,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
}

monster.immunities = {}

mType:register(monster)
