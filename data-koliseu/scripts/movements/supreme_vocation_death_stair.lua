-- Stepin on the stair/portal leading from the puzzle room to the labyrinth.
-- Only players who solved the skeleton puzzle may pass. On success the player
-- is teleported straight to the labyrinth start.

local stair = MoveEvent()
stair:type("stepin")

function stair.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return false
	end

	logger.info(string.format("[DeathStair] player=%s solved=%s pos=(%d,%d,%d)",
		player:getName(), tostring(SupremeVocation.hasSolvedDeathPuzzle(player)),
		position.x, position.y, position.z))

	if not SupremeVocation.hasSolvedDeathPuzzle(player) then
		player:teleportTo(fromPosition, true)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The stair refuses you. Recite the rite to the skeletons first.")
		fromPosition:sendMagicEffect(CONST_ME_MORTAREA)
		return false
	end

	local dest = SupremeVocation.DeathChamber.labyrinthStart
	player:teleportTo(dest, true)
	dest:sendMagicEffect(CONST_ME_TELEPORT)
	return true
end

stair:aid(SupremeVocation.DeathStairActionId)
stair:register()
