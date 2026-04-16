local config = {
	boss = {
		name = "Ichgahal",
		position = Position(1642, 833, 15),
	},
	requiredLevel = 250,
	playerPositions = {
		{ pos = Position(1612, 837, 15), teleport = Position(1642, 844, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1611, 837, 15), teleport = Position(1642, 844, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1610, 837, 15), teleport = Position(1642, 844, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1609, 837, 15), teleport = Position(1642, 844, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1608, 837, 15), teleport = Position(1642, 844, 15), effect = CONST_ME_TELEPORT },
	},
	specPos = {
		from = Position(1632, 829, 15),
		to = Position(1652, 848, 15),
	},
	exit = Position(1607, 837, 15),
}

local lever = BossLever(config)
lever:position(Position(1613, 837, 15))
lever:register()
