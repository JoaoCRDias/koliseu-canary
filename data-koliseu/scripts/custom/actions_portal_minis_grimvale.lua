local config = {
	[1] = {
		teleportPosition = Position(869, 1406, 7),
		bossName = "Bloodback",
		timeToFightAgain = 10, -- In hour
		timeToDefeat = 10, -- In minutes
		destination = Position(1238, 1257, 15),
		bossPosition = Position(1244, 1259, 15),
		specPos = {
			from = Position(1229, 1250, 15),
			to = Position(1252, 1266, 15),
		},
		exitPosition = Position(870, 1406, 7),
	},
	[2] = {
		teleportPosition = Position(869, 1408, 7),
		bossName = "Darkfang",
		timeToFightAgain = 10, -- In hour
		timeToDefeat = 10, -- In minutes
		destination = Position(1239, 1230, 15),
		bossPosition = Position(1246, 1229, 15),
		specPos = {
			from = Position(1230, 1219, 15),
			to = Position(1252, 1238, 15),
		},
		exitPosition = Position(870, 1408, 7),
	},
	[3] = {
		teleportPosition = Position(869, 1402, 7),
		bossName = "Sharpclaw",
		timeToFightAgain = 10, -- In hour
		timeToDefeat = 10, -- In minutes
		destination = Position(1294, 1258, 15),
		bossPosition = Position(1294, 1264, 15),
		specPos = {
			from = Position(1285, 1254, 15),
			to = Position(1304, 1269, 15),
		},
		exitPosition = Position(870, 1402, 7),
	},
	[4] = {
		teleportPosition = Position(869, 1410, 7),
		bossName = "Shadowpelt",
		timeToFightAgain = 10, -- In hour
		timeToDefeat = 10, -- In minutes
		destination = Position(1303, 1228, 15),
		bossPosition = Position(1290, 1229, 15),
		specPos = {
			from = Position(1282, 1220, 15),
			to = Position(1308, 1237, 15),
		},
		exitPosition = Position(870, 1410, 7),
	},
	[5] = {
		teleportPosition = Position(869, 1404, 7),
		bossName = "Black Vixen",
		timeToFightAgain = 10, -- In hour
		timeToDefeat = 10, -- In minutes
		destination = Position(1341, 1236, 15),
		bossPosition = Position(1343, 1230, 15),
		specPos = {
			from = Position(1332, 1223, 15),
			to = Position(1354, 1243, 15),
		},
		exitPosition = Position(870, 1404, 7),
	},
	[6] = {
		teleportPosition = Position(1237, 1255, 15),
		exitPosition = Position(870, 1406, 7),
	},
	[7] = {
		teleportPosition = Position(1237, 1228, 15),
		exitPosition = Position(870, 1408, 7),
	},
	[8] = {
		teleportPosition = Position(1294, 1256, 15),
		exitPosition = Position(870, 1402, 7),
	},
	[9] = {
		teleportPosition = Position(1308, 1237, 15),
		exitPosition = Position(870, 1410, 7),
	},
	[10] = {
		teleportPosition = Position(1339, 1238, 15),
		exitPosition = Position(870, 1404, 7),
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
