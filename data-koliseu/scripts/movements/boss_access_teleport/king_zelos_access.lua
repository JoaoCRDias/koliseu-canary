local accessBlood = MoveEvent()
function accessBlood.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return false
	end

	local access = player:kv():scoped("grave-danger-quest") or 0

	if access == 0 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You need to kill all grave danger mini bosses first.")

		return false
	end

	local accessBosses = { "duke krule", "earl osam", "sir baeloc", "lord azaram", "count vlarkorth" }
	for i, name in ipairs(accessBosses) do
		local killed = access:scoped(name):get("killed")
		if not killed then
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You need to kill all grave danger mini bosses first.")
			player:teleportTo(fromPosition, true)
			return false
		end
	end
	player:teleportTo(Position(1897, 892, 15), true)
	return true
end

accessBlood:type("stepin")
accessBlood:aid(54020)
accessBlood:register()
