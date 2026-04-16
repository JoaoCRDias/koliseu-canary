local config = {
	boss = {
		name = "Gaffir",
		position = Position(1412, 1230, 15),
	},
	requiredLevel = 250,
	playerPositions = {
		{ pos = Position(1412, 1254, 15), teleport = Position(1411, 1234, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1412, 1255, 15), teleport = Position(1411, 1234, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1412, 1256, 15), teleport = Position(1411, 1234, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1412, 1257, 15), teleport = Position(1411, 1234, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1412, 1258, 15), teleport = Position(1411, 1234, 15), effect = CONST_ME_TELEPORT },
	},
	specPos = {
		from = Position(1407, 1225, 15),
		to = Position(1415, 1238, 15),
	},
	exit = Position(1412, 1260, 15),
}

local lever = BossLever(config)
lever:position(Position(1412, 1253, 15))
lever:register()
