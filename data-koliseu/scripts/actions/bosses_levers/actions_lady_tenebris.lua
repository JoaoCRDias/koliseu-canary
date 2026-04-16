local config = {
	boss = {
		name = "Lady Tenebris",
		position = Position(1259, 1029, 15),
	},
	requiredLevel = 250,
	monsters = {
		{ name = "shadow tentacle", pos = Position(1256, 1033, 15) },
		{ name = "shadow tentacle", pos = Position(1256, 1035, 15) },
		{ name = "shadow tentacle", pos = Position(1256, 1037, 15) },
		{ name = "shadow tentacle", pos = Position(1262, 1033, 15) },
		{ name = "shadow tentacle", pos = Position(1262, 1035, 15) },
		{ name = "shadow tentacle", pos = Position(1262, 1037, 15) },
	},
	playerPositions = {
		{ pos = Position(1262, 1061, 15), teleport = Position(1259, 1042, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1262, 1062, 15), teleport = Position(1259, 1042, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1262, 1063, 15), teleport = Position(1259, 1042, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1262, 1064, 15), teleport = Position(1259, 1042, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1262, 1065, 15), teleport = Position(1259, 1042, 15), effect = CONST_ME_TELEPORT },
	},
	specPos = {
		from = Position(1248, 1023, 15),
		to = Position(1270, 1046, 15),
	},
	exit = Position(1262, 1067, 15),
}

local lever = BossLever(config)
lever:position(Position(1262, 1060, 15))
lever:register()
