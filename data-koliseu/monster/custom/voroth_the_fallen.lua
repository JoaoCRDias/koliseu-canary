local mType = Game.createMonsterType("Voroth The Fallen")
local monster = {}

monster.description = "Voroth The Fallen"
monster.experience = 0
monster.outfit = {
	lookType = 3088,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.health = 25000000
monster.maxHealth = 25000000
monster.race = "undead"
monster.corpse = 32707
monster.speed = 170
monster.manaCost = 0

monster.bosstiary = {
	bossRaceId = 2731,
	bossRace = RARITY_ARCHFOE,
}

monster.changeTarget = {
	interval = 5000,
	chance = 25,
}

monster.summon = {
	maxSummons = 3,
	summons = {
		{ name = "Elder Bloodjaw", chance = 20, interval = 2000, count = 2 },
	},
}

monster.strategiesTarget = {
	nearest = 50,
	health = 20,
	damage = 20,
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

monster.events = {
	"VorothPhaseHandler",
	"VorothInvulnerable",
	"VorothDeath",
}

monster.voices = {
	interval = 7000,
	chance = 10,
	{ text = "The abyss calls your names...", yell = true },
	{ text = "Kneel before the fallen!", yell = true },
}

monster.loot = {
	{ id = 60126, chance = 800 },
	{ id = 60125, chance = 800 },
	{ id = 60022, chance = 50 },
	{ name = "bag you desire", chance = 400 },
	{ name = "primal bag", chance = 400 },
	{ id = 43895, chance = 360 }, -- Bag you covet
	{ id = 60155, chance = 260 },
	{ id = 60156, chance = 260 },
	{ id = 60022, chance = 50 },
	{ name = "crystal coin", chance = 55000, minCount = 130, maxCount = 200 },
	{ id = 281, chance = 1150 }, -- giant shimmering pearl (green)
	{ name = "giant sapphire", chance = 10000, maxCount = 1 },
	{ name = "giant topaz", chance = 10000, maxCount = 1 },
	{ name = "violet gem", chance = 6000, maxCount = 1 },
	{ name = "blue gem", chance = 10000, maxCount = 3 },
	{ id = 3039, chance = 10000, maxCount = 3 }, -- red gem
	{ name = "green gem", chance = 10000, maxCount = 3 },
	{ name = "yellow gem", chance = 10000, maxCount = 3 },
	{ name = "white gem", chance = 6000, maxCount = 3 },

	{ name = "mage skill gem", chance = 600, maxCount = 1 },
	{ name = "knight skill gem", chance = 600, maxCount = 1 },
	{ name = "paladin skill gem", chance = 600, maxCount = 1 },
	{ id = 60429, chance = 800, maxCount = 1 },
	{ id = 60428, chance = 300, maxCount = 1 },
	{ id = 60427, chance = 100, maxCount = 1 },
	{ id = 60647, chance = 5000, maxCount = 1, unique = true },
	{ id = 60648, chance = 2000, maxCount = 1 }
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -6000, maxDamage = -14000 },
	{ name = "combat", interval = 2000, chance = 30, type = COMBAT_DEATHDAMAGE, minDamage = -2800, maxDamage = -4500, range = 7, radius = 5, effect = CONST_ME_MORTAREA, target = true },
	{ name = "combat", interval = 2000, chance = 22, type = COMBAT_ICEDAMAGE, minDamage = -2800, maxDamage = -4200, length = 8, spread = 3, effect = CONST_ME_ICEATTACK, target = false },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_HOLYDAMAGE, minDamage = -2600, maxDamage = -4000, radius = 6, effect = CONST_ME_HOLYDAMAGE, target = false },
	{ name = "voroth ground slam", interval = 5000, chance = 20, target = false },
	{ name = "voroth mark", interval = 8000, chance = 30, target = true },
	{ name = "voroth bombardment", interval = 20000, chance = 15, target = false },
}

monster.defenses = {
	defense = 260,
	armor = 210,
	{ name = "combat", interval = 2000, chance = 12, type = COMBAT_HEALING, minDamage = 30000, maxDamage = 60000, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 35 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 25 },
	{ type = COMBAT_EARTHDAMAGE, percent = 25 },
	{ type = COMBAT_FIREDAMAGE, percent = 25 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -15 },
	{ type = COMBAT_HOLYDAMAGE, percent = -15 },
	{ type = COMBAT_DEATHDAMAGE, percent = 60 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
