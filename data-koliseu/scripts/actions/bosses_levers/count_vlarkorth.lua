local config = {
	boss = {
		name = "Count Vlarkorth",
		position = Position(1812, 839, 15),
	},
	requiredLevel = 250,
	playerPositions = {
		{ pos = Position(1811, 821, 15), teleport = Position(1812, 852, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1812, 821, 15), teleport = Position(1812, 852, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1813, 821, 15), teleport = Position(1812, 852, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1814, 821, 15), teleport = Position(1812, 852, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1815, 821, 15), teleport = Position(1812, 852, 15), effect = CONST_ME_TELEPORT },
	},
	specPos = {
		from = Position(1801, 835, 15),
		to = Position(1822, 856, 15),
	},
	exit = Position(1812, 819, 15),
}

local lever = BossLever(config)
lever:position(Position(1810, 821, 15))
lever:register()
