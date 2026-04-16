local config = {
	boss = {
		name = "Foreshock",
		position = Position(968, 922, 15),
	},
	playerPositions = {
		{ pos = Position(942, 918, 15), teleport = Position(962, 922, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(942, 919, 15), teleport = Position(962, 922, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(942, 920, 15), teleport = Position(962, 922, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(942, 921, 15), teleport = Position(962, 922, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(942, 922, 15), teleport = Position(962, 922, 15), effect = CONST_ME_TELEPORT },
	},
	specPos = {
		from = Position(956, 910, 15),
		to = Position(980, 933, 15),
	},
	monsters = {
		{ name = "Spark of Destruction", pos = Position(970, 919, 15) },
		{ name = "Spark of Destruction", pos = Position(965, 919, 15) },
		{ name = "Spark of Destruction", pos = Position(971, 924, 15) },
		{ name = "Spark of Destruction", pos = Position(966, 925, 15) },
	},
	onUseExtra = function()
		Game.setStorageValue(GlobalStorage.HeartOfDestruction.ForeshockHealth, 105000)
		Game.setStorageValue(GlobalStorage.HeartOfDestruction.AftershockHealth, 105000)
		Game.setStorageValue(GlobalStorage.HeartOfDestruction.ForeshockStage, -1)
		Game.setStorageValue(GlobalStorage.HeartOfDestruction.AftershockStage, -1)
	end,
	exit = Position(942, 924, 15),
}

local lever = BossLever(config)
lever:aid(14329)
lever:register()
