local resetAllBossCooldowns = TalkAction("/resetbosscooldowns")

function resetAllBossCooldowns.onSay(player, words, param)
	local targetPlayerName = param ~= "" and param or player:getName()
	local targetPlayer = Player(targetPlayerName)

	if not targetPlayer then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Player " .. targetPlayerName .. " not found or is offline.")
		return false
	end

	local resetCount = 0
	local bossesCleared = {}

	for bossName, bossLever in pairs(BossLever) do
		if type(bossLever) == "table" and bossLever.name then
			local cooldown = targetPlayer:getBossCooldown(bossLever.name)
			if cooldown and cooldown > os.time() then
				targetPlayer:setBossCooldown(bossLever.name, 0)
				table.insert(bossesCleared, bossLever.name)
				resetCount = resetCount + 1
			end
		end
	end

	if resetCount > 0 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Reset " .. resetCount .. " boss cooldown(s) for player " .. targetPlayerName .. ".")
		if targetPlayer ~= player then
			targetPlayer:sendTextMessage(MESSAGE_EVENT_ADVANCE, "All your boss cooldowns have been reset by " .. player:getName() .. ".")
		else
			targetPlayer:sendTextMessage(MESSAGE_EVENT_ADVANCE, "All your boss cooldowns have been reset.")
		end

		if #bossesCleared > 0 then
			logger.info("Boss cooldowns reset for player {}: {}", targetPlayerName, table.concat(bossesCleared, ", "))
		end
	else
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "No active boss cooldowns found for player " .. targetPlayerName .. ".")
	end

	return false
end

resetAllBossCooldowns:separator(" ")
resetAllBossCooldowns:groupType("god")
resetAllBossCooldowns:register()
