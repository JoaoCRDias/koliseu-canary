-- Task Portal Bestiary Check
-- Blocks portal access if player hasn't completed bestiary for all task monsters

-- Monsters excluded from bestiary check (no bestiary entry available)
local EXCLUDED_MONSTERS = {
	["knight's apparition"] = true,
	["druid's apparition"] = true,
	["paladin's apparition"] = true,
	["sorcerer's apparition"] = true,
}

-- Helper: check if player has completed bestiary for all monsters in a task tier
local function hasAllBestiaryForTask(player, taskName)
	for _, taskData in pairs(taskConfiguration) do
		if taskData.name == taskName then
			for _, monsterName in ipairs(taskData.races) do
				if not EXCLUDED_MONSTERS[monsterName:lower()] then
					local mType = MonsterType(monsterName)
					if mType and mType:raceId() > 0 then
						if not player:isMonsterBestiaryUnlocked(mType:raceId()) then
							return false, monsterName
						end
					end
				end
			end
			return true, nil
		end
	end
	return false, nil
end

-- Helper: count completed/total bestiary for a task tier
local function getBestiaryProgress(player, taskName)
	local completed = 0
	local total = 0
	for _, taskData in pairs(taskConfiguration) do
		if taskData.name == taskName then
			for _, monsterName in ipairs(taskData.races) do
				if not EXCLUDED_MONSTERS[monsterName:lower()] then
					local mType = MonsterType(monsterName)
					if mType and mType:raceId() > 0 then
						total = total + 1
						if player:isMonsterBestiaryUnlocked(mType:raceId()) then
							completed = completed + 1
						end
					end
				end
			end
			break
		end
	end
	return completed, total
end

-- Epic Portal (ActionID 53199)
-- Requires: all hard task monsters bestiary completed
local epicPortal = MoveEvent()

function epicPortal.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return false
	end

	local hasAll, missingMonster = hasAllBestiaryForTask(player, "hard")
	if not hasAll then
		local completed, total = getBestiaryProgress(player, "hard")
		player:teleportTo(fromPosition, true)
		player:getPosition():sendMagicEffect(CONST_ME_POFF)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE,
			string.format("You need to complete the bestiary of all hard task monsters to enter this portal. (%d/%d completed, missing: %s)",
				completed, total, missingMonster or "unknown"))
		return false
	end

	return true
end

epicPortal:type("stepin")
epicPortal:aid(53199)
epicPortal:register()

print(">> Task Portal Bestiary Check loaded (epic: 53199)")
