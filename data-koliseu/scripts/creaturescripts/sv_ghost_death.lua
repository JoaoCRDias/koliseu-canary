-- Fires when one of the four terrace ghosts (Umbra, Morvai, Shael, Necros)
-- is killed. Advances the terrace progress; on the fourth kill the stage
-- completes and players are teleported out.

local event = CreatureEvent("SvGhostDeath")

function event.onDeath(creature)
	local activeId = SupremeVocation.deathTerraceActiveGhostId()
	if not activeId or activeId ~= creature:getId() then
		return true
	end
	SupremeVocation.deathTerraceAdvance()
	return true
end

event:register()
