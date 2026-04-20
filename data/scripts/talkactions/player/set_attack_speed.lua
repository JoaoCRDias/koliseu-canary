-- !as — Dev-only: set/read the player's Attack Speed skill level for
-- testing the spell cooldown reduction (CDR) system.
local setAttackSpeed = TalkAction("!as")

function setAttackSpeed.onSay(player, words, param)
	if serverEnvironment ~= "DEV" then
		player:sendCancelMessage("This command is only available in DEV environment.")
		return true
	end

	if param == "" then
		local currentLevel = player:getSkillLevel(SKILL_ATTACK_SPEED)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("Your current attack speed skill: %d", currentLevel))
		return true
	end

	local level = tonumber(param)
	if not level or level < 0 or level > 10000 then
		player:sendCancelMessage("Usage: !as <level> (0-10000)")
		return true
	end

	player:setSkillLevel(SKILL_ATTACK_SPEED, level)
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("Attack speed skill set to %d.", level))
	return true
end

setAttackSpeed:separator(" ")
setAttackSpeed:groupType("normal")
setAttackSpeed:register()
