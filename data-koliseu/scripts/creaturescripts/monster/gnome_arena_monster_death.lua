-- Gnome Arena Monster Death Event
-- Tracks when arena monsters die to trigger next wave if all are cleared

local gnomeArenaMonsterDeath = CreatureEvent("GnomeArenaMonsterDeath")

function gnomeArenaMonsterDeath.onDeath(creature)
	if not creature or not creature:isMonster() then
		return true
	end

	-- Check if this is a gnome arena monster (storage 47002 = 1)
	if creature:getStorageValue(47002) ~= 1 then
		return true
	end

	-- Notify GnomeArena that a monster died
	if GnomeArena and GnomeArena.onMonsterDeath then
		GnomeArena.onMonsterDeath()
	end

	return true
end

gnomeArenaMonsterDeath:register()
