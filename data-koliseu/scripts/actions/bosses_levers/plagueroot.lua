local config = {
	boss = {
		name = "Plagueroot",
		position = Position(1483, 1536, 15),
	},
	playerPositions = {
		{ pos = Position(1447, 1538, 15), teleport = Position(1483, 1546, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1447, 1539, 15), teleport = Position(1483, 1546, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1447, 1540, 15), teleport = Position(1483, 1546, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1447, 1541, 15), teleport = Position(1483, 1546, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1447, 1542, 15), teleport = Position(1483, 1546, 15), effect = CONST_ME_TELEPORT },
	},
	specPos = {
		from = Position(1473, 1530, 15),
		to = Position(1493, 1550, 15),
	},
	exit = Position(1447, 1543, 15),
}

local lever = BossLever(config)
lever:position(Position(1447, 1537, 15))
lever:register()
