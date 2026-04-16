local config = {
	boss = {
		name = "Soul of Dragonking Zyrtarch",
		position = Position(1220, 1029, 15),
	},
	requiredLevel = 250,
	playerPositions = {
		{ pos = Position(1222, 1061, 15), teleport = Position(1220, 1042, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1222, 1062, 15), teleport = Position(1220, 1042, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1222, 1063, 15), teleport = Position(1220, 1042, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1222, 1064, 15), teleport = Position(1220, 1042, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1222, 1065, 15), teleport = Position(1220, 1042, 15), effect = CONST_ME_TELEPORT },
	},
	specPos = {
		from = Position(1208, 1024, 15),
		to = Position(1231, 1046, 15),
	},
	exit = Position(1222, 1067, 15),
}

local lever = BossLever(config)
lever:position(Position(1222, 1060, 15))
lever:register()
