local config = {
	boss = {
		name = "The Time Guardian",
		position = Position(1295, 1028, 15),
	},
	requiredLevel = 250,
	playerPositions = {
		{ pos = Position(1299, 1059, 15), teleport = Position(1295, 1038, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1299, 1060, 15), teleport = Position(1295, 1038, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1299, 1061, 15), teleport = Position(1295, 1038, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1299, 1062, 15), teleport = Position(1295, 1038, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1299, 1063, 15), teleport = Position(1295, 1038, 15), effect = CONST_ME_TELEPORT },
	},
	specPos = {
		from = Position(1284, 1023, 15),
		to = Position(1306, 1045, 15),
	},
	exit = Position(1299, 1065, 15),
}

local lever = BossLever(config)
lever:position(Position(1299, 1058, 15))
lever:register()
