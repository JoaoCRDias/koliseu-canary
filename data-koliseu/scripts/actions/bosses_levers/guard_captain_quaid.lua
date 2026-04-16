local config = {
	boss = {
		name = "Guard Captain Quaid",
		position = Position(1435, 1230, 15),
	},
	requiredLevel = 250,
	playerPositions = {
		{ pos = Position(1436, 1252, 15), teleport = Position(1435, 1237, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1436, 1253, 15), teleport = Position(1435, 1237, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1436, 1254, 15), teleport = Position(1435, 1237, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1436, 1255, 15), teleport = Position(1435, 1237, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1436, 1256, 15), teleport = Position(1435, 1237, 15), effect = CONST_ME_TELEPORT },
	},
	specPos = {
		from = Position(1429, 1226, 15),
		to = Position(1440, 1238, 15),
	},
	exit = Position(1436, 1258, 15),
}

local lever = BossLever(config)
lever:position(Position(1436, 1251, 15))
lever:register()
