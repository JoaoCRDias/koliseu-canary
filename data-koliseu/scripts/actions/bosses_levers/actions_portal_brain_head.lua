local config = {
	boss = {
		name = "Brain Head",
		position = Position(1611, 981, 15),
	},
	playerPositions = {
		{ pos = Position(1612, 1014, 15), teleport = Position(1611, 989, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1612, 1015, 15), teleport = Position(1611, 989, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1612, 1016, 15), teleport = Position(1611, 989, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1612, 1017, 15), teleport = Position(1611, 989, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1612, 1018, 15), teleport = Position(1611, 989, 15), effect = CONST_ME_TELEPORT },
	},
	specPos = {
		from = Position(1595, 967, 15),
		to = Position(1628, 994, 15),
	},
	monsters = {
		{ name = "Cerebellum", pos = Position(1612, 982, 15) },
		{ name = "Cerebellum", pos = Position(1612, 980, 15) },
		{ name = "Cerebellum", pos = Position(1610, 980, 15) },
		{ name = "Cerebellum", pos = Position(1610, 982, 15) },
		{ name = "Cerebellum", pos = Position(1616, 977, 15) },
		{ name = "Cerebellum", pos = Position(1604, 977, 15) },
		{ name = "Cerebellum", pos = Position(1604, 987, 15) },
		{ name = "Cerebellum", pos = Position(1617, 985, 15) },
	},
	exit = Position(1612, 1020, 15),
}

local lever = BossLever(config)
lever:position(Position(1612, 1013, 15))
lever:register()
