local config = {
	boss = {
		name = "Melting Frozen Horror",
		position = Position(1333, 1033, 15),
	},
	requiredLevel = 250,
	playerPositions = {
		{ pos = Position(1334, 1063, 15), teleport = Position(1333, 1044, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1334, 1064, 15), teleport = Position(1333, 1044, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1334, 1065, 15), teleport = Position(1333, 1044, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1334, 1066, 15), teleport = Position(1333, 1044, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1334, 1067, 15), teleport = Position(1333, 1044, 15), effect = CONST_ME_TELEPORT },
	},
	specPos = {
		from = Position(1321, 1025, 15),
		to = Position(1344, 1048, 15),
	},
	exit = Position(1334, 1069, 15),
}

local lever = BossLever(config)
lever:position(Position(1334, 1062, 15))
lever:register()
