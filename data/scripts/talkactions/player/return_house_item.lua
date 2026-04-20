local returnItem = TalkAction("!returnitem")

function returnItem.onSay(player, words, param, type)
	local position = player:getPosition()
	position:getNextPosition(player:getDirection())

	local tile = Tile(position)
	if not tile then
		player:sendCancelMessage("There is nothing in front of you.")
		return true
	end

	local house = tile:getHouse()
	if not house then
		player:sendCancelMessage("You can only use this command inside a house.")
		return true
	end

	if house:getOwnerGuid() ~= player:getGuid() then
		player:sendCancelMessage("Only the house owner can return items to their owners.")
		return true
	end

	local topItem = tile:getTopVisibleThing(player)
	if not topItem or not topItem:isItem() then
		player:sendCancelMessage("There is no item in front of you.")
		return true
	end

	if not topItem:hasOwner() then
		player:sendCancelMessage("This item does not have an owner.")
		return true
	end

	if topItem:isOwner(player) then
		player:sendCancelMessage("This item belongs to you. Just pick it up.")
		return true
	end

	local ownerId = topItem:getOwnerId()
	local ownerName = topItem:getOwnerName()

	if topItem:getId() ~= ITEM_DECORATION_KIT then
		local oldId = topItem:getId()
		local oldName = topItem:getName()
		local ownerAttr = topItem:getAttribute(ITEM_ATTRIBUTE_OWNER)
		local storeAttr = topItem:getAttribute(ITEM_ATTRIBUTE_STORE)

		if not topItem:transform(ITEM_DECORATION_KIT) then
			player:sendCancelMessage("Could not wrap the item.")
			return true
		end

		topItem:setCustomAttribute("unWrapId", oldId)
		topItem:setAttribute(ITEM_ATTRIBUTE_DESCRIPTION, "Unwrap it in your own house to create a <" .. oldName .. ">.")
		if ownerAttr and ownerAttr ~= 0 then
			topItem:setAttribute(ITEM_ATTRIBUTE_OWNER, ownerAttr)
		end
		if storeAttr and storeAttr ~= 0 then
			topItem:setAttribute(ITEM_ATTRIBUTE_STORE, storeAttr)
		end
	end
	local itemToMove = topItem

	local ownerPlayer = Player(ownerId)
	local wasOffline = false
	if not ownerPlayer then
		ownerPlayer = Game.getOfflinePlayer(ownerId)
		wasOffline = true
	end

	if not ownerPlayer then
		player:sendCancelMessage("Could not find the item owner.")
		return true
	end

	local inbox = ownerPlayer:getInbox()
	if not inbox then
		player:sendCancelMessage("Could not access the owner's depot inbox.")
		if wasOffline then
			ownerPlayer:save()
		end
		return true
	end

	if not itemToMove:moveTo(inbox, FLAG_NOLIMIT) then
		player:sendCancelMessage("Could not send the item to the owner's depot inbox.")
		if wasOffline then
			ownerPlayer:save()
		end
		return true
	end

	if wasOffline then
		ownerPlayer:save()
	end

	player:getPosition():sendMagicEffect(CONST_ME_POFF)
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("The item has been returned to %s's depot inbox.", ownerName))
	return true
end

returnItem:separator(" ")
returnItem:groupType("normal")
returnItem:register()
