local BattlePassDB = dofile("data-koliseu/scripts/systems/battlepass/database.lua")
local BattlePassConfig = dofile("data-koliseu/scripts/systems/battlepass/config_rewards.lua")
local BattlePassRewards = dofile("data-koliseu/scripts/systems/battlepass/rewards.lua")
local BattlePassWindow = dofile("data-koliseu/scripts/systems/battlepass/window.lua")

local BattlePassCore = {}

-- Get current active season
function BattlePassCore.getCurrentSeason()
	return BattlePassDB.getCurrentSeason()
end

-- Get player's battle pass data
function BattlePassCore.getPlayerBattlePass(playerId, seasonId)
	return BattlePassDB.getPlayerBattlePass(playerId, seasonId)
end

-- Activate battle pass for player
function BattlePassCore.activateBattlePass(playerId, seasonId)
	return BattlePassDB.activateBattlePass(playerId, seasonId)
end

-- Open battle pass window
function BattlePassCore.openBattlePassWindow(player, season, playerData)
	return BattlePassWindow.open(player, season, playerData)
end

-- Claim a reward
function BattlePassCore.claimReward(player, day, seasonId)
	local playerId = player:getGuid()
	local season
	if seasonId then
		season = BattlePassDB.getSeasonById(seasonId)
	end
	if not season then
		season = BattlePassCore.getCurrentSeason()
	end
	if not season then
		return false, "No active season found."
	end
	local playerBP = BattlePassCore.getPlayerBattlePass(playerId, season.id)
	if not playerBP then
		return false, "Battle Pass not activated."
	end

	-- Calculate days available
	local activationTime = playerBP.activation_time
	local currentTime = os.time()
	local daysPassed = math.floor((currentTime - activationTime) / 86400) + 1
	daysPassed = math.min(daysPassed, 15)

	-- Check if day is available
	if day > daysPassed then
		return false, "This reward is not available yet."
	end

	if day < 1 or day > 15 then
		return false, "Invalid day."
	end

	-- Check if already claimed
	local claimedDays = {}
	if playerBP.claimed_days ~= "" then
		for d in string.gmatch(playerBP.claimed_days, "([^,]+)") do
			claimedDays[tonumber(d)] = true
		end
	end

	if claimedDays[day] then
		return false, "Reward already claimed."
	end

	-- Get reward
	local reward = BattlePassConfig.getDayReward(season.id, day)
	if not reward then
		return false, "Reward not found."
	end

	-- Deliver reward
	local success, message = BattlePassRewards.deliverReward(player, reward)
	if not success then
		return false, message or "Failed to deliver reward."
	end

	-- Mark as claimed
	local claimed = BattlePassDB.claimDay(playerId, season.id, day)
	if not claimed then
		return false, "Failed to update database."
	end

	return true
end

return BattlePassCore
