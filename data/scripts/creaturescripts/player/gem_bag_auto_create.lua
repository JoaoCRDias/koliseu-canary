-- Auto-create Gem Bag on login if player doesn't have one in store inbox

local gemBagAutoCreate = CreatureEvent("GemBagAutoCreate")

function gemBagAutoCreate.onLogin(player)
	-- Get store inbox
	local storeInbox = player:getStoreInbox()
	if not storeInbox then
		return true
	end

	-- Check if player already has a gem bag in store inbox
	local hasGemBag = false
	for i = 0, storeInbox:getSize() - 1 do
		local item = storeInbox:getItem(i)
		if item and item:getId() == GemBag.config.ITEMID_GEM_BAG then
			hasGemBag = true
			break
		end
	end

	-- If no gem bag found, create one
	if not hasGemBag then
		-- Pass player as destination to create in Store Inbox (immovable)
		local gemBag = GemBag.createGemBag(player, { player = player, hasExtender = false })
		if gemBag then
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "A Gem Bag has been added to your store inbox!")
		end
	end

	return true
end

gemBagAutoCreate:register()
