local arrest = TalkAction("!arrest")

local JAIL_POSITION = Position(1066, 1000, 7)

function arrest.onSay(player, words, param)
	if param == "" then
		player:sendCancelMessage("Usage: !arrest <player name>")
		return true
	end

	local targetPlayer = Player(param)
	if not targetPlayer then
		player:sendCancelMessage("Player '" .. param .. "' is not online.")
		return true
	end

	local targetIp = targetPlayer:getIp()
	if targetIp == 0 then
		player:sendCancelMessage("Could not retrieve the player's IP.")
		return true
	end

	local arrestedPlayers = {}
	local players = Game.getPlayers()

	for _, onlinePlayer in ipairs(players) do
		if onlinePlayer:getIp() == targetIp and onlinePlayer:getGroup():getId() < player:getGroup():getId() then
			table.insert(arrestedPlayers, onlinePlayer:getName())
			onlinePlayer:teleportTo(JAIL_POSITION)
			onlinePlayer:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have been arrested by an administrator.")
		end
	end

	if #arrestedPlayers == 0 then
		player:sendCancelMessage("No players arrested (all share your access level or higher).")
		return true
	end

	local ipString = Game.convertIpToString(targetIp)
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "IP: " .. ipString)
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Arrested players (" .. #arrestedPlayers .. "): " .. table.concat(arrestedPlayers, ", "))

	return true
end

arrest:separator(" ")
arrest:groupType("god")
arrest:register()
