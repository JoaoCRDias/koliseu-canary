-- Dungeon Player Death Event
-- Registered globally. If a player dies inside a dungeon instance, releases the instance.
-- The player dies normally (no prevention) — DungeonSolo.fail() is called with reason "death".

local dungeonPlayerDeath = CreatureEvent("DungeonPlayerDeath")

function dungeonPlayerDeath.onDeath(player, corpse, killer, mostDamageKiller, lastHitUnjustified, mostDamageUnjustified)
	if not player or not player:isPlayer() then
		return true
	end

	if not DungeonSolo then
		return true
	end

	if not DungeonSolo.isPlayerInDungeon(player) then
		return true
	end

	local vocationId = DungeonSolo.getBaseVocation(player)
	-- Delay: let death animation play, then teleport + cleanup
	addEvent(function()
		DungeonSolo.fail(vocationId, "death")
	end, 1000)

	return true
end

dungeonPlayerDeath:register()
