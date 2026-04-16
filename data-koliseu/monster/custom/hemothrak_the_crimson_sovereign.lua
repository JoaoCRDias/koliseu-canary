-- Hemothrak, The Crimson Sovereign - Blood Element Boss
-- Next tier above Baldur the Allfather
local mType = Game.createMonsterType("Hemothrak the Crimson Sovereign")
local monster = {}

monster.description = "Hemothrak the Crimson Sovereign"
monster.experience = 0
monster.outfit = {
	lookType = 3118,
	lookHead = 78,
	lookBody = 94,
	lookLegs = 78,
	lookFeet = 94,
	lookAddons = 0,
	lookMount = 0,
}

monster.health = 75000000
monster.maxHealth = 75000000
monster.race = "blood"
monster.corpse = 0
monster.speed = 480
monster.manaCost = 0

monster.bosstiary = {
	bossRaceId = 2768,
	bossRace = RARITY_ARCHFOE,
}

monster.changeTarget = {
	interval = 2000,
	chance = 10,
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
	color = 180,
}

monster.events = {
	"HemothrakDeath",
	"HemothrakSpawn",
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "Each drop of blood spilled feeds my eternity!", yell = true },
	{ text = "Your veins are mine to command!", yell = true },
	{ text = "The crimson tide rises!", yell = false },
	{ text = "Bleed for me, mortals!", yell = false },
	{ text = "I am the lord of the crimson abyss!", yell = true },
	{ text = "Your blood sings to me...", yell = false },
}

monster.loot = {
	{ id = 60673, chance = 9000 }, -- Improved Surprise Gem Bag
	{ id = 60648, chance = 13000 }, -- Boosted Exercise Token
	{ id = 3043, maxCount = 1500, chance = 60000 }, -- Crystal Coin
	{ id = 60663, maxCount = 1, chance = 2500 }, -- Blood Coin
	{ id = 60540, maxCount = 1, chance = 1200 }, -- Scroll Cosmic Transformation
	{ id = 60522, maxCount = 1, chance = 800 }, -- Unrevealed Relic
	{ id = 12305, chance = 50 }, -- Blood Castle Key

}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -40000, maxDamage = -75000 },
	{ name = "combat", interval = 2000, chance = 22, type = COMBAT_DEATHDAMAGE, minDamage = -45000, maxDamage = -80000, range = 7, radius = 4, shootEffect = CONST_ANI_DEATH, effect = CONST_ME_MORTAREA, target = true },
	{ name = "combat", interval = 2000, chance = 18, type = COMBAT_DEATHDAMAGE, minDamage = -40000, maxDamage = -70000, length = 8, spread = 3, effect = CONST_ME_DRAWBLOOD, target = false },
	{ name = "combat", interval = 2000, chance = 18, type = COMBAT_LIFEDRAIN, minDamage = -35000, maxDamage = -60000, range = 7, radius = 4, shootEffect = CONST_ANI_DEATH, effect = CONST_ME_MAGIC_RED, target = true },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_PHYSICALDAMAGE, minDamage = -50000, maxDamage = -90000, radius = 3, effect = CONST_ME_GROUNDSHAKER, target = false },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_FIREDAMAGE, minDamage = -35000, maxDamage = -60000, range = 7, radius = 3, shootEffect = CONST_ANI_FIRE, effect = CONST_ME_FIREATTACK, target = true },
	{ name = "speed", interval = 2000, chance = 10, speedChange = -900, range = 7, effect = CONST_ME_MAGIC_RED, target = true, duration = 8000 },
	-- Special mechanics (handled via HemothrakMechanics script)
	{ name = "hemothrak_hemorrhage", interval = 10000, chance = 50, target = false },
	{ name = "hemothrak_blood_nova", interval = 45000, chance = 100, target = false },
}

monster.defenses = {
	defense = 130,
	armor = 130,
	mitigation = 3.10,
	{ name = "combat", interval = 2000, chance = 14, type = COMBAT_HEALING, minDamage = 1000, maxDamage = 3000, effect = CONST_ME_MAGIC_RED, target = false },
	{ name = "speed", interval = 2000, chance = 14, speedChange = 480, effect = CONST_ME_MAGIC_RED, target = false, duration = 7000 },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 15 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 10 },
	{ type = COMBAT_EARTHDAMAGE, percent = 20 },
	{ type = COMBAT_FIREDAMAGE, percent = -20 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -10 },
	{ type = COMBAT_HOLYDAMAGE, percent = -15 },
	{ type = COMBAT_DEATHDAMAGE, percent = 50 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
