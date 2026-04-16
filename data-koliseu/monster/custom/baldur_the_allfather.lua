-- Baldur the Allfather - Holy Element Boss (Odin-themed)
local mType = Game.createMonsterType("Baldur the Allfather")
local monster = {}

monster.description = "Baldur the Allfather"
monster.experience = 0
monster.outfit = {
	lookType = 3167,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.health = 50000000
monster.maxHealth = 50000000
monster.race = "blood"
monster.corpse = 0
monster.speed = 450
monster.manaCost = 0

monster.bosstiary = {
	bossRaceId = 2730,
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
	"BaldurTheAllfatherDeath",
	"BaldurTheAllfatherSpawn",
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "I am the Allfather! All realms bow to my wisdom!", yell = true },
	{ text = "The light of Asgard shall purge you!", yell = true },
	{ text = "My ravens see all, mortals!", yell = false },
	{ text = "You dare challenge the ruler of the gods?", yell = false },
	{ text = "Gungnir shall find its mark!", yell = true },
	{ text = "The divine order will not be broken!", yell = false },
}

monster.loot = {
	{ id = 60673, chance = 8000 }, -- Improved Surprise Gem Bag
	{ id = 60648, chance = 12000 }, -- Boosted Exercise Token
	{ id = 3043, maxCount = 1000, chance = 60000 }, -- Crystal Coin
	{ id = 60663, maxCount = 1, chance = 15000 }, -- Blood Coin
	{ id = 60540, maxCount = 1, chance = 1000 }, -- Scroll Cosmic Transformation
	{ id = 60522, maxCount = 1, chance = 800 }, -- Unrevealed Relic
	{ id = 60532, chance = 3000 }, -- Baldur Reaper outfit
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -30000, maxDamage = -60000 },
	{ name = "combat", interval = 2000, chance = 22, type = COMBAT_HOLYDAMAGE, minDamage = -40000, maxDamage = -70000, range = 7, radius = 4, shootEffect = CONST_ANI_HOLY, effect = CONST_ME_HOLYAREA, target = true },
	{ name = "combat", interval = 2000, chance = 18, type = COMBAT_HOLYDAMAGE, minDamage = -35000, maxDamage = -65000, length = 8, spread = 3, effect = CONST_ME_HOLYDAMAGE, target = false },
	{ name = "combat", interval = 2000, chance = 18, type = COMBAT_ENERGYDAMAGE, minDamage = -30000, maxDamage = -55000, range = 7, radius = 4, shootEffect = CONST_ANI_ENERGY, effect = CONST_ME_ENERGYAREA, target = true },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_PHYSICALDAMAGE, minDamage = -45000, maxDamage = -80000, radius = 3, effect = CONST_ME_GROUNDSHAKER, target = false },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_FIREDAMAGE, minDamage = -30000, maxDamage = -55000, range = 7, radius = 3, shootEffect = CONST_ANI_FIRE, effect = CONST_ME_FIREAREA, target = true },
	{ name = "speed", interval = 2000, chance = 10, speedChange = -850, range = 7, effect = CONST_ME_MAGIC_RED, target = true, duration = 8000 },
	-- Special mechanics (handled via BaldurMechanics script)
	{ name = "baldur_divine_spear", interval = 8000, chance = 50, target = true },
	{ name = "baldur_runic_wave", interval = 12000, chance = 50, target = false },
}

monster.defenses = {
	defense = 120,
	armor = 120,
	mitigation = 2.90,
	{ name = "combat", interval = 2000, chance = 14, type = COMBAT_HEALING, minDamage = 800, maxDamage = 2000, effect = CONST_ME_MAGIC_BLUE, target = false },
	{ name = "speed", interval = 2000, chance = 14, speedChange = 450, effect = CONST_ME_MAGIC_RED, target = false, duration = 7000 },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 15 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 20 },
	{ type = COMBAT_EARTHDAMAGE, percent = -10 },
	{ type = COMBAT_FIREDAMAGE, percent = 10 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -15 },
	{ type = COMBAT_HOLYDAMAGE, percent = 50 },
	{ type = COMBAT_DEATHDAMAGE, percent = -20 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
