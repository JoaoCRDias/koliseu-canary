-- Reset mining tries for every player.
--
-- The mining skill multiplier in vocations.xml was previously 1.1 (which
-- pushed the required tries per level into the millions almost immediately
-- and made levelling impossible). It was corrected to 1.015. Players who
-- accumulated huge amounts of tries against the broken curve would, on next
-- login under the corrected formula, jump several levels at once.
--
-- This migration zeros every player's `skill_mining_tries` while keeping
-- their current `skill_mining` level intact, so the next try is counted
-- against the new (small) requirement.

function onUpdateDatabase()
	logger.info("Updating database to version 2 (reset mining tries for new mining formula)")

	db.query("UPDATE `players` SET `skill_mining_tries` = 0 WHERE `skill_mining_tries` > 0")

	return true
end
