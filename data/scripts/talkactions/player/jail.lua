local jail = TalkAction("!jail")

local JAIL_COOLDOWN_RESET_SECONDS = 7 * 24 * 60 * 60
local JAIL_REASON = "Educational jail - simultaneous multi-client hunting"
local JAIL_AREA_FROM = Position(1062, 994, 7)
local JAIL_AREA_TO = Position(1075, 1005, 7)

local function getAccountJailKV(player)
	local accountId = player:getAccountId()
	if accountId == 0 then
		return nil, 0
	end
	local accountKV = kv.scoped("account"):scoped(tostring(accountId))
	return accountKV:scoped("jail"), accountId
end

local function isAccountBanned(accountId)
	local resultId = db.storeQuery("SELECT 1 FROM `account_bans` WHERE `account_id` = " .. accountId)
	if resultId then
		result.free(resultId)
		return true
	end
	return false
end

local function banAccount(player, banDays, reason)
	local accountId = player:getAccountId()
	if accountId == 0 or isAccountBanned(accountId) then
		return
	end

	local now = os.time()
	local expiresAt = 0
	if banDays and banDays > 0 then
		expiresAt = now + (banDays * 24 * 60 * 60)
	end

	db.query(string.format(
		"INSERT INTO `account_bans` (`account_id`, `reason`, `banned_at`, `expires_at`, `banned_by`) VALUES (%d, %s, %d, %d, %d)",
		accountId,
		db.escapeString(reason),
		now,
		expiresAt,
		player:getGuid()
	))

	player:remove()
end

local function applyPunishments(player, count)
	if count >= 3 then
		local expLoss = math.floor(player:getExperience() * 0.10)
		if expLoss > 0 then
			player:removeExperience(expLoss, true)
		end
		player:setStamina(0)
		player:teleportTo(Position(1059, 1000, 7))
		return
	end

	if count == 4 then
		player:teleportTo(Position(1059, 1000, 7))
		banAccount(player, 7, JAIL_REASON .. " (7 days)")
		return
	elseif count >= 5 then
		player:teleportTo(Position(1059, 1000, 7))
		banAccount(player, 0, JAIL_REASON .. " (permanent)")
		return
	end
	player:teleportTo(Position(1059, 1000, 7))
end

function jail.onSay(player, words, param)
	if not player:getPosition():isInRange(JAIL_AREA_FROM, JAIL_AREA_TO) then
		player:sendCancelMessage("You must be in the jail to use this command.")
		return true
	end

	local modal = ModalWindow({})
	modal:setTitle("Educational jail")
	modal:setMessage(
		"Educational jail:\n" ..
		"You were arrested for breaking the MC simultaneous hunt rule.\n" ..
		"You have the following chances:\n" ..
		"1 - Educational jail\n" ..
		"2 - Educational jail\n" ..
		"3 - Educational jail + 10% XP loss + stamina reset\n" ..
		"4 - 7-day ban + 10% XP loss + stamina reset\n" ..
		"5 - Permanent ban\n\n" ..
		"These chances apply across all characters on the account!"
	)

	modal:addButton("OK", function(buttonPlayer)
		local jailKV = getAccountJailKV(buttonPlayer)
		if not jailKV then
			return
		end

		local now = os.time()
		local last = jailKV:get("last") or 0
		local count = jailKV:get("count") or 0

		if last > 0 and (now - last) >= JAIL_COOLDOWN_RESET_SECONDS then
			count = 0
		end

		count = count + 1
		jailKV:set("count", count)
		jailKV:set("last", now)

		applyPunishments(buttonPlayer, count)
	end)

	modal:setDefaultEnterButton(1)
	modal:setDefaultEscapeButton(1)
	modal:sendToPlayer(player)
	return true
end

jail:separator(" ")
jail:groupType("normal")
jail:register()
