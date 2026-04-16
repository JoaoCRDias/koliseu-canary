-- Jacquin Quest - Zone monster buff system
-- Applies power scaling to all monsters in the Jacquin quest area

local JACQUIN_POWER_LEVEL = 130
local DARKNESS_WARLOCK_POWER_LEVEL = 30

local POWER_SCALING = {
	damageDealtPerPower = 5,
	speedPerPower = 1,
	healthPerPower = 5,
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
	condition:setParameter(CONDITION_PARAM_SUBID, 93003) -- Unique ID for Jacquin
	condition:setParameter(CONDITION_PARAM_BUFF_DAMAGEDEALT, dmgDealtPercent)
	monster:addCondition(condition)

	monster:setIcon("jacquin_power", CreatureIconCategory_Modifications, CreatureIconModifications_ReducedHealth, powerLevel)
	monster:setStorageValue(93003, powerLevel)
end

local jacquinZone = Zone("jacquin.monster_power_zone")
jacquinZone:addArea(Position(813, 1554, 8), Position(909, 1674, 8))

local monsterEvent = ZoneEvent(jacquinZone)

function monsterEvent.afterEnter(zone, creature)
	local monster = creature:getMonster()
	if not monster then
		return
	end

	local name = monster:getName()
	if name == "Quest Defender" then
		return
	elseif name == "Darkness Warlock" then
		applyMonsterPower(monster, DARKNESS_WARLOCK_POWER_LEVEL)
	else
		applyMonsterPower(monster, JACQUIN_POWER_LEVEL)
	end
end

monsterEvent:register()
