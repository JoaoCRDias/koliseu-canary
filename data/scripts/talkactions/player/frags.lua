local frags = TalkAction("!frags")

function frags.onSay(player, words, param)
	local fragWindowHours = configManager.getNumber(configKeys.FRAG_WINDOW_HOURS)
	local fragWindowSeconds = fragWindowHours * 60 * 60
	local killsToRed = configManager.getNumber(configKeys.KILLS_TO_RED_SKULL)
	local killsToBlack = configManager.getNumber(configKeys.KILLS_TO_BLACK_SKULL)

	local fragsList = player:getKills()
	local currentTime = os.time()
	local recentFrags = 0

	for _, fragTable in pairs(fragsList) do
		local killTime = fragTable[2]
		if killTime then
			local diff = currentTime - killTime
			if diff <= fragWindowSeconds then
				recentFrags = recentFrags + 1
			end
		end
	end

	local remainingToRed = math.max(0, killsToRed - recentFrags)
	local remainingToBlack = math.max(0, killsToBlack - recentFrags)

	local message = string.format("Frags (last %d hours): %d/%d\n", fragWindowHours, recentFrags, killsToRed)
	if recentFrags >= killsToBlack then
		message = message .. "Status: BLACK SKULL"
	elseif recentFrags >= killsToRed then
		message = message .. string.format("Status: RED SKULL (%d more for black)", remainingToBlack)
	else
		message = message .. string.format("Status: Safe (%d more for red skull)", remainingToRed)
	end

	player:sendTextMessage(MESSAGE_LOOK, message)
	return true
end

frags:separator(" ")
frags:groupType("normal")
frags:register()
