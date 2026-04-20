-- Snapshots player experience at morning server save for the daily powergamers ranking.
-- The website compares current experience vs snapshot to rank daily XP gain.
-- Snapshot resets only once per day (morning SS). The night SS does NOT reset it.

local powergamersSnapshot = GlobalEvent("PowergamersSnapshot")

function powergamersSnapshot.onTime(interval)
	db.asyncQuery("INSERT INTO powergamers_snapshot (player_id, experience, snapshot_time) " ..
		"SELECT id, experience, UNIX_TIMESTAMP() FROM players " ..
		"WHERE group_id IN (1, 2, 3) AND deletion = 0 " ..
		"ON DUPLICATE KEY UPDATE experience = VALUES(experience), snapshot_time = VALUES(snapshot_time)")

	print("[PowergamersSnapshot] Daily experience snapshot saved.")
	return true
end

powergamersSnapshot:time("09:59:00")
powergamersSnapshot:register()
