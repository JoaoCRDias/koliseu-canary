local config = {
	boss = {
		name = "Hemothrak the Crimson Sovereign",
		position = Position(3014, 3098, 4), -- PLACEHOLDER: boss spawn position
	},
	requiredLevel = 600,
	timeToFightAgain = 60 * 60 * 20,
	timeToDefeat = 25 * 60, -- 25 minutes
	playerPositions = {
		-- PLACEHOLDER: adjust lever waiting room positions to your map
		{ pos = Position(3015, 3100, 3), teleport = Position(3014, 3104, 4), effect = CONST_ME_TELEPORT },
		{ pos = Position(3015, 3101, 3), teleport = Position(3014, 3104, 4), effect = CONST_ME_TELEPORT },
		{ pos = Position(3015, 3102, 3), teleport = Position(3014, 3104, 4), effect = CONST_ME_TELEPORT },
		{ pos = Position(3015, 3103, 3), teleport = Position(3014, 3104, 4), effect = CONST_ME_TELEPORT },
		{ pos = Position(3015, 3104, 3), teleport = Position(3014, 3104, 4), effect = CONST_ME_TELEPORT },
	},
	specPos = {
		from = Position(3007, 3093, 4), -- PLACEHOLDER
		to = Position(3022, 3114, 4), -- PLACEHOLDER
	},
	exit = Position(3015, 3106, 3), -- PLACEHOLDER
}

local lever = BossLever(config)
lever:position(Position(3015, 3099, 3)) -- PLACEHOLDER: lever position
lever:register()
