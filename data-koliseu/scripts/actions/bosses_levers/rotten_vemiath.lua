local config = {
	boss = {
		name = "Vemiath",
		position = Position(1677, 836, 15),
	},
	requiredLevel = 250,
	playerPositions = {
		{ pos = Position(1712, 837, 15), teleport = Position(1677, 846, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1711, 837, 15), teleport = Position(1677, 846, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1710, 837, 15), teleport = Position(1677, 846, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1709, 837, 15), teleport = Position(1677, 846, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1708, 837, 15), teleport = Position(1677, 846, 15), effect = CONST_ME_TELEPORT },
	},
	specPos = {
		from = Position(1668, 829, 15),
		to = Position(1688, 850, 15),
	},
	exit = Position(1707, 837, 15),
}

local lever = BossLever(config)
lever:position(Position(1713, 837, 15))
lever:register()
