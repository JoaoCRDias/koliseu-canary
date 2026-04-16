local gnomecd = TalkAction("!gnomecd")

function gnomecd.onSay(player, words, param)
	local res = db.storeQuery(("SELECT `last_play_ready_at` FROM `gnome_arena_stats` WHERE `player_id` = %d"):format(player:getGuid()))
	if not res then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "[Gnome Arena] You have never entered the Gnome Arena. You can enter now!")
		return false
	end

	local readyAt = Result.getNumber(res, "last_play_ready_at")
	Result.free(res)

	local now = os.time()
	if readyAt <= now then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "[Gnome Arena] Your cooldown has expired. You can enter now!")
	else
		local remaining = readyAt - now
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("[Gnome Arena] You must wait %s to enter again.", Game.getTimeInWords(remaining)))
	end
	return false
end

gnomecd:separator(" ")
gnomecd:groupType("normal")
gnomecd:register()
