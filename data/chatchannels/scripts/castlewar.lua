function onSpeak(player, type, message)
	-- Players cannot send messages in this channel
	-- This is a read-only channel for task notifications
	player:sendCancelMessage("This is a read-only channel for castle war notifications.")
	return false
end
