-- Event Pool - Admin commands
-- /ep start    - Force pick and start a random event
-- /ep list     - List registered events and their availability

local epAdmin = TalkAction("/ep")

function epAdmin.onSay(player, words, param, type)
	if param == "start" then
		local available = EventPool:getAvailableEvents()
		if #available == 0 then
			player:sendTextMessage(MESSAGE_STATUS_SMALL, "[EventPool] No events available to start.")
			return true
		end
		EventPool:pickAndStart()
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "[EventPool] Forced event start.")
	elseif param == "list" then
		local msg = "[EventPool] Registered events:\n"
		for i, event in ipairs(EventPool.events) do
			local status = event.canStart() and "available" or "unavailable"
			msg = msg .. string.format("%d. %s [%s]\n", i, event.name, status)
		end
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, msg)
	else
		player:sendTextMessage(MESSAGE_STATUS_SMALL, "Usage: /ep start|list")
	end
	return true
end

epAdmin:separator(" ")
epAdmin:groupType("god")
epAdmin:register()
