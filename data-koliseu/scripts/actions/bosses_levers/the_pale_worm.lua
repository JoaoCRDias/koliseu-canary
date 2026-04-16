local config = {
	boss = {
		name = "The Pale Worm",
		position = Position(1224, 1556, 15),
	},
	requiredLevel = 250,
	timeToDefeat = 25 * 60,
	playerPositions = {
		{ pos = Position(1191, 1557, 15), teleport = Position(1225, 1566, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1192, 1556, 15), teleport = Position(1225, 1566, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1192, 1557, 15), teleport = Position(1225, 1566, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1192, 1558, 15), teleport = Position(1225, 1566, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1193, 1556, 15), teleport = Position(1225, 1566, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1193, 1557, 15), teleport = Position(1225, 1566, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1193, 1558, 15), teleport = Position(1225, 1566, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1194, 1556, 15), teleport = Position(1225, 1566, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1194, 1557, 15), teleport = Position(1225, 1566, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1194, 1558, 15), teleport = Position(1225, 1566, 15), effect = CONST_ME_TELEPORT },
	},
	specPos = {
		from = Position(1210, 1545, 15),
		to = Position(1239, 1571, 15),
	},
	exit = Position(1197, 1557, 15),
}

local lever = BossLever(config)
lever:position(Position(1190, 1557, 15))
lever:register()
