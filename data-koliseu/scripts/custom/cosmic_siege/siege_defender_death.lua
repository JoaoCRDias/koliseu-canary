-- Siege Defender - Death Event
-- Increases Cosmic Siege hazard level for all participants and teleports them out

local siegeDefenderDeath = CreatureEvent("SiegeDefenderDeath")

-- Exit position after defeating Siege Defender
local EXIT_POSITION = Position(880, 749, 7)

function siegeDefenderDeath.onDeath(creature, corpse, killer, mostDamageKiller, lastHitUnjustified, mostDamageUnjustified)
	-- Get Cosmic Siege hazard system
	local hazard = CosmicSiege and CosmicSiege.getHazard()
	if not hazard then
		print("Siege Defender Death: Cosmic Siege hazard system not found!")
		return true
	end

	-- Get all players who dealt damage
	local damageMap = creature:getDamageMap()
	-- Iterate through all players who dealt damage
	for key, damageInfo in pairs(damageMap) do
		local player = Player(key)
		if player then
			local currentLevel = hazard:getPlayerCurrentLevel(player)
			local maxLevel = hazard:getPlayerMaxLevel(player)
			-- Increase max level if at cap
			if currentLevel >= maxLevel then
				local newMaxLevel = math.min(maxLevel + 1, hazard.maxLevel)
				hazard:setPlayerMaxLevel(player, newMaxLevel)
				player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("Your Cosmic Siege max hazard level increased to %d!", newMaxLevel))
			end

			-- Increase current hazard level by 1 (automatically)
			local newCurrentLevel = math.min(currentLevel + 1, hazard:getPlayerMaxLevel(player))
			if hazard:setPlayerCurrentLevel(player, newCurrentLevel) then
				player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("Your Cosmic Siege hazard level increased to %d!", newCurrentLevel))
				player:setIcon("cosmic_siege_hazard", CreatureIconCategory_Quests, CreatureIconQuests_RedBall, newCurrentLevel)
			end

			-- Teleport player to safety
			player:teleportTo(EXIT_POSITION, true)
			EXIT_POSITION:sendMagicEffect(CONST_ME_TELEPORT)
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have been teleported to safety.")
		end
	end

	return true
end

siegeDefenderDeath:register()
