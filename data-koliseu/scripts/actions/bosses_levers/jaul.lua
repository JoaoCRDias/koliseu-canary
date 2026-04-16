local config = {
	boss = {
		name = "Jaul",
		position = Position(1090, 1044, 15),
	},
	requiredLevel = 250,
	playerPositions = {
		{ pos = Position(1087, 1064, 15), teleport = Position(1088, 1032, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1087, 1065, 15), teleport = Position(1088, 1032, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1087, 1066, 15), teleport = Position(1088, 1032, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1087, 1067, 15), teleport = Position(1088, 1032, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1087, 1068, 15), teleport = Position(1088, 1032, 15), effect = CONST_ME_TELEPORT },
	},
	specPos = {
		from = Position(1071, 1026, 15),
		to = Position(1102, 1048, 15),
	},
	exit = Position(1085, 1065, 15),
}

local lever = BossLever(config)
lever:position(Position(1087, 1063, 15))
lever:register()
