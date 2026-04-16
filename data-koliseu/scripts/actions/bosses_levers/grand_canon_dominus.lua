local config = {
	boss = {
	name = "Grand Canon Dominus",
		position = Position(1541, 1231, 15),
	},
	requiredLevel = 250,
	playerPositions = {
		{ pos = Position(1548, 1252, 15), teleport = Position(1541, 1236, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1548, 1253, 15), teleport = Position(1541, 1236, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1548, 1254, 15), teleport = Position(1541, 1236, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1548, 1255, 15), teleport = Position(1541, 1236, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1548, 1256, 15), teleport = Position(1541, 1236, 15), effect = CONST_ME_TELEPORT },
	},
	specPos = {
		from = Position(1531, 1226, 15),
		to = Position(1551, 1244, 15),
	},
	exit = Position(1548, 1257, 15),
}

lever = BossLever(config)
lever:position(Position(1548, 1251, 15))
lever:register()
