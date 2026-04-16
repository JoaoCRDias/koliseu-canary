local BOUNTY_TALISMAN_ID = 51978

local bountyTalisman = MoveEvent()

function bountyTalisman.onEquip(player, item, slot, isCheck)
	if not isCheck then
		player:setBountyTalismanEquipped(true)
	end
	return true
end

bountyTalisman:type("equip")
bountyTalisman:id(BOUNTY_TALISMAN_ID)
bountyTalisman:register()

bountyTalisman = MoveEvent()

function bountyTalisman.onDeEquip(player, item, slot, isCheck)
	if not isCheck then
		player:setBountyTalismanEquipped(false)
	end
	return true
end

bountyTalisman:type("deequip")
bountyTalisman:id(BOUNTY_TALISMAN_ID)
bountyTalisman:register()
