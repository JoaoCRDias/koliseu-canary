local config = {
	boss = {
	name = "Grand Chaplain Gaunder",
		position = Position(1569, 1278, 15),
	},
	requiredLevel = 250,
	playerPositions = {
		{ pos = Position(1568, 1300, 15), teleport = Position(1569, 1283, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1568, 1301, 15), teleport = Position(1569, 1283, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1568, 1302, 15), teleport = Position(1569, 1283, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1568, 1303, 15), teleport = Position(1569, 1283, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1568, 1304, 15), teleport = Position(1569, 1283, 15), effect = CONST_ME_TELEPORT },
	},
	specPos = {
		from = Position(1560, 1273, 15),
		to = Position(1578, 1285, 15),
	},
	exit = Position(1568, 1305, 15),
}

lever = BossLever(config)
lever:position(Position(1568, 1299, 15))
lever:register()
