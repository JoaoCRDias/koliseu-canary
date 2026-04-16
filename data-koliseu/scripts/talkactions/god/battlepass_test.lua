-- !bpadvance [days] [season_id] - Advance battle pass days for testing (GOD only)
-- !bpadvance 5       -> advance 5 days on the latest season
-- !bpadvance 15 2    -> advance 15 days on season 2
-- !bpreset [season_id] - Reset battle pass (clear all claims and reset activation time)

local bpAdvance = TalkAction("!bpadvance")

function bpAdvance.onSay(player, words, param, type)
	local params = param:split(" ")
	local days = tonumber(params[1])
	if not days or days < 1 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Usage: !bpadvance [days] [season_id]")
		return true
	end

	local seasonId = tonumber(params[2])
	if not seasonId then
		-- Find latest season for this player
		local query = db.storeQuery(string.format(
			"SELECT `season_id` FROM `player_battlepass` WHERE `player_id` = %d ORDER BY `season_id` DESC LIMIT 1",
			player:getGuid()
		))
		if query then
			seasonId = result.getNumber(query, "season_id")
			result.free(query)
		else
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "[BattlePass] No active battle pass found. Activate one first.")
			return true
		end
	end

	-- Check if player has this battle pass
	local checkQuery = db.storeQuery(string.format(
		"SELECT `activation_time`, `claimed_days` FROM `player_battlepass` WHERE `player_id` = %d AND `season_id` = %d",
		player:getGuid(), seasonId
	))

	if not checkQuery then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("[BattlePass] You don't have a battle pass for season %d.", seasonId))
		return true
	end

	local currentActivation = result.getNumber(checkQuery, "activation_time")
	local claimedDays = result.getString(checkQuery, "claimed_days")
	result.free(checkQuery)

	-- Calculate current days and new days
	local currentDays = math.floor((os.time() - currentActivation) / 86400) + 1
	local newActivation = currentActivation - (days * 86400)
	local newDays = math.min(math.floor((os.time() - newActivation) / 86400) + 1, 15)

	-- Update activation_time to simulate time passing
	db.query(string.format(
		"UPDATE `player_battlepass` SET `activation_time` = %d WHERE `player_id` = %d AND `season_id` = %d",
		newActivation, player:getGuid(), seasonId
	))

	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format(
		"[BattlePass] Advanced %d days on season %d. Days available: %d -> %d (of 15). Claimed: %s",
		days, seasonId, math.min(currentDays, 15), newDays, claimedDays ~= "" and claimedDays or "none"
	))
	return true
end

bpAdvance:separator(" ")
bpAdvance:groupType("god")
bpAdvance:register()

-- Reset battle pass
local bpReset = TalkAction("!bpreset")

function bpReset.onSay(player, words, param, type)
	local seasonId = tonumber(param)
	if not seasonId then
		local query = db.storeQuery(string.format(
			"SELECT `season_id` FROM `player_battlepass` WHERE `player_id` = %d ORDER BY `season_id` DESC LIMIT 1",
			player:getGuid()
		))
		if query then
			seasonId = result.getNumber(query, "season_id")
			result.free(query)
		else
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "[BattlePass] No active battle pass found.")
			return true
		end
	end

	db.query(string.format(
		"UPDATE `player_battlepass` SET `activation_time` = %d, `claimed_days` = '', `last_claim_time` = 0 WHERE `player_id` = %d AND `season_id` = %d",
		os.time(), player:getGuid(), seasonId
	))

	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format(
		"[BattlePass] Season %d reset. Activation time set to now, all claims cleared.", seasonId
	))
	return true
end

bpReset:separator(" ")
bpReset:groupType("god")
bpReset:register()
