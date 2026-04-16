local config = {
	boss = {
		name = "Baldur the Allfather",
		position = Position(3054, 3099, 4),
	},
	requiredLevel = 500,
	timeToFightAgain = 60 * 60 * 20, -- 20 hours
	timeToDefeat = 20 * 60, -- 30 minutes
	playerPositions = {
		-- PLACEHOLDER: adjust lever waiting room positions to your map
		{ pos = Position(3053, 3103, 2), teleport = Position(3054, 3108, 4), effect = CONST_ME_TELEPORT },
		{ pos = Position(3053, 3104, 2), teleport = Position(3054, 3108, 4), effect = CONST_ME_TELEPORT },
		{ pos = Position(3053, 3105, 2), teleport = Position(3054, 3108, 4), effect = CONST_ME_TELEPORT },
		{ pos = Position(3053, 3106, 2), teleport = Position(3054, 3108, 4), effect = CONST_ME_TELEPORT },
		{ pos = Position(3053, 3107, 2), teleport = Position(3054, 3108, 4), effect = CONST_ME_TELEPORT },

	},
	specPos = {
		from = Position(3039, 3090, 4),
		to = Position(3070, 3123, 4),
	},
	exit = Position(3053, 3109, 2),
}

local lever = BossLever(config)
lever:position(Position(3053, 3102, 2)) -- PLACEHOLDER: lever position
lever:register()
