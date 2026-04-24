-- Gilded barrier guarding the wealth chamber. Only players who finished the
-- fire chamber AND reported back to the elder warrior may cross.

local barrier = MoveEvent()
barrier:type("stepin")

function barrier.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return false
	end

	if player:getStorageValue(Storage.SupremeVocation.WealthStageAccess) >= 1 then
		return true
	end

	player:teleportTo(fromPosition, true)
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "A gilded barrier repels you. Survive the fire chamber and report to the elder warrior first.")
	fromPosition:sendMagicEffect(CONST_ME_GOLDEN_FIREWORKS)
	return false
end

barrier:aid(SupremeVocation.WealthBarrierActionId)
barrier:register()
