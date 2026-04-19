-- Capture The Flag - Death and Logout handlers

-- ============================================================
-- Player Death in CTF (respawn at team base)
-- ============================================================

local ctfDeath = CreatureEvent("CTFDeath")
function ctfDeath.onPrepareDeath(creature, killer)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	if CTF.state ~= "running" then
		return true
	end

	if not CTF.players[player:getGuid()] then
		return true
	end

	-- Handle flag drop, heal and respawn
	CTF:onPlayerDeath(player)

	-- Prevent actual death
	return false
end
ctfDeath:register()

-- ============================================================
-- Player Logout during CTF
-- ============================================================

local ctfLogout = CreatureEvent("CTFLogout")
function ctfLogout.onLogout(player)
	if CTF.state == "idle" then
		return true
	end

	if CTF.players[player:getGuid()] then
		CTF:onPlayerLogout(player)
	end

	return true
end
ctfLogout:register()

-- ============================================================
-- Register events on login
-- ============================================================

local ctfLogin = CreatureEvent("CTFLogin")
function ctfLogin.onLogin(player)
	player:registerEvent("CTFDeath")
	player:registerEvent("CTFLogout")

	-- Cleanup stale CTF state if server crashed mid-event
	if player:getStorageValue(CTF.config.storageActive) == 1 then
		player:setStorageValue(CTF.config.storageActive, -1)
		player:setStorageValue(CTF.config.storageTeam, -1)
		player:setStorageValue(CTF.config.storageHasFlag, -1)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "[CTF] The event ended while you were offline.")
	end

	return true
end
ctfLogin:register()
