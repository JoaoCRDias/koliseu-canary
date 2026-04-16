local config = {
	boss = {
	name = "Grand Commander Soeren",
		position = Position(1610, 1239, 15),
	},
	requiredLevel = 250,
	playerPositions = {
		{ pos = Position(1610, 1254, 15), teleport = Position(1610, 1243, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1610, 1255, 15), teleport = Position(1610, 1243, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1610, 1256, 15), teleport = Position(1610, 1243, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1610, 1257, 15), teleport = Position(1610, 1243, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1610, 1258, 15), teleport = Position(1610, 1243, 15), effect = CONST_ME_TELEPORT },
	},
	specPos = {
		from = Position(1607, 1238, 15),
		to = Position(1612, 1244, 15),
	},
	exit = Position(1610, 1259, 15),
}

lever = BossLever(config)
lever:position(Position(1610, 1253, 15))
lever:register()
