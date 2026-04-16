local config = {
	bossName = "Anomaly",
	bossPosition = Position(1032, 919, 15),
}

local monsterTable = {
	[1] = 72500,
	[2] = 145000,
	[3] = 217500,
	[4] = 275500,
}

local chargedAnomalyDeath = CreatureEvent("ChargedAnomalyDeath")

function chargedAnomalyDeath.onDeath(creature)
	if not creature then
		return true
	end

	local healthRemove = monsterTable[Game.getStorageValue(GlobalStorage.HeartOfDestruction.ChargedAnomaly)]
	if not healthRemove then
		return true
	end

	local boss = Game.createMonster(config.bossName, config.bossPosition, false, true)
	if boss then
		boss:addHealth(-healthRemove)
	end

	return true
end

chargedAnomalyDeath:register()
