-- POI v2 - Zone monster buff system
-- Applies power scaling to all monsters in the POI v2 area (same pattern as Fallen Raid)

local POI_V2_POWER_LEVEL = 180

local POWER_SCALING = {
	damageDealtPerPower = 5,
	speedPerPower = 1,
	healthPerPower = 5, -- +10% max health per power level
}

local function applyMonsterPower(monster, powerLevel)
	if powerLevel <= 0 then
		return
	end

	local dmgDealtPercent = 100 + (powerLevel * POWER_SCALING.damageDealtPerPower)
	local speedBonus = powerLevel * POWER_SCALING.speedPerPower

	monster:changeSpeed(speedBonus)

	local healthMultiplier = 1 + (powerLevel * POWER_SCALING.healthPerPower / 100)
	local newMaxHealth = math.floor(monster:getMaxHealth() * healthMultiplier)
	monster:setMaxHealth(newMaxHealth)
	monster:addHealth(newMaxHealth - monster:getHealth())

	local condition = Condition(CONDITION_ATTRIBUTES)
	condition:setParameter(CONDITION_PARAM_TICKS, -1)
	condition:setParameter(CONDITION_PARAM_SUBID, 93002) -- Unique ID for POI v2
	condition:setParameter(CONDITION_PARAM_BUFF_DAMAGEDEALT, dmgDealtPercent)
	monster:addCondition(condition)

	monster:setIcon("poi_v2_power", CreatureIconCategory_Modifications, CreatureIconModifications_ReducedHealth, powerLevel)
	monster:setStorageValue(93002, powerLevel)
end

-- TODO: set the actual zone coordinates for POI v2 area
local poiV2Zone = Zone("poi_v2.monster_power_zone")
poiV2Zone:addArea(Position(534, 1600, 9), Position(774, 1852, 9)) -- TODO: replace with real coordinates

local monsterEvent = ZoneEvent(poiV2Zone)

function monsterEvent.afterEnter(zone, creature)
	local monster = creature:getMonster()
	if monster and monster:getName() ~= "Quest Defender" then
		applyMonsterPower(monster, POI_V2_POWER_LEVEL)
	end
end

monsterEvent:register()
