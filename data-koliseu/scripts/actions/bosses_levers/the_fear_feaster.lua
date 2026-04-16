local config = {
	boss = {
		name = "The Fear Feaster",
		position = Position(1131, 1518, 15),
	},
	requiredLevel = 250,
	playerPositions = {
		{ pos = Position(1153, 1524, 15), teleport = Position(1131, 1527, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1154, 1524, 15), teleport = Position(1131, 1527, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1155, 1524, 15), teleport = Position(1131, 1527, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1156, 1524, 15), teleport = Position(1131, 1527, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1157, 1524, 15), teleport = Position(1131, 1527, 15), effect = CONST_ME_TELEPORT },
	},
	specPos = {
		from = Position(1121, 1514, 15),
		to = Position(1140, 1531, 15),
	},
	exit = Position(1159, 1524, 15),
}

local lever = BossLever(config)
lever:position(Position(1152, 1524, 15))
lever:register()
