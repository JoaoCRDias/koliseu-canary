-- Cosmic Siege Zone Events
-- Handles player hazard icons and monster power scaling in siege zones

if not CosmicSiege then
	local ok, err = pcall(dofile, "data-koliseu/scripts/custom/cosmic_siege/cosmic_siege.lua")
	if not ok then
		logger.error("[Cosmic Siege Zones] Failed to load base module: {}", err)
		return
	end
end

if not CosmicSiege then
	logger.error("[Cosmic Siege Zones] Base module not available.")
	return
end

-- Monster power scaling per siege level
CosmicSiege.MONSTER_POWER = {
	[500] = 10, -- Arena 500 = Power 25
	[1000] = 15, -- Arena 1000 = Power 30 (was 50)
	[1500] = 20, -- Arena 1500 = Power 45 (was 100)
}

-- Scaling configuration
CosmicSiege.POWER_SCALING = {
	damageDealtPerPower = 3, -- +3% damage dealt per power level
	damageReceivedPerPower = -1, -- -1% damage received per power level (capped at -50%)
	speedPerPower = 3, -- +3 speed per power level
}

-- Helper function to apply power scaling to monsters via Condition
---@param monster Monster
---@param powerLevel number
local function applyMonsterPower(monster, powerLevel)
	if powerLevel <= 0 then
		return
	end

	-- Calculate scaling
	local dmgDealtPercent = 100 + (powerLevel * CosmicSiege.POWER_SCALING.damageDealtPerPower)
	local defenseBonus = math.min(50, powerLevel * math.abs(CosmicSiege.POWER_SCALING.damageReceivedPerPower))
	local dmgReceivedPercent = 100 - defenseBonus -- Min 50%
	local speedBonus = powerLevel * CosmicSiege.POWER_SCALING.speedPerPower

	-- Apply speed
	monster:changeSpeed(speedBonus)

	-- Apply damage/defense via Condition
	local condition = Condition(CONDITION_ATTRIBUTES)
	condition:setParameter(CONDITION_PARAM_TICKS, -1) -- Permanent
	condition:setParameter(CONDITION_PARAM_SUBID, 90000) -- Unique ID for Cosmic Siege
	condition:setParameter(CONDITION_PARAM_BUFF_DAMAGEDEALT, dmgDealtPercent)
	condition:setParameter(CONDITION_PARAM_BUFF_DAMAGERECEIVED, dmgReceivedPercent)
	monster:addCondition(condition)

	-- Set power icon (category, icon type, count/value)
	monster:setIcon("cosmic_siege_power", CreatureIconCategory_Modifications, CreatureIconModifications_ReducedHealth, powerLevel)

	-- Store power level for reference
	monster:setStorageValue(90000, powerLevel)
end

-- Create zone for PLAYER HAZARD ICON display (entry room + boss area)
-- PLACEHOLDER positions - adjust these
CosmicSiege.PLAYER_ICON_ZONE_FROM = Position(806, 726, 7)
CosmicSiege.PLAYER_ICON_ZONE_TO = Position(894, 772, 7)

local playerIconZone = Zone("cosmic_siege.player_icon_zone")
playerIconZone:addArea(CosmicSiege.PLAYER_ICON_ZONE_FROM, CosmicSiege.PLAYER_ICON_ZONE_TO)

-- Player icon zone events
local playerIconEvent = ZoneEvent(playerIconZone)

function playerIconEvent.afterEnter(zone, creature)
	local player = creature:getPlayer()
	if player then
		local hazard = CosmicSiege.getHazard()

		if hazard then
			local playerHazardLevel = hazard:getPlayerCurrentLevel(player)

			-- Set hazard icon usando o ícone de Hazard padrão (categoria Quests)
			-- Mesma forma que o hazard system usa: CreatureIconQuests_t::Hazard
			player:setIcon("cosmic_siege_hazard", CreatureIconCategory_Quests, CreatureIconQuests_RedBall, playerHazardLevel)
		end
	end
end

function playerIconEvent.afterLeave(zone, creature)
	local player = creature:getPlayer()
	if player then
		-- Remove hazard icon
		player:removeIcon("cosmic_siege_hazard", CreatureIconCategory_Quests, CreatureIconQuests_RedBall)
	end
end

playerIconEvent:register()

-- Register monster power scaling for each siege arena
for siegeLevel, config in pairs(CosmicSiege.ARENA_POSITIONS) do
	local zoneName = "cosmic_siege.arena." .. siegeLevel
	local zone = Zone(zoneName)
	local powerLevel = CosmicSiege.MONSTER_POWER[siegeLevel]

	if not zone then
		logger.error("[Cosmic Siege Zones] Zone {} not found!", zoneName)
	elseif not powerLevel then
		logger.error("[Cosmic Siege Zones] No power level defined for siege {}", siegeLevel)
	else
		-- Use Zone:monsterIcon() with custom callback for power scaling
		local monsterEvent = ZoneEvent(zone)

		function monsterEvent.afterEnter(eventZone, creature)
			local monster = creature:getMonster()
			if monster then
				-- Apply power scaling when monster enters zone
				applyMonsterPower(monster, powerLevel)
			end
		end

		monsterEvent:register()
		logger.debug("[Cosmic Siege Zones] Registered monster power scaling for {} (power: {})", zoneName, powerLevel)
	end
end

print(">> Cosmic Siege Zone Events loaded successfully!")
