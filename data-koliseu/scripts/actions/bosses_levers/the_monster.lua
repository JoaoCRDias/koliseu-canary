local config = {
	boss = {
		name = "The Monster",
		position = Position(1260, 1614, 15),
	},
	requiredLevel = 250,
	playerPositions = {
		{ pos = Position(1231, 1607, 15), teleport = Position(1250, 1614, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1230, 1607, 15), teleport = Position(1250, 1614, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1229, 1607, 15), teleport = Position(1250, 1614, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1228, 1607, 15), teleport = Position(1250, 1614, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1227, 1607, 15), teleport = Position(1250, 1614, 15), effect = CONST_ME_TELEPORT },
	},
	specPos = {
		from = Position(1248, 1608, 15),
		to = Position(1264, 1620, 15),
	},
	exit = Position(1229, 1610, 15),
}

local lever = BossLever(config)
lever:position(Position(1232, 1607, 15))
lever:register()
