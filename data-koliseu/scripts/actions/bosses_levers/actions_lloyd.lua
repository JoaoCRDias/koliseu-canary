local config = {
	boss = {
		name = "Lloyd",
		position = Position(1378, 1040, 15),
	},
	requiredLevel = 250,
	playerPositions = {
		{ pos = Position(1376, 1064, 15), teleport = Position(1378, 1046, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1376, 1065, 15), teleport = Position(1378, 1046, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1376, 1066, 15), teleport = Position(1378, 1046, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1376, 1067, 15), teleport = Position(1378, 1046, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1376, 1068, 15), teleport = Position(1378, 1046, 15), effect = CONST_ME_TELEPORT },
	},
	specPos = {
		from = Position(1364, 1025, 15),
		to = Position(1392, 1051, 15),
	},
	exit = Position(1262, 1067, 15),
}

local lever = BossLever(config)
lever:position(Position(1376, 1063, 15))
lever:register()
