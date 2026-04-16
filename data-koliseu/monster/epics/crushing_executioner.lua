local mType = Game.createMonsterType("Crushing Executioner")
local monster = {}

monster.description = "a crushing executioner"
monster.experience = 44520
monster.outfit = {
	lookType = 3071,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 2701
monster.Bestiary = {
	class = "Human",
	race = BESTY_RACE_HUMAN,
	toKill = 5000,
	FirstUnlock = 500,
	SecondUnlock = 2500,
	CharmsPoints = 100,
	Stars = 5,
	Occurrence = 0,
	Locations = "Teleports Room.",
}

monster.health = 67512
monster.maxHealth = 67512
monster.race = "blood"
monster.corpse = 6068
monster.speed = 270
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
	staticAttackChance = 70,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
	canWalkOnFire = true,
	canWalkOnPoison = true,
}

monster.light = {
	level = 0,
	color = 0,
}

monster.summon = {}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "You will be executed!", yell = false },
	{ text = "Your soul is mine!", yell = false },
	{ text = "Feel the crushing pain!", yell = false },
}

monster.loot = {
	{ name = "crystal coin", chance = 15000, maxCount = 1 },
	{ id = 3033, chance = 2500, maxCount = 5 }, -- small amethyst
	{ id = 3028, chance = 2500, maxCount = 5 }, -- small diamond
	{ id = 3032, chance = 2500, maxCount = 5 }, -- small emerald
	{ id = 3030, chance = 2500, maxCount = 5 }, -- small ruby
	{ id = 9057, chance = 2500, maxCount = 5 }, -- small topaz
	{ id = 3019, chance = 1500 }, -- demonbone amulet
	{ id = 3414, chance = 3500 }, -- mastermind shield
	{ id = 22866, chance = 2800 }, -- rift bow
	{ id = 22867, chance = 1800 }, -- rift crossbow
	{ id = 43854, chance = 100 }, -- tainted heart (1 in 1000)
	{ id = 43855, chance = 100 }, -- darklight heart (1 in 1000)
	{ id = 34109, chance = 20 }, -- bag you desire (1 in 5000)
	{ id = 39546, chance = 20 }, -- primal bag (1 in 5000)
}

monster.events = {
	"TheMasterOfPotionsCreatureEvent",
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, type = COMBAT_EARTHDAMAGE, minDamage = 0, maxDamage = -4827 },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_DEATHDAMAGE, minDamage = -3924, maxDamage = -5095, radius = 4, effect = CONST_ME_EXPLOSIONHIT, target = false },
	{ name = "combat", interval = 2000, chance = 12, type = COMBAT_ENERGYDAMAGE, minDamage = -3924, maxDamage = -5095, length = 5, spread = 0, effect = CONST_ME_BLOCKHIT, target = false },
}

monster.defenses = {
	defense = 174,
	armor = 174,
	mitigation = 6.28,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 15 },
	{ type = COMBAT_EARTHDAMAGE, percent = 15 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 100 },
	{ type = COMBAT_MANADRAIN, percent = 100 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -5 },
	{ type = COMBAT_HOLYDAMAGE, percent = -5 },
	{ type = COMBAT_DEATHDAMAGE, percent = -5 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
