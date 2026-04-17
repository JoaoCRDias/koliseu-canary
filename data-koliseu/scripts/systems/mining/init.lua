--[[
	Mining System Initialization (AFK zone-based only)

	Usage in other scripts:
		local Mining = dofile(DATA_DIRECTORY .. '/scripts/systems/mining/init.lua')
		Mining:attemptZoneMining(player, attempts)
]]

local modulePath = DATA_DIRECTORY .. "/scripts/systems/mining/"

local MiningConfig = dofile(modulePath .. "config.lua")
local MiningRewards = dofile(modulePath .. "rewards.lua")
local MiningCore = dofile(modulePath .. "core.lua")

local Mining = {}

function Mining:init()
	MiningConfig:init()
	MiningRewards:init()
	MiningCore:init(MiningConfig, MiningRewards)
	logger.info("[MINING] Mining system fully initialized")
end

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
