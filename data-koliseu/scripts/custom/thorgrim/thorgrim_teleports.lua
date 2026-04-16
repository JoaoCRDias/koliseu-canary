local HAZARD_NAME = "hazard.edron-kingdom"

-- Helper: check if player has completed bestiary for all monsters in a task tier
local function hasAllBestiaryForTask(player, taskName)
	for _, taskData in pairs(taskConfiguration) do
		if taskData.name == taskName then
			for _, monsterName in ipairs(taskData.races) do
				local mType = MonsterType(monsterName)
				if mType and mType:raceId() > 0 then
					if not player:isMonsterBestiaryUnlocked(mType:raceId()) then
						return false, monsterName
					end
				end
			end
			return true, nil
		end
	end
	return false, nil
end

local function getBestiaryProgress(player, taskName)
	local completed = 0
	local total = 0
	for _, taskData in pairs(taskConfiguration) do
		if taskData.name == taskName then
			for _, monsterName in ipairs(taskData.races) do
				local mType = MonsterType(monsterName)
				if mType and mType:raceId() > 0 then
					total = total + 1
					if player:isMonsterBestiaryUnlocked(mType:raceId()) then
						completed = completed + 1
					end
				end
			end
			break
		end
	end
	return completed, total
end

-- ActionID 53200: entrance gate
-- Requires: all epic task monsters bestiary completed + Thorgrim kill check
local gate1 = MoveEvent()

function gate1.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return false
	end

	-- Check epic bestiary requirement
	local hasAll, missingMonster = hasAllBestiaryForTask(player, "epic")
	if not hasAll then
		local completed, total = getBestiaryProgress(player, "epic")
		player:teleportTo(fromPosition, true)
		player:getPosition():sendMagicEffect(CONST_ME_POFF)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE,
			string.format("You need to complete the bestiary of all epic task monsters to enter this portal. (%d/%d completed, missing: %s)",
				completed, total, missingMonster or "unknown"))
		return false
	end

	local hazard = Hazard.getByName(HAZARD_NAME)
	local maxLevel = hazard and hazard:getPlayerMaxLevel(player) or 0

	if maxLevel < 2 then
		-- Never killed Thorgrim
		player:teleportTo(Position(3109, 3165, 4))
	else
		-- Already killed Thorgrim
		player:teleportTo(Position(3191, 3156, 4))
	end

	player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	return true
end

gate1:aid(53200)
gate1:register()

-- ActionID 53201: second gate
local gate2 = MoveEvent()

function gate2.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return false
	end

	local hazard = Hazard.getByName(HAZARD_NAME)
	local maxLevel = hazard and hazard:getPlayerMaxLevel(player) or 0

	if maxLevel >= 2 then
		-- Already killed Thorgrim
		player:teleportTo(Position(3190, 3156, 4))
	else
		-- Never killed Thorgrim
		player:teleportTo(Position(781, 1133, 3))
	end

	player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	return true
end

gate2:aid(53201)
gate2:register()

-- ActionID 53201: second gate
local gate3 = MoveEvent()

function gate3.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return false
	end
	player:teleportTo(Position(3163, 3156, 4))
	player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	return true
end

gate3:aid(53202)
gate3:register()
