local config = {
	centerPosition = Position(1810, 1013, 15), -- Center Room
	exitPosition = Position(1852, 1036, 15), -- Exit Position
	rangeX = 24,
	rangeY = 18,
}

local lionCommanderDeath = CreatureEvent("LionCommanderDeath")
function lionCommanderDeath.onPrepareDeath(creature)
	local totalCommanders = Game.getStorageValue(GlobalStorage.TheOrderOfTheLion.Drume.TotalLionCommanders)
	if totalCommanders > 1 then
		Game.setStorageValue(GlobalStorage.TheOrderOfTheLion.Drume.TotalLionCommanders, totalCommanders - 1)
	else
		local spectators = Game.getSpectators(config.centerPosition, false, false, config.rangeX, config.rangeX, config.rangeY, config.rangeY)
		for _, spectator in pairs(spectators) do
			if spectator:isMonster() and not spectator:getMaster() then
				spectator:remove()
			elseif spectator:isPlayer() then
				spectator:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You lost the skirmish.")
				spectator:teleportTo(config.exitPosition)
			end
		end
		config.exitPosition:sendMagicEffect(CONST_ME_TELEPORT)
	end
	return true
end

lionCommanderDeath:register()

local usurperCommanderDeath = CreatureEvent("UsurperCommanderDeath")
function usurperCommanderDeath.onPrepareDeath(creature)
	local totalCommanders = Game.getStorageValue(GlobalStorage.TheOrderOfTheLion.Drume.TotalUsurperCommanders)
	if totalCommanders > 0 then
		Game.setStorageValue(GlobalStorage.TheOrderOfTheLion.Drume.TotalUsurperCommanders, totalCommanders - 1)
		if totalCommanders == 1 then
			Game.createMonster("Kesar", Position(1809, 1009, 15), false, true)
			Game.createMonster("Drume", Position(1809, 1010, 15), false, true)
		end
	end
	return true
end

usurperCommanderDeath:register()

local kesarHealthChange = CreatureEvent("KesarImmortal")
function kesarHealthChange.onHealthChange(creature, attacker, primaryDamage, primaryType, secondaryDamage, secondaryType, origin)
	return 0, 0, 0, 0
end

kesarHealthChange:register()
