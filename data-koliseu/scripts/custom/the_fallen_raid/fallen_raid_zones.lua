-- Fallen Raid Zone Events
-- Applies monster power scaling (escudinho) to monsters in the fallen raid area

local FALLEN_RAID_POWER_LEVEL = 10

local POWER_SCALING = {
	damageDealtPerPower = 3, -- +3% damage dealt per power level
	damageReceivedPerPower = -1, -- -1% damage received per power level (capped at -50%)
	speedPerPower = 3, -- +3 speed per power level
}

local function applyMonsterPower(monster, powerLevel)
	if powerLevel <= 0 then
		return
	end

	local dmgDealtPercent = 100 + (powerLevel * POWER_SCALING.damageDealtPerPower)
	local defenseBonus = math.min(50, powerLevel * math.abs(POWER_SCALING.damageReceivedPerPower))
	local dmgReceivedPercent = 100 - defenseBonus
	local speedBonus = powerLevel * POWER_SCALING.speedPerPower

	monster:changeSpeed(speedBonus)

	local condition = Condition(CONDITION_ATTRIBUTES)
	condition:setParameter(CONDITION_PARAM_TICKS, -1)
	condition:setParameter(CONDITION_PARAM_SUBID, 93001) -- Unique ID for Fallen Raid
	condition:setParameter(CONDITION_PARAM_BUFF_DAMAGEDEALT, dmgDealtPercent)
	condition:setParameter(CONDITION_PARAM_BUFF_DAMAGERECEIVED, dmgReceivedPercent)
	monster:addCondition(condition)

	monster:setIcon("fallen_raid_power", CreatureIconCategory_Modifications, CreatureIconModifications_ReducedHealth, powerLevel)
	monster:setStorageValue(93001, powerLevel)
end

-- Create zone for the fallen raid area
local fallenRaidZone = Zone("fallen_raid.monster_power_zone")
fallenRaidZone:addArea(Position(561, 630, 9), Position(739, 703, 9))

-- Register monster power scaling
local monsterEvent = ZoneEvent(fallenRaidZone)

function monsterEvent.afterEnter(zone, creature)
	local monster = creature:getMonster()
	if monster then
		applyMonsterPower(monster, FALLEN_RAID_POWER_LEVEL)
	end
end

monsterEvent:register()

print(">> Fallen Raid Zone Events loaded successfully!")
