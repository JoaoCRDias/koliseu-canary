local addonBonus = TalkAction("!addonbonus")

function addonBonus.onSay(player)
	-- Get the formatted description from C++ method
	local description = player:getOutfitBonusDescription()

	-- Show in a scrollable text dialog (item ID 2187 is a parchment)
	player:showTextDialog(2187, description)

	return false
end

addonBonus:groupType("normal")
addonBonus:register()
