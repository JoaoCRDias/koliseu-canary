local nictrosPosition = Position(1783, 839, 15)
local baelocPosition = Position(1777, 839, 15)

local config = {
	boss = {
		name = "Sir Nictros",
		createFunction = function()
			local nictros = Game.createMonster("Sir Nictros", nictrosPosition, true, true)
			local baeloc = Game.createMonster("Sir Baeloc", baelocPosition, true, true)
			return nictros and baeloc
		end,
	},
	requiredLevel = 250,
	playerPositions = {
		{ pos = Position(1780, 821, 15), teleport = Position(1780, 855, 15) },
		{ pos = Position(1781, 821, 15), teleport = Position(1780, 855, 15) },
		{ pos = Position(1782, 821, 15), teleport = Position(1780, 855, 15) },
		{ pos = Position(1783, 821, 15), teleport = Position(1780, 855, 15) },
		{ pos = Position(1784, 821, 15), teleport = Position(1780, 855, 15) },
	},
	specPos = {
		from = Position(1768, 833, 15),
		to = Position(1792, 860, 15),
	},
	exit = Position(1781, 819, 15),
}

local lever = BossLever(config)
lever:position(Position(1779, 821, 15))
lever:register()
