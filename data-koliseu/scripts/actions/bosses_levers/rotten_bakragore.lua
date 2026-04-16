local config = {
	boss = {
		name = "Bakragore",
		position = Position(1677, 896, 15),
	},
	requiredLevel = 250,
	playerPositions = {
		{ pos = Position(1712, 902, 15), teleport = Position(1678, 910, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1711, 902, 15), teleport = Position(1678, 910, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1710, 902, 15), teleport = Position(1678, 910, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1709, 902, 15), teleport = Position(1678, 910, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1708, 902, 15), teleport = Position(1678, 910, 15), effect = CONST_ME_TELEPORT },
	},
	specPos = {
		from = Position(1666, 891, 15),
		to = Position(1689, 915, 15),
	},
	exit = Position(1707, 902, 15),
}

local lever = BossLever(config)
lever:position(Position(1713, 902, 15))
lever:register()
