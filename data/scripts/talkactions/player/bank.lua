local config = {
	enabled = true,
	messageStyle = MESSAGE_LOOK,
}

if not config.enabled then
	return
end

local function getPlayerBankBalance(name)
	local player = Player(name)
	if player then
		return Bank.balance(player)
	end
	local resultId = db.storeQuery("SELECT `balance` FROM `players` WHERE `name` = " .. db.escapeString(name))
	if resultId then
		local balance = Result.getNumber(resultId, "balance")
		Result.free(resultId)
		return balance
	end
	return 0
end

local function logBankTransaction(action, playerName, amount, balanceBefore, balanceAfter, extra)
	local timestamp = os.date("%Y-%m-%d %H:%M:%S")
	local date = os.date("%d-%m")
	local filePath = string.format("%s/logs/bank_transactions-%s.log", CORE_DIRECTORY, date)
	local file = io.open(filePath, "a")
	if not file then
		logger.error("[Bank Log] Failed to open log file: {}", filePath)
		return
	end

	local ip = extra and extra.ip or "unknown"
	local line = string.format(
		"[%s] ACTION: %s | PLAYER: %s | IP: %s | AMOUNT: %s | BALANCE_BEFORE: %s | BALANCE_AFTER: %s",
		timestamp, action, playerName, ip, FormatNumber(amount), FormatNumber(balanceBefore), FormatNumber(balanceAfter)
	)
	if extra and extra.target then
		line = line .. string.format(" | TARGET: %s", extra.target)
	end
	if extra and extra.targetBalanceBefore then
		line = line .. string.format(" | TARGET_BALANCE_BEFORE: %s | TARGET_BALANCE_AFTER: %s", FormatNumber(extra.targetBalanceBefore), FormatNumber(extra.targetBalanceAfter))
	end
	if extra and extra.reason then
		line = line .. string.format(" | REASON: %s", extra.reason)
	end

	io.output(file)
	io.write(line .. "\n")
	io.close(file)
end

local balance = TalkAction("!balance")

function balance.onSay(player, words, param)
	player:sendTextMessage(config.messageStyle, "Your current bank balance is " .. FormatNumber(Bank.balance(player)) .. ".")
	return true
end

balance:separator(" ")
balance:groupType("normal")
balance:register()

local deposit = TalkAction("!deposit")

function deposit.onSay(player, words, param)
	local amount
	if param == "all" then
		amount = player:getMoney()
	else
		amount = tonumber(param)
		if not amount or amount <= 0 and isValidMoney(amount) then
			player:sendTextMessage(config.messageStyle, "Invalid amount.")
			return true
		end
	end

	local balanceBefore = Bank.balance(player)
	if not Bank.deposit(player, amount) then
		player:sendTextMessage(config.messageStyle, "You don't have enough money.")
		return true
	end
	local balanceAfter = Bank.balance(player)

	logBankTransaction("DEPOSIT", player:getName(), amount, balanceBefore, balanceAfter, {
		ip = Game.convertIpToString(player:getIp()),
	})

	player:sendTextMessage(config.messageStyle, "You have deposited " .. FormatNumber(amount) .. " gold coins.")
	return true
end

deposit:separator(" ")
deposit:groupType("normal")
deposit:register()

local withdraw = TalkAction("!withdraw")

function withdraw.onSay(player, words, param)
	local amount = tonumber(param)
	if not amount or amount <= 0 and isValidMoney(amount) then
		player:sendTextMessage(config.messageStyle, "Invalid amount.")
		return true
	end

	local balanceBefore = Bank.balance(player)
	if not Bank.withdraw(player, amount) then
		player:sendTextMessage(config.messageStyle, "You don't have enough money.")
		return true
	end
	local balanceAfter = Bank.balance(player)

	logBankTransaction("WITHDRAW", player:getName(), amount, balanceBefore, balanceAfter, {
		ip = Game.convertIpToString(player:getIp()),
	})

	player:sendTextMessage(config.messageStyle, "You have withdrawn " .. FormatNumber(amount) .. " gold coins.")
	return true
end

withdraw:separator(" ")
withdraw:groupType("normal")
withdraw:register()

local transfer = TalkAction("!transfer")

function transfer.onSay(player, words, param)
	local split = param:split(",")
	local amount = tonumber(split[2])
	if not amount or amount <= 0 and isValidMoney(amount) then
		player:sendTextMessage(config.messageStyle, "Invalid amount.")
		return true
	end

	local name = split[1]
	if not name then
		player:sendTextMessage(config.messageStyle, "Invalid name.")
		return true
	end
	name = name:trim()
	local normalizedName = Game.getNormalizedPlayerName(name)
	if not normalizedName then
		player:sendTextMessage(config.messageStyle, "A player with name " .. name .. " does not exist.")
		return true
	end
	name = normalizedName

	local balanceBefore = Bank.balance(player)
	local targetBalanceBefore = getPlayerBankBalance(name)

	if not player:transferMoneyTo(name, amount) then
		player:sendTextMessage(config.messageStyle, "You don't have enough money.")
		return true
	end

	local balanceAfter = Bank.balance(player)
	local targetBalanceAfter = getPlayerBankBalance(name)

	logBankTransaction("TRANSFER", player:getName(), amount, balanceBefore, balanceAfter, {
		ip = Game.convertIpToString(player:getIp()),
		target = name,
		targetBalanceBefore = targetBalanceBefore,
		targetBalanceAfter = targetBalanceAfter,
	})

	player:sendTextMessage(config.messageStyle, "You have transferred " .. FormatNumber(amount) .. " gold coins to " .. name .. ".")
	return true
end

transfer:separator(" ")
transfer:groupType("normal")
transfer:register()
