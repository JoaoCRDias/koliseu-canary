-- Fire Or Ice - Logout and Login handlers

local foiLogout = CreatureEvent("FOILogout")
function foiLogout.onLogout(player)
	if FireOrIce.state ~= "idle" then
		FireOrIce:onPlayerLogout(player)
	end
	return true
end
foiLogout:register()

local foiLogin = CreatureEvent("FOILogin")
function foiLogin.onLogin(player)
	player:registerEvent("FOILogout")

	-- Cleanup stale state if server crashed mid-event
	if player:getStorageValue(FireOrIce.config.storageActive) == 1 then
		player:setStorageValue(FireOrIce.config.storageActive, -1)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "[Fire Or Ice] The event ended while you were offline.")
	end

	return true
end
foiLogin:register()
