--[[
	Mining System Core Logic

	This file contains the main mining logic, including:
	- Validating mining attempts
	- Calculating success chance
	- Awarding skill tries
	- Handling rewards
	- Sending messages and effects
]]

MiningCore = {}

-- Reference to config and rewards modules (set during initialization)
MiningCore.config = nil
MiningCore.rewards = nil

local MINING_BOOST_STORAGE = 58101
local MINING_BOOST_EXTRA_TRIES = 1
local MINING_BOOST_EXTRA_CHANCE = 5

-- Check if player has the store mining boost
function MiningCore:hasMiningBoost(player)
	return player:getStorageValue(MINING_BOOST_STORAGE) == 1
end

-- Check if a target is a valid mining spot
function MiningCore:isValidMiningSpot(target)
	if type(target) ~= "userdata" or not target:isItem() then
		return false
	end

	local actionId = 0
	if target.getActionId then
		actionId = target:getActionId()
	end

	return self.config.actionIds[actionId] == true
end

-- Calculate success chance based on player's mining skill
function MiningCore:calculateSuccessChance(player)
	local skillLevel = player:getSkillLevel(SKILL_MINING)
	local effectiveLevel = math.max(0, skillLevel - self.config.levelOffset)
	local successChance = self.config.baseSuccessChance + (effectiveLevel * self.config.chancePerLevel)
	if self:hasMiningBoost(player) then
		successChance = successChance + MINING_BOOST_EXTRA_CHANCE
	end
	return math.max(0, math.min(100, successChance))
end

-- Award skill tries to the player
function MiningCore:awardSkillTries(player)
	local tries = self.config.triesPerAttempt
	local boosted = self:hasMiningBoost(player)
	if boosted then
		tries = tries + MINING_BOOST_EXTRA_TRIES
	end
	player:addSkillTries(SKILL_MINING, tries)
	if self.config.attackSpeedTries > 0 then
		player:addSkillTries(SKILL_ATTACK_SPEED, self.config.attackSpeedTries)
	end
end

-- Handle successful mining attempt
function MiningCore:handleSuccess(player, toPosition)
	toPosition:sendMagicEffect(self.config.effects.success)

	local reward = self.rewards:getRewardForPlayer(player)
	if not reward then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, self.config.messages.noReward)
		return true
	end

	return self:giveRewardToPlayer(player, reward)
end

-- Handle failed mining attempt
function MiningCore:handleFailure(player, toPosition)
	toPosition:sendMagicEffect(self.config.effects.failure)
	player:sendTextMessage(MESSAGE_FAILURE, self.config.messages.failure)
	return true
end

-- Get player's loot pouch if available
function MiningCore:getPlayerLootPouch(player)
	-- First check if player has an equipped loot pouch
	local equippedPouch = player:getItemById(ITEM_GOLD_POUCH, true)
	if equippedPouch then
		return Container(equippedPouch:getUniqueId())
	end

	-- Check store inbox for loot pouch
	local inbox = player:getStoreInbox()
	if inbox then
		for _, inboxItem in ipairs(inbox:getItems()) do
			if inboxItem:getId() == ITEM_GOLD_POUCH then
				return Container(inboxItem:getUniqueId())
			end
		end
	end

	return nil
end

-- Give a reward to the player
function MiningCore:giveRewardToPlayer(player, reward)
	local minCount = math.max(1, reward.minCount or 1)
	local maxCount = math.max(minCount, reward.maxCount or minCount)
	local amount = math.random(minCount, maxCount)

	-- Check if player has enough capacity for the reward
	local itemType = ItemType(reward.itemId)
	if itemType then
		local itemWeight = itemType:getWeight() * amount
		if player:getFreeCapacity() < itemWeight then
			player:sendTextMessage(MESSAGE_FAILURE, "You don't have enough capacity to carry the mining reward.")
			return true
		end
	end

	local item = Game.createItem(reward.itemId, amount)
	if not item then
		player:sendTextMessage(MESSAGE_FAILURE, self.config.messages.errorCreatingItem)
		return true
	end

	-- Try to add to loot pouch first, then fallback to main backpack
	local lootPouch = self:getPlayerLootPouch(player)
	local addResult = RETURNVALUE_NOERROR

	if lootPouch then
		addResult = lootPouch:addItemEx(item, INDEX_WHEREEVER, FLAG_NOLIMIT)
	end

	-- If no loot pouch or failed to add, try main backpack
	if not lootPouch or addResult ~= RETURNVALUE_NOERROR then
		addResult = player:addItemEx(item, false, CONST_SLOT_WHEREEVER)
	end

	if addResult ~= RETURNVALUE_NOERROR then
		item:remove()
		player:sendTextMessage(MESSAGE_FAILURE, self.config.messages.backpackFull)
		return true
	end

	self:sendRewardMessage(player, reward, amount)

	if reward.rare then
		self:broadcastRareItem(player, reward, amount)
	end

	return true
