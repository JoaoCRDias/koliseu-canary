local mType = Game.createMonsterType("Omniscient Paladin")
local monster = {}

monster.description = "an omniscient paladin"
monster.experience = 0
monster.outfit = {
	lookType = 1366, -- Paladin outfit (boss variant)
	lookHead = 114,
	lookBody = 2,
	lookLegs = 114,
	lookFeet = 2,
	lookAddons = 3,
	lookMount = 0,
}

monster.health = 361250
monster.maxHealth = 361250
monster.race = "blood"
monster.corpse = 0
monster.speed = 330
monster.manaCost = 0

monster.changeTarget = {
	interval = 5000,
	chance = 15,
}

monster.strategiesTarget = {
	nearest = 60,
	health = 20,
	damage = 15,
	random = 5,
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
	staticAttackChance = 85,
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
	color = 144,
}

monster.voices = {
	interval = 5000,
	chance = 20,
	{ text = "The light condemns you!", yell = true },
	{ text = "Holy judgment is upon you!", yell = false },
	{ text = "No shield can deflect divine will!", yell = true },
	{ text = "My arrows carry the wrath of the gods!", yell = false },
}

monster.loot = {}

monster.attacks = {
	-- Melee (close range backup)
	{ name = "melee", interval = 2000, chance = 100, minDamage = -1595, maxDamage = -2390 },
	-- Divine missile (long range holy bolt)
	{ name = "combat", interval = 2500, chance = 40, type = COMBAT_HOLYDAMAGE, minDamage = -2870, maxDamage = -4300, range = 8, shootEffect = CONST_ANI_HOLY, effect = CONST_ME_HOLYDAMAGE, target = true },
	-- Holy wave (AoE holy blast)
	{ name = "combat", interval = 3500, chance = 30, type = COMBAT_HOLYDAMAGE, minDamage = -2550, maxDamage = -3825, radius = 4, effect = CONST_ME_HOLYAREA, target = false },
	-- Holy cross (cross-shaped holy attack)
	{ name = "combat", interval = 4000, chance = 25, type = COMBAT_HOLYDAMAGE, minDamage = -3185, maxDamage = -4780, length = 7, spread = 0, effect = CONST_ME_HOLYDAMAGE, target = false },
	-- Radiant barrage (multi-bolt holy)
	{ name = "combat", interval = 4500, chance = 25, type = COMBAT_HOLYDAMAGE, minDamage = -2230, maxDamage = -3345, range = 7, radius = 2, shootEffect = CONST_ANI_HOLY, effect = CONST_ME_HOLYDAMAGE, target = true },
	-- Blinding light (slow + physical)
	{ name = "speed", interval = 5500, chance = 20, speedChange = -900, range = 7, effect = CONST_ME_MAGIC_YELLOW, target = true, duration = 8000 },
}

monster.defenses = {
	defense = 25,
	armor = 25,
	mitigation = 0.47,
	-- Strong self-heal
	{ name = "combat", interval = 3500, chance = 25, type = COMBAT_HEALING, minDamage = 425, maxDamage = 850, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 10 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -10 },
	{ type = COMBAT_EARTHDAMAGE, percent = -5 },
	{ type = COMBAT_FIREDAMAGE, percent = -5 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -5 },
	{ type = COMBAT_HOLYDAMAGE, percent = 100 },
	{ type = COMBAT_DEATHDAMAGE, percent = -20 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
