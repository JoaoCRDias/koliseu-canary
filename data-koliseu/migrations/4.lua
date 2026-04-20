function onUpdateDatabase()
	logger.info("Updating database to version 4 (loyalty: tag legacy coin-transfer rows with mode=3)")

	-- Historically, coin transfers between players were logged in `store_history`
	-- with mode = 0 (HISTORY_TYPE_NONE), identical to store purchases. Loyalty
	-- points derive from SUM(ABS(coin_amount)) WHERE coin_amount < 0, so any
	-- pair of mutually-funded accounts could loop coins back and forth to
	-- inflate loyalty. The engine now excludes mode = 3 (HISTORY_TYPE_TRANSFER)
	-- from the loyalty query, and GameStore.parseTransferCoins writes new rows
	-- with mode = 3. This migration backfills legacy rows so the exclusion is
	-- also retroactive.
	db.query([[
		UPDATE `store_history`
		SET `mode` = 3
		WHERE `mode` = 0
		AND (`description` LIKE '%transferred%' OR `description` LIKE '%transfered%')
	]])

	logger.info("Legacy transfer entries re-tagged. loyalty_points will be recalculated on each player's next login.")

	return true
end
