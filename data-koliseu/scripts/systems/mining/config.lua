--[[
	Mining System Configuration (AFK zone-based only)

	This file contains all configuration parameters for the mining system.
	Adjust these values to balance the mining system for your server.
]]

MiningConfig = {
	-- Base success chance (percentage)
	baseSuccessChance = 0,

	-- Chance increase per mining level (percentage)
	chancePerLevel = 0,

	-- Skill tries awarded per mining attempt
	triesPerAttempt = 0,

	-- Attack speed skill tries per mining attempt (0 to disable)
	attackSpeedTries = 0,

	-- Level offset for chance calculation
	-- Effective level = max(0, skillLevel - levelOffset)
	levelOffset = 10,

	-- Messages
	messages = {
		noReward = "You mine the vein but find nothing of value this time.",
		failure = "You fail to extract anything from the rock.",
		backpackFull = "Your backpacks are full. Free some space before mining again.",
		errorCreatingItem = "An unknown error prevented you from receiving the reward. Please contact a staff member.",
		singleItem = "You mine the vein and obtain %s.",
		multipleItems = "You mine the vein and obtain %d %s.",
		rareItemSingle = "{yellow|[MINING]} - %s just uncovered %s while mining!",
		rareItemMultiple = "{yellow|[MINING]} - %s just uncovered %d %s while mining!",
	},

	-- Visual effects
	effects = {
		success = CONST_ME_BLOCKHIT,
		failure = CONST_ME_POFF,
	},
}

function MiningConfig:init()
	self.baseSuccessChance = math.max(0, configManager.getNumber(configKeys.MINING_BASE_SUCCESS_CHANCE))
	self.chancePerLevel = math.max(0, configManager.getFloat(configKeys.MINING_CHANCE_PER_LEVEL))
	self.triesPerAttempt = math.max(1, configManager.getNumber(configKeys.MINING_TRIES_PER_ATTEMPT))
	self.attackSpeedTries = math.max(0, configManager.getNumber(configKeys.MINING_ATTACK_SPEED_TRIES))
end

return MiningConfig
