local config = {
	boss = {
		name = "Shulgrax",
		position = Position(1650, 1134, 15),
	},
	requiredLevel = 250,

	playerPositions = {
		{ pos = Position(1655, 1168, 15), teleport = Position(1652, 1146, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1655, 1169, 15), teleport = Position(1652, 1146, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1655, 1170, 15), teleport = Position(1652, 1146, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1655, 1171, 15), teleport = Position(1652, 1146, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1655, 1172, 15), teleport = Position(1652, 1146, 15), effect = CONST_ME_TELEPORT },
	},
	specPos = {
		from = Position(1639, 1128, 15),
		to = Position(1663, 1152, 15),
	},
	exit = Position(1655, 1175, 15),
}

local lever = BossLever(config)
lever:position(Position(1655, 1167, 15))
lever:register()
