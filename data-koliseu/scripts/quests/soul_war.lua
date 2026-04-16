SoulWarQuest = {
	-- Item ids
	bagYouDesireItemId = 34109,
	bagYouDesireChancePerTaint = 10, -- Increases % per taint
	theBloodOfCloakTerrorIds = { 33854, 34006, 34007 },
	bagYouDesireMonsters = {
		"Bony Sea Devil",
		"Brachiodemon",
		"Branchy Crawler",
		"Capricious Phantom",
		"Cloak of Terror",
		"Courage Leech",
		"Distorted Phantom",
		"Druid's Apparition",
		"Infernal Demon",
		"Infernal Phantom",
		"Knight's Apparition",
		"Many Faces",
		"Mould Phantom",
		"Paladin's Apparition",
		"Rotten Golem",
		"Sorcerer's Apparition",
		"Turbulent Elemental",
		"Vibrant Phantom",
		"Hazardous Phantom",
		"Goshnar's Cruelty",
		"Goshnar's Spite",
		"Goshnar's Malice",
		"Goshnar's Hatred",
		"Goshnar's Greed",
		"Goshnar's Megalomania",
	},

	miniBosses = {
		["Goshnar's Malice"] = true,
		["Goshnar's Hatred"] = true,
		["Goshnar's Spite"] = true,
		["Goshnar's Cruelty"] = true,
		["Goshnar's Greed"] = true,
	},

	finalRewards = {
		{ id = 34082, name = "soulcutter" },
		{ id = 34083, name = "soulshredder" },
		{ id = 34084, name = "soulbiter" },
		{ id = 34085, name = "souleater" },
		{ id = 34086, name = "soulcrusher" },
		{ id = 34087, name = "soulmaimer" },
		{ id = 34088, name = "soulbleeder" },
		{ id = 34089, name = "soulpiercer" },
		{ id = 34090, name = "soultainter" },
		{ id = 34091, name = "soulhexer" },
		{ id = 34092, name = "soulshanks" },
		{ id = 34093, name = "soulstrider" },
		{ id = 34094, name = "soulshell" },
		{ id = 34095, name = "soulmantel" },
		{ id = 34096, name = "soulshroud" },
		{ id = 34097, name = "pair of soulwalkers" },
		{ id = 34098, name = "pair of soulstalkers" },
		{ id = 34099, name = "soulbastion" },
	},
	kvSoulWar = KV.scoped("quest"):scoped("soul-war"),
	areaZones = {
		monsters = {
			["zone.claustrophobic-inferno"] = "Brachiodemon",
			["zone.mirrored-nightmare"] = "Many Faces",
			["zone.ebb-and-flow"] = "Bony Sea Devil",
			["zone.furious-crater"] = "Cloak of Terror",
			["zone.rotten-wasteland"] = "Branchy Crawler",
		},

		claustrophobicInferno = Zone("zone.claustrophobic-inferno"),
		mirroredNightmare = Zone("zone.mirrored-nightmare"),
		ebbAndFlow = Zone("zone.ebb-and-flow"),
		furiousCrater = Zone("zone.furious-crater"),
		rottenWasteland = Zone("zone.rotten-wasteland"),
	},

	-- Levers configuration
	levers = {
		goshnarsMalicePosition = Position(962, 1320, 15),
		goshnarsSpitePosition = Position(1057, 1355, 15),
		goshnarsGreedPosition = Position(1059, 1386, 15),
		goshnarsHatredPosition = Position(1056, 1322, 15),
		goshnarsCrueltyPosition = Position(610, 1349, 6),
		goshnarsMegalomaniaPosition = Position(959, 1355, 15),

		-- Levers system
		goshnarsSpite = {
			boss = {
				name = "Goshnar's Spite",
				position = Position(1026, 1351, 15),
			},
			requiredLevel = 250,
			playerPositions = {
				{ pos = Position(1058, 1355, 15), teleport = Position(1026, 1359, 15), effect = CONST_ME_TELEPORT },
				{ pos = Position(1059, 1355, 15), teleport = Position(1026, 1359, 15), effect = CONST_ME_TELEPORT },
				{ pos = Position(1060, 1355, 15), teleport = Position(1026, 1359, 15), effect = CONST_ME_TELEPORT },
				{ pos = Position(1061, 1355, 15), teleport = Position(1026, 1359, 15), effect = CONST_ME_TELEPORT },
				{ pos = Position(1062, 1355, 15), teleport = Position(1026, 1359, 15), effect = CONST_ME_TELEPORT },
			},
			specPos = {
				from = Position(1015, 1344, 15),
				to = Position(1036, 1362, 15),
			},
			exit = Position(1064, 1355, 15),
			timeToFightAgain = 20 * 60 * 60, -- 20 hours
		},
		goshnarsMalice = {
			boss = {
				name = "Goshnar's Malice",
				position = Position(993, 1318, 15),
			},
			requiredLevel = 250,
			playerPositions = {
				{ pos = Position(963, 1320, 15), teleport = Position(993, 1326, 15), effect = CONST_ME_TELEPORT },
				{ pos = Position(964, 1320, 15), teleport = Position(993, 1326, 15), effect = CONST_ME_TELEPORT },
				{ pos = Position(965, 1320, 15), teleport = Position(993, 1326, 15), effect = CONST_ME_TELEPORT },
				{ pos = Position(966, 1320, 15), teleport = Position(993, 1326, 15), effect = CONST_ME_TELEPORT },
				{ pos = Position(967, 1320, 15), teleport = Position(993, 1326, 15), effect = CONST_ME_TELEPORT },
			},
			specPos = {
				from = Position(981, 1310, 15),
				to = Position(1006, 1330, 15),
			},
			exit = Position(969, 1320, 15),
			timeToFightAgain = 20 * 60 * 60, -- 20 hours
		},
		goshnarsGreed = {
			boss = {
				name = "Goshnar's Greed",
				position = Position(1030, 1383, 15),
			},
			requiredLevel = 250,
			playerPositions = {
				{ pos = Position(1060, 1386, 15), teleport = Position(1030, 1392, 15), effect = CONST_ME_TELEPORT },
				{ pos = Position(1061, 1386, 15), teleport = Position(1030, 1392, 15), effect = CONST_ME_TELEPORT },
				{ pos = Position(1062, 1386, 15), teleport = Position(1030, 1392, 15), effect = CONST_ME_TELEPORT },
				{ pos = Position(1063, 1386, 15), teleport = Position(1030, 1392, 15), effect = CONST_ME_TELEPORT },
				{ pos = Position(1064, 1386, 15), teleport = Position(1030, 1392, 15), effect = CONST_ME_TELEPORT },
			},
			specPos = {
				from = Position(1019, 1377, 15),
				to = Position(1042, 1396, 15),
			},
			exit = Position(1066, 1386, 15),
			timeToFightAgain = 20 * 60 * 60, -- 20 hours
		},
		goshnarsHatred = {
			boss = {
				name = "Goshnar's Hatred",
				position = Position(1027, 1316, 15),
			},
			requiredLevel = 250,
			playerPositions = {
				{ pos = Position(1057, 1322, 15), teleport = Position(1027, 1325, 15), effect = CONST_ME_TELEPORT },
				{ pos = Position(1058, 1322, 15), teleport = Position(1027, 1325, 15), effect = CONST_ME_TELEPORT },
				{ pos = Position(1059, 1322, 15), teleport = Position(1027, 1325, 15), effect = CONST_ME_TELEPORT },
				{ pos = Position(1060, 1322, 15), teleport = Position(1027, 1325, 15), effect = CONST_ME_TELEPORT },
				{ pos = Position(1061, 1322, 15), teleport = Position(1027, 1325, 15), effect = CONST_ME_TELEPORT },
			},
			specPos = {
				from = Position(1016, 1311, 15),
				to = Position(1039, 1330, 15),
			},
			exit = Position(1063, 1322, 15),
			timeToFightAgain = 20 * 60 * 60, -- 20 hours
		},
		goshnarsCruelty = {
			boss = {
				name = "Goshnar's Cruelty",
				position = Position(612, 1360, 7),
			},
			requiredLevel = 250,
			playerPositions = {
				{ pos = Position(611, 1349, 6), teleport = Position(612, 1367, 7), effect = CONST_ME_TELEPORT },
				{ pos = Position(612, 1349, 6), teleport = Position(612, 1367, 7), effect = CONST_ME_TELEPORT },
				{ pos = Position(613, 1349, 6), teleport = Position(612, 1367, 7), effect = CONST_ME_TELEPORT },
				{ pos = Position(614, 1349, 6), teleport = Position(612, 1367, 7), effect = CONST_ME_TELEPORT },
				{ pos = Position(615, 1349, 6), teleport = Position(612, 1367, 7), effect = CONST_ME_TELEPORT },
			},
			specPos = {
				from = Position(601, 1351, 7),
				to = Position(622, 1370, 7),
			},
			exit = Position(617, 1349, 6),
			timeToFightAgain = 20 * 60 * 60, -- 20 hours
		},
		goshnarsMegalomania = {
			boss = {
				name = "Goshnar's Megalomania",
				position = Position(994, 1354, 15),
			},
			requiredLevel = 250,
			playerPositions = {
				{ pos = Position(960, 1355, 15), teleport = Position(994, 1360, 15), effect = CONST_ME_TELEPORT },
				{ pos = Position(961, 1355, 15), teleport = Position(994, 1360, 15), effect = CONST_ME_TELEPORT },
				{ pos = Position(962, 1355, 15), teleport = Position(994, 1360, 15), effect = CONST_ME_TELEPORT },
				{ pos = Position(963, 1355, 15), teleport = Position(994, 1360, 15), effect = CONST_ME_TELEPORT },
				{ pos = Position(964, 1355, 15), teleport = Position(994, 1360, 15), effect = CONST_ME_TELEPORT },
			},
			specPos = {
				from = Position(982, 1346, 15),
				to = Position(1006, 1365, 15),
			},
			exit = Position(966, 1355, 15),
			timeToFightAgain = 20 * 60 * 60,
		},
	},

	apparitionNames = {
		"Druid's Apparition",
		"Knight's Apparition",
		"Paladin's Apparition",
		"Sorcerer's Apparition",
	},
}

