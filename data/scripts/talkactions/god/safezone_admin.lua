-- Safezone - Admin commands
-- /safezone start  - Force start the event
-- /safezone stop   - Force stop the event

local szAdmin = TalkAction("/safezone")

function szAdmin.onSay(player, words, param, type)
	if param == "start" then
		if Safezone.state ~= "idle" then
			player:sendTextMessage(MESSAGE_STATUS_SMALL, "Safezone is already active (state: " .. Safezone.state .. ").")
			return true
		end
		Safezone:announce()
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Safezone event announced.")
	elseif param == "stop" then
		if Safezone.state == "idle" then
			player:sendTextMessage(MESSAGE_STATUS_SMALL, "Safezone is not active.")
			return true
		end
		Safezone:cleanup()
		Game.broadcastMessage("[Safezone] Event cancelled by an administrator.", MESSAGE_EVENT_ADVANCE)
	else
		player:sendTextMessage(MESSAGE_STATUS_SMALL, "Usage: /safezone start|stop")
	end
	return true
end

szAdmin:separator(" ")
szAdmin:groupType("god")
szAdmin:register()
