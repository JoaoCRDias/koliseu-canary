local mType = Game.createMonsterType("The Welter")
local monster = {}

monster.description = "The Welter"
monster.experience = 35000000
monster.outfit = {
	lookType = 563,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.bosstiary = {
	bossRaceId = 964,
	bossRace = RARITY_NEMESIS,
}

monster.health = 5000000
monster.maxHealth = 5000000
monster.race = "blood"
monster.corpse = 18974
monster.speed = 200
monster.manaCost = 0

monster.changeTarget = {
	interval = 2000,
	chance = 5,
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
	rewardBoss = true,
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
	level = 0,
	color = 0,
}

monster.summon = {
	maxSummons = 1,
	summons = {
		{ name = "spawn of the welter", chance = 16, interval = 2000, count = 1 },
	},
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "FCHHHHH", yell = true },
}

monster.loot = {
	{ id = 19083, chance = 200 }, -- silver raid token
	{ id = 19356, chance = 200 }, -- triple bolt crossbow
	{ id = 3369, chance = 2000 }, -- warrior helmet
	{ id = 19357, chance = 500 }, -- shrunken head necklace
	{ id = 3079, chance = 1000 }, -- boots of haste
	{ id = 3436, chance = 2000 }, -- medusa shield
	{ id = 3284, chance = 2000 }, -- ice rapier
	{ id = 3029, chance = 20000, maxCount = 2 }, -- small sapphire
	{ id = 3370, chance = 3000 }, -- knight armor
	{ id = 236, chance = 20000, maxCount = 2 }, -- strong health potion
	{ id = 9302, chance = 1000 }, -- sacred tree amulet
	{ id = 3081, chance = 20000 }, -- stone skin amulet
	{ id = 9058, chance = 800 }, -- gold ingot
	{ id = 3392, chance = 500 }, -- royal helmet
	{ id = 281, chance = 600 }, -- giant shimmering pearl (green)
	{ id = 4839, chance = 2000 }, -- hydra egg
	{ id = 237, chance = 20000, maxCount = 2 }, -- strong mana potion
	{ id = 3035, chance = 20000, maxCount = 10 }, -- platinum coin
	{ id = 3031, chance = 20000, maxCount = 100 }, -- gold coin
	{ id = 60648, chance = 10000, maxCount = 1 },
	{ id = 60427, chance = 5000, maxCount = 1 },
	{ id = 60428, chance = 5000, maxCount = 1 },
	{ id = 60429, chance = 5000, maxCount = 1 },
	{ id = 58051, chance = 5000, maxCount = 1 },
	{ id = 58052, chance = 5000, maxCount = 1 },
	{ id = 58053, chance = 5000, maxCount = 1 },
	{ id = 58054, chance = 5000, maxCount = 1 },

}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -7000 },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_EARTHDAMAGE, minDamage = -3000, maxDamage = -7000, length = 8, spread = 3, effect = CONST_ME_SMALLPLANTS, target = false },
	{ name = "combat", interval = 2000, chance = 18, type = COMBAT_DEATHDAMAGE, minDamage = -3000, maxDamage = -6000, length = 8, spread = 3, effect = CONST_ME_BLACKSMOKE, target = false },
	{ name = "combat", interval = 2000, chance = 18, type = COMBAT_ICEDAMAGE, minDamage = -3000, maxDamage = -6000, range = 7, radius = 4, shootEffect = CONST_ANI_ICE, effect = CONST_ME_ICEATTACK, target = true },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_LIFEDRAIN, minDamage = -2000, maxDamage = -5000, radius = 5, effect = CONST_ME_MAGIC_GREEN, target = false },
}

monster.defenses = {
	defense = 55,
	armor = 50,
	--	mitigation = ???,
	{ name = "combat", interval = 2000, chance = 25, type = COMBAT_HEALING, minDamage = 1500, maxDamage = 3000, effect = CONST_ME_MAGIC_BLUE, target = false },
	{ name = "combat", interval = 3000, chance = 15, type = COMBAT_HEALING, minDamage = 800, maxDamage = 1500, radius = 5, effect = CONST_ME_MAGIC_GREEN, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 50 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 25 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
