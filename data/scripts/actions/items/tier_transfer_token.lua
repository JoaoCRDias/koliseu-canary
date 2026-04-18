local tierTransfer = require("data.libs.systems.tier_transfer")

local tierTransferToken = Action()

function tierTransferToken.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	-- Check if target exists and is an item
	if not target or type(target) ~= "userdata" or not target:isItem() then
		player:sendCancelMessage("You need to use this token on an item.")
		return false
	end

	-- Prevent using token on itself
	if item:getUniqueId() == target:getUniqueId() then
		player:sendCancelMessage("You cannot use the token on itself.")
		return false
	end

	-- Check if target is valid equipment
	if not tierTransfer.isValidItem(target) then
		player:sendCancelMessage("You can only use tier transfer tokens on equipment (weapons, armor, helmets, legs, boots, shields, rings, necklaces).")
		return false
	end

	-- Check if token has stored tier
	local tokenTier = tierTransfer.getTokenTier(item)

	if tokenTier == 0 then
		-- Token is empty - try to extract tier from item
		return tierTransfer.extractTier(player, item, target)
	else
		-- Token has tier - try to apply to item
		return tierTransfer.applyTier(player, item, target)
	end
end

-- Register the tier transfer token
tierTransferToken:id(tierTransfer.TRANSFER_TOKEN_ID)
tierTransferToken:register()
