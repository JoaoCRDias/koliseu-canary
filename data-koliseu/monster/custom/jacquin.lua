local mType = Game.createMonsterType("Jacquin")
local monster = {}

monster.description = "Jacquin"
monster.experience = 500000
monster.outfit = {
	lookType = 3373,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.health = 1200000
monster.maxHealth = 1200000
monster.race = "blood"
monster.corpse = 0
monster.speed = 380
monster.manaCost = 0

monster.bosstiary = {
	bossRaceId = 2800,
	bossRace = RARITY_ARCHFOE,
}

monster.changeTarget = {
	interval = 3000,
	chance = 15,
}

monster.strategiesTarget = {
	nearest = 60,
	health = 15,
	damage = 20,
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
	level = 6,
	color = 212,
}

monster.events = {
	"JacquinDeath",
	"JacquinThink",
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "VERGONHA DA PROFISSON", yell = true },
	{ text = "You call that fighting? I've seen better from a raw potato!", yell = true },
	{ text = "My secret ingredient? PAIN!", yell = false },
	{ text = "This dish is to DIE for!", yell = false },
	{ text = "Order up... YOUR DEMISE!", yell = true },
	{ text = "Too many cooks? I only need ONE!", yell = false },
}

monster.loot = {
}

monster.attacks = {
	-- Melee
	{ name = "melee", interval = 2000, chance = 100, minDamage = -6000, maxDamage = -13000 },
	-- "Hell's Kitchen" - AoE fire around self
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_FIREDAMAGE, minDamage = -8000, maxDamage = -15000, radius = 5, effect = CONST_ME_FIREAREA, target = false },
	-- "Knife Throw" - ranged physical single target
	{ name = "combat", interval = 2000, chance = 22, type = COMBAT_PHYSICALDAMAGE, minDamage = -7000, maxDamage = -12000, range = 7, shootEffect = CONST_ANI_THROWINGKNIFE, effect = CONST_ME_EXPLOSIONAREA, target = true },
	-- "Taste My Sauce!" - poison wave frontal
	{ name = "combat", interval = 2000, chance = 18, type = COMBAT_EARTHDAMAGE, minDamage = -6000, maxDamage = -11000, length = 8, spread = 3, effect = CONST_ME_GREEN_RINGS, target = false },
	-- "Flambé!" - fire beam
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_FIREDAMAGE, minDamage = -9000, maxDamage = -16000, length = 8, spread = 0, effect = CONST_ME_FIREATTACK, target = false },
	-- "Death Seasoning" - death AoE on target
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_DEATHDAMAGE, minDamage = -7000, maxDamage = -13000, range = 7, radius = 3, shootEffect = CONST_ANI_DEATH, effect = CONST_ME_MORTAREA, target = true },
	-- "Grease Trap" - speed debuff
	{ name = "speed", interval = 3000, chance = 12, speedChange = -600, range = 7, radius = 4, effect = CONST_ME_POISONAREA, target = false, duration = 6000 },
	-- Fire field hazard
	{ name = "firefield", interval = 3000, chance = 10, range = 7, radius = 4, shootEffect = CONST_ANI_FIRE, target = false },
}

monster.defenses = {
	defense = 100,
	armor = 100,
	mitigation = 2.80,
	{ name = "combat", interval = 2000, chance = 12, type = COMBAT_HEALING, minDamage = 6000, maxDamage = 12000, effect = CONST_ME_MAGIC_RED, target = false },
	{ name = "speed", interval = 2000, chance = 10, speedChange = 380, effect = CONST_ME_MAGIC_GREEN, target = false, duration = 5000 },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 10 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 5 },
	{ type = COMBAT_EARTHDAMAGE, percent = 20 },
	{ type = COMBAT_FIREDAMAGE, percent = 50 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -15 },
	{ type = COMBAT_HOLYDAMAGE, percent = -10 },
	{ type = COMBAT_DEATHDAMAGE, percent = 25 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = true },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
