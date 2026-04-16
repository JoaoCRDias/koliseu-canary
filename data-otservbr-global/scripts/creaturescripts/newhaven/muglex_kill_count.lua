local NEWHAVEN_GOBLIN_QUEST_START = 100001
local MUGLEX_KILL_COUNT = 100003

local muglexKillCount = CreatureEvent("MuglexKillCount")

function muglexKillCount.onDeath(creature, corpse, killer, mostDamageKiller, lastHitUnjustified, mostDamageUnjustified)
	if not creature:isMonster() then
		return true
	end

	local monsterName = creature:getName():lower()

	-- Check if it's a Muglex clan monster
	if not monsterName:find("muglex clan") then
		return true
	end

	local player = killer or mostDamageKiller
	if player and player:isPlayer() then
		-- Check if player has started the quest
		if player:getStorageValue(NEWHAVEN_GOBLIN_QUEST_START) ~= 1 then
			return true
		end

		-- Increment kill count
		local currentKills = player:getStorageValue(MUGLEX_KILL_COUNT)
		if currentKills < 0 then
			currentKills = 0
		end

		if currentKills < 20 then
			currentKills = currentKills + 1
			player:setStorageValue(MUGLEX_KILL_COUNT, currentKills)

			if currentKills == 20 then
				player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have killed 20 Muglex goblins! Report back to Gustavo.")
			elseif currentKills % 5 == 0 then
				player:sendTextMessage(MESSAGE_STATUS_SMALL, "Muglex kills: " .. currentKills .. "/20")
			end
		end
	end

	return true
end

muglexKillCount:register()
