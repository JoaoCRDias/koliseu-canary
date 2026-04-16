local config = {
	storage = 20001,
	pointsPerHour = 10,
	doubleCoinsForVip = true,
	vipMultiplierFactor = 2,
	checkDuplicateIps = false
}

local onlinePointsEvent = GlobalEvent("GainPointPerHour")

function onlinePointsEvent.onThink(interval)
	local players = Game.getPlayers()
	if #players == 0 then
		return true
	end

	local checkIp = {}
	for _, player in pairs(players) do
		local ip = player:getIp()
		if ip ~= 0 and (not config.checkDuplicateIps or not checkIp[ip]) then
			checkIp[ip] = true
			local seconds = math.max(0, player:getStorageValue(config.storage))
			if seconds >= 3600 then
				if player:isVip() then
					player:addCoinsBalance(config.pointsPerHour * config.vipMultiplierFactor)
				else
					player:addCoinsBalance(config.pointsPerHour)
				end
				player:setStorageValue(config.storage, 0)
				player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Voce recebeu pontos por estar online!")
				return true
			end
			player:setStorageValue(config.storage, seconds + math.ceil(interval / 1000))
		end
	end
	return true
end

onlinePointsEvent:interval(10000)
onlinePointsEvent:register()
