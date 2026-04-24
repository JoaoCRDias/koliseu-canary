local config = {
	castleBonusExp = 15, -- Bonus Exp for players inside the castle
	join = {
		minPlayers = 1, -- Minimum amount of players to join
		minLevel = 500, -- Minium level to join
	},
	castleTpId = 27590, -- Id of the teleport to castle,
	delayReleaseEntrance = 1 * 60 * 1000, -- In minutes
	closein = 4 * 60 * 1000, -- In minutes
	castleEntranceTp = Position(997, 1005, 6), -- Entrance Position,
	castleEntranceTpDestination = Position(591, 840, 7), -- Entrance Destination Position
	timeThroneTick = 5, -- In seconds
	scoreboard = {
		channelId = 12,
		interval = 30 * 1000, -- In milliseconds
	},
	gatesToRelease = {
		gatesIds = { 11561, 11562 },
		positions = {
			Position(589, 832, 7),
			Position(590, 832, 7),
			Position(591, 832, 7),
			Position(592, 832, 7),
			Position(593, 832, 7),
		}
	},
	positions = {
		finalGeneratorPosition = Position(591, 814, 7),
		generatorsPositions = {
			Position(607, 805, 7),
			Position(607, 825, 7),
			Position(575, 805, 7),
			Position(575, 825, 7),
		},
	},
	exitPosition = Position(1000, 1000, 7), -- Temple Position
	castleAreas = {
		{ fromPosition = Position(570, 800, 4), toPosition = Position(613, 845, 7) },
	},
	prison = {
		fromPosition = Position(588, 805, 4),
		toPosition = Position(593, 813, 4),
		teleportPosition = Position(591, 808, 4), -- Where dead players land in the prison
		totemPosition = Position(590, 804, 4), -- Totem that "speaks" the countdown
		releasePosition = Position(591, 834, 7), -- Where prisoners are released to (castle start)
		durationSeconds = 2 * 60, -- 2 minutes
	},
	throne = {
		agonyTickInterval = 1000, -- Agony damage tick (1 second)
		agonyPercent = 10, -- Percent of max health drained per tick
	},
	rewardCasketId = 63377, -- Castle surprise casket given to winning guild members inside the castle
}

Castle = {
	guildsPoints = {},
	dominateGuild = nil,
	opened = false,
	config = config,
	warGeneratorCount = 4,
}

local releaseEntranceEvent = nil
local gateCountdownEvent = nil
local scoreboardEvent = nil
local prisonCountdownEvent = nil

local function formatCountdown(secondsLeft)
	local minutes = math.floor(secondsLeft / 60)
	local seconds = secondsLeft % 60
	return string.format("%02d:%02d", minutes, seconds)
end

local function sendGateCountdownText(text)
	for _, position in pairs(config.gatesToRelease.positions) do
		local spectators = Game.getSpectators(position, false, true, 7, 7, 5, 5)
		for i = 1, #spectators do
			spectators[i]:say(text, TALKTYPE_MONSTER_SAY, false, spectators[i], position)
		end
	end
end

function Castle.startGateCountdown(self)
	local remainingSeconds = math.floor(config.delayReleaseEntrance / 1000)
	if remainingSeconds <= 0 then
		return
	end

	if gateCountdownEvent then
		stopEvent(gateCountdownEvent)
	end

	local function tick(selfRef, secondsLeft)
		if not selfRef.opened then
			return
		end

		if secondsLeft <= 0 then
			sendGateCountdownText("OPEN")
			return
		end

		sendGateCountdownText(formatCountdown(secondsLeft))
		gateCountdownEvent = addEvent(tick, 1000, selfRef, secondsLeft - 1)
	end

	tick(self, remainingSeconds)
end

function Castle.stopGateCountdown(self)
	if gateCountdownEvent then
		stopEvent(gateCountdownEvent)
		gateCountdownEvent = nil
	end
end

local function sendPrisonCountdownText(text)
	local position = config.prison.totemPosition
	local spectators = Game.getSpectators(position, false, true, 7, 7, 5, 5)
	for i = 1, #spectators do
		spectators[i]:say(text, TALKTYPE_MONSTER_SAY, false, spectators[i], position)
	end
end

function Castle.playersInPrison(self)
	local ret = {}
	for _, tmpPlayer in pairs(Game.getPlayers()) do
		if tmpPlayer:getPosition():isInRange(config.prison.fromPosition, config.prison.toPosition) and not tmpPlayer:getGroup():getAccess() then
			ret[#ret + 1] = tmpPlayer
		end
	end
	return ret
end

function Castle.releasePrisoners(self)
	local prisoners = self:playersInPrison()
	if #prisoners == 0 then
		return
	end

	local releasePos = config.prison.releasePosition
	for i = 1, #prisoners do
		local player = prisoners[i]
		player:teleportTo(releasePos)
		releasePos:sendMagicEffect(CONST_ME_TELEPORT)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "[Castle War] You have been released back to the castle.")
	end
end

