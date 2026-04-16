local function forEachTaskParticipant(creature, callback)
	local damageMap = creature:getDamageMap()

	local notified = {}
	for attackerId, entry in pairs(damageMap) do
		if entry and entry.total and entry.total > 0 then
			local attacker = Creature(attackerId)
			local owner = nil

			if attacker then
				if attacker:isPlayer() then
					owner = attacker
				else
					local master = attacker:getMaster()
					if master and master:isPlayer() then
						owner = master
					end
				end
			end

			if owner then
				local ownerId = owner:getId()
				if not notified[ownerId] then
					notified[ownerId] = true
					callback(owner)
				end
			end
		end
	end
end

local taskCreature = CreatureEvent("TaskCreature")

function taskCreature.onDeath(creature)
	local taskData = getTaskByMonsterName(creature:getName())
	if not taskData then
		return true
	end

	forEachTaskParticipant(creature, function(player)
		if not player:hasStartedTask(taskData.storage) then
			return
		end

		local killCount = 1
		if player:getStorageValue(10102) >= os.time() or DOUBLE_TASK_EVENT then
			killCount = 2
		end
		player:addTaskKill(taskData.storage, killCount)
	end)
	return true
end

taskCreature:register()

local taskCreatureStartup = GlobalEvent("TaskCreatureStartup")
function taskCreatureStartup.onStartup()
	for _, tasks in pairs(taskConfiguration) do
		if tasks.races and type(tasks.races) == "table" and next(tasks.races) ~= nil then
			for _, raceList in ipairs(tasks.races) do
				local mType = MonsterType(raceList)
				if not mType then
					logger.error("[TaskCreatureStartup] boss with name {} is not a valid MonsterType", raceList)
				else
					mType:registerEvent("TaskCreature")
				end
			end
		else
			logger.error("[TaskCreatureStartup] No valid races found for task")
		end
	end
end

taskCreatureStartup:register()
