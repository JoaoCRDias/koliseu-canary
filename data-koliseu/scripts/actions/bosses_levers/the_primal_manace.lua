local config = {
	boss = {
		name = "The Primal Menace",
		position = Position(216, 1641, 14),
	},
	requiredLevel = 500,
	timeToFightAgain = 4 * 60 * 60,
	playerPositions = {
		{ pos = Position(204, 1679, 14), teleport = Position(226, 1641, 14) },
		{ pos = Position(205, 1679, 14), teleport = Position(226, 1641, 14) },
		{ pos = Position(206, 1679, 14), teleport = Position(226, 1641, 14) },
		{ pos = Position(207, 1679, 14), teleport = Position(226, 1641, 14) },
		{ pos = Position(208, 1679, 14), teleport = Position(226, 1641, 14) },
	},
	specPos = {
		from = Position(206, 1629, 14),
		to = Position(235, 1653, 14),
	},
	exit = Position(209, 1679, 14),
}

lever = BossLever(config)
lever:position(Position(203, 1679, 14))
lever:register()
