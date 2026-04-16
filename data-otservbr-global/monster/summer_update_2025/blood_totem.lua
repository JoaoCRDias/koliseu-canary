local mType = Game.createMonsterType("Blood Totem")
local monster = {}

monster.description = "a blood totem"
monster.experience = 0
monster.outfit = {
	lookTypeEx = 51192,
}

monster.health = 5650 -- unknown
monster.maxHealth = 5650 -- unknown
monster.race = "undead"
monster.corpse = 0 -- unknown
monster.speed = 0
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 10,
}

monster.strategiesTarget = {
	nearest = 70,
	health = 10,
	damage = 10,
	random = 10,
}

monster.flags = {
	summonable = false,
	attackable = false,
	hostile = true,
	convinceable = false,
	pushable = false,
	rewardBoss = false,
	illusionable = true,
	canPushItems = true,
	canPushCreatures = true,
	staticAttackChance = 80,
	targetDistance = 1,
	runHealth = 85,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
	canWalkOnFire = false,
	canWalkOnPoison = true,
}

monster.light = {
	level = 0,
	color = 0,
}

monster.voices = {
	interval = 5000,
	chance = 10,
}

monster.defenses = {
	defense = 20,
	armor = 20,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
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

local blindMonstrosityArea = {
	{ 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0 },
	{ 0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0 },
	{ 0, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0 },
	{ 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0 },
	{ 0, 1, 1 ,1, 1, 1, 1, 1, 1, 1, 0 },
	{ 1 ,1, 1, 1, 1, 1, 1, 1, 1, 1, 1 },
	{ 0 ,1, 1, 1, 1, 1, 1, 1, 1, 1, 0 },
	{ 0 ,1, 1, 1, 1, 1, 1, 1, 1, 1, 0 },
	{ 0 ,0, 1, 1, 1, 1, 1, 1, 1, 0, 0 },
	{ 0 ,0, 0, 1, 1, 1, 1, 1, 0, 0, 0 },
	{ 0 ,0, 0, 0, 0, 1, 0, 0, 0, 0, 0 }
}

mType.onThink = function(monster, interval)
	if monster:getName() == "Blood Totem" then
		local monsterPosition = monster and monster:getPosition() or nil
		if monsterPosition then
			local centerX = 6
			local centerY = 6
			for y = 1, #blindMonstrosityArea do
				for x = 1, #blindMonstrosityArea[y] do
					if blindMonstrosityArea[y][x] == 1 then
						local position = Position(monsterPosition.x + (x - centerX), monsterPosition.y + (y - centerY), monsterPosition.z)
						if position then
							local tile = Tile(position)
							if tile then
								position:sendMagicEffect(CONST_ME_DRAWBLOOD)
								local creature = tile:getTopCreature()
								if creature and creature:isPlayer() and creature:getStorageValue(Storage.Quest.U15_10.BloodyTusks.Bloodbath) ~= 2 then
									doTargetCombatHealth(0, creature, COMBAT_PHYSICALDAMAGE, -70, -200, CONST_ME_DRAWBLOOD)
								end
							end
						end
					end
				end
			end
		end
	end
end

mType:register(monster)
