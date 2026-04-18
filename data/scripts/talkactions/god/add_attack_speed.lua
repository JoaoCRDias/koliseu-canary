local addAttackSpeed = TalkAction("/addattackspeed")

function addAttackSpeed.onSay(player, words, param)
	if param == "" then
		player:sendCancelMessage("Command param required.")
		return true
	end

	local split = param:split(",")
	if #split < 2 then
		player:sendCancelMessage("Usage: /addattackspeed <playername>, <levels>")
		return true
	end

	local targetPlayerName = split[1]:trim()
	local targetPlayer = Player(targetPlayerName)

	if not targetPlayer then
		player:sendCancelMessage("Player not found.")
		return true
	end

	local skillIncreaseAmount = tonumber(split[2]) or 1

	for _ = 1, skillIncreaseAmount do
		local requiredSkillTries = targetPlayer:getVocation():getRequiredSkillTries(SKILL_ATTACK_SPEED, targetPlayer:getSkillLevel(SKILL_ATTACK_SPEED) + 1)
		targetPlayer:addSkillTries(SKILL_ATTACK_SPEED, requiredSkillTries - targetPlayer:getSkillTries(SKILL_ATTACK_SPEED), true)
	end

	local skillText = (skillIncreaseAmount > 1) and "attack speed levels" or "attack speed level"
	targetPlayer:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("%s has added %d %s to you.", player:getName(), skillIncreaseAmount, skillText))
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("You have successfully added %d %s to player %s.", skillIncreaseAmount, skillText, targetPlayer:getName()))

	return true
end

addAttackSpeed:separator(" ")
addAttackSpeed:groupType("god")
addAttackSpeed:register()
