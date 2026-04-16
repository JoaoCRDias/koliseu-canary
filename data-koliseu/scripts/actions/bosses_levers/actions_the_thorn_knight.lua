local config = {
	boss = {
		name = "The Enraged Thorn Knight",
		position = Position(1426, 1037, 15),
	},
	requiredLevel = 250,
	playerPositions = {
		{ pos = Position(1428, 1073, 15), teleport = Position(1427, 1044, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1428, 1074, 15), teleport = Position(1427, 1044, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1428, 1075, 15), teleport = Position(1427, 1044, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1428, 1076, 15), teleport = Position(1427, 1044, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1428, 1077, 15), teleport = Position(1427, 1044, 15), effect = CONST_ME_TELEPORT },
	},
	specPos = {
		from = Position(1414, 1026, 15),
		to = Position(1438, 1049, 15),
	},
	exit = Position(1428, 1079, 15),
}

local lever = BossLever(config)
lever:position(Position(1428, 1072, 15))
lever:register()
