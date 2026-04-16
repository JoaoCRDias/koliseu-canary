local migration = Migration("20260308120000_weekly_progress_finished")

function migration:onExecute()
	db.query("ALTER TABLE `player_weekly_tasks` ADD COLUMN `weekly_progress_finished` tinyint NOT NULL DEFAULT 0 AFTER `needs_reward`")
end

migration:register()
