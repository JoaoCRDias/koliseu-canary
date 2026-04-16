-- Dungeon Monster Death Event
-- Registered on every monster spawned by DungeonSolo.spawnStage().
-- Uses storage MONSTER_VOC_STORAGE (54010) to identify which instance to notify.

local MONSTER_VOC_STORAGE = 54010

local dungeonMonsterDeath = CreatureEvent("DungeonMonsterDeath")

function dungeonMonsterDeath.onDeath(creature)
	if not creature or not creature:isMonster() then
		return true
	end

	local vocationId = creature:getStorageValue(MONSTER_VOC_STORAGE)
	if vocationId <= 0 then
		return true
	end

	if DungeonSolo and DungeonSolo.onMonsterDeath then
		DungeonSolo.onMonsterDeath(vocationId)
	end

	return true
end

dungeonMonsterDeath:register()
