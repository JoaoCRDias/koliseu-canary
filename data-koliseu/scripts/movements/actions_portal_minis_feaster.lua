local config = {
	[1] = {
		teleportPosition = Position(851, 1428, 7),
		bossName = "Irgix the Flimsy",
		requiredLevel = 250,
		timeToFightAgain = 20, -- In hour
		timeToDefeat = 10, -- In minutes
		destination = Position(1125, 1455, 15),
		bossPosition = Position(1125, 1461, 15),
		specPos = {
			from = Position(1116, 1450, 15),
			to = Position(1135, 1468, 15),
		},
		exitPosition = Position(852, 1428, 7),
	},
	[2] = {
		teleportPosition = Position(851, 1432, 7),
		bossName = "Unaz the Mean",
		requiredLevel = 250,
		timeToFightAgain = 20, -- In hour
		timeToDefeat = 10, -- In minutes
		destination = Position(1149, 1460, 15),
		bossPosition = Position(1162, 1461, 15),
		specPos = {
			from = Position(1143, 1450, 15),
			to = Position(1177, 1469, 15),
		},
		exitPosition = Position(852, 1432, 7),
	},
	[3] = {
		teleportPosition = Position(852, 1433, 7),
		bossName = "Vok The Freakish",
		requiredLevel = 250,
		timeToFightAgain = 20, -- In hour
		timeToDefeat = 10, -- In minutes
		destination = Position(1194, 1456, 15),
		bossPosition = Position(1196, 1463, 15),
		specPos = {
			from = Position(1190, 1453, 15),
			to = Position(1204, 1467, 15),
		},
		exitPosition = Position(852, 1432, 7),
	},
	[4] = {
		teleportPosition = Position(1125, 1454, 15),
		exitPosition = Position(852, 1428, 7),
	},
	[5] = {
		teleportPosition = Position(1149, 1459, 15),
		exitPosition = Position(852, 1432, 7),
	},
	[6] = {
		teleportPosition = Position(1194, 1455, 15),
		exitPosition = Position(852, 1432, 7),
	},
}

local teleportBoss = MoveEvent()
function teleportBoss.onStepIn(creature, item, position, fromPosition)
	if not creature or not creature:isPlayer() then
		return false
	end
	for index, value in pairs(config) do
		if Tile(position) == Tile(value.teleportPosition) then
			if not value.specPos then
				creature:teleportTo(value.exitPosition)
				creature:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
				return true
			end
			local spec = Spectators()
			spec:setOnlyPlayer(false)
			spec:setRemoveDestination(value.exitPosition)
			spec:setCheckPosition(value.specPos)
			spec:check()
			if spec:getPlayers() > 0 then
				creature:teleportTo(fromPosition, true)
				creature:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
				creature:say("There's someone fighting with " .. value.bossName .. ".", TALKTYPE_MONSTER_SAY)
				return true
			end
			if creature:getLevel() < value.requiredLevel then
				creature:teleportTo(fromPosition, true)
				creature:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
				creature:sendTextMessage(MESSAGE_EVENT_ADVANCE, "All the players need to be level " .. value.requiredLevel .. " or higher.")
				return true
			end
			if not creature:canFightBoss(value.bossName) then
				creature:teleportTo(fromPosition, true)
				creature:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
				creature:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have to wait " .. value.timeToFightAgain .. " hours to face " .. value.bossName .. " again!")
				return true
			end
			spec:removeMonsters()
			local monster = Game.createMonster(value.bossName, value.bossPosition, true, true)
			if not monster then
				return true
			end
			creature:teleportTo(value.destination)
			creature:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
			creature:setBossCooldown(value.bossName, os.time() + value.timeToFightAgain * 3600)
			creature:sendBosstiaryCooldownTimer()
			addEvent(function()
				spec:clearCreaturesCache()
				spec:setOnlyPlayer(true)
				spec:check()
				spec:removePlayers()
			end, value.timeToDefeat * 60 * 1000)
		end
	end
end

for index, value in pairs(config) do
	teleportBoss:position(value.teleportPosition)
end

teleportBoss:type("stepin")
teleportBoss:register()
