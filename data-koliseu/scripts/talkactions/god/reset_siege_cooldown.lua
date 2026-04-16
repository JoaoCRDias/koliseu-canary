-- Reset Siege Defender Cooldown
-- Command: /resetsiege or /resetsiege <player name>

local resetSiegeCooldown = TalkAction("/resetsiege")

function resetSiegeCooldown.onSay(player, words, param)
	-- Check if player is God or higher
	if player:getAccountType() < ACCOUNT_TYPE_GOD then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You don't have permission to use this command.")
		return false
	end

	local targetPlayer = nil

	if param and param ~= "" then
		-- Reset cooldown for specific player
		targetPlayer = Player(param)
		if not targetPlayer then
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Player '" .. param .. "' not found.")
			return false
		end
	else
		-- Reset cooldown for self
		targetPlayer = player
	end

	-- Reset Siege Defender cooldown
	local bossName = "Siege Defender"
	local success = targetPlayer:setBossCooldown(bossName, 0)

	if success then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE,
			string.format("Siege Defender cooldown reset for player: %s", targetPlayer:getName()))

		if targetPlayer ~= player then
			targetPlayer:sendTextMessage(MESSAGE_EVENT_ADVANCE,
				"Your Siege Defender cooldown has been reset by " .. player:getName())
		end

		logger.info("[Reset Siege Cooldown] {} reset Siege Defender cooldown for {}",
			player:getName(), targetPlayer:getName())
	else
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Failed to reset cooldown.")
	end

	return false
end

resetSiegeCooldown:separator(" ")
resetSiegeCooldown:groupType("god")
resetSiegeCooldown:register()
