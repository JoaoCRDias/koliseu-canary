-- Chest in the nature sanctum behind the sealed door. Gives the player the
-- purifier item for the fountain. One use per player.

local chest = Action()

function chest.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if player:getStorageValue(Storage.SupremeVocation.NatureBossKilled) < 1 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The chest is sealed. The guardian of the grove still lives.")
		return true
	end

	local kvKey = "nature-chest-claimed"
	local kv = player:kv():scoped(SupremeVocation.KV_SCOPE)
	if kv:get(kvKey) == true then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have already taken what the chest held.")
		return true
	end

	local purifierId = SupremeVocation.FOUNTAIN_PURIFIER_ITEM_ID
	if not purifierId or purifierId <= 0 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The chest is empty. (Config error: purifier item id not set.)")
		return true
	end

	if not player:addItem(purifierId, 1) then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have no space to carry the offering.")
		return true
	end

	kv:set(kvKey, true)
	item:getPosition():sendMagicEffect(CONST_ME_MAGIC_GREEN)
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You take the offering from the chest. Carry it to the fountain.")
	return true
end

chest:aid(SupremeVocation.NatureChestActionId)
chest:register()
