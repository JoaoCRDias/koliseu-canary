local imbuement = Action()

function imbuement.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local isVip = player:isVip()
	if not isVip then
		player:sendCancelMessage("Only VIP players can use this item.")
		return true
	end

	player:openImbuementWindow()
	return true
end

-- imbuement:position({ x = 1943, y = 1340, z = 7 }, 25061)

imbuement:id(60145)
imbuement:register()
