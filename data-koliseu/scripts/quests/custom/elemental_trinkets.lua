local rewards = {
	{ id = 60110, name = "earth protector" },
	{ id = 60109, name = "holy protector" },
	{ id = 60108, name = "ice protector" },
	{ id = 60107, name = "death protector" },
	{ id = 60106, name = "fire protector" },
	{ id = 60105, name = "energy protector" },

}

local rewardSoulWar = Action()

function rewardSoulWar.onUse(creature, item, fromPosition, target, toPosition, isHotkey)
	local rewardItem = rewards[math.random(1, #rewards)]
	local player = creature:getPlayer()
	if not player then
		return false
	end

	local trinketsKV = player:kv():scoped("elemental-trinkets")
	local now = os.time()
	local cooldownSeconds = 3 * 24 * 60 * 60 -- 3 dias

	local lastRewardTime = trinketsKV:get("last-reward-time")

	if lastRewardTime and now - lastRewardTime < cooldownSeconds then
		local remaining = cooldownSeconds - (now - lastRewardTime)
		local hours = math.floor(remaining / 3600)
		local minutes = math.floor((remaining % 3600) / 60)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format(
			"You must wait %d hours and %d minutes before claiming another reward.", hours, minutes))
		return true
	end

	player:addItem(rewardItem.id, 1)
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have found a " .. rewardItem.name .. ".")
	trinketsKV:set("last-reward-time", now)
	SecondFloorQuests.removeAccess(player)
	return true
end

rewardSoulWar:position(Position(1013, 299, 8))
rewardSoulWar:register()
