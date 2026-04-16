-- Hazard system for Darkness Warlock area
-- This area covers the spawns of Darkness Warlock epic monsters
-- Located in a separate region from Edron Kingdom

local hazard = Hazard.new({
	name = "hazard.darkness-area",
	from = Position(700, 1075, 7),  -- Covers all Darkness Warlock spawns
	to = Position(760, 1140, 8),
	maxLevel = 30,
	crit = true,
	dodge = true,
	damageBoost = true,
	defenseBoost = true,
})

hazard:register()
