-- Step-in tile (or destination of the entry teleport) for the poison room.
--
-- States it interacts with:
--   * idle    -> begin a new attempt: start the 10s waiting window, start tick.
--   * waiting -> the player joins; the seal countdown is already running.
--   * sealed  -> entry is rejected; player is teleported back.

local entry = MoveEvent()
entry:type("stepin")

function entry.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return false
	end

	if player:getStorageValue(Storage.SupremeVocation.PoisonStageAccess) < 1 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The chamber refuses you.")
		position:sendMagicEffect(CONST_ME_POISONAREA)
		return false
	end

	if not SupremeVocation.poisonRoomCanEnter() then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The chamber is sealed. Wait for the current attempt to end.")
		position:sendMagicEffect(CONST_ME_POISONAREA)
		return false
	end

	-- Teleport the player into the chamber.
	local drop = SupremeVocation.PoisonRoom.dropPosition
	player:teleportTo(drop, true)
	drop:sendMagicEffect(CONST_ME_TELEPORT)

	if SupremeVocation.poisonRoomGetPhase() == "idle" then
		SupremeVocation.poisonRoomBeginWaiting()
		SupremeVocation.poisonRoomStartTick()
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format(
			"The chamber will seal in %d seconds. Allies may still enter.",
			SupremeVocation.PoisonRoom.waitingSeconds))
	else
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You join the trial party. The chamber seals soon.")
	end

	SupremeVocation.poisonRoomEnsurePlayerState(player)
	return true
end

entry:aid(SupremeVocation.PoisonEntryActionId)
entry:register()
