-- Central mechanism for the supreme vocation lever puzzle.
-- Reads the 5x4 lever grid state and compares it to the globally active pattern
-- (which rotates every few minutes). Every attempt resets all levers, whether
-- the player succeeds or not — there are no second tries on the same layout.

local mechanism = Action()

function mechanism.onUse(creature, item, fromPosition, target, toPosition, isHotkey)
	local player = creature:getPlayer()
	if not player then
		return false
	end

	if not SupremeVocation.hasStartedMountain(player) then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The mechanism does not respond to you. Speak with the elder warrior first.")
		return true
	end

	if SupremeVocation.hasMountainAccess(player) then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have already earned passage. The mountain lies open to you.")
		return true
	end

	local pattern = SupremeVocation.getActivePattern()
	if not pattern then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The mechanism is dormant. Wait a moment and try again.")
		return true
	end

	local state = SupremeVocation.readLeverState()
	local total = SupremeVocation.GRID_ROWS * SupremeVocation.GRID_COLS
	local matches = SupremeVocation.countMatches(state, pattern)
	local success = matches == total

	if success then
		SupremeVocation.grantMountainAccess(player)
		SupremeVocation.startReport(player)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The stones align. The mountain opens its first gate to you. The elder warrior awaits your report.")
		item:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
	else
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format(
			"The mechanism hums. %d of %d stones align with the mountain's will. The rest fall back to rest.",
			matches, total
		))
		item:getPosition():sendMagicEffect(CONST_ME_POFF)
	end

	-- Every attempt consumes the current lever layout.
	SupremeVocation.resetAllLevers()

	return true
end

mechanism:aid(SupremeVocation.MechanismActionId)
mechanism:register()
