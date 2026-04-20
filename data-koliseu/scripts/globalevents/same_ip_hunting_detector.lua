-- Warns GMs/GODs when two or more players on the same IP are hunting
-- simultaneously (in-fight outside a protection zone). One warning per IP
-- per cooldown window, so the chat is not flooded while the offenders are
-- still active.

local TICK_INTERVAL_MS = 60 * 1000
local WARN_COOLDOWN_SECONDS = 5 * 60
local IGNORE_LOCAL_IP = 0x0100007F -- 127.0.0.1, masks test/dev logins

local lastWarnByIp = {}

local function isHunting(player)
	return player:hasCondition(CONDITION_INFIGHT) and not player:isPzLocked()
end

local function isStaff(player)
	return player:getGroup():getId() >= GROUP_TYPE_GAMEMASTER
end

local sameIpHuntingDetector = GlobalEvent("SameIpHuntingDetector")

function sameIpHuntingDetector.onThink(interval)
	local players = Game.getPlayers()
	if #players < 2 then
		return true
	end

	local byIp = {}
	for _, player in ipairs(players) do
		local ip = player:getIp()
		if ip ~= 0 and ip ~= IGNORE_LOCAL_IP and not isStaff(player) then
			local bucket = byIp[ip]
			if not bucket then
				bucket = {}
				byIp[ip] = bucket
			end
			bucket[#bucket + 1] = player
		end
	end

	local now = os.time()
	for ip, bucket in pairs(byIp) do
		if #bucket >= 2 then
			local hunting = {}
			for _, p in ipairs(bucket) do
				if isHunting(p) then
					hunting[#hunting + 1] = p
				end
			end

			if #hunting >= 2 then
				local last = lastWarnByIp[ip] or 0
				if now - last >= WARN_COOLDOWN_SECONDS then
					lastWarnByIp[ip] = now

					local names = {}
					for i, p in ipairs(hunting) do
						names[i] = string.format("%s [%d]", p:getName(), p:getLevel())
					end

					local message = string.format(
						"[Multi-IP Hunt] %s: %s",
						Game.convertIpToString(ip),
						table.concat(names, ", ")
					)

					for _, staff in ipairs(players) do
						if isStaff(staff) then
							staff:sendTextMessage(MESSAGE_ADMINISTRATOR, message)
						end
					end
				end
			end
		end
	end

	return true
end

sameIpHuntingDetector:interval(TICK_INTERVAL_MS)
sameIpHuntingDetector:register()
