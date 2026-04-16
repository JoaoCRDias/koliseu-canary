local config = {
	boss = {
		name = "The Last Lore Keeper",
		position = Position(1469, 1031, 15),
	},
	requiredLevel = 250,
	playerPositions = {
		{ pos = Position(1472, 1069, 15), teleport = Position(1470, 1044, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1472, 1070, 15), teleport = Position(1470, 1044, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1472, 1071, 15), teleport = Position(1470, 1044, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1472, 1072, 15), teleport = Position(1470, 1044, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1472, 1073, 15), teleport = Position(1470, 1044, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1471, 1069, 15), teleport = Position(1470, 1044, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1471, 1070, 15), teleport = Position(1470, 1044, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1471, 1071, 15), teleport = Position(1470, 1044, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1471, 1072, 15), teleport = Position(1470, 1044, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1471, 1073, 15), teleport = Position(1470, 1044, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1473, 1069, 15), teleport = Position(1470, 1044, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1473, 1070, 15), teleport = Position(1470, 1044, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1473, 1071, 15), teleport = Position(1470, 1044, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1473, 1072, 15), teleport = Position(1470, 1044, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1473, 1073, 15), teleport = Position(1470, 1044, 15), effect = CONST_ME_TELEPORT },
	},
	specPos = {
		from = Position(1458, 1026, 15),
		to = Position(1482, 1050, 15),
	},
	exit = Position(1472, 1075, 15),
}

local lever = BossLever(config)
lever:position(Position(1472, 1068, 15))
lever:register()
