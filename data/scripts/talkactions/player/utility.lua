local UTILITY_COMMAND = "!utility"

local LOOT_POUCH_ID = ITEM_GOLD_POUCH
local SHOPPING_BAG_ID = ITEM_SHOPPING_BAG

local function getPlayerLootPouches(player)
	local pouches = {}

	local equippedPouch = player:getItemById(LOOT_POUCH_ID, true)
	if equippedPouch then
		table.insert(pouches, equippedPouch)
	end

	local inbox = player:getStoreInbox()
	if inbox then
		for _, inboxItem in ipairs(inbox:getItems()) do
			if inboxItem:getId() == LOOT_POUCH_ID then
				local storePouch = Container(inboxItem:getUniqueId())
				if storePouch then
					table.insert(pouches, storePouch)
				end
			end
		end
	end

	return pouches
end

local function clearLootPouches(player)
	local pouches = getPlayerLootPouches(player)
	if #pouches == 0 then
		player:sendCancelMessage("You must own a loot pouch first.")
		return true
	end

	for _, pouch in ipairs(pouches) do
		for _, item in ipairs(pouch:getItems(true)) do
			item:remove()
		end
	end

	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Loot pouch cleaned.")
	return true
end

local function getMainBackpack(player)
	local backpackItem = player:getSlotItem(CONST_SLOT_BACKPACK)
	if not backpackItem or not backpackItem:isContainer() then
		return nil
	end
	return backpackItem
end

local function isEmptyShoppingBag(item)
	if not item:isContainer() then
		return false
	end
	if item:getId() == SHOPPING_BAG_ID then
		return item:getEmptySlots() == item:getCapacity()
	end
	if item:getId() == 37561 then
		return item:getEmptySlots() == item:getCapacity()
	end
	return false
end

local function clearShoppingBags(player)
	local backpack = getMainBackpack(player)
	if not backpack then
		player:sendCancelMessage("You must equip a backpack first.")
		return true
	end

	local removed = 0
	for _, item in ipairs(backpack:getItems(true)) do
		if isEmptyShoppingBag(item) then
			item:remove()
			removed = removed + 1
		end
	end

	if removed > 0 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("You removed %d empty shopping bag%s.", removed, removed == 1 and "" or "s"))
	else
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have no shopping bags in your main backpack.")
	end
	return true
end

local function clearBossRewards(player)
	local rewardList = player:getRewardList()
	if not rewardList or #rewardList == 0 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have no boss rewards in your reward chest.")
		return true
	end

	local removedItems = 0
	for _, rewardId in ipairs(rewardList) do
		local reward = player:getReward(rewardId, false)
		if reward and reward:isItem() then
			for _, item in ipairs(reward:getItems(true)) do
				item:remove()
				removedItems = removedItems + 1
			end
		end
	end

	if removedItems > 0 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Boss rewards cleaned.")
	else
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Your reward chest is already empty.")
	end
	return true
end

local function sendConfirmationModal(player, title, message, onConfirm, cancelMessage)
	local window = ModalWindow({
		title = title,
		message = message,
	})

	window:addButton("Confirm", function(confirmPlayer, button, choice)
		onConfirm(confirmPlayer)
		return true
	end)

	window:addButton("Cancel", function(cancelPlayer, button, choice)
		cancelPlayer:sendCancelMessage(cancelMessage)
		return true
	end)

	window:setDefaultEnterButton(1)
	window:setDefaultEscapeButton(2)
	window:sendToPlayer(player)
end

local function sendUtilityModal(player)
	local window = ModalWindow({
		title = "Utility",
		message = "Select an action:",
	})

	window:addChoice("Clean loot pouch")
	window:addChoice("Clean all shopping bags")
	window:addChoice("Clean boss rewards")

	window:addButton("Select", function(actionPlayer, button, choice)
		if not choice or not choice.text then
			return true
		end

		if choice.text == "Clean loot pouch" then
			sendConfirmationModal(
				actionPlayer,
				"Clean Loot Pouch",
				"This action is irreversible. All items inside your loot pouch will be destroyed.\nDo you really want to continue?",
				clearLootPouches,
				"Loot pouch cleaning cancelled."
			)
		elseif choice.text == "Clean all shopping bags" then
			sendConfirmationModal(
				actionPlayer,
				"Clean Shopping Bags",
				"This will remove all empty shopping bags from your main backpack.\nDo you really want to continue?",
				clearShoppingBags,
				"Shopping bag cleaning cancelled."
			)
		elseif choice.text == "Clean boss rewards" then
			sendConfirmationModal(
				actionPlayer,
				"Clean Boss Rewards",
				"This action is irreversible. All boss rewards in your reward chest will be destroyed.\nDo you really want to continue?",
				clearBossRewards,
				"Boss reward cleaning cancelled."
			)
		end
		return true
	end)

	window:addButton("Close")
	window:setDefaultEnterButton(1)
	window:setDefaultEscapeButton(2)
	window:sendToPlayer(player)
end

local utilityCommand = TalkAction(UTILITY_COMMAND)

function utilityCommand.onSay(player, words, param)
	sendUtilityModal(player)
	return true
end

utilityCommand:groupType("normal")
utilityCommand:register()
