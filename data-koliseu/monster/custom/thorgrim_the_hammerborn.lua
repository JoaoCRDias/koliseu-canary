-- Thorgrim the Hammerborn - Thor-themed Boss
local mType = Game.createMonsterType("Thorgrim the Hammerborn")
local monster = {}

monster.description = "Thorgrim the Hammerborn"
monster.experience = 0
monster.outfit = {
	lookType = 3113,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.health = 3000000
monster.maxHealth = 3000000
monster.race = "blood"
monster.corpse = 0
monster.speed = 270
monster.manaCost = 0

monster.bosstiary = {
	bossRaceId = 2732,
	bossRace = RARITY_ARCHFOE,
}

monster.changeTarget = {
	interval = 2000,
	chance = 8,
}

monster.strategiesTarget = {
	nearest = 70,
	health = 10,
	damage = 15,
	random = 5,
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
	staticAttackChance = 96,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
	canWalkOnFire = true,
	canWalkOnPoison = true,
}

monster.light = {
	level = 8,
	color = 215,
}

monster.events = {
	"ThorgrimTheHammerbornDeath",
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "I am the storm incarnate!", yell = true },
	{ text = "Mjolnir hungers for battle!", yell = true },
	{ text = "Thunder answers my call!", yell = false },
	{ text = "Kneel before the god of thunder!", yell = true },
	{ text = "The skies tremble at my fury!", yell = false },
	{ text = "You cannot outrun lightning!", yell = true },
}

monster.summon = {
	maxSummons = 3,
	summons = {
		{ name = "Thorgrim's Stormbringer", chance = 25, interval = 5000, count = 3 },
	},
}

monster.loot = {}

monster.attacks = {
	{ name = "melee", interval = 1000, chance = 100, minDamage = -3000, maxDamage = -6000 },
	{ name = "combat", interval = 1000, chance = 20, type = COMBAT_ENERGYDAMAGE, minDamage = -4000, maxDamage = -14000, range = 7, radius = 5, shootEffect = CONST_ANI_ENERGY, effect = CONST_ME_ENERGYAREA, target = true },
	{ name = "combat", interval = 1000, chance = 17, type = COMBAT_ENERGYDAMAGE, minDamage = -5000, maxDamage = -12000, length = 8, spread = 3, effect = CONST_ME_BIGCLOUDS, target = false },
	{ name = "combat", interval = 1000, chance = 15, type = COMBAT_PHYSICALDAMAGE, minDamage = -7000, maxDamage = -15000, radius = 4, effect = CONST_ME_GROUNDSHAKER, target = false },
	{ name = "speed", interval = 1000, chance = 10, speedChange = -800, range = 7, effect = CONST_ME_ENERGYHIT, target = true, duration = 8000 },
	-- Special mechanics
	{ name = "thorgrim_thunder_rain", interval = 10000, chance = 50, target = false },
	{ name = "thorgrim_chain_lightning", interval = 4000, chance = 30, target = true },
	{ name = "thorgrim_ground_slam", interval = 8000, chance = 60, target = false },
}

monster.defenses = {
	defense = 115,
	armor = 115,
	mitigation = 2.80,
	{ name = "combat", interval = 1000, chance = 12, type = COMBAT_HEALING, minDamage = 400, maxDamage = 1200, effect = CONST_ME_MAGIC_BLUE, target = false },
	{ name = "speed", interval = 1000, chance = 14, speedChange = 450, effect = CONST_ME_MAGIC_RED, target = false, duration = 7000 },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 15 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 50 },
	{ type = COMBAT_EARTHDAMAGE, percent = -15 },
	{ type = COMBAT_FIREDAMAGE, percent = 10 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 10 },
	{ type = COMBAT_HOLYDAMAGE, percent = 20 },
	{ type = COMBAT_DEATHDAMAGE, percent = -10 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

-- ============================================================
-- HAZARD SYSTEM
-- ============================================================
monster.hazard = true
monster.hazardCrit = true
monster.hazardDodge = true
monster.hazardDamageBoost = true
monster.hazardDefenseBoost = true

mType:register(monster)
