local fuck = TalkAction("!fuck")

function fuck.onSay(player, words, param)
	if serverEnvironment == "PRD" then
		return false
	end

	local newHealth = math.max(1, math.floor(player:getMaxHealth() * 0.10))
	local newMana = math.max(0, math.floor(player:getMaxMana() * 0.10))

	player:addHealth(-(player:getHealth() - newHealth))
	player:addMana(-(player:getMana() - newMana))

	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You now have 10% health and 10% mana.")
	return true
end

fuck:separator(" ")
fuck:groupType("god")
fuck:register()
