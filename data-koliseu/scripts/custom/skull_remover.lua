local removeFrags = Action()

function removeFrags.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if not isInArray({ SKULL_RED, SKULL_BLACK }, player:getSkull()) then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You can only remove RED SKULL or BLACK SKULL!")
		return true
	end

	local playerId = player:getGuid()
	player:setSkull(SKULL_NONE)
	player:setSkullTime(0)
	player:setKills({})
	item:remove(1)
	db.asyncQuery("DELETE FROM `player_kills` WHERE `player_id` = " .. playerId)
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Your skull has been removed and your frags have been cleared.")
	player:getPosition():sendMagicEffect(CONST_ME_MAGIC_GREEN)
	return true
end

removeFrags:id(60100)
removeFrags:register()
