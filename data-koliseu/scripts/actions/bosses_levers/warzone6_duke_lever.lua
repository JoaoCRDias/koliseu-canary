local config = {
	boss = {
		name = "The Duke Of The Depths",
		position = Position(1197, 942, 15),
	},
	playerPositions = {
		{ pos = Position(1164, 827, 15), teleport = Position(1198, 942, 15) },
		{ pos = Position(1164, 828, 15), teleport = Position(1198, 942, 15) },
		{ pos = Position(1164, 829, 15), teleport = Position(1198, 942, 15) },
		{ pos = Position(1164, 830, 15), teleport = Position(1198, 942, 15) },
		{ pos = Position(1164, 831, 15), teleport = Position(1198, 942, 15) },
	},
	specPos = {
		from = Position(1185, 930, 15),
		to = Position(1209, 954, 15),
	},
	exit = Position(1164, 832, 15),
}

local warzone6Lever = BossLever(config)
warzone6Lever:aid(57806)
warzone6Lever:register()
