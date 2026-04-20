-- Consolidated koliseu migrations (merged from 1-4 on 2026-04-20).
--
-- schema.sql already ships everything below. This script exists only to
-- upgrade an old database (pre-migration) to the current layout and to
-- clean legacy store_history rows. Every step is idempotent so running it
-- on a fresh database is a no-op.

function onUpdateDatabase()
	logger.info("Updating database to version 1 (consolidated koliseu migrations)")

	-- Task board (Winter Update 2025): bounty tasks + weekly tasks.
	db.query([[
		CREATE TABLE IF NOT EXISTS `player_bounty_tasks` (
			`player_id` int NOT NULL,
			`state` tinyint NOT NULL DEFAULT 0,
			`difficulty` tinyint NOT NULL DEFAULT 0,
			`bounty_points` int NOT NULL DEFAULT 0,
			`reroll_tokens` tinyint NOT NULL DEFAULT 0,
			`free_reroll` bigint NOT NULL DEFAULT 0,
			`active_raceid` int NOT NULL DEFAULT 0,
			`active_kills` int NOT NULL DEFAULT 0,
			`active_required_kills` int NOT NULL DEFAULT 0,
			`active_reward_exp` int NOT NULL DEFAULT 0,
			`active_reward_points` tinyint NOT NULL DEFAULT 0,
			`active_task_grade` tinyint NOT NULL DEFAULT 0,
			`active_task_difficulty` tinyint NOT NULL DEFAULT 0,
			`talisman_damage_level` tinyint NOT NULL DEFAULT 0,
			`talisman_lifeleech_level` tinyint NOT NULL DEFAULT 0,
			`talisman_loot_level` tinyint NOT NULL DEFAULT 0,
			`talisman_bestiary_level` tinyint NOT NULL DEFAULT 0,
			`preferred_lists` BLOB NULL,
			`current_creatures_list` BLOB NULL,
			CONSTRAINT `player_bounty_tasks_pk` PRIMARY KEY (`player_id`),
			CONSTRAINT `player_bounty_tasks_players_fk`
				FOREIGN KEY (`player_id`) REFERENCES `players` (`id`)
				ON DELETE CASCADE
		) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
	]])

	db.query([[
		CREATE TABLE IF NOT EXISTS `player_weekly_tasks` (
			`player_id` int NOT NULL,
			`has_expansion` BOOLEAN NOT NULL DEFAULT FALSE,
			`difficulty` tinyint NOT NULL DEFAULT 0,
			`any_creature_total_kills` int NOT NULL DEFAULT 0,
			`any_creature_current_kills` int NOT NULL DEFAULT 0,
			`completed_kill_tasks` tinyint NOT NULL DEFAULT 0,
			`completed_delivery_tasks` tinyint NOT NULL DEFAULT 0,
			`kill_task_reward_exp` int NOT NULL DEFAULT 0,
			`delivery_task_reward_exp` int NOT NULL DEFAULT 0,
			`reward_hunting_points` int NOT NULL DEFAULT 0,
			`reward_soulseals` int NOT NULL DEFAULT 0,
			`soulseals_points` int NOT NULL DEFAULT 0,
			`needs_reward` tinyint NOT NULL DEFAULT 0,
			`weekly_progress_finished` tinyint NOT NULL DEFAULT 0,
			`kill_tasks` BLOB NULL,
			`delivery_tasks` BLOB NULL,
			CONSTRAINT `player_weekly_tasks_pk` PRIMARY KEY (`player_id`),
			CONSTRAINT `player_weekly_tasks_players_fk`
				FOREIGN KEY (`player_id`) REFERENCES `players` (`id`)
				ON DELETE CASCADE
		) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
	]])

	-- If player_weekly_tasks already existed from a pre-migration-3 version of the
	-- schema, it may be missing weekly_progress_finished.
	local weeklyProgress = db.storeQuery("SHOW COLUMNS FROM `player_weekly_tasks` LIKE 'weekly_progress_finished'")
	if weeklyProgress then
		Result.free(weeklyProgress)
	else
		db.query("ALTER TABLE `player_weekly_tasks` ADD COLUMN `weekly_progress_finished` tinyint NOT NULL DEFAULT 0")
	end

	-- player_deaths.participants (serialized killer list used by Cyclopedia → Recent Deaths).
	-- Format per entry: "Name: <name>\nType: <player|monster>" joined by blank lines.
	local participants = db.storeQuery("SHOW COLUMNS FROM `player_deaths` LIKE 'participants'")
	if participants then
		Result.free(participants)
	else
		db.query("ALTER TABLE `player_deaths` ADD COLUMN `participants` TEXT NOT NULL DEFAULT ''")
	end

	-- Loyalty exploit mitigation: legacy coin transfers were logged with mode = 0
	-- (HISTORY_TYPE_NONE), identical to store purchases. Loyalty points derive from
	-- SUM(ABS(coin_amount)) WHERE coin_amount < 0, so mutually-funded accounts could
	-- loop coins to inflate loyalty. The engine now excludes mode = 3
	-- (HISTORY_TYPE_TRANSFER) from the loyalty query and GameStore.parseTransferCoins
	-- writes new rows with mode = 3. This retro-tags legacy rows; on a fresh install
	-- the table is empty and the UPDATE is a no-op.
	db.query([[
		UPDATE `store_history`
		SET `mode` = 3
		WHERE `mode` = 0
		AND (`description` LIKE '%transferred%' OR `description` LIKE '%transfered%')
	]])

	return true
end
