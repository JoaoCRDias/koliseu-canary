local config = {
	boss = {
		name = "Eradicator",
		position = Position(999, 955, 15),
	},
	playerPositions = {
		{ pos = Position(1024, 955, 15), teleport = Position(1005, 955, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1024, 956, 15), teleport = Position(1005, 955, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1024, 957, 15), teleport = Position(1005, 955, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1024, 958, 15), teleport = Position(1005, 955, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1024, 959, 15), teleport = Position(1005, 955, 15), effect = CONST_ME_TELEPORT },
	},
	specPos = {
		from = Position(988, 943, 15),
		to = Position(1012, 966, 15),
	},
	monsters = {
		{ name = "Spark of Destruction", pos = Position(1003, 952, 15) },
		{ name = "Spark of Destruction", pos = Position(997, 951, 15) },
		{ name = "Spark of Destruction", pos = Position(997, 958, 15) },
		{ name = "Spark of Destruction", pos = Position(1004, 958, 15) },
	},
	onUseExtra = function()
		Game.setStorageValue(GlobalStorage.HeartOfDestruction.EradicatorReleaseT, -1)
		Game.setStorageValue(GlobalStorage.HeartOfDestruction.EradicatorWeak, -1)

		eradicatorEvent = addEvent(function()
			Game.setStorageValue(GlobalStorage.HeartOfDestruction.EradicatorReleaseT, 1)
		end, 74000)

		local tile = Tile(Position(1008, 955, 15))
		if tile then
			local vortex = tile:getItemById(23482)
			if vortex then
				vortex:transform(23483)
				vortex:setActionId(14348)
			end
		end
	end,
	exit = Position(1024, 961, 15),
}

local lever = BossLever(config)
lever:aid(14330)
lever:register()
