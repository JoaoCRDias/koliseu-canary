local config = {
	boss = {
		name = "Chagorz",
		position = Position(1677, 865, 15),
	},
	requiredLevel = 250,
	playerPositions = {
		{ pos = Position(1712, 871, 15), teleport = Position(1678, 877, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1711, 871, 15), teleport = Position(1678, 877, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1710, 871, 15), teleport = Position(1678, 877, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1709, 871, 15), teleport = Position(1678, 877, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1708, 871, 15), teleport = Position(1678, 877, 15), effect = CONST_ME_TELEPORT },
	},
	specPos = {
		from = Position(1668, 861, 15),
		to = Position(1687, 881, 15),
	},
	exit = Position(1707, 871, 15),
}

local lever = BossLever(config)
lever:position(Position(1713, 871, 15))
lever:register()
