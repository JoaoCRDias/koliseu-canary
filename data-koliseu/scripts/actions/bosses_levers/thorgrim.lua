local config = {
	boss = {
		name = "Thorgrim the Hammerborn",
		position = Position(3107, 3148, 4),
	},
	playerPositions = {
		{ pos = Position(3107, 3163, 4), teleport = Position(3107, 3158, 4), effect = CONST_ME_TELEPORT },
		{ pos = Position(3107, 3164, 4), teleport = Position(3107, 3158, 4), effect = CONST_ME_TELEPORT },
		{ pos = Position(3107, 3165, 4), teleport = Position(3107, 3158, 4), effect = CONST_ME_TELEPORT },
		{ pos = Position(3107, 3166, 4), teleport = Position(3107, 3158, 4), effect = CONST_ME_TELEPORT },
		{ pos = Position(3107, 3167, 4), teleport = Position(3107, 3158, 4), effect = CONST_ME_TELEPORT },
	},
	specPos = {
		from = Position(3102, 3144, 4),
		to = Position(3112, 3160, 4),
	},
	exit = Position(3109, 3165, 4),
}

local lever = BossLever(config)
lever:aid(14426)
lever:register()
