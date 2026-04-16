--[[
	Linked Task System - Kill Tracking
	Registers a CreatureEvent on all linked task monsters.
	On death, checks if any damage dealer has this monster's task active
	and increments their kill counter.
]]

local linkedTaskKill = CreatureEvent("LinkedTaskKill")

function linkedTaskKill.onDeath(creature)
	local monsterName = creature:getName()
	local taskInfo = LinkedTask.getTaskByMonster(monsterName)
	if not taskInfo then
		return true
	end

	local targetGlobalIndex = taskInfo.globalIndex
	local room = LinkedTask.Rooms[taskInfo.roomIndex]
	if not room then
		return true
	end

	-- Iterate damage dealers
	for attackerId, _ in pairs(creature:getDamageMap()) do
		local attacker = Creature(attackerId)
		if attacker then
			-- Resolve summoner
			local master = attacker:getMaster()
			local player = (master and master:isPlayer()) and master or (attacker:isPlayer() and attacker or nil)

			if player then
				local activeGlobalIndex = LinkedTask.getActiveTaskGlobalIndex(player)
				local status = LinkedTask.getTaskStatus(player)

				-- Only count if this is the player's active task and it's in progress
				if activeGlobalIndex == targetGlobalIndex and status == LinkedTask.Status.ACTIVE then
					local kills = LinkedTask.getKillCount(player) + 1
					player:setStorageValue(LinkedTask.Storages.KILL_COUNT, kills)

					local taskName = LinkedTask.Rooms[taskInfo.roomIndex].tasks[taskInfo.taskIndex].name
					local required = LinkedTask.getKillsRequired(taskInfo.roomIndex, taskInfo.taskIndex)
					local percent = math.floor((kills / required) * 100)
					local prevPercent = math.floor(((kills - 1) / required) * 100)

					local progressMsg = string.format("[Linked Task - %s] Progress: %s/%s",
						taskName,
						LinkedTask.formatNumber(kills),
						LinkedTask.formatNumber(required))
					player:sendChannelMessage(player, progressMsg, TALKTYPE_CHANNEL_O, 9)

					if kills >= required then
						player:setStorageValue(LinkedTask.Storages.TASK_STATUS, LinkedTask.Status.KILLS_COMPLETE)
						local completionMsg = string.format("[Linked Task - %s] Complete! Return to the totem to claim your reward.", taskName)
						player:sendTextMessage(MESSAGE_EVENT_ADVANCE, completionMsg)
						player:sendChannelMessage(player, completionMsg, TALKTYPE_CHANNEL_O, 9)
						player:getPosition():sendMagicEffect(CONST_ME_FIREWORK_YELLOW)
					elseif percent >= 10 and math.floor(percent / 10) > math.floor(prevPercent / 10) then
						player:sendTextMessage(MESSAGE_STATUS,
							string.format("[Linked Task] Progress: %s/%s (%d%%)",
								LinkedTask.formatNumber(kills),
								LinkedTask.formatNumber(required),
								percent))
					end
				end
			end
		end
	end

	return true
end

linkedTaskKill:register()