function RegisterSoulWarBossesLevers()
	-- Register levers
	local goshnarsMaliceLever = BossLever(SoulWarQuest.levers.goshnarsMalice)
	goshnarsMaliceLever:position(SoulWarQuest.levers.goshnarsMalicePosition)
	goshnarsMaliceLever:register()
	logger.debug("Registering soul war boss lever zone: {}", goshnarsMaliceLever:getZone():getName())

	local goshnarsSpiteLever = BossLever(SoulWarQuest.levers.goshnarsSpite)
	goshnarsSpiteLever:position(SoulWarQuest.levers.goshnarsSpitePosition)
	goshnarsSpiteLever:register()
	logger.debug("Registering soul war boss lever zone: {}", goshnarsSpiteLever:getZone():getName())

	local goshnarsGreedLever = BossLever(SoulWarQuest.levers.goshnarsGreed)
	goshnarsGreedLever:position(SoulWarQuest.levers.goshnarsGreedPosition)
	goshnarsGreedLever:register()
	logger.debug("Registering soul war boss lever zone: {}", goshnarsGreedLever:getZone():getName())

	local goshnarsHatredLever = BossLever(SoulWarQuest.levers.goshnarsHatred)
	goshnarsHatredLever:position(SoulWarQuest.levers.goshnarsHatredPosition)
	goshnarsHatredLever:register()
	logger.debug("Registering soul war boss lever zone: {}", goshnarsHatredLever:getZone():getName())

	local goshnarsCrueltyLever = BossLever(SoulWarQuest.levers.goshnarsCruelty)
	goshnarsCrueltyLever:position(SoulWarQuest.levers.goshnarsCrueltyPosition)
	goshnarsCrueltyLever:register()
	logger.debug("Registering soul war boss lever zone: {}", goshnarsCrueltyLever:getZone():getName())

	local goshnarsMegalomaniaLever = BossLever(SoulWarQuest.levers.goshnarsMegalomania)
	goshnarsMegalomaniaLever:position(SoulWarQuest.levers.goshnarsMegalomaniaPosition)
	goshnarsMegalomaniaLever:register()
	logger.debug("Registering soul war boss lever zone: {}", goshnarsMegalomaniaLever:getZone():getName())
