-- Siege Defender Boss Lever
-- Allows players to fight the Siege Defender to increase their hazard level

local config = {
	boss = {
		name = "Siege Defender",
		position = Position(860, 742, 7), -- PLACEHOLDER: Boss spawn position
	},
	playerPositions = {
		-- PLACEHOLDER: Lever standing positions → teleport destinations
		{ pos = Position(880, 743, 7), teleport = Position(860, 751, 7), effect = CONST_ME_TELEPORT },
		{ pos = Position(880, 744, 7), teleport = Position(860, 751, 7), effect = CONST_ME_TELEPORT },
		{ pos = Position(880, 745, 7), teleport = Position(860, 751, 7), effect = CONST_ME_TELEPORT },
		{ pos = Position(880, 746, 7), teleport = Position(860, 751, 7), effect = CONST_ME_TELEPORT },
		{ pos = Position(880, 747, 7), teleport = Position(860, 751, 7), effect = CONST_ME_TELEPORT },
	},
	specPos = {
		-- PLACEHOLDER: Boss room boundaries
		from = Position(851, 736, 7),
		to = Position(869, 755, 7),
	},
	exit = Position(880, 749, 7), -- PLACEHOLDER: Exit position (usually temple)
}

local lever = BossLever(config)
lever:position(Position(880, 742, 7)) -- PLACEHOLDER: Lever position
lever:register()
