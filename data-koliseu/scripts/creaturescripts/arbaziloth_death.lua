local arbazilothDeath = CreatureEvent("ArbazilothDeath")

function arbazilothDeath.onDeath(creature, corpse, killer, mostDamageKiller, lastHitUnjustified, mostDamageUnjustified)
	if not creature then
		return true
	end

	-- Itera sobre todos os jogadores que causaram dano ao boss
	onDeathForDamagingPlayers(creature, function(creature, player)
		if player then
			-- Define o storage 47975 como true (1) para cada participante
			player:setStorageValue(47975, 1)
		end
	end)

	return true
end

arbazilothDeath:register()
