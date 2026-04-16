local citizen = MoveEvent()
citizen:type("stepin")

function citizen.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return false
	end

	local hasPaid = SecondFloorQuests.hasAccess(player)
	if not hasPaid then
		player:teleportTo(fromPosition)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You must pay the quest access fee before entering this area.")
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		return false
	end
	return true
end

citizen:aid(31550)
citizen:register()
