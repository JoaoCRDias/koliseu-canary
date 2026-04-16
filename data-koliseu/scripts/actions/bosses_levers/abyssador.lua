local config = {
	boss = { name = "Abyssador", position = Position(1264, 938, 15) },
	requiredLevel = 250,
	playerPositions = {
		{ pos = Position(1267, 980, 15), teleport = Position(1259, 938, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1267, 981, 15), teleport = Position(1259, 938, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1267, 982, 15), teleport = Position(1259, 938, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1267, 983, 15), teleport = Position(1259, 938, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1267, 984, 15), teleport = Position(1259, 938, 15), effect = CONST_ME_TELEPORT },
	},
	specPos = {
		from = Position(1250, 924, 15),
		to = Position(1278, 951, 15),
	},
	exit = Position(1267, 985, 15),
}

local lever = BossLever(config)
lever:position(Position(1267, 979, 15))
lever:register()
