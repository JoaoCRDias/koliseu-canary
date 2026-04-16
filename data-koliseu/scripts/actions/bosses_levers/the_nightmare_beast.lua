local config = {
	boss = {
		name = "The Nightmare Beast",
		position = Position(1375, 1612, 15),
	},
	requiredLevel = 250,
	playerPositions = {
		{ pos = Position(1379, 1640, 15), teleport = Position(1375, 1622, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1377, 1640, 15), teleport = Position(1375, 1622, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1378, 1640, 15), teleport = Position(1375, 1622, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1380, 1640, 15), teleport = Position(1375, 1622, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1381, 1640, 15), teleport = Position(1375, 1622, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1377, 1641, 15), teleport = Position(1375, 1622, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1378, 1641, 15), teleport = Position(1375, 1622, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1379, 1641, 15), teleport = Position(1375, 1622, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1380, 1641, 15), teleport = Position(1375, 1622, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1381, 1641, 15), teleport = Position(1375, 1622, 15), effect = CONST_ME_TELEPORT },
	},
	specPos = {
		from = Position(1359, 1604, 15),
		to = Position(1390, 1628, 15),
	},
	exit = Position(1379, 1643, 15),
}

local lever = BossLever(config)
lever:position(Position(1379, 1639, 15))
lever:register()
