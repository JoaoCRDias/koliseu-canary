--[[
	Linked Task System - Player Talkaction
	!linkedtask - Show current linked task progress and bonuses
]]

local linkedTaskTalk = TalkAction("!linkedtask", "!ltask")

function linkedTaskTalk.onSay(player, words, param, type)
	if not LinkedTask then
		player:sendTextMessage(MESSAGE_STATUS_CONSOLE_RED, "Linked Task system is not loaded.")
		return true
	end

	local activeGlobalIndex = LinkedTask.getActiveTaskGlobalIndex(player)
	local status = LinkedTask.getTaskStatus(player)

	local lines = {}

	-- Active task details (on top)
	if activeGlobalIndex > 0 and status > LinkedTask.Status.NONE then
		local room, task, info = LinkedTask.getTaskByGlobalIndex(activeGlobalIndex)
		if room and task and info then
			local kills = LinkedTask.getKillCount(player)
			local required = LinkedTask.getKillsRequired(info.roomIndex, info.taskIndex)
			local statusText = "In progress"
			if status == LinkedTask.Status.KILLS_COMPLETE then
				statusText = "COMPLETED - Return to totem!"
			end

			lines[#lines + 1] = "--- Active Task ---"
			lines[#lines + 1] = string.format("Task: %s", task.name)
			lines[#lines + 1] = string.format("Room: %s", room.name)
			lines[#lines + 1] = string.format("Progress: %s/%s kills",
				LinkedTask.formatNumber(kills),
				LinkedTask.formatNumber(required))
			lines[#lines + 1] = string.format("Status: %s", statusText)
		end
	else
		lines[#lines + 1] = "No active task. Visit a totem to start one."
	end

	-- Room status
	lines[#lines + 1] = ""
	lines[#lines + 1] = "--- Rooms ---"
	for roomIndex, room in ipairs(LinkedTask.Rooms) do
		local completed = LinkedTask.isRoomCompleted(player, roomIndex)
		local accessible = LinkedTask.canAccessRoom(player, roomIndex)

		if completed then
			lines[#lines + 1] = string.format("[v] %s - COMPLETED", room.name)
		elseif accessible then
			local completedTasks = 0
			for taskIdx, _ in ipairs(room.tasks) do
				local gi = LinkedTask.getGlobalIndex(roomIndex, taskIdx)
				if LinkedTask.isTaskCompleted(player, gi) then
					completedTasks = completedTasks + 1
				end
			end
			lines[#lines + 1] = string.format("[>] %s - %d/%d tasks", room.name, completedTasks, #room.tasks)
		else
			lines[#lines + 1] = string.format("[x] %s - LOCKED", room.name)
		end
	end

	-- Permanent bonuses
	local xpBonus = LinkedTask.getPlayerBonusXP(player)
	local lootBonus = LinkedTask.getPlayerBonusLoot(player)
	local forgeBonus = LinkedTask.getPlayerBonusForge(player)

	if xpBonus > 0 or lootBonus > 0 or forgeBonus > 0 then
		lines[#lines + 1] = ""
		lines[#lines + 1] = "--- Permanent Bonuses ---"
		if xpBonus > 0 then
			lines[#lines + 1] = string.format("XP Bonus: +%d%%", xpBonus)
		end
		if lootBonus > 0 then
			lines[#lines + 1] = string.format("Loot Bonus: +%d%%", lootBonus)
		end
		if forgeBonus > 0 then
			lines[#lines + 1] = string.format("Forge Success: +%d%%", forgeBonus)
		end
	end

	local window = ModalWindow({
		title = "Linked Task Progress",
		message = table.concat(lines, "\n"),
	})
	window:addButton("Close", function() return true end)
	window:setDefaultEnterButton(0)
	window:setDefaultEscapeButton(0)
	window:sendToPlayer(player)
	return true
end

linkedTaskTalk:separator(" ")
linkedTaskTalk:groupType("normal")
linkedTaskTalk:register()
