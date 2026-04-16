--[[
	Mining Reward System

	This file defines the reward tiers based on mining skill level.
	Each tier has a minimum level requirement and a list of rewards with weights.

	How it works:
	- Rewards are organized in tiers based on mining skill level
	- Each reward has a weight (not percentage) - higher weight = more common
	- The system automatically calculates probabilities based on weight ratios
	- Players unlock new reward tiers as they level up their mining skill
	- Rare items can trigger server-wide broadcasts

	Adding new rewards:
	1. Choose the appropriate tier (skill level range)
	2. Add a new entry with: weight, itemId, minCount, maxCount, and optional rare flag
	3. Adjust weights to balance drop rates (no need to sum to 100)
]]

MiningRewards = {}

-- Reward tiers organized by mining skill level
MiningRewards.tiers = {
	--[[
		TIER 1: Novice Miners (Level 0-20)
		Basic rewards with common ores and a few gems
	]]
	{
		minLevel = 0,
		maxLevel = 20,
		name = "Novice",
		rewards = {
			-- Common rewards
			{ weight = 100, itemId = 3035, minCount = 1, maxCount = 2 },
			{ weight = 30, itemId = 3026, minCount = 1, maxCount = 1 },
			{ weight = 30, itemId = 3027, minCount = 1, maxCount = 1 },
			{ weight = 25, itemId = 3028, minCount = 1, maxCount = 1 },
			{ weight = 25, itemId = 3029, minCount = 1, maxCount = 1 },
			{ weight = 25, itemId = 3030, minCount = 1, maxCount = 1 },
			{ weight = 25, itemId = 3032, minCount = 1, maxCount = 1 },
			{ weight = 25, itemId = 3033, minCount = 1, maxCount = 1 },
		},
	},

	--[[
		TIER 2: Intermediate Miners (Level 21-40)
		Includes Tier 1 rewards + better gems and basic crystals
	]]
	{
		minLevel = 21,
		maxLevel = 40,
		name = "Intermediate",
		rewards = {
			-- Common rewards (from Tier 1)
			{ weight = 0.5, itemId = 3043, minCount = 1, maxCount = 1 },
			{ weight = 25, itemId = 3026, minCount = 1, maxCount = 1 },
			{ weight = 25, itemId = 3027, minCount = 1, maxCount = 1 },
			{ weight = 25, itemId = 3028, minCount = 1, maxCount = 1 },
			{ weight = 25, itemId = 3029, minCount = 1, maxCount = 1 },
			{ weight = 25, itemId = 3030, minCount = 1, maxCount = 1 },
			{ weight = 25, itemId = 3032, minCount = 1, maxCount = 1 },
			{ weight = 25, itemId = 3033, minCount = 1, maxCount = 1 },

			-- Better gems (unlocked at level 21+)
			{ weight = 20, itemId = 3036, minCount = 1, maxCount = 1 },
			{ weight = 20, itemId = 3037, minCount = 1, maxCount = 1 },
			{ weight = 20, itemId = 3038, minCount = 1, maxCount = 1 },
			{ weight = 20, itemId = 3039, minCount = 1, maxCount = 1 },

			-- Basic crystals
			{ weight = 15, itemId = 281, minCount = 1, maxCount = 1 },
			{ weight = 15, itemId = 282, minCount = 1, maxCount = 1 },
		},
	},

	--[[
		TIER 3: Advanced Miners (Level 41-60)
		Includes Tier 1 & 2 rewards + rare gems and special items
	]]
	{
		minLevel = 41,
		maxLevel = 60,
		name = "Advanced",
		rewards = {
			-- Common rewards
			{ weight = 1, itemId = 3043, minCount = 1, maxCount = 2 },
			{ weight = 20, itemId = 3026, minCount = 1, maxCount = 2 },
			{ weight = 20, itemId = 3027, minCount = 1, maxCount = 2 },
			{ weight = 20, itemId = 3028, minCount = 1, maxCount = 1 },
			{ weight = 20, itemId = 3029, minCount = 1, maxCount = 1 },
			{ weight = 20, itemId = 3030, minCount = 1, maxCount = 1 },
			{ weight = 20, itemId = 3032, minCount = 1, maxCount = 1 },
			{ weight = 20, itemId = 3033, minCount = 1, maxCount = 1 },

			-- Better gems
			{ weight = 18, itemId = 3036, minCount = 1, maxCount = 1 },
			{ weight = 18, itemId = 3037, minCount = 1, maxCount = 1 },
			{ weight = 18, itemId = 3038, minCount = 1, maxCount = 1 },
			{ weight = 18, itemId = 3039, minCount = 1, maxCount = 1 },
			{ weight = 18, itemId = 3040, minCount = 1, maxCount = 1 },
			{ weight = 18, itemId = 3041, minCount = 1, maxCount = 1 },

			-- Crystals
			{ weight = 15, itemId = 281, minCount = 1, maxCount = 1 },
			{ weight = 15, itemId = 282, minCount = 1, maxCount = 1 },
			{ weight = 15, itemId = 9057, minCount = 1, maxCount = 1 },

			-- Special items (unlocked at level 41+)
			{ weight = 12, itemId = 30059, minCount = 1, maxCount = 1 },
			{ weight = 12, itemId = 30060, minCount = 1, maxCount = 1 },
			{ weight = 12, itemId = 30061, minCount = 1, maxCount = 1 },
			{ weight = 10, itemId = 30180, minCount = 1, maxCount = 1 },
		},
	},

	--[[
		TIER 4: Expert Miners (Level 61-80)
		Includes all previous rewards + rare crystals and elemental items
	]]
	{
		minLevel = 61,
		maxLevel = 119,
		name = "Expert",
		rewards = {
			-- Common rewards
			{ weight = 2, itemId = 3043, minCount = 1, maxCount = 1 },
			{ weight = 15, itemId = 3026, minCount = 1, maxCount = 2 },
			{ weight = 15, itemId = 3027, minCount = 1, maxCount = 2 },
			{ weight = 15, itemId = 3028, minCount = 1, maxCount = 2 },
			{ weight = 15, itemId = 3029, minCount = 1, maxCount = 2 },
			{ weight = 15, itemId = 3030, minCount = 1, maxCount = 2 },
			{ weight = 15, itemId = 3032, minCount = 1, maxCount = 2 },
			{ weight = 15, itemId = 3033, minCount = 1, maxCount = 2 },

			-- Better gems
			{ weight = 15, itemId = 3036, minCount = 1, maxCount = 1 },
			{ weight = 15, itemId = 3037, minCount = 1, maxCount = 1 },
			{ weight = 15, itemId = 3038, minCount = 1, maxCount = 1 },
			{ weight = 15, itemId = 3039, minCount = 1, maxCount = 1 },
			{ weight = 15, itemId = 3040, minCount = 1, maxCount = 1 },
			{ weight = 15, itemId = 3041, minCount = 1, maxCount = 1 },

			-- Crystals
			{ weight = 12, itemId = 281, minCount = 1, maxCount = 1 },
			{ weight = 12, itemId = 282, minCount = 1, maxCount = 1 },
			{ weight = 12, itemId = 9057, minCount = 1, maxCount = 1 },

			-- Special items
			{ weight = 10, itemId = 30059, minCount = 1, maxCount = 1 },
			{ weight = 10, itemId = 30060, minCount = 1, maxCount = 1 },
			{ weight = 10, itemId = 30061, minCount = 1, maxCount = 1 },
			{ weight = 10, itemId = 30180, minCount = 1, maxCount = 1 },

			-- Rare crystals (unlocked at level 61+)
			{ weight = 8, itemId = 32622, minCount = 1, maxCount = 1 },
			{ weight = 8, itemId = 32623, minCount = 1, maxCount = 1 },
			{ weight = 8, itemId = 32769, minCount = 1, maxCount = 1 },

			-- Elemental items
			{ weight = 6, itemId = 44602, minCount = 1, maxCount = 1 },
			{ weight = 5, itemId = 44603, minCount = 1, maxCount = 1 },
			{ weight = 1, itemId = 44604, minCount = 1, maxCount = 1 },
			{ weight = 6, itemId = 44605, minCount = 1, maxCount = 1 },
			{ weight = 5, itemId = 44606, minCount = 1, maxCount = 1 },
			{ weight = 1, itemId = 44607, minCount = 1, maxCount = 1 },
			{ weight = 6, itemId = 44608, minCount = 1, maxCount = 1 },
			{ weight = 5, itemId = 44609, minCount = 1, maxCount = 1 },
			{ weight = 1, itemId = 44610, minCount = 1, maxCount = 1 },
			{ weight = 6, itemId = 44611, minCount = 1, maxCount = 1 },
			{ weight = 5, itemId = 44612, minCount = 1, maxCount = 1 },
			{ weight = 1, itemId = 44613, minCount = 1, maxCount = 1 },
			{ weight = 5, itemId = 49371, minCount = 1, maxCount = 1 },
			{ weight = 4, itemId = 49372, minCount = 1, maxCount = 1 },
			{ weight = 1, itemId = 49373, minCount = 1, maxCount = 1 },
		},
	},

	--[[
		TIER 5: Master Miners (Level 81+)
		Includes all rewards + extremely rare items and legendary drops
	]]
	{
		minLevel = 120,
		maxLevel = 999,
		name = "Master",
		rewards = {
			-- Common rewards
			{ weight = 3, itemId = 3043, minCount = 1, maxCount = 2 },
			{ weight = 12, itemId = 3026, minCount = 1, maxCount = 3 },
			{ weight = 12, itemId = 3027, minCount = 1, maxCount = 3 },
			{ weight = 12, itemId = 3028, minCount = 1, maxCount = 2 },
			{ weight = 12, itemId = 3029, minCount = 1, maxCount = 2 },
			{ weight = 12, itemId = 3030, minCount = 1, maxCount = 2 },
			{ weight = 12, itemId = 3032, minCount = 1, maxCount = 2 },
			{ weight = 12, itemId = 3033, minCount = 1, maxCount = 2 },

			-- Better gems
			{ weight = 12, itemId = 3036, minCount = 1, maxCount = 2 },
			{ weight = 12, itemId = 3037, minCount = 1, maxCount = 2 },
			{ weight = 12, itemId = 3038, minCount = 1, maxCount = 2 },
			{ weight = 12, itemId = 3039, minCount = 1, maxCount = 2 },
			{ weight = 12, itemId = 3040, minCount = 1, maxCount = 2 },
			{ weight = 12, itemId = 3041, minCount = 1, maxCount = 2 },

			-- Crystals
			{ weight = 10, itemId = 281, minCount = 1, maxCount = 2 },
			{ weight = 10, itemId = 282, minCount = 1, maxCount = 2 },
			{ weight = 10, itemId = 9057, minCount = 1, maxCount = 2 },

			-- Special items
			{ weight = 8, itemId = 30059, minCount = 1, maxCount = 1 },
			{ weight = 8, itemId = 30060, minCount = 1, maxCount = 1 },
			{ weight = 8, itemId = 30061, minCount = 1, maxCount = 1 },
			{ weight = 8, itemId = 30180, minCount = 1, maxCount = 1 },

			-- Rare crystals
			{ weight = 7, itemId = 32622, minCount = 1, maxCount = 1 },
			{ weight = 7, itemId = 32623, minCount = 1, maxCount = 1 },
			{ weight = 7, itemId = 32769, minCount = 1, maxCount = 1 },

			-- Elemental items
			{ weight = 6, itemId = 44602, minCount = 1, maxCount = 1 },
			{ weight = 5, itemId = 44603, minCount = 1, maxCount = 1 },
			{ weight = 3, itemId = 44604, minCount = 1, maxCount = 1 },
			{ weight = 6, itemId = 44605, minCount = 1, maxCount = 1 },
			{ weight = 5, itemId = 44606, minCount = 1, maxCount = 1 },
			{ weight = 3, itemId = 44607, minCount = 1, maxCount = 1 },
			{ weight = 6, itemId = 44608, minCount = 1, maxCount = 1 },
			{ weight = 5, itemId = 44609, minCount = 1, maxCount = 1 },
			{ weight = 3, itemId = 44610, minCount = 1, maxCount = 1 },
			{ weight = 6, itemId = 44611, minCount = 1, maxCount = 1 },
			{ weight = 5, itemId = 44612, minCount = 1, maxCount = 1 },
			{ weight = 3, itemId = 44613, minCount = 1, maxCount = 1 },

			-- High tier items
			{ weight = 5, itemId = 49371, minCount = 1, maxCount = 1 },
			{ weight = 4, itemId = 49372, minCount = 1, maxCount = 1 },
			{ weight = 1, itemId = 49373, minCount = 1, maxCount = 1 },

			-- { weight = 2, itemId = 60020, minCount = 1, maxCount = 1, rare = true },

			-- Legendary items (unlocked at level 81+)
			{ weight = 0.044, itemId = 37110, minCount = 1, maxCount = 1 },
			{ weight = 0.05, itemId = 49272, minCount = 1, maxCount = 1, rare = true },
			{ weight = 0.005, itemId = 60022, minCount = 1, maxCount = 1, rare = true },

			-- upgrade stones
			{ weight = 0.075, itemId = 60429, minCount = 1, maxCount = 1, rare = true },
			{ weight = 0.05, itemId = 60428, minCount = 1, maxCount = 1, rare = true },
			{ weight = 0.025, itemId = 60427, minCount = 1, maxCount = 1, rare = true },

			-- skill gems
			{ weight = 0.025, itemId = 58051, minCount = 1, maxCount = 1, rare = true },
			{ weight = 0.025, itemId = 58052, minCount = 1, maxCount = 1, rare = true },
			{ weight = 0.025, itemId = 58053, minCount = 1, maxCount = 1, rare = true },
			{ weight = 0.025, itemId = 58054, minCount = 1, maxCount = 1, rare = true },
		},
	},
}

