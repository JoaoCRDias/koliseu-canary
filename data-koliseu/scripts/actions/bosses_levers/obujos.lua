local config = {
	boss = {
		name = "Obujos",
		position = Position(1177, 1030, 15),
	},
	requiredLevel = 250,
	playerPositions = {
		{ pos = Position(1176, 1069, 15), teleport = Position(1169, 1041, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1176, 1070, 15), teleport = Position(1169, 1041, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1176, 1071, 15), teleport = Position(1169, 1041, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1176, 1072, 15), teleport = Position(1169, 1041, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1176, 1073, 15), teleport = Position(1169, 1041, 15), effect = CONST_ME_TELEPORT },
	},
	specPos = {
		from = Position(1155, 1020, 15),
		to = Position(1192, 1047, 15),
	},
	exit = Position(1173, 1070, 15),
}

local lever = BossLever(config)
lever:position(Position(1176, 1068, 15))
lever:register()
