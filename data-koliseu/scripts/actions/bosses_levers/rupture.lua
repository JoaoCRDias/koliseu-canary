local config = {
	boss = {
		name = "Rupture",
		position = Position(1025, 997, 15),
	},
	playerPositions = {
		{ pos = Position(1000, 993, 15), teleport = Position(1019, 995, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1000, 994, 15), teleport = Position(1019, 995, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1000, 995, 15), teleport = Position(1019, 995, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1000, 996, 15), teleport = Position(1019, 995, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(1000, 997, 15), teleport = Position(1019, 995, 15), effect = CONST_ME_TELEPORT },
	},
	specPos = {
		from = Position(1016, 985, 15),
		to = Position(1037, 1006, 15),
	},
	monsters = {
		{ name = "Spark of Destruction", pos = Position(1022, 993, 15) },
		{ name = "Spark of Destruction", pos = Position(1021, 999, 15) },
		{ name = "Spark of Destruction", pos = Position(1030, 999, 15) },
		{ name = "Spark of Destruction", pos = Position(1030, 994, 15) },
	},
	onUseExtra = function()
		Game.setStorageValue(GlobalStorage.HeartOfDestruction.RuptureResonanceStage, -1)
		Game.setStorageValue(GlobalStorage.HeartOfDestruction.RuptureResonanceActive, -1)

		local tile = Tile(Position(1017, 995, 15))
		if tile then
			local vortex = tile:getItemById(23482)
			if vortex then
				vortex:transform(23483)
				vortex:setActionId(14343)
			end
		end
	end,
	exit = Position(1000, 999, 15),
}

local lever = BossLever(config)
lever:aid(14327)
lever:register()
