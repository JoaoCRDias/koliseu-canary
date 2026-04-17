--[[
	Mining System Initialization

	This file initializes the mining system by:
	1. Loading all mining modules (config, rewards, core)
	2. Initializing each module in the correct order
	3. Exporting the public API for use in other scripts

	Usage in other scripts:
		local Mining = dofile('data-koliseu/scripts/systems/mining/init.lua')
		Mining:attemptMining(player, target, toPosition)
]]

-- Get the directory path for this module
local modulePath = "data-koliseu/scripts/systems/mining/"

-- Load all mining modules
local MiningConfig = dofile(modulePath .. "config.lua")
local MiningRewards = dofile(modulePath .. "rewards.lua")
local MiningCore = dofile(modulePath .. "core.lua")

-- Mining System Public API
local Mining = {}

-- Initialize the entire mining system
function Mining:init()
	-- Initialize configuration from config.lua
	MiningConfig:init()

	-- Initialize rewards system
	MiningRewards:init()

	-- Initialize core mining logic with dependencies
	MiningCore:init(MiningConfig, MiningRewards)

	logger.info("[MINING] Mining system fully initialized")
end

-- Attempt to mine a target
-- Returns true if this was a mining attempt (success or failure)
-- Returns false if this was not a mining spot
function Mining:attemptMining(player, target, toPosition)
	return MiningCore:attemptMining(player, target, toPosition)
end

-- Zone-based mining attempt (AFK, no target needed)
-- attempts: number of hits to simulate (default 1)
function Mining:attemptZoneMining(player, attempts)
	return MiningCore:attemptZoneMining(player, attempts)
end

-- Get the current mining configuration
function Mining:getConfig()
	return MiningConfig
end

-- Get the rewards system
function Mining:getRewards()
	return MiningRewards
end

-- Get mining skill level requirement for a specific tier
function Mining:getTierInfo(tierIndex)
	if not MiningRewards.tiers[tierIndex] then
		return nil
	end
	return MiningRewards.tiers[tierIndex]
end

-- Get all tier information (useful for displaying in-game info)
function Mining:getAllTiers()
	local tiers = {}
	for i, tier in ipairs(MiningRewards.tiers) do
		table.insert(tiers, {
			index = i,
			name = tier.name,
			minLevel = tier.minLevel,
			maxLevel = tier.maxLevel,
			rewardCount = #tier.rewards,
		})
	end
	return tiers
end

-- Get player's current tier based on mining skill
function Mining:getPlayerTier(player)
	if not player then
		return nil
	end

	local skillLevel = player:getSkillLevel(SKILL_MINING)
	local tier = MiningRewards:getTierForLevel(skillLevel)
	return tier
end

-- Check if a player can receive a specific reward
function Mining:canPlayerGetReward(player, rewardItemId)
	if not player then
		return false
	end

	local tier = self:getPlayerTier(player)
	if not tier then
		return false
	end

	for _, reward in ipairs(tier.rewards) do
		if reward.itemId == rewardItemId then
			return true
		end
	end

	return false
end

-- Initialize the system when this module is loaded
-- Protection: Only initialize once, even if this file is loaded multiple times
-- Store in _G so subsequent dofile() calls return the same initialized instance
if not _G.MiningSystemInstance then
	Mining:init()
	_G.MiningSystemInstance = Mining
end

-- Export the Mining API (always return the same initialized instance)
return _G.MiningSystemInstance
