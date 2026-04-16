local missionZone = Zone("bloodbath")

missionZone:addArea({ x = 32924, y = 31415, z = 5 }, { x = 32930, y = 31420, z = 5 })

local playerIconAddEvent = {}

local function stopPlayerIconAddEvent(playerGuid)
	local eventId = playerIconAddEvent[playerGuid]
	if eventId then
		stopEvent(eventId)
		playerIconAddEvent[playerGuid] = nil
	end
end

local function updateBloodbathIcon(playerGuid, currentCount)
	local player = Player(playerGuid)
	if not player then
		stopPlayerIconAddEvent(playerGuid)
		return
	end

	if player:getStorageValue(Storage.Quest.U15_10.BloodyTusks.Bloodbath) ~= 1 then
		stopPlayerIconAddEvent(playerGuid)
		return
	end

	currentCount = currentCount + 1
	if currentCount > 10 then
		player:removeIcon("bloodbath")
		stopPlayerIconAddEvent(playerGuid)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You gained the sacrament of blood!")
		player:setStorageValue(Storage.Quest.U15_10.BloodyTusks.Bloodbath, 2)
		player:setStorageValue(Storage.Quest.U15_10.BloodyTusks.WellPrepared, 1)
	else
		if currentCount == 2 then
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Argh! That Pain!!")
		elseif currentCount == 8 then
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "<gasp>")
		end

		player:setIcon("bloodbath", CreatureIconCategory_Quests, CreatureIconQuests_RedBall, currentCount)
		playerIconAddEvent[playerGuid] = addEvent(updateBloodbathIcon, 1000, playerGuid, currentCount)
	end

	return
end

local zoneEvent = ZoneEvent(missionZone)

function zoneEvent.afterEnter(_zone, creature)
	local player = creature:getPlayer()
	if not player then
		return
	end

	local playerGuid = player:getGuid()
	if not playerIconAddEvent[playerGuid] then
		playerIconAddEvent[playerGuid] = addEvent(updateBloodbathIcon, 1000, playerGuid, 0)
	end
end

function zoneEvent.afterLeave(_zone, creature)
	local player = creature:getPlayer()
	if not player then
		return
	end

	stopPlayerIconAddEvent(player:getGuid())
	player:removeIcon("bloodbath")
end

zoneEvent:register()
