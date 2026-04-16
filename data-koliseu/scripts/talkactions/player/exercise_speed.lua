local EXERCISE_SPEED_KV = "exercise-speed-improvement"

local exerciseSpeed = TalkAction("!exercisespeed")

function exerciseSpeed.onSay(player, words, param)
	local remaining = player:kv():scoped(EXERCISE_SPEED_KV):get("remaining") or 0

	if remaining <= 0 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have no exercise speed improvement active.")
		return false
	end

	local hours = math.floor(remaining / 3600)
	local minutes = math.floor((remaining % 3600) / 60)
	local seconds = math.floor(remaining % 60)

	local parts = {}
	if hours > 0 then
		parts[#parts + 1] = hours .. (hours == 1 and " hour" or " hours")
	end
	if minutes > 0 then
		parts[#parts + 1] = minutes .. (minutes == 1 and " minute" or " minutes")
	end
	if seconds > 0 then
		parts[#parts + 1] = seconds .. (seconds == 1 and " second" or " seconds")
	end

	local timeStr = table.concat(parts, " and ")
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Exercise speed improvement remaining: " .. timeStr .. ".")
	return false
end

exerciseSpeed:separator(" ")
exerciseSpeed:groupType("normal")
exerciseSpeed:register()