end

-- Initialize bosses access for taint check
SoulWarQuest.areaZones.claustrophobicInferno:addArea(Position(1009, 1773, 9), Position(1102, 1884, 11))

SoulWarQuest.areaZones.ebbAndFlow:addArea(Position(912, 1767, 8), Position(1001, 1919, 9))

SoulWarQuest.areaZones.furiousCrater:addArea(Position(551, 1294, 3), Position(708, 1449, 7))

SoulWarQuest.areaZones.rottenWasteland:addArea(Position(929, 1751, 11), Position(1039, 1887, 13))

SoulWarQuest.areaZones.mirroredNightmare:addArea(Position(906, 1603, 8), Position(1028, 1683, 12))

-- Initialize safe areas (should not spawn monster, teleport, take damage from taint, etc)
SoulWarQuest.areaZones.claustrophobicInferno:subtractArea(Position(1043, 1782, 9), Position(1061, 1794, 9))

SoulWarQuest.areaZones.ebbAndFlow:subtractArea(Position(927, 1788, 8), Position(963, 1802, 8))

SoulWarQuest.areaZones.furiousCrater:subtractArea(Position(611, 1323, 3), Position(626, 1329, 3))

SoulWarQuest.areaZones.rottenWasteland:subtractArea(Position(1008, 1812, 11), Position(1018, 1826, 11))

