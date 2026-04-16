local config = {
	boss = {
		name = "Grand Master Oberon",
		position = Position(1643, 1291, 15),
	},
	playerPositions = {
		{ pos = Position(1643, 1317, 15), teleport = Position(1643, 1296, 15) },
		{ pos = Position(1641, 1317, 15), teleport = Position(1643, 1296, 15) },
		{ pos = Position(1642, 1317, 15), teleport = Position(1643, 1296, 15) },
		{ pos = Position(1644, 1317, 15), teleport = Position(1643, 1296, 15) },
		{ pos = Position(1645, 1317, 15), teleport = Position(1643, 1296, 15) },
	},
	specPos = {
		from = Position(1634, 1283, 15),
		to = Position(1653, 1299, 15),
	},
	exit = Position(1643, 1315, 15),
}

local leverOberon = BossLever(config)
leverOberon:aid(57605)
leverOberon:register()
