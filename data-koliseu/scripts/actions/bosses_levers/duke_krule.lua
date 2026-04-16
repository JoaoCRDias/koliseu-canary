local config = {
	boss = {
		name = "Duke Krule",
		position = Position(1812, 886, 15),
	},
	requiredLevel = 250,
	playerPositions = {
		{ pos = Position(1811, 901, 15), teleport = Position(1812, 875, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1812, 901, 15), teleport = Position(1812, 875, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1813, 901, 15), teleport = Position(1812, 875, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1814, 901, 15), teleport = Position(1812, 875, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1815, 901, 15), teleport = Position(1812, 875, 15), effect = CONST_ME_TELEPORT },
	},
	specPos = {
		from = Position(1800, 869, 15),
		to = Position(1825, 891, 15),
	},
	exit = Position(1812, 904, 15),
}

local lever = BossLever(config)
lever:position(Position(1810, 901, 15))
lever:register()
