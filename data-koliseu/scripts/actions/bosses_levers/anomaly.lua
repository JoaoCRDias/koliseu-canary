local config = {
	boss = {
		name = "Anomaly",
		position = Position(1032, 918, 15),
	},
	playerPositions = {
		{ pos = Position(1005, 914, 15), teleport = Position(1024, 919, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1005, 915, 15), teleport = Position(1024, 919, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1005, 916, 15), teleport = Position(1024, 919, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1005, 917, 15), teleport = Position(1024, 919, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1005, 918, 15), teleport = Position(1024, 919, 15), effect = CONST_ME_TELEPORT },
	},
	specPos = {
		from = Position(1019, 907, 15),
		to = Position(1043, 930, 15),
	},
	monsters = {
		{ name = "Spark of Destruction", pos = Position(1034, 915, 15) },
		{ name = "Spark of Destruction", pos = Position(1035, 922, 15) },
		{ name = "Spark of Destruction", pos = Position(1029, 922, 15) },
		{ name = "Spark of Destruction", pos = Position(1029, 915, 15) },
	},
	onUseExtra = function()
		Game.setStorageValue(GlobalStorage.HeartOfDestruction.ChargedAnomaly, 0)
		local tile = Tile(Position(1021, 919, 15))
		if tile then
			local vortex = tile:getItemById(23482)
			if vortex then
				vortex:transform(23483)
				vortex:setActionId(14324)
			end
		end
	end,
	exit = Position(1005, 920, 15),
}

local lever = BossLever(config)
lever:aid(14325)
lever:register()
