local config = {
	boss = {
		name = "Malofur Mangrinder",
		position = Position(1399, 1504, 15),
	},
	playerPositions = {
		{ pos = Position(1363, 1506, 15), teleport = Position(1399, 1514, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1363, 1507, 15), teleport = Position(1399, 1514, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1363, 1508, 15), teleport = Position(1399, 1514, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1363, 1509, 15), teleport = Position(1399, 1514, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1363, 1510, 15), teleport = Position(1399, 1514, 15), effect = CONST_ME_TELEPORT },
	},
	specPos = {
		from = Position(1389, 1498, 15),
		to = Position(1410, 1518, 15),
	},
	exit = Position(1363, 1511, 15),
}

local lever = BossLever(config)
lever:position(Position(1363, 1505, 15))
lever:register()
