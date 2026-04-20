local status = TalkAction("!expboost", "!xpboost")

function status.onSay(player, words, param)
	local kv = player:kv():scoped("exp-boost-item")

	local now = os.time()
	local legacyExpires = kv:get("expires") or 0
	if legacyExpires > now then
		kv:set("remaining_seconds", legacyExpires - now)
		kv:remove("expires")
	elseif legacyExpires > 0 then
		kv:remove("expires")
	end

	local legacyRemaining = kv:get("remaining") or 0
	if legacyRemaining > 0 then
		kv:set("remaining_seconds", legacyRemaining)
		kv:remove("remaining")
	end

	local remainingSeconds = kv:get("remaining_seconds") or 0
	local percent = kv:get("percent") or 0

	if remainingSeconds > 0 and percent > 0 then
		local mins = math.floor(remainingSeconds / 60)
		local secs = remainingSeconds % 60
		local timeStr = ""
		if mins > 0 then
			timeStr = mins .. " minute" .. (mins ~= 1 and "s" or "")
		end
		if secs > 0 then
			if timeStr ~= "" then timeStr = timeStr .. " and " end
			timeStr = timeStr .. secs .. " second" .. (secs ~= 1 and "s" or "")
		end
		player:sendTextMessage(MESSAGE_LOOK, string.format("Your item-based experience bonus is %d%% with %s of hunting time remaining.", percent, timeStr))
	else
		player:sendTextMessage(MESSAGE_LOOK, "You don't have an active item-based experience bonus.")
	end

	return true
end

status:separator(" ")
status:groupType("normal")
status:register()
