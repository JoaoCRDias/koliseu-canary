-- Starter Bundle (Store Item - One Per Account)
-- Item ID: 60036

local STARTER_BUNDLE_ID = 60036

local ITEMS = {
	BOOSTED_EXERCISE_TOKEN = 60648,
	EXERCISE_TOKEN = 60141,
	EXERCISE_SPEED_IMPROVEMENT = 60647,
	LESSER_EXP_POTION = 60303,
	EXP_POTION = 60301,
	INIT_GEM_BAG = 60316,
	DUMMY = 60454,
	STARLIGHT_POWER = 60148,
	PREMIUM_SCROLL = 14758,
	PREY_WILDCARD = 60101,
}

local bundleItems = {
	{ id = ITEMS.BOOSTED_EXERCISE_TOKEN, count = 3 },
	{ id = ITEMS.EXERCISE_TOKEN, count = 3 },
	{ id = ITEMS.EXERCISE_SPEED_IMPROVEMENT, count = 1 },
	{ id = ITEMS.LESSER_EXP_POTION, count = 2 },
	{ id = ITEMS.EXP_POTION, count = 1 },
	{ id = ITEMS.INIT_GEM_BAG, count = 3 },
	{ id = ITEMS.STARLIGHT_POWER, count = 1 },
	{ id = ITEMS.PREMIUM_SCROLL, count = 1 },
	{ id = ITEMS.PREY_WILDCARD, count = 1 },
}

local starterBundle = Action()

function starterBundle.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if item.itemid ~= STARTER_BUNDLE_ID then
		return false
	end

	local accountId = player:getAccountId()
	local accountKV = kv.scoped("account"):scoped(tostring(accountId))
	if accountKV:get("starter-bundle-redeemed") then
		player:sendCancelMessage("Your account has already redeemed the Starter Bundle.")
		return true
	end

	local inbox = player:getStoreInbox()
	if not inbox then
		player:sendCancelMessage("Could not access your store inbox. Please try again.")
		return true
	end

	local itemsReceived = {}
	local itemsFailed = {}

	for _, itemData in ipairs(bundleItems) do
		local itemType = ItemType(itemData.id)
		if not itemType or itemType:getId() == 0 then
			goto continue
		end

		if itemType:isStackable() then
			local addedItem, location = player:safeDeliverItem(itemData.id, itemData.count, "Starter Bundle")
			if addedItem then
				table.insert(itemsReceived, string.format("%dx %s", itemData.count, itemType:getName()))
			else
				table.insert(itemsFailed, string.format("%dx %s", itemData.count, itemType:getName()))
			end
		else
			local addedCount = 0
			for i = 1, itemData.count do
				local addedItem, location = player:safeDeliverItem(itemData.id, 1, "Starter Bundle")
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

	-- Add dummy wrapped as decoration kit
	local decoKit, location = player:safeDeliverItem(ITEM_DECORATION_KIT, 1, "Starter Bundle")
	if decoKit then
		local dummyType = ItemType(ITEMS.DUMMY)
		decoKit:setAttribute(ITEM_ATTRIBUTE_DESCRIPTION, "Unwrap it in your own house to create a <" .. dummyType:getName() .. ">.")
		decoKit:setCustomAttribute("unWrapId", ITEMS.DUMMY)
		table.insert(itemsReceived, string.format("1x %s", dummyType:getName()))
	else
		table.insert(itemsFailed, "1x Training Dummy")
	end

	accountKV:set("starter-bundle-redeemed", true)

	-- Visual effects
	player:getPosition():sendMagicEffect(CONST_ME_GIFT_WRAPS)

	-- Send message
	local message = string.format(
		"You have opened the Starter Bundle!\nYour items have been sent to your Store Inbox:\n%s",
		table.concat(itemsReceived, "\n")
	)
	if #itemsFailed > 0 then
		message = message .. string.format("\n\n[WARNING] The following items could NOT be delivered:\n%s\nPlease contact an administrator.", table.concat(itemsFailed, "\n"))
		logger.error("[StarterBundle] Player {} failed to receive items: {}", player:getName(), table.concat(itemsFailed, ", "))
	end
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, message)
	player:say("You opened a Starter Bundle!", TALKTYPE_MONSTER_SAY)

	-- Remove the bundle item
	item:remove(1)

	return true
end

starterBundle:id(STARTER_BUNDLE_ID)
starterBundle:register()
