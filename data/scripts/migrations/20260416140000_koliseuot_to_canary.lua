-- Aligns a koliseuot DB to what the koliseu-canary engine expects.
-- Most of the koliseuot schema is already compatible; only the differences
-- that the C++ engine relies on are handled here.
-- Idempotent — guarded by information_schema checks and safe defaults.

local migration = Migration("20260416140000_koliseuot_to_canary")

local function columnExists(tableName, columnName)
	local resultId = db.storeQuery(string.format(
		"SELECT COLUMN_NAME FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = %s AND COLUMN_NAME = %s LIMIT 1",
		db.escapeString(tableName),
		db.escapeString(columnName)
	))
	if resultId ~= false then
		result.free(resultId)
		return true
	end
	return false
end

function migration:onExecute()
	--
	-- player_charms column types: engine reads these as uint16_t; narrow to
	-- SMALLINT to match. Skip narrowing if any row would overflow.
	--
	local resultId = db.storeQuery([[
		SELECT COUNT(*) AS n FROM `player_charms`
		WHERE `charm_points` > 32767 OR `minor_charm_echoes` > 32767
			OR `max_charm_points` > 32767 OR `max_minor_charm_echoes` > 32767
	]])
	if resultId ~= false then
		local overflow = result.getNumber(resultId, "n") or 0
		result.free(resultId)
		if overflow == 0 then
			db.query("ALTER TABLE `player_charms` MODIFY `charm_points` SMALLINT DEFAULT 0")
			db.query("ALTER TABLE `player_charms` MODIFY `minor_charm_echoes` SMALLINT DEFAULT 0")
			db.query("ALTER TABLE `player_charms` MODIFY `max_charm_points` SMALLINT DEFAULT 0")
			db.query("ALTER TABLE `player_charms` MODIFY `max_minor_charm_echoes` SMALLINT DEFAULT 0")
		else
			logger.warn("[migration 20260416140000] player_charms narrowing skipped: {} rows exceed SMALLINT range", overflow)
		end
	end

	--
	-- Fix the legacy canary column name `tracker list` (with a space) to
	-- `tracker_list` — the engine now reads/writes the underscore form.
	--
	if columnExists("player_charms", "tracker list") and not columnExists("player_charms", "tracker_list") then
		db.query("ALTER TABLE `player_charms` CHANGE `tracker list` `tracker_list` BLOB NULL")
	end
end

migration:register()
