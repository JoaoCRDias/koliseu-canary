local energyPrismDeath = CreatureEvent("EnergyPrismDeath")
function energyPrismDeath.onDeath(creature)
	stopEvent(Storage.ForgottenKnowledge.LloydEvent)
	local tile = Tile(Position(1378, 1038, 15))
	if not tile then
		return false
	end
	local lloyd = tile:getTopCreature()
	if lloyd then
		lloyd:teleportTo(Position(1378, 1041, 15))
		lloyd:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	end
	return true
end

energyPrismDeath:register()
