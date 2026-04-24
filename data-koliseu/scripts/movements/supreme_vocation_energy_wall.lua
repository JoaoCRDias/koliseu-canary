-- Wall of energies gating the nature sanctum. Only players who reported the
-- trial to the elder warrior may cross.

local wall = MoveEvent()
wall:type("stepin")

function wall.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return false
	end

	if player:getStorageValue(Storage.SupremeVocation.EnergyWallAccess) >= 1 then
		return true
	end

	player:teleportTo(fromPosition, true)
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "A wall of energies repels you. Report the trial to the elder warrior first.")
	fromPosition:sendMagicEffect(CONST_ME_ENERGYHIT)
	return false
end

wall:aid(SupremeVocation.EnergyWallActionId)
wall:register()
