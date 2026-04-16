local conf = {
	toggleLogger = true, -- if send terminal message when player use the item
	dustPotionId = 60146, -- register the item
	exhaust = 300,
}

local dustPotion = Action()

function dustPotion.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local playerForgeLevel = player:getForgeDustLevel()
	local playerDustCount = player:getForgeDusts()
	local dustsToAdd = playerForgeLevel - playerDustCount
	player:addForgeDusts(dustsToAdd)
	player:sendTextMessage(MESSAGE_STATUS, "Dusts filled")
	item:remove(1)  -- Remove apenas 1 item da stack
	return true
end

dustPotion:id(conf.dustPotionId)
dustPotion:register()
