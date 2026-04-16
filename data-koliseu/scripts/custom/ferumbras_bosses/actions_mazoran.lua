local config = {
	boss = {
		name = "Mazoran",
		position = Position(1609, 1131, 15),
	},
	requiredLevel = 250,

	playerPositions = {
		{ pos = Position(1612, 1168, 15), teleport = Position(1610, 1142, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1612, 1169, 15), teleport = Position(1610, 1142, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1612, 1170, 15), teleport = Position(1610, 1142, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1612, 1171, 15), teleport = Position(1610, 1142, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1612, 1172, 15), teleport = Position(1610, 1142, 15), effect = CONST_ME_TELEPORT },
	},
	specPos = {
		from = Position(1595, 1123, 15),
		to = Position(1624, 1148, 15),
	},
	exit = Position(1612, 1175, 15),
}

local lever = BossLever(config)
lever:position(Position(1612, 1167, 15))
lever:register()
