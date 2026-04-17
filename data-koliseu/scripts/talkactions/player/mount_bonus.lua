local mountBonus = TalkAction("!mountbonus")

function mountBonus.onSay(player)
	-- Get the formatted description from C++ method
	local description = player:getMountBonusDescription()

	-- Show in a scrollable text dialog (item ID 2187 is a parchment)
	player:showTextDialog(2187, description)

	return false
end

mountBonus:groupType("normal")
mountBonus:register()
