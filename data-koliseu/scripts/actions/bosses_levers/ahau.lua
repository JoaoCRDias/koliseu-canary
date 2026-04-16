local config = {
	boss = {
		name = "Ahau",
		position = Position(1447, 930, 15),
	},
	requiredLevel = 250,
	playerPositions = {
		{ pos = Position(1510, 932, 15), teleport = Position(1447, 933, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1509, 932, 15), teleport = Position(1447, 933, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1508, 932, 15), teleport = Position(1447, 933, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1507, 932, 15), teleport = Position(1447, 933, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1506, 932, 15), teleport = Position(1447, 933, 15), effect = CONST_ME_TELEPORT },
	},
	specPos = {
		from = Position(1439, 924, 15),
		to = Position(1458, 937, 15),
	},
	exit = Position(1509, 934, 15),
}

local lever = BossLever(config)
lever:position(Position(1511, 932, 15))
lever:register()
