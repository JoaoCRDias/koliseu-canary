local config = {
	boss = {
		name = "Tanjis",
		position = Position(1133, 1033, 15),
	},
	requiredLevel = 250,
	playerPositions = {
		{ pos = Position(1135, 1069, 15), teleport = Position(1134, 1043, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1135, 1070, 15), teleport = Position(1134, 1043, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1135, 1071, 15), teleport = Position(1134, 1043, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1135, 1072, 15), teleport = Position(1134, 1043, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1135, 1073, 15), teleport = Position(1134, 1043, 15), effect = CONST_ME_TELEPORT },
	},
	specPos = {
		from = Position(1118, 1020, 15),
		to = Position(1144, 1049, 15),
	},
	exit = Position(1134, 1069, 15),
}

local lever = BossLever(config)
lever:position(Position(1135, 1068, 15))
lever:register()
