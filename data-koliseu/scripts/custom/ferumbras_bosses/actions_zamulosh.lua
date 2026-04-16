local config = {
	boss = {
		name = "Zamulosh",
		position = Position(1535, 1132, 15),
	},
	requiredLevel = 250,

	playerPositions = {
		{ pos = Position(1534, 1167, 15), teleport = Position(1535, 1139, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1534, 1168, 15), teleport = Position(1535, 1139, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1534, 1169, 15), teleport = Position(1535, 1139, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1534, 1170, 15), teleport = Position(1535, 1139, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1534, 1171, 15), teleport = Position(1535, 1139, 15), effect = CONST_ME_TELEPORT },
	},
	monsters = {
		{ name = "Zamulosh3", pos = Position(1532, 1130, 15) },
		{ name = "Zamulosh3", pos = Position(1532, 1133, 15) },
		{ name = "Zamulosh3", pos = Position(1532, 1136, 15) },
		{ name = "Zamulosh3", pos = Position(1539, 1136, 15) },
		{ name = "Zamulosh3", pos = Position(1539, 1133, 15) },
		{ name = "Zamulosh3", pos = Position(1539, 1130, 15) },
	},
	specPos = {
		from = Position(1525, 1126, 15),
		to = Position(1544, 1141, 15),
	},
	exit = Position(1534, 1164, 15),
}

local lever = BossLever(config)
lever:position(Position(1534, 1166, 15))
lever:register()
