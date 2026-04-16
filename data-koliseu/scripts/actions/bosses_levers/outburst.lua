local config = {
	boss = {
		name = "Outburst",
		position = Position(961, 957, 15),
	},
	playerPositions = {
		{ pos = Position(934, 957, 15), teleport = Position(954, 958, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(934, 958, 15), teleport = Position(954, 958, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(934, 959, 15), teleport = Position(954, 958, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(934, 960, 15), teleport = Position(954, 958, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(934, 961, 15), teleport = Position(954, 958, 15), effect = CONST_ME_TELEPORT },
	},
	specPos = {
		from = Position(950, 947, 15),
		to = Position(973, 969, 15),
	},
	monsters = {
		{ name = "Spark of Destruction", pos = Position(963, 956, 15) },
		{ name = "Spark of Destruction", pos = Position(957, 955, 15) },
		{ name = "Spark of Destruction", pos = Position(965, 961, 15) },
		{ name = "Spark of Destruction", pos = Position(958, 961, 15) },
	},
	onUseExtra = function()
		Game.setStorageValue(GlobalStorage.HeartOfDestruction.OutburstStage, 0)
		Game.setStorageValue(GlobalStorage.HeartOfDestruction.OutburstHealth, 290000)

		local tile = Tile(Position(952, 958, 15))
		if tile then
			local vortex = tile:getItemById(23482)
			if vortex then
				vortex:transform(23483)
				vortex:setActionId(14350)
			end
		end
	end,
	exit = Position(934, 963, 15),
}

local lever = BossLever(config)
lever:aid(14331)
lever:register()
