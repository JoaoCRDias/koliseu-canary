local config = {
	boss = {
		name = "Earl Osam",
		position = Position(1844, 846, 15),
	},
	requiredLevel = 250,
	playerPositions = {
		{ pos = Position(1872, 852, 15), teleport = Position(1844, 841, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1873, 852, 15), teleport = Position(1844, 841, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1874, 852, 15), teleport = Position(1844, 841, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1875, 852, 15), teleport = Position(1844, 841, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1876, 852, 15), teleport = Position(1844, 841, 15), effect = CONST_ME_TELEPORT },
	},
	specPos = {
		from = Position(1833, 835, 15),
		to = Position(1856, 857, 15),
	},
	exit = Position(1874, 849, 15),
}

local lever = BossLever(config)
lever:position(Position(1871, 852, 15))
lever:register()
