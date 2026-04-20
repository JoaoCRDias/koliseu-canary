-- Training Bundles (Common and Rare)
-- Item IDs: 60614 (Common), 60613 (Rare)

local COMMON_BUNDLE = 60614
local RARE_BUNDLE = 60613

local ITEMS = {
	BOOSTED_EXERCISE_TOKEN = 60648,
	EXERCISE_SPEED_IMPROVEMENT = 60647,
}

local bundles = {
	[COMMON_BUNDLE] = {
		name = "Common Training Bundle",
		items = {
			{ id = ITEMS.BOOSTED_EXERCISE_TOKEN, count = 3 },
			{ id = ITEMS.EXERCISE_SPEED_IMPROVEMENT, count = 1 },
		},
	},
	[RARE_BUNDLE] = {
		name = "Rare Training Bundle",
		items = {
			{ id = ITEMS.BOOSTED_EXERCISE_TOKEN, count = 5 },
			{ id = ITEMS.EXERCISE_SPEED_IMPROVEMENT, count = 3 },
		},
	},
}

local trainingBundles = Action()

function trainingBundles.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local bundle = bundles[item.itemid]
	if not bundle then
		return false
	end

	local inbox = player:getStoreInbox()
	if not inbox then
		player:sendCancelMessage("Could not access your store inbox. Please try again.")
		return true
	end

	local itemsReceived = {}
	local itemsFailed = {}

	for _, itemData in ipairs(bundle.items) do
		local itemType = ItemType(itemData.id)
		if not itemType or itemType:getId() == 0 then
			goto continue
		end

		if itemType:isStackable() then
			local addedItem, location = player:safeDeliverItem(itemData.id, itemData.count, bundle.name)
			if addedItem then
				table.insert(itemsReceived, string.format("%dx %s", itemData.count, itemType:getName()))
			else
				table.insert(itemsFailed, string.format("%dx %s", itemData.count, itemType:getName()))
			end
		else
			local addedCount = 0
			for i = 1, itemData.count do
				local addedItem, location = player:safeDeliverItem(itemData.id, 1, bundle.name)
				if addedItem then
					addedCount = addedCount + 1
				end
			end
			if addedCount > 0 then
				table.insert(itemsReceived, string.format("%dx %s", addedCount, itemType:getName()))
			end
			if addedCount < itemData.count then
				table.insert(itemsFailed, string.format("%dx %s", itemData.count - addedCount, itemType:getName()))
			end
		end

		::continue::
	end

	player:getPosition():sendMagicEffect(CONST_ME_GIFT_WRAPS)

	local message = string.format(
		"You have opened the %s!\nYour items have been sent to your Store Inbox:\n%s",
		bundle.name, table.concat(itemsReceived, "\n")
	)
	if #itemsFailed > 0 then
		message = message .. string.format("\n\n[WARNING] The following items could NOT be delivered:\n%s\nPlease contact an administrator.", table.concat(itemsFailed, "\n"))
		logger.error("[TrainingBundle] Player {} failed to receive items from {}: {}", player:getName(), bundle.name, table.concat(itemsFailed, ", "))
	end
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, message)
	player:say(string.format("You opened a %s!", bundle.name), TALKTYPE_MONSTER_SAY)

	item:remove(1)

	return true
end

trainingBundles:id(COMMON_BUNDLE)
trainingBundles:id(RARE_BUNDLE)
trainingBundles:register()