function Castle.startPrisonCountdown(self)
	if prisonCountdownEvent then
		return -- Already running, do not restart
	end

	local function tick(secondsLeft)
		if not Castle.opened then
			prisonCountdownEvent = nil
			return
		end

		if secondsLeft <= 0 then
			sendPrisonCountdownText("RELEASED")
			Castle:releasePrisoners()
			prisonCountdownEvent = addEvent(tick, 1000, config.prison.durationSeconds)
			return
		end

		sendPrisonCountdownText(formatCountdown(secondsLeft))
		prisonCountdownEvent = addEvent(tick, 1000, secondsLeft - 1)
	end

	tick(config.prison.durationSeconds)
end

function Castle.stopPrisonCountdown(self)
	if prisonCountdownEvent then
		stopEvent(prisonCountdownEvent)
		prisonCountdownEvent = nil
	end
end

function Castle.sendToPrison(self, player)
	if not player then
		return
	end

	local prisonPos = config.prison.teleportPosition
	player:teleportTo(prisonPos)
	prisonPos:sendMagicEffect(CONST_ME_TELEPORT)
end

function Castle.getScoreboardText(self)
	local guildsPoints = self:getGuildsPointsHighscore()
	if #guildsPoints == 0 then
		return "Castle War Score:\nNo points yet."
	end

	local lines = { "Castle War Score:" }
	for i, info in ipairs(guildsPoints) do
		lines[#lines+1] = string.format("%d. %s - %d", i, info.guildName, info.thronePoints)
	end
	return table.concat(lines, "\n")
end

function Castle.broadcastScoreboard(self)
	sendChannelMessage(config.scoreboard.channelId, TALKTYPE_CHANNEL_R1, self:getScoreboardText())
end

function Castle.startScoreboard(self)
	if scoreboardEvent then
		stopEvent(scoreboardEvent)
	end

	local function tick(selfRef)
		if not selfRef.opened then
			return
		end
		selfRef:broadcastScoreboard()
		scoreboardEvent = addEvent(tick, config.scoreboard.interval, selfRef)
	end

	tick(self)
end

function Castle.stopScoreboard(self)
	if scoreboardEvent then
		stopEvent(scoreboardEvent)
		scoreboardEvent = nil
	end
end

function Castle.load(self)
	local resultId = db.storeQuery("SELECT `guild_id` FROM `castle_war` WHERE `active` = 1")
	if resultId then
		local guildId = Result.getNumber(resultId, "guild_id")
		Result.free(resultId)
		self.dominateGuild = guildId
	end

	self:open()
end

function Castle.resetCastle(self)
	if not self.opened then
		return
	end
	self:stopGateCountdown()
	self:stopScoreboard()
	self:stopPrisonCountdown()

	-- Teleport any remaining prisoners to the temple too
	local prisoners = self:playersInPrison()
	for i = 1, #prisoners do
		local player = prisoners[i]
		if player then
			player:teleportTo(config.exitPosition)
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "[Castle War] The castle was reset and you were teleported to temple.")
		end
	end

	local playersCastle = self:playersInCastle()
	if next(playersCastle) ~= nil then
		for i = 1, #playersCastle do
			local player = playersCastle[i]
			if player then
				player:teleportTo(config.exitPosition)
				player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "[Castle War] The castle was reset and you were teleported to temple.")
			end
		end
	end

	self.guildsPoints = {}
	self.opened = false
	self.warGeneratorCount = 4

	local item = Tile(config.castleEntranceTp):getItemById(config.castleTpId)
	if item then
		item:remove()
	end
end

function Castle.releaseEntrance(self)
	local playersInsideCastle = self:playersInCastle()
	if #playersInsideCastle < config.join.minPlayers then
		self:resetCastle()
		Game.broadcastMessage("[Guild Castle War] The Castle did not obtain the required number of players for the battle!", MESSAGE_GAME_HIGHLIGHT)
		return
	end

	Game.broadcastMessage(string.format("[Guild Castle War] Entry has been cleared, the castle will close in %d minutes.", config.closein), MESSAGE_GAME_HIGHLIGHT)
	self:stopGateCountdown()

	for _, position in pairs(config.gatesToRelease.positions) do
		local tile = Tile(position)
		if tile then
			for _, gateId in ipairs(config.gatesToRelease.gatesIds) do
				local item = tile:getItemById(gateId)
				while item do
					item:remove()
					position:sendMagicEffect(CONST_ME_POFF)
					item = tile:getItemById(gateId)
				end
			end
		end
	end

	for _, position in pairs(config.positions.generatorsPositions) do
		position:sendMagicEffect(CONST_ME_FIREAREA)
		Game.createMonster("War Generator", position, true, true)
	end
	Game.createMonster("Siege Generator", config.positions.finalGeneratorPosition, true, true)
	addEvent(function(self)
		self:close()
	end, config.closein, self)
end

function Castle.open(self)
	local item = Game.createItem(config.castleTpId, 1, config.castleEntranceTp)
	if item:isTeleport() then
		item:setDestination(config.castleEntranceTpDestination)
		item:setActionId(38133)
	end
	Game.broadcastMessage("[Guild Castle War] It's time to fight! The Castle is open for domination.", MESSAGE_GAME_HIGHLIGHT)
	self.opened = true
	self:startGateCountdown()
	self:startScoreboard()
	self:startPrisonCountdown()

	releaseEntranceEvent = addEvent(function(self)
		self:releaseEntrance()
	end, config.delayReleaseEntrance, self)
