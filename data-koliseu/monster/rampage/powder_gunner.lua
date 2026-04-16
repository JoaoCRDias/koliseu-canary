local mType = Game.createMonsterType("Powder Gunner")
local monster = {}

monster.description = "a powder gunner"
monster.experience = 64400
monster.outfit = {
	lookType = 3216,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 2760
monster.Bestiary = {
	class = "Human",
	race = BESTY_RACE_HUMAN,
	toKill = 5000,
	FirstUnlock = 500,
	SecondUnlock = 1000,
	CharmsPoints = 100,
	Stars = 5,
	Occurrence = 0,
	Locations = "Pirate Cove.",
}

monster.health = 97580
monster.maxHealth = 97580
monster.race = "blood"
monster.corpse = 6068
monster.speed = 830
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 15,
}

monster.strategiesTarget = {
	nearest = 60,
	health = 15,
	damage = 15,
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
	staticAttackChance = 60,
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
	{ text = "FIRE IN THE HOLE!", yell = true },
	{ text = "TASTE CANNONFIRE!", yell = true },
}

monster.loot = {
	{ name = "crystal coin", chance = 72000, maxCount = 3 },
	{ name = "gold ingot", chance = 30000, maxCount = 1 },
	{ name = "violet gem", chance = 14000 },
	{ name = "blue gem", chance = 14000 },
	{ name = "green gem", chance = 14000 },
	{ name = "yellow gem", chance = 12000 },
	{ name = "giant sapphire", chance = 8000 },
	{ name = "giant emerald", chance = 5000 },
	{ name = "giant ruby", chance = 5000 },
	{ name = "giant amethyst", chance = 5000 },
	{ name = "giant topaz", chance = 5000 },
	{ name = "boots of haste", chance = 22000 },
	{ name = "demonic essence", chance = 40000, maxCount = 2 },
	{ name = "soul orb", chance = 70000, maxCount = 3 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -6696 },
	{ name = "combat", interval = 2000, chance = 25, type = COMBAT_PHYSICALDAMAGE, minDamage = -5442, maxDamage = -7068, range = 7, radius = 3, shootEffect = CONST_ANI_EXPLOSION, effect = CONST_ME_EXPLOSIONAREA, target = false },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_FIREDAMAGE, minDamage = -5442, maxDamage = -7068, range = 7, radius = 2, shootEffect = CONST_ANI_FIRE, effect = CONST_ME_FIREAREA, target = false },
}

monster.defenses = {
	defense = 302,
	armor = 302,
	mitigation = 20.50,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 5 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -15 },
	{ type = COMBAT_EARTHDAMAGE, percent = 20 },
	{ type = COMBAT_FIREDAMAGE, percent = 30 },
	{ type = COMBAT_LIFEDRAIN, percent = 100 },
	{ type = COMBAT_MANADRAIN, percent = 100 },
	{ type = COMBAT_DROWNDAMAGE, percent = 100 },
	{ type = COMBAT_ICEDAMAGE, percent = -15 },
	{ type = COMBAT_HOLYDAMAGE, percent = -20 },
	{ type = COMBAT_DEATHDAMAGE, percent = 10 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
