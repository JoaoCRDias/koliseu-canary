local config = {
	boss = {
		name = "Tarbaz",
		position = Position(1355, 1121, 15),
	},
	requiredLevel = 250,
	playerPositions = {
		{ pos = Position(1355, 1157, 15), teleport = Position(1356, 1128, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1355, 1158, 15), teleport = Position(1356, 1128, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1355, 1159, 15), teleport = Position(1356, 1128, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1355, 1160, 15), teleport = Position(1356, 1128, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1355, 1161, 15), teleport = Position(1356, 1128, 15), effect = CONST_ME_TELEPORT },
	},
	specPos = {
		from = Position(1342, 1110, 15),
		to = Position(1368, 1133, 15),
	},
	exit = Position(1355, 1152, 15),
}

local lever = BossLever(config)
lever:position(Position(1355, 1156, 15))
lever:register()
