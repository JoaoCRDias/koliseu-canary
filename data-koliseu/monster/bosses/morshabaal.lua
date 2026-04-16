local mType = Game.createMonsterType("Morshabaal")
local monster = {}

monster.description = "Morshabaal"
monster.experience = 90000000
monster.outfit = {
	lookType = 1468,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.health = 5000000
monster.maxHealth = 5000000
monster.race = "blood"
monster.corpse = 37704
monster.speed = 530
monster.manaCost = 0

monster.changeTarget = {
	interval = 2000,
	chance = 10,
}

monster.bosstiary = {
	bossRaceId = 2118,
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
	staticAttackChance = 70,
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
	{ text = "Revenge for my little brother!", yell = false },
	{ text = "You are starting to annoy me!", yell = false },
	{ text = "I will restore our family honor!", yell = false },
}

monster.summons = {}

monster.loot = {
	{ id = 3043, chance = 60000, maxCount = 35 }, -- crystal coin
	{ id = 3035, chance = 100000, maxCount = 69 }, -- Platinum Coin
	{ id = 23373, chance = 40000, maxCount = 100 }, -- Ultimate Mana Potion
	{ id = 7643, chance = 30000, maxCount = 100 }, -- Ultimate Health Potion
	{ id = 23374, chance = 30000, maxCount = 100 }, -- Ultimate Spirit Potion
	{ id = 37810, chance = 100000 }, -- Morshabaal's Extract
	{ id = 33780, chance = 100000 }, -- Watermelon Tourmaline (Pear)
	{ id = 33779, chance = 100000 }, -- Watermelon Tourmaline (Slice)
	{ id = 32625, chance = 40000 }, -- Amber with a Dragonfly
	{ id = 30054, chance = 20000 }, -- Unicorn Figurine
	{ id = 31323, chance = 20000 }, -- Sea Horse Figurine
	{ id = 37611, chance = 10000 }, -- Morshabaal's Mask
	{ id = 30060, chance = 10000 }, -- Giant Emerald
	{ id = 14112, chance = 10000 }, -- Bar of Gold
	{ id = 37613, chance = 6666 }, -- Morshabaal's Brain
	{ id = 37608, chance = 6666 }, -- Green Demon Armor
	{ id = 37609, chance = 6666 }, -- Green Demon Helmet
	{ id = 37607, chance = 6666 }, -- Green Demon Legs
	{ id = 37610, chance = 6666 }, -- Green Demon Slippers
	{ id = 30053, chance = 6666 }, -- Dragon Figurine
	{ id = 3309, chance = 6666 }, -- Thunder Hammer
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
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -11000 },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_PHYSICALDAMAGE, minDamage = -4000, maxDamage = -9000, length = 8, spread = 0, effect = CONST_ME_WHITE_ENERGY_SPARK },
	{ name = "combat", interval = 2000, chance = 22, type = COMBAT_ICEDAMAGE, minDamage = -5000, maxDamage = -12000, effect = CONST_ME_ICEATTACK },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_MANADRAIN, minDamage = -2000, maxDamage = -5000, range = 7, shootEffect = CONST_ANI_ENERGY, effect = CONST_ME_POFF, target = false },
	{ name = "combat", interval = 2000, chance = 18, type = COMBAT_LIFEDRAIN, minDamage = -3000, maxDamage = -7000, radius = 8, effect = CONST_ME_LOSEENERGY, target = false },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_MANADRAIN, minDamage = -2000, maxDamage = -5000, radius = 8, effect = CONST_ME_MAGIC_GREEN, target = false },
	{ name = "speed", interval = 2000, chance = 15, speedChange = -900, radius = 6, effect = CONST_ME_POISONAREA, target = false, duration = 20000 },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_FIREDAMAGE, minDamage = -4000, maxDamage = -9000, range = 7, radius = 7, shootEffect = CONST_ANI_FIRE, effect = CONST_ME_FIREAREA, target = true },
	{ name = "combat", interval = 2000, chance = 18, type = COMBAT_LIFEDRAIN, minDamage = -4000, maxDamage = -8000, length = 8, spread = 0, effect = CONST_ME_MAGIC_RED, target = false },
}

monster.defenses = {
	defense = 90,
	armor = 90,
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_HEALING, minDamage = 5000, maxDamage = 10000, effect = CONST_ME_MAGIC_BLUE, target = false },
	{ name = "combat", interval = 3000, chance = 30, type = COMBAT_HEALING, minDamage = 2000, maxDamage = 4000, effect = CONST_ME_MAGIC_BLUE, target = false },
	{ name = "speed", interval = 2000, chance = 15, speedChange = 900, effect = CONST_ME_MAGIC_RED, target = false, duration = 5000 },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 5 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 5 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "drunk", condition = true },
	{ type = "bleed", condition = false },
}

mType.onAppear = function(monster, creature)
	if monster:getType():isRewardBoss() then
		monster:setReward(true)
	end
end

mType:register(monster)
