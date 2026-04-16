local config = {
	boss = {
		name = "King Zelos",
		position = Position(1860, 885, 15),
	},
	requiredLevel = 250,
	playerPositions = {
		{ pos = Position(1891, 890, 15), teleport = Position(1860, 896, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1891, 891, 15), teleport = Position(1860, 896, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1891, 892, 15), teleport = Position(1860, 896, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1891, 893, 15), teleport = Position(1860, 896, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1891, 894, 15), teleport = Position(1860, 896, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1892, 890, 15), teleport = Position(1860, 896, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1892, 891, 15), teleport = Position(1860, 896, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1892, 892, 15), teleport = Position(1860, 896, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1892, 893, 15), teleport = Position(1860, 896, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1892, 894, 15), teleport = Position(1860, 896, 15), effect = CONST_ME_TELEPORT },
	},
	specPos = {
		from = Position(1845, 878, 15),
		to = Position(1875, 902, 15),
	},
	exit = Position(1896, 892, 15),
}

local lever = BossLever(config)
lever:position(Position(1890, 892, 15))
lever:register()
