-- Miasma barrier gating the poison/swamp biome. Only players who reported the
-- fountain purification to the elder warrior may cross.

local barrier = MoveEvent()
barrier:type("stepin")

function barrier.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return false
	end

	if player:getStorageValue(Storage.SupremeVocation.PoisonStageAccess) >= 1 then
		return true
	end

	player:teleportTo(fromPosition, true)
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "A poisonous miasma repels you. Purify the nature fountain and report to the elder warrior first.")
	fromPosition:sendMagicEffect(CONST_ME_POISONAREA)
	return false
end

barrier:aid(SupremeVocation.PoisonBarrierActionId)
barrier:register()
