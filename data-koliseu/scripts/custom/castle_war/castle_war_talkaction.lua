local castlewar = TalkAction("/opencastle")
function castlewar.onSay(player, words, param)
	if not player:getGroup():getAccess() or player:getAccountType() < ACCOUNT_TYPE_GOD then
		return true
	end
	Castle:load()
	return true
end
castlewar:separator(" ")
castlewar:groupType("god")
castlewar:register()