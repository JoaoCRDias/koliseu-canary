local addCoins = TalkAction("!addcoins")
local usageMessage = "Usage: !addcoins <playername>,<coins>"

function addCoins.onSay(player, words, param)
	if param == "" then
		player:sendCancelMessage(usageMessage)
		return true
	end

	local split = param:split(",")
	if #split < 2 then
		player:sendCancelMessage(usageMessage)
		return true
	end

	local targetName = split[1]:trim()
	local coins = tonumber(split[2])
	if not targetName or targetName == "" then
		player:sendCancelMessage("Player name is required.")
		return true
	end

	if not coins then
		player:sendCancelMessage("Coin amount is required.")
		return true
	end

	coins = math.floor(coins)
	if coins <= 0 then
		player:sendCancelMessage("Coin amount must be greater than zero.")
		return true
	end

	local normalizedName = Game.getNormalizedPlayerName(targetName)
	if not normalizedName then
		player:sendCancelMessage("Player " .. targetName .. " does not exist.")
		return true
	end

	local targetPlayer = Player(normalizedName)
	local accountId

	if targetPlayer then
		accountId = targetPlayer:getAccountId()
	else
		local resultId = db.storeQuery("SELECT `account_id` FROM `players` WHERE `name` = " .. db.escapeString(normalizedName) .. " LIMIT 1")
		if not resultId then
			player:sendCancelMessage("Could not retrieve account for " .. normalizedName .. ".")
			return true
		end
		accountId = Result.getNumber(resultId, "account_id")
		Result.free(resultId)
	end

	if not accountId or accountId <= 0 then
		player:sendCancelMessage("Invalid account for player " .. normalizedName .. ".")
		return true
	end

	if targetPlayer then
		targetPlayer:addTransferableCoinsBalance(coins, true)
		targetPlayer:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("You received %d Tibia Coins.", coins))
	else
		local updateQuery = string.format("UPDATE `accounts` SET `coins_transferable` = `coins_transferable` + %d WHERE `id` = %d", coins, accountId)
		if not db.query(updateQuery) then
			player:sendCancelMessage("Failed to credit coins to account " .. accountId .. ".")
			return true
		end
	end

	if GameStore and GameStore.insertHistory then
		GameStore.insertHistory(accountId, GameStore.HistoryTypes.HISTORY_TYPE_NONE, string.format("Admin grant (%d coins)", coins), coins, GameStore.CoinType.Coin)
	end

	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("Added %d transferable coins to %s (account %d). Not registered as donation.", coins, normalizedName, accountId))
	logger.info("[AddCoins] {} granted {} transferable coins to {} (account {}) - no donation record.", player:getName(), coins, normalizedName, accountId)
	return true
end

addCoins:separator(" ")
addCoins:groupType("god")
addCoins:register()
