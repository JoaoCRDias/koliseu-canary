--[[
	Mining System Core Logic (AFK zone-based only)

	Handles:
	- Calculating success chance
	- Awarding skill tries
	- Handling rewards
	- Sending messages and effects
]]

MiningCore = {}

MiningCore.config = nil
MiningCore.rewards = nil

local MINING_BOOST_STORAGE = 58101
local MINING_BOOST_EXTRA_TRIES = 1
local MINING_BOOST_EXTRA_CHANCE = 5

function MiningCore:hasMiningBoost(player)
	return player:getStorageValue(MINING_BOOST_STORAGE) == 1
end

function MiningCore:calculateSuccessChance(player)
	local skillLevel = player:getSkillLevel(SKILL_MINING)
	local effectiveLevel = math.max(0, skillLevel - self.config.levelOffset)
	local successChance = self.config.baseSuccessChance + (effectiveLevel * self.config.chancePerLevel)
	if self:hasMiningBoost(player) then
		successChance = successChance + MINING_BOOST_EXTRA_CHANCE
	end
	return math.max(0, math.min(100, successChance))
end

function MiningCore:getPlayerLootPouch(player)
	local equippedPouch = player:getItemById(ITEM_GOLD_POUCH, true)
	if equippedPouch then
		return Container(equippedPouch:getUniqueId())
	end

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

function MiningCore:giveRewardToPlayer(player, reward)
	local minCount = math.max(1, reward.minCount or 1)
	local maxCount = math.max(minCount, reward.maxCount or minCount)
	local amount = math.random(minCount, maxCount)

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

	local lootPouch = self:getPlayerLootPouch(player)
	local addResult = RETURNVALUE_NOERROR

	if lootPouch then
		addResult = lootPouch:addItemEx(item, INDEX_WHEREEVER, FLAG_NOLIMIT)
	end

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

function MiningCore:broadcastRareItem(player, reward, amount)
	local itemType = ItemType(reward.itemId)
	local itemName = itemType and itemType:getName() or "item"

	local broadcastMessage
	if amount > 1 then
		broadcastMessage = string.format(self.config.messages.rareItemMultiple, player:getName(), amount, itemName)
	else
		broadcastMessage = string.format(self.config.messages.rareItemSingle, player:getName(), itemName)
	end

	local players = Game.getPlayers()
	if not players then
		return
	end

	for _, onlinePlayer in ipairs(players) do
		onlinePlayer:sendTextMessage(MESSAGE_EVENT_ADVANCE, broadcastMessage)
	end
end

function MiningCore:attemptZoneMining(player, attempts)
	attempts = attempts or 1

	local hasMiningBoost = self:hasMiningBoost(player)
	if hasMiningBoost then
		attempts = attempts + MINING_BOOST_EXTRA_TRIES
	end

	player:addSkillTries(SKILL_MINING, self.config.triesPerAttempt * attempts)
	if self.config.attackSpeedTries > 0 then
		player:addSkillTries(SKILL_ATTACK_SPEED, self.config.attackSpeedTries * attempts)
	end

	local successChance = self:calculateSuccessChance(player)
	local threshold = math.floor(successChance * 100)

	local playerPos = player:getPosition()
	local hadSuccess = false

	for _ = 1, attempts do
		if threshold > 0 and math.random(10000) <= threshold then
			hadSuccess = true
			local reward = self.rewards:getRewardForPlayer(player)
			if reward then
				self:giveRewardToPlayer(player, reward)
			end
		end
	end

	if hadSuccess then
		playerPos:sendMagicEffect(self.config.effects.success)
	else
		playerPos:sendMagicEffect(self.config.effects.failure)
	end

	return hadSuccess
end

function MiningCore:init(config, rewards)
	self.config = config
	self.rewards = rewards
	logger.info("[MINING CORE] Mining system initialized successfully")
end

return MiningCore
