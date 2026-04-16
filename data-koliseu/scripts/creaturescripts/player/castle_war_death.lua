local castleDeath = CreatureEvent("CastleWarDeath")
function castleDeath.onPrepareDeath(creature, killer)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	local pos = player:getPosition()
	local inCastle = false
	for _, area in pairs(Castle.config.castleAreas) do
		if pos:isInRange(area.fromPosition, area.toPosition) then
			inCastle = true
			break
		end
	end

	if not inCastle then
		return true
	end

	-- Send to castle prison, heal, and prevent actual death
	Castle:sendToPrison(player)
	player:addHealth(player:getMaxHealth())
	player:addMana(player:getMaxMana())
	player:removeCondition(CONDITION_FIRE)
	player:removeCondition(CONDITION_ENERGY)
	player:removeCondition(CONDITION_POISON)
	player:removeCondition(CONDITION_BLEEDING)
	player:removeCondition(CONDITION_CURSED)
	player:removeCondition(CONDITION_DAZZLED)
	player:removeCondition(CONDITION_FREEZING)
	player:removeCondition(CONDITION_AGONY)
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "[Castle War] You have been defeated! You were sent to the prison.")

	return false
end
castleDeath:register()

local castleDeathLogin = CreatureEvent("CastleWarDeathLogin")
function castleDeathLogin.onLogin(player)
	player:registerEvent("CastleWarDeath")
	return true
end
castleDeathLogin:register()
