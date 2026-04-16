local mType = Game.createMonsterType("Blind Monstrosity")
local monster = {}

monster.description = "a blind monstrosity"
monster.experience = 0
monster.outfit = {
	lookType = 1869,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.health = 5650 -- unknown
monster.maxHealth = 5650 -- unknown
monster.race = "venom"
monster.corpse = 6532 -- unknown
monster.speed = 40
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
	canTarget = false,
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
}

monster.attacks = {}

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

local positionMonsterX = 0
local positionMonsterY = 0

local direitaPosition = 32919
local esquerdaPosition = 32909
local ySemCrate = 31420

local xCrate = 32918
local crateCimaPosition = 31417
local crateBaixoPosition = 31418

local lastPositionMonsterX = 0
local lastPositionMonsterY = 0
local timeSecondsStopped = 0

local blindMonstrosityArea = {
	{ 0, 0, 1, 1, 1, 0, 0 },
	{ 0, 1, 1, 1, 1, 1, 0 },
	{ 1, 1, 1, 1, 1, 1, 1 },
	{ 1, 1, 1, 1, 1, 1, 1 },
	{ 1, 1, 1, 1, 1, 1, 1 },
	{ 0, 1, 1, 1, 1, 1, 0 },
	{ 0, 0, 1, 1, 1, 0, 0 }
}

mType.onThink = function(monster, interval)
	if monster:getName() == "Blind Monstrosity" then
		local monsterPosition = monster and monster:getPosition() or nil
		if monsterPosition then
			local centerX = 4
			local centerY = 4
			for y = 1, #blindMonstrosityArea do
				for x = 1, #blindMonstrosityArea[y] do
					if blindMonstrosityArea[y][x] == 1 then
						local position = Position(monsterPosition.x + (x - centerX), monsterPosition.y + (y - centerY), monsterPosition.z)
						if position then
							local tile = Tile(position)
							if tile and tile:isWalkable(false, false, false, true, true) then
								position:sendMagicEffect(CONST_ME_DRAWBLOOD)
								local creature = tile:getTopCreature()
								if creature and creature:isPlayer() and creature:getStorageValue(Storage.Quest.U15_10.BloodyTusks.Bloodbath) ~= 2 then
									creature:teleportTo(Position(32906, 31428, 5))
								end
							end
						end
					end
				end
			end

			local hasCrate = false
			local tile = Tile(Position(32919, 31416, 5))
			if tile then
				local crate = tile:getTopCreature()
				if crate and crate:isMonster() then
					if crate:getName() == "Crate" then
						hasCrate = true
					end
				end
			end

			local x = 0
			local y = 0

			if positionMonsterX == 0 then
				x = esquerdaPosition
				y = ySemCrate
			else
				if not hasCrate then
					if positionMonsterX ~= xCrate then
						x = xCrate
						y = crateCimaPosition
					else
						if positionMonsterY == crateCimaPosition and monsterPosition.x == xCrate and monsterPosition.y == crateCimaPosition then
							x = xCrate
							y = crateBaixoPosition
						elseif positionMonsterY == crateBaixoPosition and monsterPosition.x == xCrate and monsterPosition.y == crateBaixoPosition then
							x = xCrate
							y = crateCimaPosition
						end
					end
					monster:say("???", TALKTYPE_MONSTER_SAY)
				else
					if positionMonsterX == esquerdaPosition and monsterPosition.x == esquerdaPosition then
						x = direitaPosition
						y = ySemCrate
					elseif positionMonsterX == direitaPosition and monsterPosition.x == direitaPosition then
						x = esquerdaPosition
						y = ySemCrate
					end
				end
			end

			if lastPositionMonsterX == monsterPosition.x and lastPositionMonsterY == monsterPosition.y then
				timeSecondsStopped = timeSecondsStopped + 1
			else
				lastPositionMonsterX = monsterPosition.x
				lastPositionMonsterY = monsterPosition.y
				timeSecondsStopped = 0
			end

			if timeSecondsStopped >= 3 then
				x = esquerdaPosition
				y = ySemCrate
				timeSecondsStopped = 0
			end

			if x ~= 0 then
				monster:walkTo(Position(x, y, 5))
				positionMonsterX = x
				positionMonsterY = y
			else
				monster:walkTo(Position(positionMonsterX, positionMonsterY, 5))
			end
		end
	end
end

mType:register(monster)
