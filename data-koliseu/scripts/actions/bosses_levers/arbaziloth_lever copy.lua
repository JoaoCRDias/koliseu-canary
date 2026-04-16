local config = {
	boss = {
		name = "Arbaziloth",
		position = Position(949, 1066, 15),
	},
	playerPositions = {
		{ pos = Position(950, 1100, 15), teleport = Position(950, 1073, 15) },
		{ pos = Position(950, 1101, 15), teleport = Position(950, 1073, 15) },
		{ pos = Position(950, 1102, 15), teleport = Position(950, 1073, 15) },
		{ pos = Position(950, 1103, 15), teleport = Position(950, 1073, 15) },
		{ pos = Position(950, 1104, 15), teleport = Position(950, 1073, 15) },
	},
	specPos = {
		from = Position(941, 1059, 15),
		to = Position(959, 1079, 15),
	},
	exit = Position(950, 1106, 15),
}

local arbazilothLever = BossLever(config)
arbazilothLever:aid(57800)
arbazilothLever:register()