SoulWarQuest.areaZones.mirroredNightmare:subtractArea(Position(912, 1624, 9), Position(923, 1642, 9))

TaintDurationSeconds = 14 * 24 * 60 * 60 -- 14 days

local soulWarTaints = {
	"taints-teleport", -- Taint 1
	"taints-spawn", -- Taint 2
	"taints-damage", -- Taint 3
	"taints-heal", -- Taint 4
	"taints-loss", -- Taint 5
}

function MonsterType:calculateBagYouDesireChance(player, itemChance)
	local playerTaintLevel = player:getTaintLevel()
	if not playerTaintLevel or playerTaintLevel == 0 then
		return itemChance
	end

	local monsterName = self:getName()
	local isMonsterValid = table.contains(SoulWarQuest.bagYouDesireMonsters, monsterName)
	if not isMonsterValid then
		return itemChance
	end

	local soulWarQuest = player:soulWarQuestKV()
	local megalomaniaKills = soulWarQuest:scoped("megalomania-kills"):get("count") or 0

	if monsterName == "Goshnar's Megalomania" then
		-- Special handling for Goshnar's Megalomania
		itemChance = itemChance + megalomaniaKills * SoulWarQuest.bagYouDesireChancePerTaint
	else
		-- General handling for other monsters (bosses and non-bosses)
		itemChance = itemChance + (playerTaintLevel * SoulWarQuest.bagYouDesireChancePerTaint)
	end

	logger.debug("Player {} killed {} with {} taints, loot chance {}", player:getName(), monsterName, playerTaintLevel, itemChance)

	if math.random(1, 100000) <= itemChance then
		logger.debug("Player {} killed {} and got a bag you desire with drop chance {}", player:getName(), monsterName, itemChance)
		if monsterName == "Goshnar's Megalomania" then
			-- Reset kill count on successful drop
			soulWarQuest:scoped("megalomania-kills"):set("count", 0)
		end
	else
		if monsterName == "Goshnar's Megalomania" then
			-- Increment kill count for unsuccessful attempts
			soulWarQuest:scoped("megalomania-kills"):set("count", megalomaniaKills + 1)
		end
	end

	return itemChance
end

TaintTeleportCooldown = {}

function Player:getTaintNameByNumber(taintNumber, skipKvCheck)
	local haveTaintName = nil
	local soulWarQuest = self:soulWarQuestKV()
	local taintName = soulWarTaints[taintNumber]
	if skipKvCheck or taintName and soulWarQuest:get(taintName) then
		haveTaintName = taintName
	end

	return haveTaintName
end

function Player:addNextTaint()
	local soulWarQuest = self:soulWarQuestKV()
	for _, taintName in ipairs(soulWarTaints) do
		if not soulWarQuest:get(taintName) then
			soulWarQuest:set(taintName, true)
			self:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have gained the " .. taintName .. ".")
			self:setTaintIcon()
			break
		end
	end
end

function Player:setTaintIcon(taintId)
	self:resetTaintConditions()
	local condition = Condition(CONDITION_GOSHNARTAINT, CONDITIONID_DEFAULT, taintId or self:getTaintLevel())
	condition:setTicks(14 * 24 * 60 * 60 * 1000)
	self:addCondition(condition)
end

function Player:resetTaintConditions()
	for i = 1, 5 do
		self:removeCondition(CONDITION_GOSHNARTAINT, CONDITIONID_DEFAULT, i)
	end
end

function Player:getTaintLevel()
	local taintLevel = nil
	local soulWarQuest = self:soulWarQuestKV()
	for i, taint in ipairs(soulWarTaints) do
		if soulWarQuest:get(taint) then
			taintLevel = i
		end
	end

	return taintLevel
