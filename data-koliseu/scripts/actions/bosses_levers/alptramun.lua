local config = {
	boss = {
		name = "Alptramun",
		position = Position(1399, 1531, 15),
	},
	playerPositions = {
		{ pos = Position(1363, 1533, 15), teleport = Position(1399, 1541, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1363, 1534, 15), teleport = Position(1399, 1541, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1363, 1535, 15), teleport = Position(1399, 1541, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1363, 1536, 15), teleport = Position(1399, 1541, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1363, 1537, 15), teleport = Position(1399, 1541, 15), effect = CONST_ME_TELEPORT },
	},
	specPos = {
		from = Position(1390, 1525, 15),
		to = Position(1410, 1545, 15),
	},
	exit = Position(1363, 1538, 15),
}

local lever = BossLever(config)
lever:position(Position(1363, 1532, 15))
lever:register()
