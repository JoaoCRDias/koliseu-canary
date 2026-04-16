local mType = Game.createMonsterType("Fallen Tentacle")
local monster = {}

monster.description = "Fallen Tentacle"
monster.experience = 0
monster.outfit = {
	lookType = 1570,
	lookHead = 38,
	lookBody = 114,
	lookLegs = 0,
	lookFeet = 94,
	lookAddons = 0,
	lookMount = 0,
}

monster.health = 500000
monster.maxHealth = 500000
monster.race = "fire"
monster.corpse = 0
monster.speed = 0
monster.manaCost = 0

monster.changeTarget = {
	interval = 5000,
	chance = 40,
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
	rewardBoss = false,
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
	"FallenTentacleMinionSpawn",
	"FallenInvulnerable",
	"FallenTentacleDeath"
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "I'M HERE TO TEST YOU!!!", yell = true },
	{ text = "IF YOU CAN'T GET THROUGH ME YOU ARE NOT WORTHY OF CONTINUING!", yell = true },
	{ text = "I WILL SMASH YOU!", yell = true },
}

monster.loot = {}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, skill = 400, attack = 210 },
	{ name = "strength", interval = 1000, chance = 10, minDamage = -600, maxDamage = -1450, radius = 5, effect = CONST_ME_HITAREA, target = false },
	{ name = "combat", interval = 3000, chance = 13, type = COMBAT_FIREDAMAGE, minDamage = -300, maxDamage = -800, range = 7, radius = 7, shootEffect = CONST_ANI_FIRE, effect = CONST_ME_FIREAREA, target = true },
	{ name = "fallen tentacle soulfire", interval = 2000, chance = 15, range = 7, target = true },
	{ name = "fire tentacle fire rain", interval = 10000, chance = 40, target = false },
	{ name = "fallen tentacle curse", interval = 5000, chance = 20, target = false },
}

monster.defenses = {
	defense = 200,
	armor = 130,
	--	mitigation = ???,
	{ name = "combat", interval = 1000, chance = 15, type = COMBAT_HEALING, minDamage = 10000, maxDamage = 15000, effect = CONST_ME_MAGIC_RED, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 100 },
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
	{ type = "bleed", condition = false },
}

FallenTentacleCurse = {
	event = nil,
	cursedPlayers = {},
}

mType.onSpawn = function(monster)
	if monster:getName() == "Fallen Tentacle" then
		Game.setStorageValue(GlobalStorage.FallenMinionsSpawned, 0)
		FallenTentacleCurse.event = addEvent(FallenRaid.tentacleCurse, 5000)
	end
end

mType:register(monster)