-- Get the appropriate reward tier for a given mining skill level
function MiningRewards:getTierForLevel(level)
	for _, tier in ipairs(self.tiers) do
		if level >= tier.minLevel and level <= tier.maxLevel then
			return tier
		end
	end
	-- Fallback to first tier if no tier found
	return self.tiers[1]
end

-- Calculate total weight for a reward tier
function MiningRewards:calculateTotalWeight(tier)
	local totalWeight = 0
	for _, reward in ipairs(tier.rewards) do
		totalWeight = totalWeight + math.max(0, reward.weight or 0)
	end
	return totalWeight
end

-- Roll a random reward from a tier based on weights
function MiningRewards:rollReward(tier)
	local totalWeight = self:calculateTotalWeight(tier)
	if totalWeight <= 0 then
		return nil
	end

	local roll = math.random() * totalWeight
	local cumulative = 0

	for _, reward in ipairs(tier.rewards) do
		local weight = math.max(0, reward.weight or 0)
		cumulative = cumulative + weight
		if roll <= cumulative + 1e-9 then
			return reward
		end
	end

	return nil
end

-- Get a reward for a player based on their mining skill level
function MiningRewards:getRewardForPlayer(player)
	if not player then
		return nil
	end

	local skillLevel = player:getSkillLevel(SKILL_MINING)
	local tier = self:getTierForLevel(skillLevel)
	return self:rollReward(tier)
end

-- Initialize the reward system (calculate weights, validate tiers, etc.)
function MiningRewards:init()
	-- Validate and log tier information
	for _, tier in ipairs(self.tiers) do
		local totalWeight = self:calculateTotalWeight(tier)
		logger.info(string.format(
			"[MINING REWARDS] Tier '%s' (Level %d-%d): %d rewards, total weight: %.2f",
			tier.name,
			tier.minLevel,
			tier.maxLevel,
			#tier.rewards,
			totalWeight
		))
	end
end

return MiningRewards
