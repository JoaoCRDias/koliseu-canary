function onUpdateDatabase()
	logger.info("Updating database to version 3 (player_weekly_tasks.weekly_progress_finished column)")

	-- Add weekly_progress_finished to player_weekly_tasks (missing from migration 1, required by IOLoginDataSave)
	local resultId = db.storeQuery("SHOW COLUMNS FROM `player_weekly_tasks` LIKE 'weekly_progress_finished'")
	if resultId then
		Result.free(resultId)
		logger.info("Column 'weekly_progress_finished' already exists in player_weekly_tasks, skipping.")
	else
		db.query("ALTER TABLE `player_weekly_tasks` ADD COLUMN `weekly_progress_finished` tinyint NOT NULL DEFAULT 0")
	end

	return true
end
