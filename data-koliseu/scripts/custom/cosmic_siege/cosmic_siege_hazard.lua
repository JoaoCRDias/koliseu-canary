-- Cosmic Siege Hazard System
-- Custom hazard system for Cosmic Siege event

-- Create Cosmic Siege hazard instance
local cosmicSiegeHazard = Hazard.new({
	name = "hazard.cosmic_siege",
	minLevel = 0,
	maxLevel = 30,
	-- No zone boundaries - this is a virtual hazard for progression tracking
	from = nil,
	to = nil,
	-- Bonuses per hazard level
	crit = 0.03, -- 1% crit per level
	dodge = 0.03, -- 1% dodge per level
	damageBoost = 0.04, -- 2% damage boost per level
	defenseBoost = 0.04, -- 2% defense boost per level
})

-- Register in global hazard table
Hazard.areas["hazard.cosmic_siege"] = cosmicSiegeHazard

-- Helper function to get Cosmic Siege hazard
function CosmicSiege.getHazard()
	return Hazard.areas["hazard.cosmic_siege"]
end

-- Update validation to use the new hazard system
local originalValidateTeam = CosmicSiege.validateTeam

CosmicSiege.validateTeam = function(players, siegeLevel)
	local req = CosmicSiege.REQUIREMENTS[siegeLevel]
	local now = os.time()
	local failedPlayers = {}
	local hazard = CosmicSiege.getHazard()

	if not hazard then
		logger.error("Cosmic Siege hazard system not found!")
		return false, "Hazard system not initialized."
	end

	for _, player in ipairs(players) do
		-- 1. Check hazard level using Cosmic Siege hazard
		local playerHazard = hazard:getPlayerCurrentLevel(player)
		if playerHazard < req.hazard then
			table.insert(failedPlayers, {
				player = player,
				reason = string.format("Requires Hazard %d (has %d)", req.hazard, playerHazard),
			})
		end

		-- 2. Check cooldown
		local cooldownEnd = player:kv():get("cosmic_siege.cooldown") or 0
		if cooldownEnd > now then
			local remaining = cooldownEnd - now
			table.insert(failedPlayers, {
				player = player,
				reason = string.format("Cooldown: %s", Game.getTimeInWords(remaining)),
			})
		end
	end

	-- 3. Check arena occupancy
	local arenaZone = CosmicSiege.getArenaZone(siegeLevel)
	arenaZone:refresh()
	if arenaZone:countPlayers(IgnoredByMonsters) > 0 then
		return false, "Arena is currently occupied."
	end

	if #failedPlayers > 0 then
		return false, failedPlayers
	end

	return true
end

print(">> Cosmic Siege Hazard system loaded successfully!")
