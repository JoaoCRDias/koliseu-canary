-- Map Texts System
-- Displays periodic text messages at configured map positions

local config = {
	interval = 4 * 1000, -- Interval between messages in milliseconds (30 seconds)
	texts = {
		-- Example entries:
		-- { position = Position(1000, 1000, 7), text = "Welcome to the temple!" },
		-- { position = Position(500, 500, 7), text = "Beware of the monsters ahead!" },

		-- Cosmic Siege entrance
		{ position = Position(998, 1004, 8), text = "Cosmic Siege" },
		{ position = Position(775, 1128, 3), text = "Easy" },
		{ position = Position(779, 1128, 3), text = "Medium" },
		{ position = Position(783, 1128, 3), text = "Hard" },
		{ position = Position(787, 1128, 3), text = "Epic" },
		{ position = Position(791, 1128, 3), text = "Rampage" },
		{ position = Position(1013, 994, 7), text = "Roulette" },
		{ position = Position(1023, 995, 7), text = "Fallen Raid" },
		{ position = Position(1012, 1001, 8), text = "Hunted System" },
		{ position = Position(1002, 995, 8), text = "Craft" },
		{ position = Position(1015, 999, 6), text = "Gnome Arena" },
		{ position = Position(997, 1005, 6), text = "Castle War" },
		{ position = Position(988, 1000, 8), text = "Mining System" },
		{ position = Position(1007, 1006, 7), text = "Clean Shopping Bags" },
		{ position = Position(1063, 999, 7), text = "Say !jail" },
		{ position = Position(1063, 1000, 7), text = "Say !jail" },
		{ position = Position(1063, 1001, 7), text = "Say !jail" },
		{ position = Position(997, 1005, 7), text = "King's Throne" },

		{ position = Position(1075, 548, 6), text = "ED" },
		{ position = Position(1075, 553, 6), text = "MS" },
		{ position = Position(1086, 560, 6), text = "EM" },
		{ position = Position(1097, 553, 6), text = "RP" },
		{ position = Position(1097, 548, 6), text = "EK" },



		-- Add more map texts here following the pattern:
		-- { position = Position(x, y, z), text = "Your message here" },
	}
}

local function sendMapTexts()
	for _, entry in ipairs(config.texts) do
		local position = entry.position
		local text = entry.text

		-- Get spectators near the position to send the message
		local spectators = Game.getSpectators(position, false, true, 7, 7, 5, 5)
		for _, player in ipairs(spectators) do
			if player:isPlayer() then
				player:say(text, TALKTYPE_MONSTER_SAY, false, player, position)
			end
		end
	end

	-- Schedule next execution
	addEvent(sendMapTexts, config.interval)
end

-- Start the map texts system
addEvent(sendMapTexts, config.interval)

logger.info("[Map Texts] System loaded with " .. #config.texts .. " configured texts.")
