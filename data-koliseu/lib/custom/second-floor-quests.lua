SecondFloorQuests = {}

SecondFloorQuests.addAccess = function(player)
	player:kv():scoped('quests-second-floor'):set("access", true)
end

SecondFloorQuests.removeAccess = function(player)
	player:kv():scoped('quests-second-floor'):set("access", false)
end

SecondFloorQuests.hasAccess = function(player)
	return player:kv():scoped('quests-second-floor'):get("access")
end
