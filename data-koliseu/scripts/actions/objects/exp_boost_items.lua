-- Experience Boost Items (independent from Store XP Boost)
-- Online-time countdown: only decrements while hunting (gaining experience).
-- Daily limit: 2 uses per potion type per day, resets at 10:00 server save.

local BOOSTS = {
	[60303] = 25,
	[60301] = 50,
	[60302] = 100,
}

local DURATION = 60 * 60 -- 1 hour in seconds (online/hunting time)
local KV_SCOPE = "exp-boost-item"
local MAX_DAILY_USES = 2
local SS_HOUR = 10 -- Server save hour (10:00)

-- Returns the timestamp of the last server save (10:00)
local function getLastSSTimestamp()
	local now = os.time()
	local today = os.date("*t", now) --[[@as osdateparam]]
	today.hour = SS_HOUR
	today.min = 0
	today.sec = 0
	local todaySS = os.time(today)
	if now < todaySS then
		return todaySS - 86400 -- before today's SS, use yesterday's
	end
	return todaySS
end

local action = Action()
function action.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local itemId = item:getId()
	local percent = BOOSTS[itemId]
	if not percent then
		return false
	end

	local kv = player:kv():scoped(KV_SCOPE)

	-- Daily use limit per potion type
	local usageKv = player:kv():scoped("exp-boost-usage")
	local usageKey = "item_" .. itemId
	local lastSSTimestamp = getLastSSTimestamp()

	local usageData = usageKv:get(usageKey)
	local usesToday = 0
	if usageData then
		local lastReset = usageData.lastReset or 0
		if lastReset >= lastSSTimestamp then
			usesToday = usageData.count or 0
		end
	end

	if usesToday >= MAX_DAILY_USES then
		player:sendTextMessage(MESSAGE_FAILURE, string.format(
			"You have already used this experience potion %d times today. The limit resets at %d:00.",
			MAX_DAILY_USES, SS_HOUR
		))
		player:getPosition():sendMagicEffect(CONST_ME_POFF)
		return true
	end

	-- Migrate legacy absolute "expires" to remaining seconds
	local now = os.time()
	local legacyExpires = kv:get("expires") or 0
	if legacyExpires > now then
		kv:set("remaining_seconds", legacyExpires - now)
		kv:remove("expires")
	elseif legacyExpires > 0 then
		kv:remove("expires")
	end

	-- Migrate legacy "remaining" (old format)
	local legacyRemaining = kv:get("remaining") or 0
	if legacyRemaining > 0 then
		kv:set("remaining_seconds", legacyRemaining)
		kv:remove("remaining")
	end

	local remainingSeconds = kv:get("remaining_seconds") or 0
	if remainingSeconds > 0 then
		local mins = math.floor(remainingSeconds / 60)
		local secs = remainingSeconds % 60
		local timeStr = ""
		if mins > 0 then
			timeStr = mins .. " minute" .. (mins ~= 1 and "s" or "")
		end
		if secs > 0 then
			if timeStr ~= "" then timeStr = timeStr .. " and " end
			timeStr = timeStr .. secs .. " second" .. (secs ~= 1 and "s" or "")
		end
		player:sendTextMessage(MESSAGE_FAILURE, "You already have an experience boost active with " .. timeStr .. " of hunting time remaining.")
		player:getPosition():sendMagicEffect(CONST_ME_POFF)
		return true
	end

	-- Increment daily usage
	usageKv:set(usageKey, { count = usesToday + 1, lastReset = os.time() })

	kv:set("percent", percent)
	kv:set("remaining_seconds", DURATION)

	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format(
		"You activated a %d%% experience boost for 1 hour of hunting time. (%d/%d uses today)",
		percent, usesToday + 1, MAX_DAILY_USES
	))
	player:getPosition():sendMagicEffect(CONST_ME_MAGIC_GREEN)

	-- Initialize the timer tracker for this player
	local playerId = player:getId()
	if not _G.NextUseExpItemTime then
		_G.NextUseExpItemTime = {}
	end
	_G.NextUseExpItemTime[playerId] = 1

	item:remove(1)
	return true
end

for itemId, _ in pairs(BOOSTS) do
	action:id(itemId)
end

action:register()
