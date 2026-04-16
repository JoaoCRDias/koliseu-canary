local mType = Game.createMonsterType("Gift Goblin")
local monster = {}

monster.description = "a gift goblin"
monster.experience = 5000
monster.outfit = {
	lookType = 296, -- Goblin looktype
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
}

monster.health = 50000
monster.maxHealth = 50000
monster.race = "blood"
monster.corpse = 6002
monster.speed = 280
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 20,
}

monster.strategiesTarget = {
	nearest = 70,
	health = 10,
	damage = 10,
	random = 10,
}

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

monster.light = {
	level = 4,
	color = 180,
}

monster.summon = {
	maxSummons = 0,
	summons = {},
}

monster.voices = {
	interval = 5000,
	chance = 15,
	{ text = "You can't have these presents!", yell = false },
	{ text = "The party is MINE!", yell = false },
	{ text = "No gifts for you!", yell = false },
	{ text = "Hehehe! Come and get them!", yell = false },
	{ text = "These presents belong to ME!", yell = true },
}

monster.loot = {
	{ id = 6526, chance = 45000, maxCount = 2 }, -- Christmas Token
	{ id = 3031, chance = 100000, maxCount = 50 }, -- Gold Coin
	{ id = 239, chance = 30000, maxCount = 5 }, -- Great Health Potion
	{ id = 238, chance = 30000, maxCount = 5 }, -- Great Mana Potion
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -200, maxDamage = -450 },
	{ name = "combat", interval = 2500, chance = 30, type = COMBAT_FIREDAMAGE, minDamage = -150, maxDamage = -350, range = 5, shootEffect = CONST_ANI_FIRE, effect = CONST_ME_FIREAREA, target = true },
	{ name = "combat", interval = 3000, chance = 20, type = COMBAT_PHYSICALDAMAGE, minDamage = -200, maxDamage = -400, length = 5, spread = 2, effect = CONST_ME_EXPLOSIONHIT, target = false },
}

monster.defenses = {
	defense = 40,
	armor = 40,
	mitigation = 1.0,
	{ name = "combat", interval = 4000, chance = 25, type = COMBAT_HEALING, minDamage = 500, maxDamage = 1000, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -10 },
	{ type = COMBAT_EARTHDAMAGE, percent = 10 },
	{ type = COMBAT_FIREDAMAGE, percent = 10 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -10 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
