-- Safezone - Logout and Login handlers

local szLogout = CreatureEvent("SZLogout")
function szLogout.onLogout(player)
	if Safezone.state ~= "idle" then
		Safezone:onPlayerLogout(player)
	end
	return true
end
szLogout:register()

local szLogin = CreatureEvent("SZLogin")
function szLogin.onLogin(player)
	player:registerEvent("SZLogout")

	-- Cleanup stale state if server crashed mid-event
	if player:getStorageValue(Safezone.config.storageActive) == 1 then
		player:setStorageValue(Safezone.config.storageActive, -1)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "[Safezone] The event ended while you were offline.")
	end

	return true
end
szLogin:register()
