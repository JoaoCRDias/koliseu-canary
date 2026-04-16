local config = {
	boss = {
		name = "The Baron From Below",
		position = Position(1134, 942, 15),
	},
	playerPositions = {
		{ pos = Position(1154, 827, 15), teleport = Position(1133, 942, 15) },
		{ pos = Position(1154, 828, 15), teleport = Position(1133, 942, 15) },
		{ pos = Position(1154, 829, 15), teleport = Position(1133, 942, 15) },
		{ pos = Position(1154, 830, 15), teleport = Position(1133, 942, 15) },
		{ pos = Position(1154, 831, 15), teleport = Position(1133, 942, 15) },
	},
	specPos = {
		from = Position(1122, 930, 15),
		to = Position(1147, 954, 15),
	},
	exit = Position(1154, 832, 15),
}

local warzone4Lever = BossLever(config)
warzone4Lever:aid(57804)
warzone4Lever:register()
