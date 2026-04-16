local config = {
	boss = {
		name = "Brokul",
		position = Position(1036, 1033, 15),
	},
	requiredLevel = 250,
	playerPositions = {
		{ pos = Position(1042, 1067, 15), teleport = Position(1035, 1039, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1040, 1067, 15), teleport = Position(1035, 1039, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1041, 1067, 15), teleport = Position(1035, 1039, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1043, 1067, 15), teleport = Position(1035, 1039, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1044, 1067, 15), teleport = Position(1035, 1039, 15), effect = CONST_ME_TELEPORT },
	},
	specPos = {
		from = Position(1023, 1023, 15),
		to = Position(1049, 1044, 15),
	},
	exit = Position(1042, 1069, 15),
}

local lever = BossLever(config)
lever:position(Position(1042, 1066, 15))
lever:register()
