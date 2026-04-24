-- Any tile tagged with DeathLabyrinthTrapActionId teleports the player back
-- to the labyrinth start. The real path sqms are left without the action id.

local trap = MoveEvent()
trap:type("stepin")

function trap.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return false
	end

	local cfg = SupremeVocation.DeathChamber
	player:teleportTo(cfg.labyrinthStart, true)
	cfg.labyrinthStart:sendMagicEffect(CONST_ME_TELEPORT)
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You step into nothingness and find yourself back at the start.")
	return true
end

trap:aid(SupremeVocation.DeathLabyrinthTrapActionId)
trap:register()
