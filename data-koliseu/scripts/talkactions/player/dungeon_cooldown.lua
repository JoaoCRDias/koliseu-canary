local dungeoncd = TalkAction("!dungeoncd")

local DUNGEON_COOLDOWN_STORAGE = 54001

function dungeoncd.onSay(player, words, param)
	local cooldownEnd = player:getStorageValue(DUNGEON_COOLDOWN_STORAGE)
	local now = os.time()

	if cooldownEnd <= 0 or cooldownEnd <= now then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "[Solo Dungeon] Your cooldown has expired. You can enter now!")
	else
		local remaining = cooldownEnd - now
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("[Solo Dungeon] You must wait %s to enter again.", Game.getTimeInWords(remaining)))
	end
	return false
end

dungeoncd:separator(" ")
dungeoncd:groupType("normal")
dungeoncd:register()
