local config = {
	boss = {
		name = "The Rootkraken",
		position = Position(1027, 1443, 15),
	},
	playerPositions = {
		{ pos = Position(1031, 1495, 15), teleport = Position(1027, 1451, 15) },
		{ pos = Position(1031, 1496, 15), teleport = Position(1027, 1451, 15) },
		{ pos = Position(1031, 1497, 15), teleport = Position(1027, 1451, 15) },
		{ pos = Position(1031, 1498, 15), teleport = Position(1027, 1451, 15) },
		{ pos = Position(1031, 1499, 15), teleport = Position(1027, 1451, 15) },
	},
	specPos = {
		from = Position(1012, 1435, 15),
		to = Position(1042, 1457, 15),
	},
	exit = Position(1031, 1501, 15),
}

local arbazilothLever = BossLever(config)
arbazilothLever:aid(57801)
arbazilothLever:register()
