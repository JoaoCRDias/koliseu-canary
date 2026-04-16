local config = {
	boss = {
		name = "Tentugly's Head",
		position = Position(1277, 1374, 6),
	},
	requiredLevel = 250,
	playerPositions = {
		{ pos = Position(1279, 1409, 6), teleport = Position(1266, 1375, 7), effect = CONST_ME_TELEPORT },
		{ pos = Position(1280, 1409, 6), teleport = Position(1266, 1375, 7), effect = CONST_ME_TELEPORT },
		{ pos = Position(1281, 1409, 6), teleport = Position(1266, 1375, 7), effect = CONST_ME_TELEPORT },
		{ pos = Position(1282, 1409, 6), teleport = Position(1266, 1375, 7), effect = CONST_ME_TELEPORT },
		{ pos = Position(1283, 1409, 6), teleport = Position(1266, 1375, 7), effect = CONST_ME_TELEPORT },
	},
	specPos = {
		from = Position(1257, 1364, 6),
		to = Position(1294, 1384, 7),
	},
	exit = Position(1284, 1409, 6),
}

local lever = BossLever(config)
lever:position(Position(1278, 1409, 6))
lever:register()
