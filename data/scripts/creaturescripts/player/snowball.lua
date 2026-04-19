-- Snowball Fight - Logout and Login handlers

local sbLogout = CreatureEvent("SnowballLogout")
function sbLogout.onLogout(player)
	if Snowball.state ~= "idle" then
		Snowball:onPlayerLogout(player)
	end
	return true
end
sbLogout:register()

local sbLogin = CreatureEvent("SnowballLogin")
function sbLogin.onLogin(player)
	player:registerEvent("SnowballLogout")

	-- Cleanup stale state if server crashed mid-event
	if player:getStorageValue(Snowball.config.storageActive) == 1 then
		player:setStorageValue(Snowball.config.storageActive, -1)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "[Snowball] The event ended while you were offline.")
	end

	return true
end
sbLogin:register()
