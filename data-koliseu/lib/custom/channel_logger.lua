function logChannelMessage(channelName, playerName, message)
	local date = os.date("%Y-%m-%d")
	local time = os.date("%H:%M:%S")
	local dir = "data/logs/channels"
	local filename = string.format("%s/%s_%s.log", dir, channelName, date)
	local file = io.open(filename, "a")
	if file then
		file:write(string.format("[%s] %s: %s\n", time, playerName, message))
		file:close()
	end
end
