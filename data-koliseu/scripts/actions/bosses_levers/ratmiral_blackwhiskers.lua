local config = {
	boss = {
		name = "Ratmiral Blackwhiskers",
		position = Position(1211, 1358, 15),
	},
	requiredLevel = 250,
	playerPositions = {
		{ pos = Position(1212, 1389, 15), teleport = Position(1211, 1361, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1213, 1389, 15), teleport = Position(1211, 1361, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1214, 1389, 15), teleport = Position(1211, 1361, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1215, 1389, 15), teleport = Position(1211, 1361, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1216, 1389, 15), teleport = Position(1211, 1361, 15), effect = CONST_ME_TELEPORT },
	},
	specPos = {
		from = Position(1192, 1349, 15),
		to = Position(1228, 1368, 15),
	},
	exit = Position(1217, 1389, 15),
}

local lever = BossLever(config)
lever:position(Position(1211, 1389, 15))
lever:register()
