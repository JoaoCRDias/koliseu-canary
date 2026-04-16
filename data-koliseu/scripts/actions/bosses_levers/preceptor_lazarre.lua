local config = {
	boss = {
		name = "Preceptor Lazare",
		position = Position(1571, 1233, 15),
	},
	requiredLevel = 250,
	playerPositions = {
		{ pos = Position(1569, 1252, 15), teleport = Position(1570, 1236, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1569, 1253, 15), teleport = Position(1570, 1236, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1569, 1254, 15), teleport = Position(1570, 1236, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1569, 1255, 15), teleport = Position(1570, 1236, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1569, 1256, 15), teleport = Position(1570, 1236, 15), effect = CONST_ME_TELEPORT },
	},
	specPos = {
		from = Position(1567, 1232, 15),
		to = Position(1573, 1237, 15),
	},
	exit = Position(1569, 1257, 15),
}

lever = BossLever(config)
lever:position(Position(1569, 1251, 15))
lever:register()
