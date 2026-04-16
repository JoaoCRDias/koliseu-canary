local config = {
	boss = { name = "Magma Bubble", position = Position(1134, 1377, 15) },
	requiredLevel = 250,
	playerPositions = {
		{ pos = Position(1148, 1395, 15), teleport = Position(1136, 1387, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1148, 1396, 15), teleport = Position(1136, 1387, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1148, 1397, 15), teleport = Position(1136, 1387, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1148, 1398, 15), teleport = Position(1136, 1387, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1148, 1399, 15), teleport = Position(1136, 1387, 15), effect = CONST_ME_TELEPORT },
	},
	specPos = {
		from = Position(1115, 1362, 15),
		to = Position(1143, 1390, 15),
	},
	exit = Position(1148, 1400, 15),
}

local lever = BossLever(config)
lever:position(Position(1148, 1394, 15))
lever:register()
