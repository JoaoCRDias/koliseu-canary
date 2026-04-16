local config = {
	boss = {
		name = "Razzagorn",
		position = Position(1466, 1128, 15),
	},
	requiredLevel = 250,

	playerPositions = {
		{ pos = Position(1460, 1164, 15), teleport = Position(1455, 1126, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1461, 1164, 15), teleport = Position(1455, 1126, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1462, 1164, 15), teleport = Position(1455, 1126, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1463, 1164, 15), teleport = Position(1455, 1126, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1464, 1164, 15), teleport = Position(1455, 1126, 15), effect = CONST_ME_TELEPORT },
	},
	specPos = {
		from = Position(1439, 1106, 15),
		to = Position(1482, 1146, 15),
	},
	exit = Position(1456, 1164, 15),
}

local lever = BossLever(config)
lever:position(Position(1459, 1164, 15))
lever:register()
