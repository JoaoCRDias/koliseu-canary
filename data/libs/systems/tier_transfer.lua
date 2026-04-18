TierTransfer = {
	TRANSFER_TOKEN_ID = 60636,
}

-- Check if a transfer token has a stored tier level
function TierTransfer.getTokenTier(token)
	return token:getCustomAttribute("stored_tier_level") or 0
end

-- Set the tier level stored in the token
function TierTransfer.setTokenTier(token, tier)
	if tier > 0 then
		token:setCustomAttribute("stored_tier_level", tier)
		-- Update token name to show the tier
		token:setAttribute(ITEM_ATTRIBUTE_NAME, string.format("tier transfer token (tier %d)", tier))
		-- Update description
		local description = string.format("This token contains a tier %d.\nUse it on an item to transfer this tier level.", tier)
		token:setAttribute(ITEM_ATTRIBUTE_DESCRIPTION, description)
	else
		-- Reset to empty token
		token:removeCustomAttribute("stored_tier_level")
		token:removeAttribute(ITEM_ATTRIBUTE_NAME)
		token:setAttribute(ITEM_ATTRIBUTE_DESCRIPTION, "A special token that can extract and transfer item tiers. Use it on a tiered item to extract its tier level, then use it on another item to apply the tier.")
	end
end

-- Check if an item can have tier
function TierTransfer.isValidItem(item)
	if not item or not item:isItem() then
		return false
	end

	local itemType = item:getType()
	local weaponType = itemType:getWeaponType()
	local slotPosition = itemType:getSlotPosition()

	-- Allow weapons, armor, helmets, legs, boots, shields, rings, necklaces
	return weaponType ~= WEAPON_NONE
			or bit.band(slotPosition, SLOTP_ARMOR) ~= 0
			or bit.band(slotPosition, SLOTP_HEAD) ~= 0
			or bit.band(slotPosition, SLOTP_LEGS) ~= 0
			or bit.band(slotPosition, SLOTP_FEET) ~= 0
			or bit.band(slotPosition, SLOTP_NECKLACE) ~= 0
			or bit.band(slotPosition, SLOTP_RING) ~= 0
			or bit.band(slotPosition, SLOTP_LEFT) ~= 0
			or bit.band(slotPosition, SLOTP_RIGHT) ~= 0
end

-- Extract tier from an item to the token
function TierTransfer.extractTier(player, token, item)
	-- Validate token is empty
	local tokenTier = TierTransfer.getTokenTier(token)
	if tokenTier > 0 then
		player:sendCancelMessage("This transfer token already contains a tier. Use it on an item first.")
		return false
	end

	-- Validate item is not a badge
	if BadgeBag.isBadge(item) then
		player:sendCancelMessage("You cannot use tier transfer on badges.")
		return false
	end

	-- Validate item is not a relic
	if RelicSystem and RelicSystem.isRelic(item) then
		player:sendCancelMessage("You cannot use tier transfer on relics.")
		return false
	end

	-- Validate item has tier
	local itemTier = item:getTier()
	if not itemTier or itemTier == 0 then
		player:sendCancelMessage("This item has no tier to extract.")
		return false
	end

	-- Show confirmation modal
	local itemName = item:getName()

	local message = string.format([[Extract Tier from Item?

Item: %s
Current Tier: %d

This will:
- Remove the tier from the item
- Store tier %d in the token
- Reset item to tier 0

Continue?]], itemName, itemTier, itemTier)

	local modal = ModalWindow({
		title = "Extract Tier",
		message = message,
	})

	modal:addButton("Confirm")
	modal:addButton("Cancel")
	modal:setDefaultEnterButton(1)
	modal:setDefaultEscapeButton(2)

	-- Store data for callback
	local confirmKey = "extract_tier_" .. player:getId()
	if not _G.TierTransferConfirmations then
		_G.TierTransferConfirmations = {}
	end

	_G.TierTransferConfirmations[confirmKey] = {
		token = token,
		item = item,
		itemTier = itemTier
	}

	modal:setDefaultCallback(function(clickedPlayer, button)
		local data = _G.TierTransferConfirmations[confirmKey]
		if button.id == 1 and data then
			-- Perform extraction
			TierTransfer.performExtraction(clickedPlayer, data.token, data.item, data.itemTier)
		else
			clickedPlayer:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Extraction cancelled.")
		end
		-- Clean up
		_G.TierTransferConfirmations[confirmKey] = nil
	end)

	modal:sendToPlayer(player)
	return true
end

