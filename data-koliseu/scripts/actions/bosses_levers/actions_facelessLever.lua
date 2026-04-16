local config = {
	boss = {
		name = "Faceless Bane",
		position = Position(1902, 965, 15),
	},
	requiredLevel = 250,
	timeToDefeat = 15 * 60,
	playerPositions = {
		{ pos = Position(1923, 961, 15), teleport = Position(1902, 966, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1924, 961, 15), teleport = Position(1902, 966, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1925, 961, 15), teleport = Position(1902, 966, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1926, 961, 15), teleport = Position(1902, 966, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1927, 961, 15), teleport = Position(1902, 966, 15), effect = CONST_ME_TELEPORT },
	},
	specPos = {
		from = Position(1894, 954, 15),
		to = Position(1911, 968, 15),
	},
	exit = Position(1925, 960, 15),
}

local lever = BossLever(config)
lever:uid(1039)
lever:register()
