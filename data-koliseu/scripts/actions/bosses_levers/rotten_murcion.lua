local config = {
	boss = {
		name = "Murcion",
		position = Position(1643, 866, 15),
	},
	requiredLevel = 250,
	playerPositions = {
		{ pos = Position(1612, 869, 15), teleport = Position(1643, 876, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1611, 869, 15), teleport = Position(1643, 876, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1610, 869, 15), teleport = Position(1643, 876, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1609, 869, 15), teleport = Position(1643, 876, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1608, 869, 15), teleport = Position(1643, 876, 15), effect = CONST_ME_TELEPORT },
	},
	specPos = {
		from = Position(1633, 861, 15),
		to = Position(1653, 881, 15),
	},
	exit = Position(1607, 869, 15),
}

local lever = BossLever(config)
lever:position(Position(1613, 869, 15))
lever:register()
