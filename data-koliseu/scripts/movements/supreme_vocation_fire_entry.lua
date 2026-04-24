-- Entry teleport for the Supreme Vocation fire chamber. Steps on the AID 60022
-- tile. Gated by FireStageAccess. Enters waiting phase; teleports player into
-- the chamber. Rejects entry during sealed phase.

local entry = MoveEvent()
entry:type("stepin")

function entry.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return false
	end

	if player:getStorageValue(Storage.SupremeVocation.FireStageAccess) < 1 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The chamber refuses you.")
		position:sendMagicEffect(CONST_ME_FIREAREA)
		return false
	end

	if not SupremeVocation.fireChamberCanEnter() then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The chamber is sealed. Wait for the current attempt to end.")
		position:sendMagicEffect(CONST_ME_FIREAREA)
		return false
	end

	local drop = SupremeVocation.FireChamber.dropPosition
	player:teleportTo(drop, true)
	drop:sendMagicEffect(CONST_ME_TELEPORT)

	if SupremeVocation.fireChamberGetPhase() == "idle" then
		SupremeVocation.fireChamberBeginWaiting()
		SupremeVocation.fireChamberStartTick()
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format(
			"The chamber will seal in %d seconds. Allies may still enter.",
			SupremeVocation.FireChamber.waitingSeconds))
	else
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You join the trial party. The chamber seals soon.")
	end
	return true
end

entry:aid(SupremeVocation.FireEntryActionId)
entry:register()
