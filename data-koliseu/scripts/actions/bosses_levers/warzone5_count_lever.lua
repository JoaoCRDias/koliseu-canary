local config = {
	boss = {
		name = "The Count Of The Core",
		position = Position(1166, 974, 15),
	},
	playerPositions = {
		{ pos = Position(1159, 827, 15), teleport = Position(1165, 974, 15) },
		{ pos = Position(1159, 828, 15), teleport = Position(1165, 974, 15) },
		{ pos = Position(1159, 829, 15), teleport = Position(1165, 974, 15) },
		{ pos = Position(1159, 830, 15), teleport = Position(1165, 974, 15) },
		{ pos = Position(1159, 831, 15), teleport = Position(1165, 974, 15) },
	},
	specPos = {
		from = Position(1151, 963, 15),
		to = Position(1180, 982, 15),
	},
	exit = Position(1159, 832, 15),
}

local warzone5Lever = BossLever(config)
warzone5Lever:aid(57805)
warzone5Lever:register()
