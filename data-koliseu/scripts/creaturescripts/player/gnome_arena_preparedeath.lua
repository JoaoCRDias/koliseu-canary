local gnomeArenaPrepareDeath = CreatureEvent("GnomeArenaPrepareDeath")

function gnomeArenaPrepareDeath.onPrepareDeath(player, killer, realDamage)
	if not player or not player:isPlayer() then
		return true
	end

	if not GnomeArena or not GnomeArena._active then
		return true
	end

	if not GnomeArena.isPlayerInside(player) then
		return true
	end

	GnomeArena.finishPlayer(player, { reason = "death" })
	return false
end

gnomeArenaPrepareDeath:register()
