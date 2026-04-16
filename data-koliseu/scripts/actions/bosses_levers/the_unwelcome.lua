local config = {
	boss = {
		name = "The Unwelcome",
		position = Position(1127, 1589, 15),
	},
	requiredLevel = 250,
	playerPositions = {
		{ pos = Position(1155, 1590, 15), teleport = Position(1127, 1597, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1156, 1590, 15), teleport = Position(1127, 1597, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1157, 1590, 15), teleport = Position(1127, 1597, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1158, 1590, 15), teleport = Position(1127, 1597, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1159, 1590, 15), teleport = Position(1127, 1597, 15), effect = CONST_ME_TELEPORT },
	},
	specPos = {
		from = Position(1114, 1581, 15),
		to = Position(1140, 1602, 15),
	},
	exit = Position(1161, 1590, 15),
}

local lever = BossLever(config)
lever:position(Position(1154, 1590, 15))
lever:register()
