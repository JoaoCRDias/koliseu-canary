-- Gloom Spore: stationary explosive used inside the Supreme Vocation poison
-- room. Behaves as a fragile prop: 1 HP, no attacks, no movement. The room's
-- driver schedules its detonation (3x3 explosion + chance to drop antidote).

local mType = Game.createMonsterType("Gloom Spore")
local monster = {}

monster.description = "a gloom spore"
monster.experience = 0

monster.outfit = {
	lookTypeEx = 43587,
}

monster.health = 1
monster.maxHealth = 1
monster.race = "venom"
monster.corpse = 0
monster.speed = 0
monster.manaCost = 0

monster.changeTarget = {
	interval = 0,
	chance = 0,
}

monster.flags = {
	summonable = false,
	attackable = false,
	hostile = false,
	convinceable = false,
	pushable = false,
	rewardBoss = false,
	illusionable = false,
	canPushItems = false,
	canPushCreatures = false,
	staticAttackChance = 0,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = true,
	isBlockable = true,
	canWalkOnEnergy = true,
	canWalkOnFire = true,
	canWalkOnPoison = true,
}

monster.attacks = {}
monster.defenses = { defense = 0, armor = 0 }
monster.elements = {}
monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = true },
	{ type = "drunk", condition = true },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = true },
}

mType:register(monster)
