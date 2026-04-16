local config = {
	boss = {
		name = "Ferumbras Mortal Shell",
		position = Position(1709, 1143, 15),
	},
	timeToFightAgain = 60 * 60 * 24 * 7,
	playerPositions = {
		{ pos = Position(1711, 1178, 15), teleport = Position(1709, 1153, 15) },
		{ pos = Position(1711, 1179, 15), teleport = Position(1709, 1153, 15) },
		{ pos = Position(1711, 1180, 15), teleport = Position(1709, 1153, 15) },
		{ pos = Position(1711, 1181, 15), teleport = Position(1709, 1153, 15) },
		{ pos = Position(1711, 1182, 15), teleport = Position(1709, 1153, 15) },
		{ pos = Position(1710, 1178, 15), teleport = Position(1709, 1153, 15) },
		{ pos = Position(1710, 1179, 15), teleport = Position(1709, 1153, 15) },
		{ pos = Position(1710, 1180, 15), teleport = Position(1709, 1153, 15) },
		{ pos = Position(1710, 1181, 15), teleport = Position(1709, 1153, 15) },
		{ pos = Position(1710, 1182, 15), teleport = Position(1709, 1153, 15) },
		{ pos = Position(1712, 1178, 15), teleport = Position(1709, 1153, 15) },
		{ pos = Position(1712, 1179, 15), teleport = Position(1709, 1153, 15) },
		{ pos = Position(1712, 1180, 15), teleport = Position(1709, 1153, 15) },
		{ pos = Position(1712, 1181, 15), teleport = Position(1709, 1153, 15) },
		{ pos = Position(1712, 1182, 15), teleport = Position(1709, 1153, 15) },
	},
	specPos = {
		from = Position(1696, 1130, 15),
		to = Position(1722, 1155, 15),
	},
	exit = Position(1711, 1175, 15),
	monsters = {
		{ name = "rift invader", pos = Position(1707, 1139, 15) },
		{ name = "rift invader", pos = Position(1711, 1139, 15) },
		{ name = "rift invader", pos = Position(1713, 1141, 15) },
		{ name = "rift invader", pos = Position(1713, 1145, 15) },
		{ name = "rift invader", pos = Position(1711, 1147, 15) },
		{ name = "rift invader", pos = Position(1707, 1147, 15) },
		{ name = "rift invader", pos = Position(1705, 1145, 15) },
		{ name = "rift invader", pos = Position(1705, 1141, 15) },
		{ name = "rift invader", pos = Position(1707, 1143, 15) },
		{ name = "rift invader", pos = Position(1711, 1143, 15) },
	},
}

local leverFerumbras = BossLever(config)
leverFerumbras:position(Position(1711, 1177, 15))
leverFerumbras:register()
