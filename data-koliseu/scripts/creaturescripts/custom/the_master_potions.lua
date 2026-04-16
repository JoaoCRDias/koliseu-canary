local TheMasterOfPotionsCreatureEvent = CreatureEvent("TheMasterOfPotionsCreatureEvent")
function TheMasterOfPotionsCreatureEvent.onDeath(creature, _corpse, _lastHitKiller, mostDamageKiller)
	onDeathForParty(creature, mostDamageKiller, function(creature, player)
		local value = player:getStorageValue(Storage.TheMasterHealer.KillCount) or 0
		local isActive = player:getStorageValue(Storage.TheMasterHealer.Mission03) == 0
		if isActive and value < 10000 then
			player:setStorageValue(Storage.TheMasterHealer.KillCount, value + 1)
			player:setStorageValue(Storage.TheMasterHealer.Mission03, 0)
		end
		if value >= 10000 and player:getStorageValue(Storage.TheMasterHealer.Mission03) ~= 1 then
			player:say("You have successfully hunted 10000 creatures. Your potions are now boosted with 20% healing bonus.", TALKTYPE_MONSTER_SAY)
			player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
			player:setStorageValue(Storage.TheMasterHealer.BoostStage, 2)
			player:setStorageValue(Storage.TheMasterHealer.Mission03, 1)
		end
	end)
	return true
end

TheMasterOfPotionsCreatureEvent:register()
