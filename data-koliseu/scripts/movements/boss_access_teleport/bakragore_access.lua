local accessBlood = MoveEvent()
function accessBlood.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return false
	end

	local access = player:kv():scoped("rotten-blood-quest") or 0

	if access == 0 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You need to kill all rotten blood mini bosses first.")
		return false
	end

	local accessBosses = { "murcion", "chagorz", "ichgahal", "vemiath" }
	for i, name in ipairs(accessBosses) do
		local killed = access:scoped(name):get("killed")
		if not killed then
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You need to kill all rotten blood mini bosses first.")
			player:teleportTo(fromPosition, true)
			return false
		end
	end
	player:teleportTo(Position(1704, 909, 15), true)
	return true
end

accessBlood:type("stepin")
accessBlood:aid(54021)
accessBlood:register()
