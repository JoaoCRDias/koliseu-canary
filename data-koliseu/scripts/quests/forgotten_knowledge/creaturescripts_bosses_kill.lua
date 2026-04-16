local bossesForgottenKill = CreatureEvent("ForgottenKnowledgeBossDeath")

function bossesForgottenKill.onDeath(creature)
	onDeathForDamagingPlayers(creature, function(creature, player)
		player:kv():set(creature:getName():lower(), true)
	end)
	return true
end

bossesForgottenKill:register()
