-- Central mechanism for the four basins of the nature sanctum. Checks that
-- each basin holds a different extract; on success, consumes them, opens the
-- portal for a limited window, and marks the player's mission as advanced.

local mechanism = Action()

function mechanism.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if player:getStorageValue(Storage.SupremeVocation.MissionReport) < 2 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The mechanism is dormant. Report the trial to the elder warrior first.")
		return true
	end

	if not SupremeVocation.validateBasins() then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The basins reject your offering.")
		item:getPosition():sendMagicEffect(CONST_ME_POFF)
		return true
	end

	SupremeVocation.consumeBasinExtracts()
	SupremeVocation.openBasinPortal()
	SupremeVocation.markBasinRitualOpened(player)

	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format(
		"The basins accept the ritual. A portal has opened for %d seconds.",
		SupremeVocation.BasinRitual.portalDurationSeconds))
	item:getPosition():sendMagicEffect(CONST_ME_MAGIC_GREEN)
	return true
end

mechanism:aid(SupremeVocation.BasinRitual.mechanismActionId)
mechanism:register()
