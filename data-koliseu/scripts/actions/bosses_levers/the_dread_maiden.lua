local config = {
	boss = {
		name = "The Dread Maiden",
		position = Position(1132, 1553, 15),
	},
	requiredLevel = 250,
	playerPositions = {
		{ pos = Position(1158, 1559, 15), teleport = Position(1132, 1560, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1159, 1559, 15), teleport = Position(1132, 1560, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1160, 1559, 15), teleport = Position(1132, 1560, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1161, 1559, 15), teleport = Position(1132, 1560, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1162, 1559, 15), teleport = Position(1132, 1560, 15), effect = CONST_ME_TELEPORT },
	},
	specPos = {
		from = Position(1121, 1546, 15),
		to = Position(1145, 1568, 15),
	},
	exit = Position(1164, 1559, 15),
}

local lever = BossLever(config)
lever:position(Position(1157, 1559, 15))
lever:register()
