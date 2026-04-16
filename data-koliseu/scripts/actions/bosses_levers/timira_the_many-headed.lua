local config = {
	boss = { name = "Timira the Many-Headed", position = Position(914, 1429, 15) },
	requiredLevel = 250,
	playerPositions = {
		{ pos = Position(943, 1432, 15), teleport = Position(914, 1434, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(942, 1432, 15), teleport = Position(914, 1434, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(941, 1432, 15), teleport = Position(914, 1434, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(940, 1432, 15), teleport = Position(914, 1434, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(939, 1432, 15), teleport = Position(914, 1434, 15), effect = CONST_ME_TELEPORT },
	},
	specPos = {
		from = Position(903, 1421, 15),
		to = Position(924, 1439, 15),
	},
	exit = Position(937, 1432, 15),
}

local lever = BossLever(config)
lever:position(Position(944, 1432, 15))
lever:register()
