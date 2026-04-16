-- Battle Pass Scroll items
-- Each scroll is tied to a specific season
local SCROLL_TO_SEASON = {
	[60426] = 1, -- Season 1: Relic Hunter
	[60422] = 2, -- Season 2: Cosmic Wolfes
}

local SEASON_STORE_NAME = {
	[1] = "Battle Pass - Season 1",
	[2] = "Battle Pass - Season 2",
}

local battlepassItem = Action()

local function hasAccountPurchased(accountId, seasonId)
	local storeName = SEASON_STORE_NAME[seasonId]
	if not storeName then
		return false
	end
	local query = db.storeQuery(string.format(
		"SELECT `id` FROM `store_history` WHERE `account_id` = %d AND `description` = %s LIMIT 1",
		accountId, db.escapeString(storeName)
	))
	if query then
		result.free(query)
		return true
	end
	return false
end

function battlepassItem.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local BattlePassCore = dofile("data-crystal/scripts/systems/battlepass/core.lua")
	local BattlePassDB = dofile("data-crystal/scripts/systems/battlepass/database.lua")

	-- Check if item is in the player's inventory
	local topParent = item:getTopParent()
	if not topParent or topParent ~= player then
		return false
	end

	-- Get season ID from scroll item
	local seasonId = SCROLL_TO_SEASON[item.itemid]
	if not seasonId then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "[Error] Unknown Battle Pass scroll.")
		return true
	end

	-- Get season from database
	local season = BattlePassDB.getSeasonById(seasonId)
	if not season then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "[Error] Battle Pass season not configured in database.")
		return true
	end

	-- Check if player has Battle Pass for this season
	local playerBP = BattlePassCore.getPlayerBattlePass(player:getGuid(), seasonId)

	-- If not, activate Battle Pass (first time using the scroll)
	if not playerBP then
		-- Verify the account actually purchased this Battle Pass
		if not hasAccountPurchased(player:getAccountId(), seasonId) then
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Your account does not have a Battle Pass purchase for this season.")
			return true
		end

		local activated = BattlePassCore.activateBattlePass(player:getGuid(), seasonId)
		if activated then
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Battle Pass activated! Season: " .. season.name)
			player:getPosition():sendMagicEffect(CONST_ME_FIREWORK_RED)

			playerBP = BattlePassCore.getPlayerBattlePass(player:getGuid(), seasonId)
		else
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Failed to activate Battle Pass.")
			return true
		end
	end

	-- Open Battle Pass modal window
	BattlePassCore.openBattlePassWindow(player, season, playerBP)

	return true
end

for scrollId, _ in pairs(SCROLL_TO_SEASON) do
	battlepassItem:id(scrollId)
end
battlepassItem:register()
