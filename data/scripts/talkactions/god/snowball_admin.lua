-- Snowball Fight - Admin commands
-- /snowball start  - Force start the event
-- /snowball stop   - Force stop the event

local sbAdmin = TalkAction("/snowball")

function sbAdmin.onSay(player, words, param, type)
	if param == "start" then
		if Snowball.state ~= "idle" then
			player:sendTextMessage(MESSAGE_STATUS_SMALL, "Snowball is already active (state: " .. Snowball.state .. ").")
			return true
		end
		Snowball:announce()
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Snowball Fight event announced.")
	elseif param == "stop" then
		if Snowball.state == "idle" then
			player:sendTextMessage(MESSAGE_STATUS_SMALL, "Snowball is not active.")
			return true
		end
		Snowball:cleanup()
		Game.broadcastMessage("[Snowball] Event cancelled by an administrator.", MESSAGE_EVENT_ADVANCE)
	else
		player:sendTextMessage(MESSAGE_STATUS_SMALL, "Usage: /snowball start|stop")
	end
	return true
end

sbAdmin:separator(" ")
sbAdmin:groupType("god")
sbAdmin:register()
