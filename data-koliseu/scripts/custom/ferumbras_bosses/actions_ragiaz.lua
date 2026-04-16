local config = {
	boss = {
		name = "Ragiaz",
		position = Position(1292, 1121, 15),
	},
	requiredLevel = 250,
	monsters = {
		{ name = "Death Dragon", pos = Position(1288, 1119, 15) },
		{ name = "Death Dragon", pos = Position(1292, 1119, 15) },
		{ name = "Death Dragon", pos = Position(1292, 1123, 15) },
		{ name = "Death Dragon", pos = Position(1288, 1123, 15) },
	},
	playerPositions = {
		{ pos = Position(1291, 1148, 15), teleport = Position(1291, 1131, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1292, 1148, 15), teleport = Position(1291, 1131, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1293, 1148, 15), teleport = Position(1291, 1131, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1294, 1148, 15), teleport = Position(1291, 1131, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1295, 1148, 15), teleport = Position(1291, 1131, 15), effect = CONST_ME_TELEPORT },
	},
	specPos = {
		from = Position(1278, 1110, 15),
		to = Position(1304, 1136, 15),
	},
	exit = Position(1293, 1150, 15),
}

local lever = BossLever(config)
lever:position(Position(1290, 1148, 15))
lever:register()
