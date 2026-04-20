-- Hunted System - Place bounty on a player's head
-- Usage: !hunted <player name>, <amount in kk>
local hunted = TalkAction("!hunted")

function hunted.onSay(player, words, param)
	if param == "" then
		player:sendCancelMessage("Usage: !hunted <player name>, <amount in kk>")
		player:sendCancelMessage("Example: !hunted Player Name, 5")
		return true
	end

	local split = param:split(",")
	if #split ~= 2 then
		player:sendCancelMessage("Usage: !hunted <player name>, <amount in kk>")
		return true
	end

	local targetName = split[1]:trim()
	local amountKK = tonumber(split[2]:trim())

	if not amountKK or amountKK <= 0 then
		player:sendCancelMessage("Invalid bounty amount. Must be a positive number.")
		return true
	end

	local bountyAmount = amountKK * 1000000

	local normalizedName = Game.getNormalizedPlayerName(targetName)
	if not normalizedName then
		player:sendCancelMessage("A player with name '" .. targetName .. "' does not exist.")
		return true
	end

	local targetPlayer = Player(normalizedName)
	local targetPlayerId

	if targetPlayer then
		targetPlayerId = targetPlayer:getGuid()
	else
		local resultId = db.storeQuery("SELECT `id` FROM `players` WHERE `name` = " .. db.escapeString(normalizedName))
		if not resultId then
			player:sendCancelMessage("A player with name '" .. normalizedName .. "' does not exist.")
			return true
		end
		targetPlayerId = result.getNumber(resultId, "id")
		result.free(resultId)
	end

	if targetPlayerId == player:getGuid() then
		player:sendCancelMessage("You cannot place a bounty on yourself.")
		return true
	end

	local playerMoney = player:getMoney() + Bank.balance(player)
	if playerMoney < bountyAmount then
		player:sendCancelMessage("You don't have enough money. You need " .. FormatNumber(bountyAmount) .. " gold coins.")
		return true
	end

	local query = string.format("SELECT `bounty`, `placed_by_id` FROM `hunted_system` WHERE `player_id` = %d", targetPlayerId)
	local resultQuery = db.storeQuery(query)

	if resultQuery then
		local currentBounty = result.getNumber(resultQuery, "bounty")
		result.free(resultQuery)

		if bountyAmount <= currentBounty then
			player:sendCancelMessage("There is already a bounty of " .. FormatNumber(currentBounty) .. " on " .. normalizedName .. ". Your bounty must be higher.")
			return true
		end

		local updateQuery = string.format(
			"UPDATE `hunted_system` SET `bounty` = %d, `placed_by_id` = %d, `placed_by_name` = %s, `updated_at` = NOW() WHERE `player_id` = %d",
			bountyAmount,
			player:getGuid(),
			db.escapeString(player:getName()),
			targetPlayerId
		)

		if not db.query(updateQuery) then
			player:sendCancelMessage("Failed to update bounty. Please try again.")
			return true
		end
	else
		local insertQuery = string.format(
			"INSERT INTO `hunted_system` (`player_id`, `player_name`, `bounty`, `placed_by_id`, `placed_by_name`) VALUES (%d, %s, %d, %d, %s)",
			targetPlayerId,
			db.escapeString(normalizedName),
			bountyAmount,
			player:getGuid(),
			db.escapeString(player:getName())
		)

		if not db.query(insertQuery) then
			player:sendCancelMessage("Failed to place bounty. Please try again.")
			return true
		end
	end

	if not player:removeMoney(bountyAmount) then
		player:sendCancelMessage("Failed to deduct money. Transaction cancelled.")
		return true
	end

	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have placed a bounty of " .. FormatNumber(bountyAmount) .. " (" .. amountKK .. "kk) on " .. normalizedName .. "!")

	if targetPlayer then
		targetPlayer:sendTextMessage(MESSAGE_EVENT_ADVANCE, "A bounty of " .. FormatNumber(bountyAmount) .. " has been placed on your head!")
	end

	Game.broadcastMessage("A bounty of " .. FormatNumber(bountyAmount) .. " (" .. amountKK .. "kk) has been placed on " .. normalizedName .. "'s head!", MESSAGE_EVENT_ADVANCE)

	return true
end

hunted:separator(" ")
hunted:groupType("normal")
hunted:register()