-- Perform the actual extraction
function TierTransfer.performExtraction(player, token, item, itemTier)
	-- Validate items still exist
	if not token or not item then
		player:sendCancelMessage("Item not found.")
		return false
	end

	local inbox = player:getStoreInbox()
	if not inbox then
		player:sendCancelMessage("Failed to access store inbox.")
		return false
	end

	-- Clone the token to preserve attributes and apply tier visually
	local clonedToken = token:clone()
	if not clonedToken then
		player:sendCancelMessage("Failed to clone token.")
		return false
	end

	-- Store tier in cloned token and apply tier visually
	TierTransfer.setTokenTier(clonedToken, itemTier)
	clonedToken:setTier(itemTier)

	-- Add cloned token to store inbox (verify success before removing original)
	local retToken = inbox:addItemEx(clonedToken)
	if retToken ~= RETURNVALUE_NOERROR then
		player:sendCancelMessage("Failed to add token to store inbox. Make sure your inbox is not full.")
		return false
	end

	-- Clone the item, remove tier and move to store inbox
	local clonedItem = item:clone()
	if not clonedItem then
		player:sendCancelMessage("Failed to clone item.")
		return false
	end

	clonedItem:setTier(0)
	local retItem = inbox:addItemEx(clonedItem)
	if retItem ~= RETURNVALUE_NOERROR then
		player:sendCancelMessage("Failed to add item to store inbox. Make sure your inbox is not full.")
		return false
	end

	-- Only remove originals after both clones are safely in the inbox
	token:remove()
	item:remove()

	-- Visual effects and message
	player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("Successfully extracted tier %d to transfer token! Check your store inbox.", itemTier))

	return true
end

-- Apply tier from token to an item
function TierTransfer.applyTier(player, token, item)
	-- Validate token has tier
	local tokenTier = TierTransfer.getTokenTier(token)
	if tokenTier == 0 then
		player:sendCancelMessage("This transfer token is empty. Use it on a tiered item first to extract its tier.")
		return false
	end

	-- Validate item is not a badge
	if BadgeBag.isBadge(item) then
		player:sendCancelMessage("You cannot use tier transfer on badges.")
		return false
	end

	-- Validate item is not a relic
	if RelicSystem and RelicSystem.isRelic(item) then
		player:sendCancelMessage("You cannot use tier transfer on relics.")
		return false
	end

	-- Validate item has no tier or tier 0
	local itemTier = item:getTier() or 0
	if itemTier > 0 then
		player:sendCancelMessage("This item already has a tier. You can only transfer to items without tiers (tier 0).")
		return false
	end

	-- Show confirmation modal
	local itemName = item:getName()

	local message = string.format([[Transfer Tier to Item?

Token Tier: %d
Target Item: %s

This will:
- Apply tier %d to the item
- Consume the transfer token

Continue?]], tokenTier, itemName, tokenTier)

	local modal = ModalWindow({
		title = "Apply Tier",
		message = message,
	})

	modal:addButton("Confirm")
	modal:addButton("Cancel")
	modal:setDefaultEnterButton(1)
	modal:setDefaultEscapeButton(2)

	-- Store data for callback
	local confirmKey = "apply_tier_" .. player:getId()
	if not _G.TierTransferConfirmations then
		_G.TierTransferConfirmations = {}
	end

	_G.TierTransferConfirmations[confirmKey] = {
		token = token,
		item = item,
		tokenTier = tokenTier
	}

	modal:setDefaultCallback(function(clickedPlayer, button)
		local data = _G.TierTransferConfirmations[confirmKey]
		if button.id == 1 and data then
			-- Perform application
			TierTransfer.performApplication(clickedPlayer, data.token, data.item, data.tokenTier)
		else
			clickedPlayer:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Transfer cancelled.")
		end
		-- Clean up
		_G.TierTransferConfirmations[confirmKey] = nil
	end)

	modal:sendToPlayer(player)
	return true
end

-- Perform the actual application
function TierTransfer.performApplication(player, token, item, tokenTier)
	-- Validate items still exist
	if not token or not item then
		player:sendCancelMessage("Item not found.")
		return false
	end

	local inbox = player:getStoreInbox()
	if not inbox then
		player:sendCancelMessage("Failed to access store inbox.")
		return false
	end

	-- Clone the item to preserve all attributes
	local clonedItem = item:clone()
	if not clonedItem then
		player:sendCancelMessage("Failed to clone item.")
		return false
	end

	-- Apply tier to the cloned item
	clonedItem:setTier(tokenTier)

	-- Add cloned item to store inbox (verify success before removing originals)
	local ret = inbox:addItemEx(clonedItem)
	if ret ~= RETURNVALUE_NOERROR then
		player:sendCancelMessage("Failed to add item to store inbox. Make sure your inbox is not full.")
		return false
	end

	-- Only remove originals after clone is safely in the inbox
	item:remove()
	token:remove(1)

	-- Visual effects and message
	player:getPosition():sendMagicEffect(CONST_ME_MAGIC_GREEN)
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("Successfully applied tier %d to item!", tokenTier))

	return true
end

return TierTransfer
