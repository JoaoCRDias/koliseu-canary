-- Capture The Flag - Admin commands
-- /ctf start  - Force start the event announcement
-- /ctf stop   - Force stop the event
-- /ctf status - Show event status

local ctfAdmin = TalkAction("/ctf")

function ctfAdmin.onSay(player, words, param, type)
	if param == "start" then
		if CTF.state ~= "idle" then
			player:sendTextMessage(MESSAGE_STATUS_SMALL, "CTF is already active (state: " .. CTF.state .. ").")
			return true
		end
		CTF:announce()
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "CTF event announced.")
	elseif param == "stop" then
		if CTF.state == "idle" then
			player:sendTextMessage(MESSAGE_STATUS_SMALL, "CTF is not active.")
			return true
		end
		CTF:cleanup()
		Game.broadcastMessage("[CTF] Capture The Flag has been cancelled by an administrator.", MESSAGE_EVENT_ADVANCE)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "CTF event stopped.")
	elseif param == "status" then
		local playerCount = 0
		for _ in pairs(CTF.players) do
			playerCount = playerCount + 1
		end
		local msg = string.format(
			"CTF Status: %s | Players: %d | Score: Green %d x %d Red | Flag carriers: Green=%s Red=%s",
			CTF.state,
			playerCount,
			CTF.scores[1],
			CTF.scores[2],
			CTF.flagCarrier[1] and "stolen" or "safe",
			CTF.flagCarrier[2] and "stolen" or "safe"
		)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, msg)
	else
		player:sendTextMessage(MESSAGE_STATUS_SMALL, "Usage: /ctf start|stop|status")
	end

	return true
end

ctfAdmin:separator(" ")
ctfAdmin:groupType("god")
ctfAdmin:register()
