local config = {
	boss = {
		name = "Urmahlullu the Weakened",
		position = Position(1588, 1437, 15),
	},
	requiredLevel = 100,
	playerPositions = {
		{ pos = Position(1587, 1420, 15), teleport = Position(1588, 1447, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1588, 1420, 15), teleport = Position(1588, 1447, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1589, 1420, 15), teleport = Position(1588, 1447, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1590, 1420, 15), teleport = Position(1588, 1447, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1591, 1420, 15), teleport = Position(1588, 1447, 15), effect = CONST_ME_TELEPORT },
	},
	specPos = {
		from = Position(1572, 1429, 15),
		to = Position(1602, 1459, 15),
	},
	exit = Position(1589, 1417, 15),
}

local lever = BossLever(config)
lever:uid(9545)
lever:register()
