-- Final barrier guarding the summit (5 demons + Ascenar). Only players who
-- finished the wealth chamber AND reported back to the elder warrior may
-- cross.

local barrier = MoveEvent()
barrier:type("stepin")

function barrier.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return false
	end

	if SupremeVocation.hasCompletedWealthStage(player) then
		return true
	end

	player:teleportTo(fromPosition, true)
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The summit refuses you. Beat Goldmouth and report to the elder warrior first.")
	fromPosition:sendMagicEffect(CONST_ME_GOLDEN_FIREWORKS)
	return false
end

barrier:aid(SupremeVocation.SummitBarrierActionId)
barrier:register()
