local verify = TalkAction("!verify")

local VISIT_INTERVAL_MS = 5000
local activeVerify = {}

local function visitNext(gmId, playerList, index)
	local gm = Player(gmId)
	if not gm then
		activeVerify[gmId] = nil
		return
	end

	if not activeVerify[gmId] then
		return
	end

	if index > #playerList then
		gm:sendTextMessage(MESSAGE_EVENT_ADVANCE, "[Verify] Verification complete. " .. #playerList .. " players visited.")
		activeVerify[gmId] = nil
		return
	end

	local target = Player(playerList[index].id)
	if not target then
		gm:sendTextMessage(MESSAGE_EVENT_ADVANCE, "[Verify] " .. playerList[index].name .. " logged out. Skipping...")
		addEvent(visitNext, 500, gmId, playerList, index + 1)
		return
	end

	local pos = target:getPosition()
	gm:teleportTo(pos)
	pos:sendMagicEffect(CONST_ME_TELEPORT)

	gm:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format(
		"[Verify] (%d/%d) %s [Level %d] - Next in %ds...",
		index, #playerList, target:getName(), target:getLevel(), VISIT_INTERVAL_MS / 1000
	))

	addEvent(visitNext, VISIT_INTERVAL_MS, gmId, playerList, index + 1)
end

function verify.onSay(player, words, param)
	if param == "" then
		player:sendCancelMessage("Usage: !verify <player name or IP>")
		return true
	end

	if param:lower() == "stop" then
		if activeVerify[player:getId()] then
			activeVerify[player:getId()] = nil
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "[Verify] Verification cancelled.")
		else
			player:sendCancelMessage("No active verification.")
		end
		return true
	end

	if activeVerify[player:getId()] then
		player:sendCancelMessage("A verification is already running. Use '!verify stop' to cancel it.")
		return true
	end

	local targetIp = nil
	local ipString = nil

	local targetPlayer = Player(param)
	if targetPlayer then
		targetIp = targetPlayer:getIp()
		ipString = Game.convertIpToString(targetIp)
	else
		local parts = { param:match("^(%d+)%.(%d+)%.(%d+)%.(%d+)$") }
		if #parts == 4 then
			local a, b, c, d = tonumber(parts[1]), tonumber(parts[2]), tonumber(parts[3]), tonumber(parts[4])
			if a and b and c and d and a <= 255 and b <= 255 and c <= 255 and d <= 255 then
				targetIp = a + (b * 256) + (c * 65536) + (d * 16777216)
				ipString = param
			end
		end
	end

	if not targetIp or targetIp == 0 then
		player:sendCancelMessage("Player not found or invalid IP.")
		return true
	end

	local playerList = {}
	for _, onlinePlayer in ipairs(Game.getPlayers()) do
		if onlinePlayer:getIp() == targetIp and onlinePlayer:getId() ~= player:getId() then
			table.insert(playerList, {
				id = onlinePlayer:getId(),
				name = onlinePlayer:getName(),
			})
		end
	end

	if #playerList == 0 then
		player:sendCancelMessage("No players found with IP " .. ipString)
		return true
	end

	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format(
		"[Verify] IP: %s - %d players found. Starting verification...",
		ipString, #playerList
	))

	activeVerify[player:getId()] = true
	visitNext(player:getId(), playerList, 1)

	return true
end

verify:separator(" ")
verify:groupType("gamemaster")
verify:register()
