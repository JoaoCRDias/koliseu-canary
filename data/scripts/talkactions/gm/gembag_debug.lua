local talk = TalkAction("/gembagdebug")

function talk.onSay(player, words, param)
	player:sendTextMessage(MESSAGE_ADMINISTRATOR, "=== GEM BAG DIAGNOSTIC ===")

	local momentum = player:getStorageValue(910002)
	local onslaught = player:getStorageValue(910003)
	local transcendence = player:getStorageValue(910004)
	local ruse = player:getStorageValue(910005)

	player:sendTextMessage(MESSAGE_ADMINISTRATOR, string.format("Storage 910002 (Momentum): %d (%.2f%%)", momentum, momentum / 100))
	player:sendTextMessage(MESSAGE_ADMINISTRATOR, string.format("Storage 910003 (Onslaught): %d (%.2f%%)", onslaught, onslaught / 100))
	player:sendTextMessage(MESSAGE_ADMINISTRATOR, string.format("Storage 910004 (Transcendence): %d (%.2f%%)", transcendence, transcendence / 100))
	player:sendTextMessage(MESSAGE_ADMINISTRATOR, string.format("Storage 910005 (Ruse): %d (%.2f%%)", ruse, ruse / 100))

	if param == "reapply" then
		player:sendTextMessage(MESSAGE_ADMINISTRATOR, "Reapplying bonuses...")
		GemBag.applyStatBonuses(player)
		player:sendTextMessage(MESSAGE_ADMINISTRATOR, "Bonuses reapplied! Check your stats.")
	end

	local condition = player:getCondition(CONDITION_ATTRIBUTES, CONDITIONID_DEFAULT, 98)
	if condition then
		player:sendTextMessage(MESSAGE_ADMINISTRATOR, "Gem Bag condition is ACTIVE")
	else
		player:sendTextMessage(MESSAGE_ADMINISTRATOR, "Gem Bag condition is NOT ACTIVE")
	end

	return true
end

talk:separator(" ")
talk:groupType("gamemaster")
talk:register()
