local siegecd = TalkAction("!siegecd")

local SIEGE_LEVELS = { 500, 1000, 1500 }

local BOSS_NAMES = {
	[500] = "Nebular Warlord",
	[1000] = "Eclipse Sovereign",
	[1500] = "Astral Tyrant",
}

function siegecd.onSay(player, words, param)
	local now = os.time()
	local lines = {}

	for _, level in ipairs(SIEGE_LEVELS) do
		local cooldownEnd = player:kv():get("cosmic_siege.cooldown." .. level) or 0
		local bossName = BOSS_NAMES[level]
		if cooldownEnd > now then
			local remaining = cooldownEnd - now
			table.insert(lines, string.format("  Level %d (%s): %s remaining.", level, bossName, Game.getTimeInWords(remaining)))
		else
			table.insert(lines, string.format("  Level %d (%s): Ready!", level, bossName))
		end
	end

	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "[Cosmic Siege] Cooldowns:\n" .. table.concat(lines, "\n"))
	return false
end

siegecd:separator(" ")
siegecd:groupType("normal")
siegecd:register()
