local mType = Game.createMonsterType("Gaz'Haragoth")
local monster = {}

monster.description = "Gaz'Haragoth"
monster.experience = 80000000
monster.outfit = {
	lookType = 591,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.health = 5000000
monster.maxHealth = 5000000
monster.race = "undead"
monster.corpse = 20228
monster.speed = 250
monster.manaCost = 0

monster.changeTarget = {
	interval = 10000,
	chance = 20,
}

monster.bosstiary = {
	bossRaceId = 1003,
	bossRace = RARITY_NEMESIS,
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
	staticAttackChance = 98,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
	canWalkOnFire = false,
	canWalkOnPoison = false,
}

monster.events = {}

monster.light = {
	level = 0,
	color = 0,
}

monster.summon = {}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "NO ONE WILL ESCAPE ME!", yell = true },
	{ text = "I'LL KEEP THE ORDER UP!", yell = true },
	{ text = "I've beaten tougher demons then you even know!", yell = true },
	{ text = "You puny humans will be my snacks!", yell = true },
}

monster.loot = {
	{ id = 3043, chance = 10000, maxCount = 6 }, -- crystal coin
	{ id = 16124, chance = 10000, maxCount = 15 }, -- blue crystal splinter
	{ id = 7368, chance = 10000, maxCount = 100 }, -- assassin star
	{ id = 20264, chance = 7000, maxCount = 3 }, -- unrealized dream
	{ id = 6499, chance = 1000, maxCount = 2 }, -- demonic essence
	{ id = 7643, chance = 10000, maxCount = 100 }, -- ultimate health potion
	{ id = 238, chance = 10000, maxCount = 100 }, -- great mana potion
	{ id = 7642, chance = 10000, maxCount = 100 }, -- great spirit potion
	{ id = 20063, chance = 2000, maxCount = 3 }, -- dream matter
	{ id = 20062, chance = 12000, maxCount = 14 }, -- cluster of solace
	{ id = 3041, chance = 10000, maxCount = 2 }, -- blue gem
	{ id = 16122, chance = 10000, maxCount = 10 }, -- green crystal splinter
	{ id = 16120, chance = 10000, maxCount = 15 }, -- violet crystal shard
	{ id = 6528, chance = 6000 }, -- infernal bolt
	{ id = 20278, chance = 6000 }, -- demonic tapestry
	{ id = 5914, chance = 6000 }, -- yellow piece of cloth
	{ id = 5911, chance = 6000 }, -- red piece of cloth
	{ id = 20276, chance = 1100 }, -- dream warden mask
	{ id = 281, chance = 6000 }, -- giant shimmering pearl (green)
	{ id = 5954, chance = 6000 }, -- demon horn
	{ id = 20274, chance = 6000, unique = true }, -- nightmare horn
	{ id = 3052, chance = 6000 }, -- life ring
	{ id = 20280, chance = 6000 }, -- nightmare beacon
	{ id = 20279, chance = 6000 }, -- eye pod
	{ id = 20277, chance = 6000 }, -- psychedelic tapestry
	{ id = 20064, chance = 800 }, -- crude umbral blade
	{ id = 20067, chance = 1000 }, -- crude umbral slayer
	{ id = 20070, chance = 1000 }, -- crude umbral axe
	{ id = 20073, chance = 1000 }, -- crude umbral chopper
	{ id = 20079, chance = 1000 }, -- crude umbral hammer
	{ id = 20076, chance = 500 }, -- crude umbral mace
	{ id = 20082, chance = 1000 }, -- crude umbral bow
	{ id = 20085, chance = 400 }, -- crude umbral crossbow
	{ id = 20088, chance = 700 }, -- crude umbral spellbook
	{ id = 20065, chance = 100 }, -- umbral blade
	{ id = 20068, chance = 200 }, -- umbral slayer
	{ id = 20071, chance = 1000 }, -- umbral axe
	{ id = 20074, chance = 500 }, -- umbral chopper
	{ id = 20080, chance = 1000 }, -- umbral hammer
	{ id = 20077, chance = 500 }, -- umbral mace
	{ id = 20083, chance = 250 }, -- umbral bow
	{ id = 20086, chance = 400 }, -- umbral crossbow
	{ id = 20089, chance = 200 }, -- umbral spellbook
	{ id = 20066, chance = 300 }, -- umbral masterblade
	{ id = 20069, chance = 700 }, -- umbral master slayer
	{ id = 20072, chance = 500 }, -- umbral master axe
	{ id = 20075, chance = 300 }, -- umbral master chopper
	{ id = 20081, chance = 250 }, -- umbral master hammer
	{ id = 20078, chance = 300 }, -- umbral master mace
	{ id = 20084, chance = 1300 }, -- umbral master bow
	{ id = 20087, chance = 1000 }, -- umbral master crossbow
	{ id = 20090, chance = 140 }, -- umbral master spellbook
	{ id = 10345, chance = 6000 }, -- solitude charm
	{ id = 10344, chance = 6000 }, -- twin sun charm
	{ id = 10343, chance = 6000 }, -- spiritual charm
	{ id = 10342, chance = 6000 }, -- unity charm
	{ id = 10341, chance = 6000 }, -- phoenix charm
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
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -12000 },
	{ name = "combat", interval = 2000, chance = 25, type = COMBAT_ICEDAMAGE, minDamage = -5000, maxDamage = -11000, range = 7, radius = 7, shootEffect = CONST_ANI_ICE, effect = CONST_ME_ICEAREA, target = true },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_DEATHDAMAGE, minDamage = -4000, maxDamage = -9000, length = 8, spread = 3, effect = CONST_ME_MORTAREA, target = false },
	{ name = "combat", interval = 2000, chance = 18, type = COMBAT_DEATHDAMAGE, minDamage = -3000, maxDamage = -8000, range = 7, radius = 6, shootEffect = CONST_ANI_SUDDENDEATH, effect = CONST_ME_MORTAREA, target = true },
	{ name = "combat", interval = 2000, chance = 22, type = COMBAT_FIREDAMAGE, minDamage = -5000, maxDamage = -12000, length = 8, spread = 3, effect = CONST_ME_HITBYFIRE, target = false },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_PHYSICALDAMAGE, minDamage = -3000, maxDamage = -7000, range = 7, radius = 5, effect = CONST_ME_MAGIC_GREEN, target = false },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_MANADRAIN, minDamage = -2000, maxDamage = -5000, radius = 5, effect = CONST_ME_ENERGYAREA, target = false },
}

monster.defenses = {
	defense = 80,
	armor = 70,
	{ name = "combat", interval = 3000, chance = 35, type = COMBAT_HEALING, minDamage = 3000, maxDamage = 5000, effect = CONST_ME_MAGIC_BLUE, target = false },
	{ name = "speed", interval = 4000, chance = 80, speedChange = 700, effect = CONST_ME_MAGIC_RED, target = false, duration = 6000 },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 50 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 50 },
	{ type = COMBAT_EARTHDAMAGE, percent = 50 },
	{ type = COMBAT_FIREDAMAGE, percent = 50 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 50 },
	{ type = COMBAT_HOLYDAMAGE, percent = 50 },
	{ type = COMBAT_DEATHDAMAGE, percent = 50 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
