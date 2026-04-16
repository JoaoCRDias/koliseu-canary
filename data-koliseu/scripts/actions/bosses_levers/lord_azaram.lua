local config = {
	boss = {
		name = "Lord Azaram",
		position = Position(1780, 887, 15),
	},
	requiredLevel = 250,
	playerPositions = {
		{ pos = Position(1778, 901, 15), teleport = Position(1780, 875, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1779, 901, 15), teleport = Position(1780, 875, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1780, 901, 15), teleport = Position(1780, 875, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1781, 901, 15), teleport = Position(1780, 875, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1782, 901, 15), teleport = Position(1780, 875, 15), effect = CONST_ME_TELEPORT },
	},
	specPos = {
		from = Position(1769, 868, 15),
		to = Position(1791, 891, 15),
	},
	exit = Position(1812, 904, 15),
}

local lever = BossLever(config)
lever:position(Position(1777, 901, 15))
lever:register()
