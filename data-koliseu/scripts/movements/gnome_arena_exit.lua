local gnomeArenaExit = MoveEvent()

function gnomeArenaExit.onStepIn(creature, item, position, fromPosition)
	local player = creature and creature:getPlayer()
	if not player then
		return true
	end

	if not GnomeArena then
		return true
	end

	if not GnomeArena.isInside(position) then
		return true
	end

	GnomeArena.finishPlayer(player, {
		reason = "exit",
		force = true,
	})
	return true
end

gnomeArenaExit:type("stepin")
gnomeArenaExit:aid(GnomeArena.EXIT_TELEPORT_AID)
gnomeArenaExit:register()
