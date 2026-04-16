local mType = Game.createMonsterType("Dracola")
local monster = {}

monster.description = "Dracola"
monster.experience = 45000000
monster.outfit = {
	lookType = 231,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.bosstiary = {
	bossRaceId = 302,
	bossRace = RARITY_NEMESIS,
}

monster.health = 5000000
monster.maxHealth = 5000000
monster.race = "undead"
monster.corpse = 6306
monster.speed = 220
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
	staticAttackChance = 95,
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

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "DEATH CAN'T STOP MY HUNGER!", yell = true },
	{ text = "YOU ARE ALL DOOMED!", yell = true },
	{ text = "Your new name is breakfast.", yell = false },
	{ text = "I'm bad to the bone.", yell = false },
}

monster.loot = {
	{ id = 5944, chance = 100000 }, -- soul orb
	{ id = 5741, chance = 9000 }, -- skull helmet
	{ id = 7420, chance = 3000 }, -- reaper's axe
	{ id = 3061, chance = 12000 }, -- life crystal
	{ id = 5925, chance = 5000, maxCount = 3 }, -- hardened bone
	{ id = 238, chance = 9000, maxCount = 4 }, -- great mana potion
	{ id = 239, chance = 9000, maxCount = 4 }, -- great health potion
	{ id = 6299, chance = 14000 }, -- death ring
	{ id = 3383, chance = 29000 }, -- dark armor
	{ id = 3031, chance = 29000, maxCount = 100 }, -- gold coin
	{ id = 3031, chance = 29000, maxCount = 100 }, -- gold coin
	{ id = 3035, chance = 20000, maxCount = 8 }, -- platinum coin
	{ id = 6499, chance = 6000, maxCount = 4 }, -- demonic essence
	{ id = 6546, chance = 100000 }, -- dracola's eye
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
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -8000 },
	{ name = "combat", interval = 2000, chance = 22, type = COMBAT_LIFEDRAIN, minDamage = -4000, maxDamage = -8000, length = 8, spread = 3, effect = CONST_ME_MAGIC_GREEN, target = false },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_EARTHDAMAGE, minDamage = -3000, maxDamage = -7000, range = 7, radius = 4, shootEffect = CONST_ANI_POISON, effect = CONST_ME_POISONAREA, target = true },
	{ name = "combat", interval = 2000, chance = 18, type = COMBAT_PHYSICALDAMAGE, minDamage = -3000, maxDamage = -7000, range = 7, radius = 4, shootEffect = CONST_ANI_FIRE, effect = CONST_ME_HITAREA, target = true },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_DEATHDAMAGE, minDamage = -4000, maxDamage = -8000, range = 7, shootEffect = CONST_ANI_SUDDENDEATH, effect = CONST_ME_MORTAREA, target = false },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_MANADRAIN, minDamage = -2000, maxDamage = -5000, range = 7, target = false },
}

monster.defenses = {
	defense = 65,
	armor = 60,
	--	mitigation = ???,
	{ name = "combat", interval = 3000, chance = 20, type = COMBAT_HEALING, minDamage = 2000, maxDamage = 3500, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 100 },
	{ type = COMBAT_FIREDAMAGE, percent = 100 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 100 },
	{ type = COMBAT_ICEDAMAGE, percent = 100 },
	{ type = COMBAT_HOLYDAMAGE, percent = -10 },
	{ type = COMBAT_DEATHDAMAGE, percent = 100 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
