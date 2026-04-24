-- !pattern
-- Dev/test: open a popup showing the currently active Supreme Vocation lever
-- pattern. Rotates every SupremeVocation.PATTERN_ROTATION_SECONDS seconds.

local talk = TalkAction("!pattern")

function talk.onSay(player, words, param)
	local index = SupremeVocation.getActivePatternIndex()
	if not index then
		player:sendCancelMessage("No active pattern is set.")
		return false
	end

	local pattern = SupremeVocation.LeverPatterns[index]
	local lines = { string.format("Active lever pattern #%d", index), "" }
	for row = 1, SupremeVocation.GRID_ROWS do
		local rowText = ""
		for col = 1, SupremeVocation.GRID_COLS do
			rowText = rowText .. (pattern[row][col] == 1 and "[X] " or "[ ] ")
		end
		lines[#lines + 1] = rowText
	end
	lines[#lines + 1] = ""
	lines[#lines + 1] = "[X] = lever pulled"
	lines[#lines + 1] = "[ ] = lever at rest"

	player:popupFYI(table.concat(lines, "\n"))
	return false
end

talk:separator(" ")
talk:groupType("normal")
talk:register()
