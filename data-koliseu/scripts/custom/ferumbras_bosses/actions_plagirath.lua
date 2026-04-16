local config = {
	boss = {
		name = "Plagirath",
		position = Position(1399, 1123, 15),
	},
	requiredLevel = 250,

	playerPositions = {
		{ pos = Position(1401, 1158, 15), teleport = Position(1401, 1131, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1401, 1159, 15), teleport = Position(1401, 1131, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1401, 1160, 15), teleport = Position(1401, 1131, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1401, 1161, 15), teleport = Position(1401, 1131, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1401, 1162, 15), teleport = Position(1401, 1131, 15), effect = CONST_ME_TELEPORT },
	},
	specPos = {
		from = Position(1384, 1113, 15),
		to = Position(1416, 1138, 15),
	},
	exit = Position(1401, 1154, 15),
}

local lever = BossLever(config)
lever:position(Position(1401, 1157, 15))
lever:register()
