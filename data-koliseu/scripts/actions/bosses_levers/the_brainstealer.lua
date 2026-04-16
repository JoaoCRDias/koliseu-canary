local config = {
	boss = {
		name = "The Brainstealer",
		position = Position(1271, 1440, 15),
	},
	requiredLevel = 250,
	playerPositions = {
		{ pos = Position(1306, 1437, 15), teleport = Position(1279, 1440, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1307, 1437, 15), teleport = Position(1279, 1440, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1308, 1437, 15), teleport = Position(1279, 1440, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1309, 1437, 15), teleport = Position(1279, 1440, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1310, 1437, 15), teleport = Position(1279, 1440, 15), effect = CONST_ME_TELEPORT },
	},
	specPos = {
		from = Position(1264, 1430, 15),
		to = Position(1284, 1448, 15),
	},
	exit = Position(1312, 1437, 15),
}

local lever = BossLever(config)
lever:position(Position(1305, 1437, 15))
lever:register()
