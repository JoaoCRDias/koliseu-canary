-- Wall of flame gating the fire chamber. Only players who finished the death
-- chamber AND reported back to the elder warrior may cross.

local barrier = MoveEvent()
barrier:type("stepin")

function barrier.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return false
	end

	if player:getStorageValue(Storage.SupremeVocation.FireStageAccess) >= 1 then
		return true
	end

	player:teleportTo(fromPosition, true)
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "A wall of flame repels you. Clear the death chamber and report to the elder warrior first.")
	fromPosition:sendMagicEffect(CONST_ME_FIREAREA)
	return false
end

barrier:aid(SupremeVocation.FireBarrierActionId)
barrier:register()
