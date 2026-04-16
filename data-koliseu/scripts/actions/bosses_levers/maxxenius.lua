local config = {
	boss = {
		name = "Maxxenius",
		position = Position(1484, 1503, 15),
	},
	playerPositions = {
		{ pos = Position(1448, 1505, 15), teleport = Position(1484, 1512, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1448, 1506, 15), teleport = Position(1484, 1512, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1448, 1507, 15), teleport = Position(1484, 1512, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1448, 1508, 15), teleport = Position(1484, 1512, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1448, 1509, 15), teleport = Position(1484, 1512, 15), effect = CONST_ME_TELEPORT },
	},
	specPos = {
		from = Position(1475, 1498, 15),
		to = Position(1494, 1517, 15),
	},
	exit = Position(1448, 1510, 15),
}

local lever = BossLever(config)
lever:position(Position(1448, 1504, 15))
lever:register()