end

function Player:resetTaints(skipCheckTime)
	local soulWarQuest = self:soulWarQuestKV()
	local firstTaintTime = soulWarQuest:get("firstTaintTime")
	if skipCheckTime or firstTaintTime and os.time() >= (firstTaintTime + TaintDurationSeconds) then
		-- Reset all taints and remove condition
		for _, taintName in ipairs(soulWarTaints) do
			if soulWarQuest:get(taintName) then
				soulWarQuest:remove(taintName)
			end
		end
		self:resetTaintConditions()
		soulWarQuest:remove("firstTaintTime")
		local resetMessage = "Your Goshnar's taints have been reset."
		if not skipCheckTime then
			resetMessage = resetMessage .. " You didn't finish the quest in 14 days."
		end
		self:sendTextMessage(MESSAGE_EVENT_ADVANCE, resetMessage)

		for bossName, _ in pairs(SoulWarQuest.miniBosses) do
			soulWarQuest:remove(bossName)
		end
	end
end

function Monster:tryTeleportToPlayer(sayMessage)
	local range = 30
	local spectators = Game.getSpectators(self:getPosition(), false, false, range, range, range, range)
	local maxDistance = 0
	local farthestPlayer = nil
	for i, spectator in ipairs(spectators) do
		if spectator:isPlayer() then
			local player = spectator:getPlayer()
			if player:getTaintNameByNumber(1, true) and player:getSoulWarZoneMonster() ~= nil then
				local distance = self:getPosition():getDistance(player:getPosition())
				if distance > maxDistance then
					maxDistance = distance
					farthestPlayer = player
					logger.trace("Found player {} to teleport", player:getName())
				end
			end
		end
	end

	if farthestPlayer and math.random(100) <= 10 then
		local playerPosition = farthestPlayer:getPosition()
		if TaintTeleportCooldown[farthestPlayer:getId()] then
			logger.trace("Cooldown is active to player {}", farthestPlayer:getName())
			return
		end

		if not TaintTeleportCooldown[farthestPlayer:getId()] then
			TaintTeleportCooldown[farthestPlayer:getId()] = true

			logger.trace("Scheduling player {} to teleport", farthestPlayer:getName())
			self:getPosition():sendMagicEffect(CONST_ME_MORTAREA)
			farthestPlayer:getPosition():sendMagicEffect(CONST_ME_MORTAREA)
			addEvent(function(playerId, monsterId)
				local monsterEvent = Monster(monsterId)
				local playerEvent = Player(playerId)
				if monsterEvent and playerEvent then
					local destinationTile = Tile(playerPosition)
					if destinationTile and not (destinationTile:hasProperty(CONST_PROP_BLOCKPROJECTILE) or destinationTile:hasProperty(CONST_PROP_MOVEABLE)) then
						monsterEvent:say(sayMessage)
						monsterEvent:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
						monsterEvent:teleportTo(playerPosition, true)
						monsterEvent:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
					end
				end
			end, 2000, farthestPlayer:getId(), self:getId())

			addEvent(function(playerId)
				local playerEvent = Player(playerId)
				if not playerEvent then
					return
				end

				logger.trace("Cleaning player cooldown")
				TaintTeleportCooldown[playerEvent:getId()] = nil
			end, 10000, farthestPlayer:getId())
		end
	end
end

function Monster:getSoulWarKV()
	return SoulWarQuest.kvSoulWar:scoped("monster"):scoped(self:getName())
end

function Player:getSoulWarZoneMonster()
	local zoneMonsterName = nil
	for zoneName, monsterName in pairs(SoulWarQuest.areaZones.monsters) do
		local zone = Zone.getByName(zoneName)
		if zone and zone:isInZone(self:getPosition()) then
			zoneMonsterName = monsterName
			break
		end
	end

	return zoneMonsterName
end

function Player:soulWarQuestKV()
	return self:kv():scoped("quest"):scoped("soul-war")
end

function Zone:getRandomPlayer()
	local players = self:getPlayers()
	if #players == 0 then
		return nil
	end

	local randomIndex = math.random(#players)
	return players[randomIndex]
end

-- We need to register the variables beforehand to avoid accessing null values.
if RegisterSoulWarBossesLevers then
	RegisterSoulWarBossesLevers()
end
