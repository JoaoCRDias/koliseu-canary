local config = {
	boss = {
		name = "World Devourer",
		position = Position(943, 991, 15),
	},
	playerPositions = {
		{ pos = Position(907, 995, 15), teleport = Position(955, 999, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(907, 996, 15), teleport = Position(955, 999, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(907, 997, 15), teleport = Position(955, 999, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(907, 998, 15), teleport = Position(955, 999, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(907, 999, 15), teleport = Position(955, 999, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(908, 995, 15), teleport = Position(955, 999, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(908, 996, 15), teleport = Position(955, 999, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(908, 997, 15), teleport = Position(955, 999, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(908, 998, 15), teleport = Position(955, 999, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(908, 999, 15), teleport = Position(955, 999, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(909, 995, 15), teleport = Position(955, 999, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(909, 996, 15), teleport = Position(955, 999, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(909, 997, 15), teleport = Position(955, 999, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(909, 998, 15), teleport = Position(955, 999, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(909, 999, 15), teleport = Position(955, 999, 15), effect = CONST_ME_TELEPORT },
	},
	specPos = {
		from = Position(928, 982, 15),
		to = Position(961, 1015, 15),
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
lever:aid(14332)
lever:register()
