local config = {
	boss = {
		name = "Voroth The Fallen",
		position = Position(229, 992, 11),
	},
	requiredLevel = 500,
	playerPositions = {
		{ pos = Position(587, 730, 9), teleport = Position(229, 998, 11), effect = CONST_ME_TELEPORT },
		{ pos = Position(585, 731, 9), teleport = Position(227, 999, 11), effect = CONST_ME_TELEPORT },
		{ pos = Position(586, 731, 9), teleport = Position(228, 999, 11), effect = CONST_ME_TELEPORT },
		{ pos = Position(587, 731, 9), teleport = Position(229, 999, 11), effect = CONST_ME_TELEPORT },
		{ pos = Position(588, 731, 9), teleport = Position(230, 999, 11), effect = CONST_ME_TELEPORT },
		{ pos = Position(589, 731, 9), teleport = Position(231, 999, 11), effect = CONST_ME_TELEPORT },
		{ pos = Position(585, 732, 9), teleport = Position(227, 1000, 11), effect = CONST_ME_TELEPORT },
		{ pos = Position(586, 732, 9), teleport = Position(228, 1000, 11), effect = CONST_ME_TELEPORT },
		{ pos = Position(587, 732, 9), teleport = Position(229, 1000, 11), effect = CONST_ME_TELEPORT },
		{ pos = Position(588, 732, 9), teleport = Position(230, 1000, 11), effect = CONST_ME_TELEPORT },
		{ pos = Position(589, 732, 9), teleport = Position(231, 1000, 11), effect = CONST_ME_TELEPORT },
		{ pos = Position(585, 733, 9), teleport = Position(227, 1001, 11), effect = CONST_ME_TELEPORT },
		{ pos = Position(586, 733, 9), teleport = Position(228, 1001, 11), effect = CONST_ME_TELEPORT },
		{ pos = Position(587, 733, 9), teleport = Position(229, 1001, 11), effect = CONST_ME_TELEPORT },
		{ pos = Position(588, 733, 9), teleport = Position(230, 1001, 11), effect = CONST_ME_TELEPORT },
		{ pos = Position(589, 733, 9), teleport = Position(231, 1001, 11), effect = CONST_ME_TELEPORT },
		{ pos = Position(585, 734, 9), teleport = Position(227, 1002, 11), effect = CONST_ME_TELEPORT },
		{ pos = Position(586, 734, 9), teleport = Position(228, 1002, 11), effect = CONST_ME_TELEPORT },
		{ pos = Position(587, 734, 9), teleport = Position(229, 1002, 11), effect = CONST_ME_TELEPORT },
		{ pos = Position(588, 734, 9), teleport = Position(230, 1002, 11), effect = CONST_ME_TELEPORT },
		{ pos = Position(589, 734, 9), teleport = Position(231, 1002, 11), effect = CONST_ME_TELEPORT },

	},
	specPos = {
		from = Position(220, 987, 11),
		to = Position(238, 1008, 11),
	},
	exit = Position(587, 735, 9),
}

local lever = BossLever(config)
lever:position(Position(587, 729, 9))
lever:register()
