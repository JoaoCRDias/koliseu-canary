-- The bonfire the player must defend inside the Supreme Vocation fire chamber.
-- It's a static object disguised as a monster: no attacks, no movement, lots
-- of HP. Damage comes from frost mobs that reach it.

local mType = Game.createMonsterType("Supreme Bonfire")
local monster = {}

monster.description = "a roaring bonfire"
monster.experience = 0

monster.outfit = {
	lookTypeEx = 30250,
}

monster.health = 20000
monster.maxHealth = 20000
monster.race = "fire"
monster.corpse = 0
monster.speed = 0
monster.manaCost = 0

monster.faction = FACTION_EFREET

monster.changeTarget = { interval = 0, chance = 0 }

monster.flags = {
	summonable = false,
	attackable = true,
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
	healthHidden = false,
	isBlockable = true,
	canWalkOnEnergy = true,
	canWalkOnFire = true,
	canWalkOnPoison = true,
	ignoreSpawnBlock = true,
}

monster.attacks = {}
monster.defenses = { defense = 0, armor = 0 }

monster.elements = {
	-- Takes more damage from ice (intentional — theme).
	{ type = COMBAT_ICEDAMAGE, percent = -100 },
	-- Fire damage goes through to onHealthChange where it's converted to healing.
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = true },
	{ type = "drunk", condition = true },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = true },
}

monster.events = { "SvBonfireDeath", "SvBonfireInvulnerable" }

mType:register(monster)
