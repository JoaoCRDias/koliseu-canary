local migration = Migration("20260308120000_weekly_progress_finished")

function migration:onExecute()
	local resultId = db.storeQuery("SELECT COLUMN_NAME FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'player_weekly_tasks' AND COLUMN_NAME = 'weekly_progress_finished' LIMIT 1")
	if resultId ~= false then
		result.free(resultId)
		return
	end
	db.query("ALTER TABLE `player_weekly_tasks` ADD COLUMN `weekly_progress_finished` tinyint NOT NULL DEFAULT 0 AFTER `needs_reward`")
end

migration:register()
