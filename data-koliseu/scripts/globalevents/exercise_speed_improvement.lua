local EXERCISE_SPEED_KV = "exercise-speed-improvement"

function AddExerciseSpeedBoost(player, seconds)
	player:kv():scoped(EXERCISE_SPEED_KV):set("remaining", seconds)
end

function GetExerciseSpeedRemaining(player)
	return player:kv():scoped(EXERCISE_SPEED_KV):get("remaining") or 0
end

-- Decrement boost time by the given interval (in ms). Called from exercise training event.
-- Returns the remaining seconds after decrement.
function DecrementExerciseSpeedBoost(player, intervalMs)
	local kv = player:kv():scoped(EXERCISE_SPEED_KV)
	local remaining = kv:get("remaining") or 0
	if remaining <= 0 then
		return 0
	end

	remaining = remaining - (intervalMs / 1000)
	if remaining > 0 then
		kv:set("remaining", remaining)
	else
		remaining = 0
		kv:remove("remaining")
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Your exercise speed boost has expired.")
	end
	return remaining
end