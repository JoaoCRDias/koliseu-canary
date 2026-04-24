-- Veil-of-death barrier gating the death chamber. Only players who finished
-- the poison chamber AND reported back to the elder warrior may cross.

local barrier = MoveEvent()
barrier:type("stepin")

function barrier.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return false
	end

	if player:getStorageValue(Storage.SupremeVocation.PoisonStageComplete) >= 1 then
		return true
	end

	player:teleportTo(fromPosition, true)
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "A veil of death repels you. Survive the poison chamber and report to the elder warrior first.")
	fromPosition:sendMagicEffect(CONST_ME_MORTAREA)
	return false
end

barrier:aid(SupremeVocation.DeathBarrierActionId)
barrier:register()
