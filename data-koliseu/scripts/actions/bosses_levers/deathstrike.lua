local config = {
	boss = { name = "Deathstrike", position = Position(1378, 948, 15) },
	requiredLevel = 250,
	playerPositions = {
		{ pos = Position(1302, 980, 15), teleport = Position(1370, 938, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1302, 981, 15), teleport = Position(1370, 938, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1302, 982, 15), teleport = Position(1370, 938, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1302, 983, 15), teleport = Position(1370, 938, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1302, 984, 15), teleport = Position(1370, 938, 15), effect = CONST_ME_TELEPORT },
	},
	specPos = {
		from = Position(1356, 923, 15),
		to = Position(1402, 967, 15),
	},
	exit = Position(1302, 985, 15),
}

local lever = BossLever(config)
lever:position(Position(1302, 979, 15))
lever:register()
