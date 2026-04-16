local mType = Game.createMonsterType("Muglex Clan Footman")
local monster = {}

monster.description = "a muglex clan footman"
monster.experience = 24
monster.outfit = {
	lookType = 61,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceid = 1067

monster.events = {
	"MuglexKillCount",
}

monster.health = 30
monster.maxHealth = 30
monster.race = "blood"
monster.corpse = 6002
monster.speed = 60
monster.manaCost = 0

monster.changeTarget = {
	interval = 2000,
	chance = 0,
}

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

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "Take that!", yell = false },
}

-- Loot based on statistics (1,895 kills, avg 9.11 gold)
monster.loot = {
	{ id = 3031, chance = 100000, minCount = 1, maxCount = 14 }, -- gold coin (100%)
	{ id = 7618, chance = 18580 }, -- health potion (18.58%)
	{ id = 3578, chance = 13930 }, -- fish (13.93%)
	{ id = 3447, chance = 6700, minCount = 1, maxCount = 14 }, -- simple arrow (6.7%)
	{ id = 3311, chance = 6280, minCount = 1, maxCount = 4 }, -- poison arrow (6.28%)
	{ id = 1781, chance = 5910 }, -- small stone (5.91%)
	{ id = 3372, chance = 790 }, -- brass legs (0.79%)
	{ id = 10319, chance = 530 }, -- ranger's cloak (0.53%)
	{ id = 3059, chance = 260 }, -- spellbook (0.26%)
	{ id = 3274, chance = 110 }, -- axe (0.11%)
	{ id = 44771, chance = 110 }, -- plain monk robe (0.11%)
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -8 },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_EARTHDAMAGE, minDamage = 0, maxDamage = -10, range = 5, shootEffect = CONST_ANI_SPEAR, target = true },
}

monster.defenses = {
	defense = 4,
	armor = 0,
	mitigation = 0.03,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = -10 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
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
