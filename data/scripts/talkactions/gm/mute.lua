-- Staff mute: silences a player for MUTE_DURATION_SECONDS across all talk types
-- except spells. Expiration is stored as a unix timestamp in the player's KV
-- `features.mutePlayer`, read from C++ (Player::checkMute).
local MUTE_DURATION_SECONDS = 60 * 60 -- 1 hour

local mute = TalkAction("/mute")

function mute.onSay(player, words, param)
	if param == "" then
		player:sendCancelMessage("You must specify a player. Usage: /mute playerName.")
		return true
	end

	local split = param:split(",")
	local targetName = split[1]:trim()
	local target = Player(targetName)

	if not target then
		player:sendCancelMessage("A player with that name is not online.")
		return true
	end

	if target:getGroup():getId() >= GROUP_TYPE_GAMEMASTER then
		player:sendCancelMessage("You cannot mute this character.")
		return true
	end

	local expiresAt = os.time() + MUTE_DURATION_SECONDS
	target:kv():scoped("features"):set("mutePlayer", expiresAt)

	local minutes = math.floor(MUTE_DURATION_SECONDS / 60)
	player:popupFYI(target:getName() .. " has been muted for " .. minutes .. " minutes.")
	target:sendTextMessage(MESSAGE_FAILURE, "You have been muted by " .. player:getName() .. " for " .. minutes .. " minutes.")
	return true
end

mute:separator(" ")
mute:groupType("tutor")
mute:register()

local unmute = TalkAction("/unmute")

function unmute.onSay(player, words, param)
	if param == "" then
		player:sendCancelMessage("You must specify a player. Usage: /unmute playerName.")
		return true
	end

	local targetName = param:trim()
	local target = Player(targetName)

	if not target then
		player:sendCancelMessage("A player with that name is not online.")
		return true
	end

	target:kv():scoped("features"):remove("mutePlayer")
	player:popupFYI(target:getName() .. " has been unmuted.")
	target:sendTextMessage(MESSAGE_INFO_DESCR, "You have been unmuted by " .. player:getName() .. ".")
	return true
end

unmute:separator(" ")
unmute:groupType("tutor")
unmute:register()