end

function Castle.close(self)
	if not self.opened then
		return
	end

	self:stopGateCountdown()
	self:stopScoreboard()
	self:dominate()
	self:resetCastle()
end

function Castle.dominate(self)
	local guilds = self:getGuildsPointsHighscore()
	local winnerGuild = guilds[1]
	if not winnerGuild then
		Game.broadcastMessage("[Castle War]: Castle War has no new winner!")
		print("Castle War has no new winner!")
		return true
	end

	local newDominantId = winnerGuild.guildId
	local newThronePoints = winnerGuild.thronePoints
	local newDominantName = winnerGuild.guildName

	if newDominantId ~= self.dominateGuild then
		db.query("UPDATE `castle_war` SET `active` = 0 WHERE `active` = 1")
		db.query(string.format('INSERT INTO `castle_war` (`guild_id`, `guild_name`, `timestamp`, `throne_points`, `active`) VALUES (%d, %s, %d, %d, %d)', newDominantId, db.escapeString(newDominantName), os.time(), newThronePoints, 1))
		Game.broadcastMessage(string.format('[Castle War] - The guild that dominates the Castle War is the %s!', newDominantName), MESSAGE_GAME_HIGHLIGHT)

		self.dominateGuild = newDominantId
	elseif newDominantId == self.dominateGuild then
		Game.broadcastMessage(string.format('[Castle War] - The guild %s continues the owner of the Castle!', self:getDominantName()), MESSAGE_GAME_HIGHLIGHT)
	end

	local guildsPoints = self:getGuildsPointsHighscore()
	local str = ''
	for i, info in ipairs(guildsPoints) do
		if i >= 4 then
			break
		end

		local thronePoints = info.thronePoints
		local tmpGuild = Guild(info.guildId)
		if tmpGuild then
			str = string.format('%s%s - Points: %d\n', str, info.guildName, thronePoints)
		end
	end

	-- Reward winning guild members that are inside the castle with a surprise casket
	for _, tmpPlayer in ipairs(Game.getPlayers()) do
		for _, area in pairs(config.castleAreas) do
			if tmpPlayer:getPosition():isInRange(area.fromPosition, area.toPosition) then
				local playerGuild = tmpPlayer:getGuild()
				if playerGuild and playerGuild:getId() == newDominantId then
					local casket = tmpPlayer:addItem(config.rewardCasketId, 1)
					if casket then
						tmpPlayer:sendTextMessage(MESSAGE_EVENT_ADVANCE, "[Castle War] You received a Castle Surprise Casket for dominating the castle!")
					else
						tmpPlayer:sendTextMessage(MESSAGE_EVENT_ADVANCE, "[Castle War] Your reward casket could not be delivered (inventory full).")
					end
				end
				local safePosition = tmpPlayer:getTown():getTemplePosition()
				tmpPlayer:teleportTo(safePosition)
				break
			end
		end
	end


	if str ~= '' then
		local playersCastle = Game.getPlayers()
		for _, tmpPlayer in ipairs(playersCastle) do
			tmpPlayer:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format('Castle Score:\n%s', str))
		end
	end
end

function Castle.playersInCastle(self)
	local ret = {}
	for _, tmpPlayer in pairs(Game.getPlayers()) do
		for _, area in pairs(config.castleAreas) do
			if tmpPlayer:getPosition():isInRange(area.fromPosition, area.toPosition) and not tmpPlayer:getGroup():getAccess() then
				table.insert(ret, tmpPlayer)
				break
			end
		end
	end
	return ret
end

function Castle.getGuildsPointsHighscore(self)
	local t = {}
	for guildId, points in pairs(self.guildsPoints) do
		t[#t+1] = { guildId = guildId, thronePoints = points, guildName = Guild(guildId) and Guild(guildId):getName() or "Unknown" }
	end

	table.sort(t, function(lhs, rhs) return lhs.thronePoints > rhs.thronePoints end)
	return t
end

function Castle.getDominantGuildId(self)
	if self.dominateGuild then
		return self.dominateGuild
	end

	local resultId = db.storeQuery("SELECT `guild_id` FROM `castle_war` WHERE `active` = 1")
	if resultId then
		local guildId = Result.getNumber(resultId, "guild_id")
		Result.free(resultId)
		self.dominateGuild = guildId
		return guildId
	end
	return nil
end

function Castle.getDominantName(self)
	local guildId = self:getDominantGuildId()
	if guildId then
		local guild = Guild(guildId)
		if guild then
			return guild:getName()
		end
	end
	return nil
end

function Castle.isPlayerInDominantGuild(self, player)
	if not player then
		return false
	end

	local guild = player:getGuild()
	if not guild then
		return false
	end

	local dominantGuildId = self:getDominantGuildId()
	if not dominantGuildId then
		return false
	end

	return guild:getId() == dominantGuildId
end

function Castle.getExpBonus(self)
	return self.config.castleBonusExp or 0
end
