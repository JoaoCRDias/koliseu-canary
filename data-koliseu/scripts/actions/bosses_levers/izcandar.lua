local config = {
	boss = {
		name = "Izcandar the Banished",
		position = Position(1401, 1565, 15),
	},
	playerPositions = {
		{ pos = Position(1365, 1567, 15), teleport = Position(1401, 1575, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1365, 1568, 15), teleport = Position(1401, 1575, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1365, 1569, 15), teleport = Position(1401, 1575, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1365, 1570, 15), teleport = Position(1401, 1575, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1365, 1571, 15), teleport = Position(1401, 1575, 15), effect = CONST_ME_TELEPORT },
	},
	specPos = {
		from = Position(1392, 1560, 15),
		to = Position(1412, 1579, 15),
	},
	exit = Position(1365, 1572, 15),
}

local lever = BossLever(config)
lever:position(Position(1365, 1566, 15))
lever:register()
