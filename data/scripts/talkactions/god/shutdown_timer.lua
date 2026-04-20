local shutdownTimer = TalkAction("/shutdown")

local function doShutdown()
	Game.setGameState(GAME_STATE_SHUTDOWN)
end

local function shutdownWarning(remainingMinutes)
	if remainingMinutes <= 0 then
		Game.broadcastMessage("Server is shutting down NOW!", MESSAGE_GAME_HIGHLIGHT)
		addEvent(doShutdown, 3000)
		return
	end

	local plural = remainingMinutes > 1 and "minutes" or "minute"
	Game.broadcastMessage("Server will shutdown in " .. remainingMinutes .. " " .. plural .. ". Please logout.", MESSAGE_GAME_HIGHLIGHT)

	addEvent(shutdownWarning, 60000, remainingMinutes - 1)
end

function shutdownTimer.onSay(player, words, param)
	local minutes = tonumber(param)
	if not minutes or minutes < 1 then
		player:sendTextMessage(MESSAGE_ADMINISTRATOR, "Usage: /shutdown <minutes>")
		return true
	end

	minutes = math.floor(minutes)
	local plural = minutes > 1 and "minutes" or "minute"
	Game.broadcastMessage("Server will shutdown in " .. minutes .. " " .. plural .. ". Please logout.", MESSAGE_GAME_HIGHLIGHT)
	player:sendTextMessage(MESSAGE_ADMINISTRATOR, "Shutdown scheduled in " .. minutes .. " " .. plural .. ".")

	addEvent(shutdownWarning, 60000, minutes - 1)
	return true
end

shutdownTimer:separator(" ")
shutdownTimer:groupType("god")
shutdownTimer:register()