end

-- Send reward message to the player
function MiningCore:sendRewardMessage(player, reward, amount)
	local itemType = ItemType(reward.itemId)
	local itemName = itemType and itemType:getName() or "item"

	local message
	if amount > 1 then
		message = string.format(self.config.messages.multipleItems, amount, itemName)
	else
		message = string.format(self.config.messages.singleItem, itemName)
	end

	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, message)
end

-- Broadcast rare item drop to all players
function MiningCore:broadcastRareItem(player, reward, amount)
	local itemType = ItemType(reward.itemId)
	local itemName = itemType and itemType:getName() or "item"

	local broadcastMessage
	if amount > 1 then
		broadcastMessage = string.format(
			self.config.messages.rareItemMultiple,
			player:getName(),
			amount,
			itemName
		)
	else
		broadcastMessage = string.format(
			self.config.messages.rareItemSingle,
			player:getName(),
			itemName
		)
	end

	local players = Game.getPlayers()
	if not players then
		return
	end

	for _, onlinePlayer in ipairs(players) do
		onlinePlayer:sendColoredMessage(broadcastMessage, MESSAGE_EVENT_ADVANCE)
	end
end

-- Main mining attempt function
function MiningCore:attemptMining(player, target, toPosition)
	-- Check if mining system is enabled
	if not next(self.config.actionIds) then
		return false
	end

	-- Validate mining spot
	if not self:isValidMiningSpot(target) then
		return false
	end

	-- Award skill tries
	self:awardSkillTries(player)

	-- Calculate success chance
	local successChance = self:calculateSuccessChance(player)
	local successRoll = math.random(10000)
	local threshold = math.floor(successChance * 100)

	-- Check if mining was successful
	if threshold > 0 and successRoll <= threshold then
		return self:handleSuccess(player, toPosition)
	else
		return self:handleFailure(player, toPosition)
	end
end

-- Zone-based mining attempt (no target validation, uses player position for effects)
-- attempts: number of mining hits to simulate in a single tick
-- Awards tries once (multiplied), rolls rewards N times, shows 1 effect
function MiningCore:attemptZoneMining(player, attempts)
	attempts = attempts or 1

	local hasMiningBoost = self:hasMiningBoost(player)
	if hasMiningBoost then
		attempts = attempts + MINING_BOOST_EXTRA_TRIES
	end

	-- Award skill tries in bulk (N× per attempt)
	player:addSkillTries(SKILL_MINING, self.config.triesPerAttempt * attempts)
	if self.config.attackSpeedTries > 0 then
		player:addSkillTries(SKILL_ATTACK_SPEED, self.config.attackSpeedTries * attempts)
	end

	-- Calculate success chance once (skill won't change mid-tick)
	local successChance = self:calculateSuccessChance(player)
	local threshold = math.floor(successChance * 100)

	local playerPos = player:getPosition()
	local hadSuccess = false

	-- Roll rewards N times
	for _ = 1, attempts do
		if threshold > 0 and math.random(10000) <= threshold then
			hadSuccess = true
			local reward = self.rewards:getRewardForPlayer(player)
			if reward then
				self:giveRewardToPlayer(player, reward)
			end
		end
	end

	-- Single visual effect per tick
	if hadSuccess then
		playerPos:sendMagicEffect(self.config.effects.success)
	else
		playerPos:sendMagicEffect(self.config.effects.failure)
	end

	return hadSuccess
end

-- Initialize the mining core system
function MiningCore:init(config, rewards)
	self.config = config
	self.rewards = rewards
	logger.info("[MINING CORE] Mining system initialized successfully")
end

return MiningCore
