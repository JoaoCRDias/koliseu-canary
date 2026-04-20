local talk = TalkAction("!pz")

local function getBattleTime(player)
	local condition = player:getCondition(CONDITION_INFIGHT, CONDITIONID_DEFAULT)
	if not condition then
		return 0
	end

	local ticks = condition:getTicks() or 0
	if ticks <= 0 then
		return 0
	end

	return math.ceil(ticks / 1000)
end

function talk.onSay(player, words, param)
	local seconds = getBattleTime(player)
	if seconds <= 0 then
		if player:isPzLocked() then
			player:sendCancelMessage("You are still PZ-locked, wait a moment.")
		else
			player:sendCancelMessage("You are not in battle right now.")
		end
		return true
	end

	local minutes = math.floor(seconds / 60)
	local remainingSeconds = seconds % 60
	player:sendCancelMessage(string.format("Battle/PZ ends in %d minute(s) and %d second(s).", minutes, remainingSeconds))
	return true
end

talk:setDescription("Shows how long until you leave battle/PZ.")
talk:groupType("normal")
talk:register()
