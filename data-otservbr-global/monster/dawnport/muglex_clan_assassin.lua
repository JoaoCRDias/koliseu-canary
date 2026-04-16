local mType = Game.createMonsterType("Muglex Clan Assassin")
local monster = {}

monster.description = "a muglex clan assassin"
monster.experience = 34
monster.outfit = {
	lookType = 296,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 1078

monster.events = {
	"MuglexKillCount",
}

monster.health = 45
monster.maxHealth = 45
monster.race = "blood"
monster.corpse = 6002
monster.speed = 70
monster.manaCost = 0
monster.strategiesTarget = {
	nearest = 100,
}

monster.flags = {
	summonable = false,
	attackable = true,
	hostile = true,
	convinceable = false,
	pushable = true,
	rewardBoss = false,
	illusionable = true,
	canPushItems = false,
	canPushCreatures = false,
	staticAttackChance = 90,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
	canWalkOnFire = false,
	canWalkOnPoison = false,
}

monster.light = {
	level = 0,
	color = 0,
}

-- Loot based on statistics (1,420 kills, avg 22.34 gold)
monster.loot = {
	{ id = 3031, chance = 100000, minCount = 1, maxCount = 16 }, -- gold coin (100%)
	{ id = 7620, chance = 20490 }, -- mana potion (20.49%)
	{ id = 3578, chance = 13730 }, -- fish (13.73%)
	{ id = 3294, chance = 7390 }, -- short sword (7.39%)
	{ id = 3003, chance = 4930 }, -- rope (4.93%)
	{ id = 3372, chance = 850 }, -- brass legs (0.85%)
	{ id = 10319, chance = 280 }, -- ranger's cloak (0.28%)
	{ id = 44771, chance = 70 }, -- plain monk robe (0.07%)
	{ id = 3059, chance = 70 }, -- spellbook (0.07%)
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -10 },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_EARTHDAMAGE, minDamage = 0, maxDamage = -12, range = 5, shootEffect = CONST_ANI_SMALLSTONE, target = true },
}

monster.defenses = {
	defense = 5,
	armor = 0,
	mitigation = 0.03,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = -10 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -5 },
	{ type = COMBAT_EARTHDAMAGE, percent = -5 },
	{ type = COMBAT_FIREDAMAGE, percent = 5 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = 20 },
	{ type = COMBAT_DEATHDAMAGE, percent = -10 },
}

monster.immunities = {
	{ type = "paralyze", condition = false },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = false },
	{ type = "bleed", condition = false },
}

mType:register(monster)
