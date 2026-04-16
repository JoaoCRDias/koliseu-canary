local callback = EventCallback("PlayerOnSoulSealsFightBaseEvent")

function callback.playerOnSoulSealsFight(player, monsterName)
	return SoulPit.startFight(player, monsterName)
end

callback:register()
