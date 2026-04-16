local accessBlood = MoveEvent()
function accessBlood.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return false
	end

	local access = player:kv():scoped("ascending-ferumbras") or 0

	if access == 0 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You need to kill all ascending ferumbras mini bosses first.")
		return false
	end

	local accessBosses = {
		"tarbaz",
		"ragiaz",
		"plagirath",
		"razzagorn",
		"zamulosh",
		"mazoran",
		"shulgrax",
	}
	for i, name in ipairs(accessBosses) do
		local killed = access:scoped(name):get("killed")
		if not killed then
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You need to kill all ascending ferumbras mini bosses first.")
			player:teleportTo(fromPosition, true)
			return false
		end
	end
	player:teleportTo(Position(1711, 1175, 15), true)
	return true
end

accessBlood:type("stepin")
accessBlood:aid(54024)
accessBlood:register()
