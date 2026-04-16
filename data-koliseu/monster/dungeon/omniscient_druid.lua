local mType = Game.createMonsterType("Omniscient Druid")
local monster = {}

monster.description = "an omniscient druid"
monster.experience = 0
monster.outfit = {
	lookType = 1364, -- Druid outfit
	lookHead = 57,
	lookBody = 94,
	lookLegs = 57,
	lookFeet = 94,
	lookAddons = 3,
	lookMount = 0,
}

monster.health = 318750
monster.maxHealth = 318750
monster.race = "blood"
monster.corpse = 0
monster.speed = 310
monster.manaCost = 0

monster.changeTarget = {
	interval = 6000,
	chance = 15,
}

monster.strategiesTarget = {
	nearest = 40,
	health = 25,
	damage = 25,
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
	canPushCreatures = false,
	staticAttackChance = 80,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
	canWalkOnFire = true,
	canWalkOnPoison = true,
}

monster.light = {
	level = 7,
	color = 35,
}

monster.voices = {
	interval = 5000,
	chance = 20,
	{ text = "Nature's wrath has no equal!", yell = true },
	{ text = "The storm, the frost, the earth — all answer to me!", yell = false },
	{ text = "Blizzard!", yell = true },
	{ text = "The world itself rebels against you!", yell = false },
}

monster.loot = {}

monster.attacks = {
	-- Melee backup
	{ name = "melee", interval = 2000, chance = 100, minDamage = -1275, maxDamage = -1910 },
	-- Grand blizzard (large radius ice AoE)
	{ name = "combat", interval = 3000, chance = 35, type = COMBAT_ICEDAMAGE, minDamage = -2870, maxDamage = -4300, radius = 6, effect = CONST_ME_ICEAREA, target = false },
	-- Thunderstorm (energy AoE)
	{ name = "combat", interval = 3500, chance = 30, type = COMBAT_ENERGYDAMAGE, minDamage = -2550, maxDamage = -3825, radius = 4, effect = CONST_ME_ENERGYAREA, target = false },
	-- Ice wave (wide cone freeze)
	{ name = "combat", interval = 4000, chance = 25, type = COMBAT_ICEDAMAGE, minDamage = -2550, maxDamage = -3825, length = 8, spread = 4, effect = CONST_ME_ICEATTACK, target = false },
	-- Poison chain (earth ranged)
	{ name = "combat", interval = 4000, chance = 25, type = COMBAT_EARTHDAMAGE, minDamage = -2230, maxDamage = -3345, range = 8, shootEffect = CONST_ANI_EARTH, effect = CONST_ME_POISONAREA, target = true },
	-- Nature DoT (strong poison)
	{ name = "condition", interval = 5000, chance = 20, type = CONDITION_POISON, minDamage = -255, maxDamage = -380, range = 8, shootEffect = CONST_ANI_EARTH, target = true },
	-- Thorn barrage (earth ranged AoE)
	{ name = "combat", interval = 5000, chance = 20, type = COMBAT_EARTHDAMAGE, minDamage = -1910, maxDamage = -2870, range = 7, radius = 3, shootEffect = CONST_ANI_EARTH, effect = CONST_ME_POISONAREA, target = true },
}

monster.defenses = {
	defense = 23,
	armor = 23,
	mitigation = 0.42,
	-- Massive self-heal
	{ name = "combat", interval = 3500, chance = 30, type = COMBAT_HEALING, minDamage = 530, maxDamage = 1060, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 5 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -15 },
	{ type = COMBAT_EARTHDAMAGE, percent = 100 },
	{ type = COMBAT_FIREDAMAGE, percent = -15 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 20 },
	{ type = COMBAT_HOLYDAMAGE, percent = -15 },
	{ type = COMBAT_DEATHDAMAGE, percent = -10 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "poison", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
