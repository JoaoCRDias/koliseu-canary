local config = {
	boss = { name = "Gnomevil", position = Position(1327, 940, 15) },
	requiredLevel = 250,
	playerPositions = {
		{ pos = Position(1286, 981, 15), teleport = Position(1317, 933, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1286, 982, 15), teleport = Position(1317, 933, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1286, 983, 15), teleport = Position(1317, 933, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1286, 984, 15), teleport = Position(1317, 933, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1286, 985, 15), teleport = Position(1317, 933, 15), effect = CONST_ME_TELEPORT },
	},
	specPos = {
		from = Position(1308, 923, 15),
		to = Position(1341, 953, 15),
	},
	exit = Position(1286, 986, 15),
}

local lever = BossLever(config)
lever:position(Position(1286, 980, 15))
lever:register()
