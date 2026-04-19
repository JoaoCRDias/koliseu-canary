local MAX_MITIGATION_SKILL = 100
local MITIGATION_PER_LEVEL = 0.2

local mitigationPotion = Action()

function mitigationPotion.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local kv = player:kv()
	local currentLevel = kv:get("mitigation_skill") or 0

	if currentLevel >= MAX_MITIGATION_SKILL then
		player:sendTextMessage(MESSAGE_FAILURE, "Your mitigation skill is already at maximum level (100).")
		return true
	end

	item:remove(1)

	if math.random(1, 100) <= 60 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You failed to improve your mitigation skill.")
		player:getPosition():sendMagicEffect(CONST_ME_POFF)
		return true
	end

	local newLevel = currentLevel + 1
	kv:set("mitigation_skill", newLevel)

	player:sendTextMessage(
		MESSAGE_EVENT_ADVANCE,
		string.format(
			"You advanced to mitigation skill level %d. (%.1f%% total mitigation bonus)",
			newLevel,
			newLevel * MITIGATION_PER_LEVEL
		)
	)
	player:getPosition():sendMagicEffect(CONST_ME_MAGIC_GREEN)
	player:sendStats()
	player:sendSkills()

	return true
end

mitigationPotion:id(11372)
mitigationPotion:register()
