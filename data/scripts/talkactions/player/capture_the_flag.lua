-- Capture The Flag - Leave command (!ctf leave)

local ctfLeave = TalkAction("!ctf")

function ctfLeave.onSay(player, words, param, type)
	if param == "leave" then
		if CTF.state == "waiting" then
			-- Player is in waiting room, just teleport out
			if player:getPosition():isInRange(CTF.config.waitingRoom.fromPos, CTF.config.waitingRoom.toPos) then
				player:teleportTo(CTF.config.exitPos)
				CTF.config.exitPos:sendMagicEffect(CONST_ME_TELEPORT)
				player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "[CTF] You left the waiting room.")
			else
				player:sendTextMessage(MESSAGE_STATUS_SMALL, "You are not in the CTF event.")
			end
		elseif CTF.state == "running" and CTF.players[player:getGuid()] then
			CTF:removePlayer(player)
		else
			player:sendTextMessage(MESSAGE_STATUS_SMALL, "You are not in the CTF event.")
		end
	else
		player:sendTextMessage(MESSAGE_STATUS_SMALL, "Use '!ctf leave' to leave the event.")
	end
	return true
end

ctfLeave:separator(" ")
ctfLeave:groupType("normal")
ctfLeave:register()
