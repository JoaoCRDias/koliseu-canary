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
	local playerGuid = player:getGuid()
	-- Delay: let death animation play, then teleport + cleanup.
	-- The Player userdata captured here becomes stale once the engine finishes
	-- the death flow (removeCreature + respawn at temple), so resolve by GUID
	-- inside the event instead of passing `player` directly.
	addEvent(function(guid, voc)
		DungeonSolo.fail(voc, "death", guid)
	end, 1000, playerGuid, vocationId)

	return true
end

dungeonPlayerDeath:register()
