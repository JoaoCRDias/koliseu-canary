-- Fire Or Ice - Admin commands
-- /foi start  - Force start the event
-- /foi stop   - Force stop the event

local foiAdmin = TalkAction("/foi")

function foiAdmin.onSay(player, words, param, type)
	if param == "start" then
		if FireOrIce.state ~= "idle" then
			player:sendTextMessage(MESSAGE_STATUS_SMALL, "Fire Or Ice is already active (state: " .. FireOrIce.state .. ").")
			return true
		end
		FireOrIce:announce()
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Fire Or Ice event announced.")
	elseif param == "stop" then
		if FireOrIce.state == "idle" then
			player:sendTextMessage(MESSAGE_STATUS_SMALL, "Fire Or Ice is not active.")
			return true
		end
		FireOrIce:cleanup()
		Game.broadcastMessage("[Fire Or Ice] Event cancelled by an administrator.", MESSAGE_EVENT_ADVANCE)
	else
		player:sendTextMessage(MESSAGE_STATUS_SMALL, "Usage: /foi start|stop")
	end
	return true
end

foiAdmin:separator(" ")
foiAdmin:groupType("god")
foiAdmin:register()
