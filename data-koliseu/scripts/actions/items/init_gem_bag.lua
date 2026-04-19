-- Init Gem Bag Action
-- Gives player 1 random tier 1 gem

local TIER_1_GEMS = {
	60338, -- momentum gem tier 1
	60348, -- onslaught gem tier 1
	60358, -- transcendence gem tier 1
	60368, -- ruse gem tier 1
	60167, -- death gem tier 1
	60177, -- energy gem tier 1
	60187, -- fire gem tier 1
	60197, -- holy gem tier 1
	60207, -- ice gem tier 1
	60217, -- physical gem tier 1
	60227, -- earth gem tier 1
}

local initGemBag = Action()

function initGemBag.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if not player then
		return false
	end

	-- Select random tier 1 gem
	local randomGemId = TIER_1_GEMS[math.random(1, #TIER_1_GEMS)]

	-- Add gem directly to player's backpack
	local addedItem = player:addItem(randomGemId, 1)
	if not addedItem then
		player:sendCancelMessage("You do not have enough space in your inventory.")
		return false
	end

	-- Get gem name from the added item
	local gemName = addedItem:getName()

	-- Remove the Init Gem Bag item
	item:remove(1)

	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("You received: %s!", gemName))
	player:getPosition():sendMagicEffect(CONST_ME_GIFT_WRAPS)

	return true
end

initGemBag:id(60316)
initGemBag:register()
