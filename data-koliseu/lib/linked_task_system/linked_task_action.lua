--[[
	Linked Task System - Totem Interaction
	Player clicks a totem (action ID 57001-57250) to:
	  - Accept a task (if no active task and this is the next in sequence)
	  - Check progress (if this task is currently active)
	  - Claim reward (if kills are complete)
	  - See status (if already completed)
]]

local linkedTaskTotem = Action()

function linkedTaskTotem.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local actionId = item:getActionId()
	local globalIndex = LinkedTask._actionIdLookup[actionId]
	if not globalIndex then
		return false
	end

	local room, task, info = LinkedTask.getTaskByGlobalIndex(globalIndex)
	if not room or not task then
		return false
	end

	local roomIndex = info.roomIndex
	local taskIndex = info.taskIndex

	-- Check if player can access this room
	if not LinkedTask.canAccessRoom(player, roomIndex) then
		local prevRoom = LinkedTask.Rooms[roomIndex - 1]
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE,
			string.format("[Linked Task] You must complete all tasks in the %s room first.", prevRoom and prevRoom.name or "previous"))
		return true
	end

	-- Check if this task is already completed
	if LinkedTask.isTaskCompleted(player, globalIndex) then
		player:sendTextMessage(MESSAGE_INFO_DESCR,
			string.format("[Linked Task] You have already completed the '%s' task.", task.name))
		return true
	end

	-- Check if this is the correct next task in sequence
	local nextTaskIndex = LinkedTask.getNextTaskInRoom(player, roomIndex)
	if not nextTaskIndex or nextTaskIndex ~= taskIndex then
		local nextTask = nextTaskIndex and room.tasks[nextTaskIndex] or nil
		if nextTask then
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE,
				string.format("[Linked Task] You must complete the '%s' task first.", nextTask.name))
		else
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE,
				"[Linked Task] All tasks in this room are complete. Check the room reward totem.")
		end
		return true
	end

	local activeGlobalIndex = LinkedTask.getActiveTaskGlobalIndex(player)
	local status = LinkedTask.getTaskStatus(player)

	-- Case 1: No active task or different task -> Accept this one
	if activeGlobalIndex ~= globalIndex or status == LinkedTask.Status.NONE then
		-- If player has another active task, they can't start a new one
		if activeGlobalIndex > 0 and status == LinkedTask.Status.ACTIVE then
			local _, activeTask = LinkedTask.getTaskByGlobalIndex(activeGlobalIndex)
			if activeTask then
				player:sendTextMessage(MESSAGE_EVENT_ADVANCE,
					string.format("[Linked Task] You already have an active task: '%s'. Complete it first.", activeTask.name))
				return true
			end
		end

		-- Accept the task
		player:setStorageValue(LinkedTask.Storages.QUEST_LOG, 1)
		player:setStorageValue(LinkedTask.Storages.ACTIVE_ROOM, roomIndex)
		player:setStorageValue(LinkedTask.Storages.ACTIVE_TASK_INDEX, globalIndex)
		player:setStorageValue(LinkedTask.Storages.KILL_COUNT, 0)
		player:setStorageValue(LinkedTask.Storages.TASK_STATUS, LinkedTask.Status.ACTIVE)

		local required = LinkedTask.getKillsRequired(roomIndex, taskIndex)
		local raceList = table.concat(task.races, ", ")
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE,
			string.format("[Linked Task] Task accepted: %s\nRoom: %s (%d/%d)\nKill %s creatures: 0/%s\nMonsters: %s",
				task.name,
				room.name,
				taskIndex, #room.tasks,
				LinkedTask.formatNumber(required),
				LinkedTask.formatNumber(required),
				raceList))

		player:sendTextMessage(MESSAGE_STATUS,
			string.format("Linked Task '%s' started. Kill %s monsters.",
				task.name, LinkedTask.formatNumber(required)))
		return true
	end

	-- Case 2: This is the active task
	if activeGlobalIndex == globalIndex then
		local kills = LinkedTask.getKillCount(player)

		-- Task is active, show progress
		local required = LinkedTask.getKillsRequired(roomIndex, taskIndex)
		if status == LinkedTask.Status.ACTIVE then
			if kills >= required then
				-- Kills complete! Mark as ready for reward
				player:setStorageValue(LinkedTask.Storages.TASK_STATUS, LinkedTask.Status.KILLS_COMPLETE)
				status = LinkedTask.Status.KILLS_COMPLETE
			else
				player:sendTextMessage(MESSAGE_EVENT_ADVANCE,
					string.format("[Linked Task] %s - Progress: %s/%s kills.",
						task.name,
						LinkedTask.formatNumber(kills),
						LinkedTask.formatNumber(required)))
				return true
			end
		end

		-- Task kills complete -> Claim reward
		if status == LinkedTask.Status.KILLS_COMPLETE then
			-- Mark task as completed
			player:setStorageValue(LinkedTask.Storages.TASK_STATUS, LinkedTask.Status.REWARD_CLAIMED)
			player:setStorageValue(LinkedTask.Storages.TASK_COMPLETE_BASE + globalIndex, 1)
			player:setStorageValue(LinkedTask.Storages.ACTIVE_TASK_INDEX, 0)
			player:setStorageValue(LinkedTask.Storages.KILL_COUNT, 0)
			player:setStorageValue(LinkedTask.Storages.TASK_STATUS, LinkedTask.Status.NONE)

			player:sendTextMessage(MESSAGE_EVENT_ADVANCE,
				string.format("[Linked Task] Task '%s' completed! Here are your rewards:", task.name))

			-- Apply individual task rewards
			LinkedTask.applyRewards(player, task.rewards)

			-- Check if entire room is now complete
			if LinkedTask.areAllTasksCompleted(player, roomIndex) then
				player:setStorageValue(LinkedTask.Storages.ROOM_COMPLETE_BASE + roomIndex - 1, 1)
				player:sendTextMessage(MESSAGE_EVENT_ADVANCE,
					string.format("\n[Linked Task] === ROOM '%s' COMPLETED! === \nSpecial room rewards:", room.name:upper()))

				-- Apply room completion rewards
				LinkedTask.applyRewards(player, room.roomReward)

				-- Advance to next room if available
				if roomIndex < #LinkedTask.Rooms then
					player:setStorageValue(LinkedTask.Storages.ACTIVE_ROOM, roomIndex + 1)
					local nextRoom = LinkedTask.Rooms[roomIndex + 1]
					player:sendTextMessage(MESSAGE_EVENT_ADVANCE,
						string.format("[Linked Task] The %s room is now unlocked!", nextRoom.name))
				else
					player:sendTextMessage(MESSAGE_EVENT_ADVANCE,
						"[Linked Task] Congratulations! You have completed ALL linked tasks!")
				end
			end

			-- Visual effects
			player:getPosition():sendMagicEffect(CONST_ME_HOLYDAMAGE)
			return true
		end
	end

	return true
end

-- Register for all possible action IDs
for actionId, _ in pairs(LinkedTask._actionIdLookup) do
	linkedTaskTotem:aid(actionId)
end
linkedTaskTotem:register()

print("[LinkedTask] Registered totem actions for " .. LinkedTask._totalTasks .. " tasks (AIDs " ..
	(LinkedTask.ACTION_ID_BASE + 1) .. "-" .. (LinkedTask.ACTION_ID_BASE + LinkedTask._totalTasks) .. ")")
