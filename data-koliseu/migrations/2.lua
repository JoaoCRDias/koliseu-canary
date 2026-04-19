function onUpdateDatabase()
	logger.info("Updating database to version 2 (player_deaths.participants column)")

	-- Add participants column to player_deaths (serialized killer list used by Cyclopedia → Recent Deaths)
	-- Format per entry: "Name: <name>\nType: <player|monster>" joined by blank lines.
	local resultId = db.storeQuery("SHOW COLUMNS FROM `player_deaths` LIKE 'participants'")
	if resultId then
		Result.free(resultId)
		logger.info("Column 'participants' already exists in player_deaths, skipping.")
	else
		db.query("ALTER TABLE `player_deaths` ADD COLUMN `participants` TEXT NOT NULL DEFAULT ''")
	end

	return true
end
