-- Capture The Flag Event System
-- Storage IDs: 54001 (CTF active), 54002 (CTF team), 54003 (CTF has flag)

CTF = {
	-- State
	state = "idle", -- idle, waiting, running
	players = {}, -- [guid] = { team = 1|2, name = string }
	scores = { [1] = 0, [2] = 0 },
	flagCarrier = { [1] = nil, [2] = nil }, -- [team] = guid of player carrying THIS team's flag
	events = {}, -- scheduled event IDs

	-- Config
	config = {
		waitingTimeSeconds = 5 * 60, -- 5 minutes waiting room
		maxDurationSeconds = 30 * 60, -- 30 min max duration
		minPlayers = 6,
		scoresToWin = 5,
		flagCarrierSpeed = 200,
		announceIntervalSeconds = 60, -- announce every minute during waiting

		-- Outfits (lookType for team colors)
		teamOutfit = {
			[1] = { lookType = 128, lookHead = 82, lookBody = 82, lookLegs = 82, lookFeet = 82 }, -- green
			[2] = { lookType = 128, lookHead = 94, lookBody = 94, lookLegs = 94, lookFeet = 94 }, -- red
		},
		teamOutfitFemale = {
			[1] = { lookType = 136, lookHead = 82, lookBody = 82, lookLegs = 82, lookFeet = 82 },
			[2] = { lookType = 136, lookHead = 94, lookBody = 94, lookLegs = 94, lookFeet = 94 },
		},
		teamName = {
			[1] = "Green",
			[2] = "Red",
		},

		-- Positions (MUST BE CONFIGURED for your map)
		waitingRoom = {
			fromPos = Position(827, 505, 5), -- waiting room area top-left
			toPos = Position(833, 514, 5), -- waiting room area bottom-right
			center = Position(830, 509, 5), -- teleport destination for waiting room
		},
		teamSpawn = {
			[1] = Position(806, 510, 6), -- green team spawn
			[2] = Position(852, 510, 6), -- red team spawn
		},
		-- Flag positions: the SQM where the flag item sits
		flagPos = {
			[1] = Position(802, 510, 6), -- green flag
			[2] = Position(856, 510, 6), -- red flag
		},
		-- Flag item IDs (visual flag on base and carried by player)
		flagItemId = {
			[1] = 2020, -- green flag
			[2] = 2018, -- red flag
		},
		-- Flag tiles: the SQM in front of each flag
		-- Enemy steps here to steal, owner steps here to deliver enemy flag
		flagTileActionId = {
			[1] = 54201, -- action ID on the tile in front of green flag
			[2] = 54202, -- action ID on the tile in front of red flag
		},
		arenaArea = {
			fromPos = Position(799, 488, 6), -- arena top-left
			toPos = Position(861, 529, 7), -- arena bottom-right
		},
		exitPos = Position(1000, 1000, 7), -- temple/exit position

		-- Teleport entry (appears in temple during waiting phase)
		teleportId = 1949, -- item ID of the teleport visual
		teleportPos = Position(1015, 998, 7), -- position where the TP appears in temple

		-- Storage keys
		storageActive = 54001,
		storageTeam = 54002,
		storageHasFlag = 54003,
	},
}

-- ============================================================
-- Utility
-- ============================================================

function CTF:isPlayerInArea(player, fromPos, toPos)
	return player:getPosition():isInRange(fromPos, toPos)
end

function CTF:getTeam(player)
	return self.players[player:getGuid()] and self.players[player:getGuid()].team or 0
end

function CTF:getEnemyTeam(team)
	return team == 1 and 2 or 1
end

function CTF:broadcast(msg, msgType)
	msgType = msgType or MESSAGE_STATUS_WARNING
	for guid, info in pairs(self.players) do
		local player = Player(info.name)
		if player then
			player:sendTextMessage(msgType, "[CTF] " .. msg)
		end
	end
end

function CTF:broadcastToTeam(team, msg, msgType)
	msgType = msgType or MESSAGE_STATUS_WARNING
	for guid, info in pairs(self.players) do
		if info.team == team then
			local player = Player(info.name)
			if player then
				player:sendTextMessage(msgType, "[CTF] " .. msg)
			end
		end
	end
end

function CTF:getActivePlayers()
	local list = {}
	for guid, info in pairs(self.players) do
		local player = Player(info.name)
		if player then
			list[#list + 1] = player
		end
	end
	return list
end

function CTF:getActivePlayersByTeam(team)
	local list = {}
	for guid, info in pairs(self.players) do
		if info.team == team then
			local player = Player(info.name)
			if player then
				list[#list + 1] = player
			end
		end
	end
	return list
end

function CTF:stopAllEvents()
	for _, eventId in pairs(self.events) do
		stopEvent(eventId)
	end
	self.events = {}
end

-- ============================================================
-- Join / Leave
-- ============================================================

function CTF:getPlayersInWaitingRoom()
	local list = {}
	for _, player in ipairs(Game.getPlayers()) do
		if not player:getGroup():getAccess() then
			if player:getPosition():isInRange(self.config.waitingRoom.fromPos, self.config.waitingRoom.toPos) then
				list[#list + 1] = player
			end
		end
	end
	return list
end

function CTF:registerPlayer(player)
	self.players[player:getGuid()] = {
		team = 0,
		name = player:getName(),
		level = player:getLevel(),
	}
	player:setStorageValue(self.config.storageActive, 1)
end

function CTF:removePlayer(player, silent)
	local guid = player:getGuid()
	if not self.players[guid] then
		return
	end

	local team = self.players[guid].team

	-- If carrying a flag, drop it
	if team > 0 then
		local enemyTeam = self:getEnemyTeam(team)
		if self.flagCarrier[enemyTeam] == guid then
			self:dropFlag(enemyTeam, player)
		end
	end

	-- Remove outfit and speed enforcement
	self:restoreOutfit(player)
	self:removeFlagCarrierSlow(player)

	-- Clear storages
	player:setStorageValue(self.config.storageActive, -1)
	player:setStorageValue(self.config.storageTeam, -1)
	player:setStorageValue(self.config.storageHasFlag, -1)

	-- Teleport out
	player:teleportTo(self.config.exitPos)
	self.config.exitPos:sendMagicEffect(CONST_ME_TELEPORT)

	self.players[guid] = nil

	if not silent then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "[CTF] You have been removed from the event.")
	end
end

-- ============================================================
-- Team Balancing
-- ============================================================

function CTF:assignTeams()
	-- Collect all registered players sorted by level descending
	local sorted = {}
	for guid, info in pairs(self.players) do
		sorted[#sorted + 1] = { guid = guid, level = info.level, name = info.name }
	end
	table.sort(sorted, function(a, b) return a.level > b.level end)

	-- Snake draft: strongest goes to team 1, next to team 2, next to team 2, next to team 1, etc.
	local teamPower = { [1] = 0, [2] = 0 }
	for i, entry in ipairs(sorted) do
		local team
		if teamPower[1] <= teamPower[2] then
			team = 1
		else
			team = 2
		end
		self.players[entry.guid].team = team
		teamPower[team] = teamPower[team] + entry.level
	end
end

-- ============================================================
-- Outfit & Conditions
-- ============================================================

function CTF:applyTeamOutfit(player)
	local team = self:getTeam(player)
	if team == 0 then
		return
	end

	local isFemale = player:getSex() == PLAYERSEX_FEMALE
	local outfitTable = isFemale and self.config.teamOutfitFemale or self.config.teamOutfit
	local outfit = outfitTable[team]

	-- Save original outfit on first apply
	local guid = player:getGuid()
	if not self.savedOutfits then
		self.savedOutfits = {}
	end
	if not self.savedOutfits[guid] then
		self.savedOutfits[guid] = player:getOutfit()
	end

	self.outfitBypass = true
	player:setOutfit(outfit)
	self.outfitBypass = false
end

function CTF:restoreOutfit(player)
	if not self.savedOutfits then
		return
	end
	local guid = player:getGuid()
	local saved = self.savedOutfits[guid]
	if saved then
		self.outfitBypass = true
		player:setOutfit(saved)
		self.outfitBypass = false
		self.savedOutfits[guid] = nil
	end
end

function CTF:applyFlagCarrierSlow(player)
	-- Enforce fixed speed via recurring tick instead of CONDITION_PARALYZE
	-- This prevents haste spells from overriding the slow
	local playerName = player:getName()
	self:enforceSpeed(playerName)
	self:startFlagFollow(playerName)
end

function CTF:enforceSpeed(playerName)
	local player = Player(playerName)
	if not player then
		return
	end
	if CTF.state ~= "running" then
		return
	end
	local guid = player:getGuid()
	if not CTF.players[guid] then
		return
	end
	if player:getStorageValue(CTF.config.storageHasFlag) <= 0 then
		return
	end

	-- Remove any haste/paralyze conditions that may interfere
	player:removeCondition(CONDITION_HASTE)
	player:removeCondition(CONDITION_PARALYZE)

	-- Force speed to target value
	local currentSpeed = player:getSpeed()
	local targetSpeed = CTF.config.flagCarrierSpeed
	if currentSpeed ~= targetSpeed then
		player:changeSpeed(targetSpeed - currentSpeed)
	end

	-- Show [FLAG] text above player
	player:say("[FLAG]", TALKTYPE_MONSTER_SAY)

	-- Reschedule every second (speed + text)
	CTF.events["speed_" .. playerName] = addEvent(function()
		CTF:enforceSpeed(playerName)
	end, 1000)
end

function CTF:startFlagFollow(playerName)
	self:updateFlagPosition(playerName)
end

function CTF:updateFlagPosition(playerName)
	local player = Player(playerName)
	if not player then
		return
	end
	if CTF.state ~= "running" then
		return
	end
	local guid = player:getGuid()
	local teamCarrying = player:getStorageValue(CTF.config.storageHasFlag)
	if not teamCarrying or teamCarrying <= 0 then
		return
	end

	local pos = player:getPosition()
	local flagItemId = CTF.config.flagItemId[teamCarrying]

	-- Remove flag from previous position
	if CTF.lastFlagPos and CTF.lastFlagPos[guid] then
		local oldPos = CTF.lastFlagPos[guid]
		if oldPos.x ~= pos.x or oldPos.y ~= pos.y or oldPos.z ~= pos.z then
			local oldTile = Tile(oldPos)
			if oldTile then
				local oldItem = oldTile:getItemById(flagItemId)
				if oldItem then
					oldItem:remove()
				end
			end
			Game.createItem(flagItemId, 1, pos)
			CTF.lastFlagPos[guid] = pos
		end
	else
		Game.createItem(flagItemId, 1, pos)
		if not CTF.lastFlagPos then
			CTF.lastFlagPos = {}
		end
		CTF.lastFlagPos[guid] = pos
	end

	-- Reschedule every 100ms (flag position)
	CTF.events["flag_" .. playerName] = addEvent(function()
		CTF:updateFlagPosition(playerName)
	end, 100)
end

function CTF:stopFlagFollow(player)
	local playerName = player:getName()
	local eventKey = "flag_" .. playerName
	if self.events[eventKey] then
		stopEvent(self.events[eventKey])
		self.events[eventKey] = nil
	end
end

function CTF:removeFlagCarrierSlow(player)
	local playerName = player:getName()
	local guid = player:getGuid()

	-- Stop the speed enforcement tick
	local eventKey = "speed_" .. playerName
	if self.events[eventKey] then
		stopEvent(self.events[eventKey])
		self.events[eventKey] = nil
	end

	-- Stop the flag follow tick
	self:stopFlagFollow(player)

	-- Remove any leftover conditions
	player:removeCondition(CONDITION_PARALYZE)

	-- Restore normal speed by removing delta
	local currentSpeed = player:getSpeed()
	local baseSpeed = player:getBaseSpeed()
	if currentSpeed ~= baseSpeed then
		player:changeSpeed(baseSpeed - currentSpeed)
	end
end

-- ============================================================
-- Flag Visuals (item on base and carried by player)
-- ============================================================

function CTF:spawnBaseFlag(flagTeam)
	local pos = self.config.flagPos[flagTeam]
	local itemId = self.config.flagItemId[flagTeam]
	-- Remove any existing flag first
	self:removeBaseFlag(flagTeam)
	Game.createItem(itemId, 1, pos)
end

function CTF:removeBaseFlag(flagTeam)
	local pos = self.config.flagPos[flagTeam]
	local tile = Tile(pos)
	if tile then
		local item = tile:getItemById(self.config.flagItemId[flagTeam])
		if item then
			item:remove()
		end
	end
end

function CTF:spawnCarriedFlag(player, flagTeam)
	local pos = player:getPosition()
	local itemId = self.config.flagItemId[flagTeam]
	-- Remove previous carried flag item if exists
	self:removeCarriedFlag(player, flagTeam)
	Game.createItem(itemId, 1, pos)
end

function CTF:removeCarriedFlag(player, flagTeam)
	local guid = player:getGuid()
	local flagItemId = self.config.flagItemId[flagTeam]

	-- Remove from lastFlagPos (authoritative position from the 100ms tick)
	if self.lastFlagPos and self.lastFlagPos[guid] then
		local oldTile = Tile(self.lastFlagPos[guid])
		if oldTile then
			local item = oldTile:getItemById(flagItemId)
			if item then
				item:remove()
			end
		end
		self.lastFlagPos[guid] = nil
	end

	-- Also remove from current player position as fallback
	local pos = player:getPosition()
	local tile = Tile(pos)
	if tile then
		local item = tile:getItemById(flagItemId)
		if item then
			item:remove()
		end
	end
end

function CTF:spawnAllBaseFlags()
	self:spawnBaseFlag(1)
	self:spawnBaseFlag(2)
end

function CTF:removeAllBaseFlags()
	self:removeBaseFlag(1)
	self:removeBaseFlag(2)
end

-- ============================================================
-- Flag Mechanics
-- ============================================================

function CTF:pickupFlag(flagTeam, player)
	local playerTeam = self:getTeam(player)
	if playerTeam == 0 or playerTeam == flagTeam then
		return false -- can't pick up your own flag
	end

	-- Already carrying a flag
	if player:getStorageValue(self.config.storageHasFlag) > 0 then
		return false
	end

	-- Someone else already carrying this flag
	if self.flagCarrier[flagTeam] then
		return false
	end

	self.flagCarrier[flagTeam] = player:getGuid()
	player:setStorageValue(self.config.storageHasFlag, flagTeam)
	self:applyFlagCarrierSlow(player)

	-- Remove flag from base and show on player
	self:removeBaseFlag(flagTeam)
	self.config.flagPos[flagTeam]:sendMagicEffect(CONST_ME_POFF)

	self:broadcast(string.format("%s has stolen the %s flag!", player:getName(), self.config.teamName[flagTeam]), MESSAGE_EVENT_ADVANCE)

	return true
end

function CTF:deliverFlag(deliverTeam, player)
	local playerTeam = self:getTeam(player)
	if playerTeam ~= deliverTeam then
		return false -- can only deliver at your own base
	end

	local carriedFlag = player:getStorageValue(self.config.storageHasFlag)
	if carriedFlag <= 0 then
		return false -- not carrying a flag
	end

	-- Score! Stop ticks first, then remove flag, then clear state
	self:stopFlagFollow(player)
	self.scores[playerTeam] = self.scores[playerTeam] + 1
	self.flagCarrier[carriedFlag] = nil
	self:removeCarriedFlag(player, carriedFlag)
	player:setStorageValue(self.config.storageHasFlag, -1)
	self:removeFlagCarrierSlow(player)

	self:broadcast(
		string.format(
			"%s captured the %s flag! Score: %s %d x %d %s",
			player:getName(),
			self.config.teamName[carriedFlag],
			self.config.teamName[1],
			self.scores[1],
			self.scores[2],
			self.config.teamName[2]
		),
		MESSAGE_EVENT_ADVANCE
	)

	-- Check win condition
	if self.scores[playerTeam] >= self.config.scoresToWin then
		self:finish(playerTeam)
		return true
	end

	-- Reset round after 1 second
	self:broadcast("New round starting in 1 second...", MESSAGE_EVENT_ADVANCE)
	addEvent(function()
		if CTF.state == "running" then
			CTF:resetRound()
		end
	end, 1000)
	return true
end

function CTF:resetRound()
	-- Clear any flag carrier state
	self.flagCarrier = { [1] = nil, [2] = nil }

	-- Restore both flags to their bases
	self:spawnAllBaseFlags()

	-- Teleport all players back to their team spawn, heal, reset conditions
	for guid, info in pairs(self.players) do
		local player = Player(info.name)
		if player then
			self:removeFlagCarrierSlow(player)
			player:setStorageValue(self.config.storageHasFlag, -1)

			local spawnPos = self.config.teamSpawn[info.team]
			player:teleportTo(spawnPos)
			spawnPos:sendMagicEffect(CONST_ME_TELEPORT)
			player:addHealth(player:getMaxHealth())
			player:addMana(player:getMaxMana())
			self:applyTeamOutfit(player)
		end
	end

	self:broadcast("Go!", MESSAGE_EVENT_ADVANCE)
end

function CTF:dropFlag(flagTeam, player)
	if self.flagCarrier[flagTeam] ~= player:getGuid() then
		return
	end

	self:stopFlagFollow(player)
	self.flagCarrier[flagTeam] = nil
	self:removeCarriedFlag(player, flagTeam)
	player:setStorageValue(self.config.storageHasFlag, -1)
	self:removeFlagCarrierSlow(player)

	-- Restore flag to base
	self:spawnBaseFlag(flagTeam)

	self:broadcast(
		string.format("The %s flag has been returned!", self.config.teamName[flagTeam]),
		MESSAGE_EVENT_ADVANCE
	)
end

-- ============================================================
-- Player Death in CTF
-- ============================================================

function CTF:onPlayerDeath(player)
	if self.state ~= "running" then
		return
	end

	local guid = player:getGuid()
	if not self.players[guid] then
		return
	end

	local team = self.players[guid].team

	-- Drop flag if carrying
	local enemyTeam = self:getEnemyTeam(team)
	if self.flagCarrier[enemyTeam] == guid then
		self:dropFlag(enemyTeam, player)
	end

	-- Instant respawn at team base (heal before teleport so client sees full HP)
	local teamSpawn = self.config.teamSpawn[team]
	player:addHealth(player:getMaxHealth())
	player:addMana(player:getMaxMana())
	player:teleportTo(teamSpawn)
	teamSpawn:sendMagicEffect(CONST_ME_TELEPORT)
	self:applyTeamOutfit(player)
end

-- ============================================================
-- Event Flow
-- ============================================================

function CTF:createEntryTeleport()
	local item = Game.createItem(self.config.teleportId, 1, self.config.teleportPos)
	if item and item:isTeleport() then
		item:setDestination(self.config.waitingRoom.center)
		item:setActionId(54200)
	end
	self.config.teleportPos:sendMagicEffect(CONST_ME_TELEPORT)
end

function CTF:removeEntryTeleport()
	local tile = Tile(self.config.teleportPos)
	if tile then
		local item = tile:getItemById(self.config.teleportId)
		if item then
			item:remove()
			self.config.teleportPos:sendMagicEffect(CONST_ME_POFF)
		end
	end
end

function CTF:announce()
	if self.state ~= "idle" then
		return
	end

	self.state = "waiting"
	self.players = {}
	self.scores = { [1] = 0, [2] = 0 }
	self.flagCarrier = { [1] = nil, [2] = nil }

	-- Create entry teleport in temple
	self:createEntryTeleport()

	Game.broadcastMessage("[CTF] Capture The Flag event starting in 5 minutes! Enter the teleport in the temple to join!", MESSAGE_EVENT_ADVANCE)

	-- Periodic announcements during waiting
	local announceCount = 0
	local maxAnnouncements = math.floor(self.config.waitingTimeSeconds / self.config.announceIntervalSeconds) - 1

	local function announceRemaining()
		announceCount = announceCount + 1
		if CTF.state ~= "waiting" then
			return
		end
		if announceCount >= maxAnnouncements then
			return
		end

		local remaining = self.config.waitingTimeSeconds - (announceCount * self.config.announceIntervalSeconds)
		local waitingPlayers = CTF:getPlayersInWaitingRoom()
		local playerCount = #waitingPlayers

		Game.broadcastMessage(
			string.format("[CTF] Capture The Flag starts in %d minute(s)! %d player(s) in waiting room. Enter the teleport in the temple to join!", math.floor(remaining / 60), playerCount),
			MESSAGE_EVENT_ADVANCE
		)
		CTF.events.announce = addEvent(announceRemaining, CTF.config.announceIntervalSeconds * 1000)
	end

	self.events.announce = addEvent(announceRemaining, self.config.announceIntervalSeconds * 1000)

	-- Schedule start
	self.events.start = addEvent(function()
		CTF:startEvent()
	end, self.config.waitingTimeSeconds * 1000)
end

function CTF:startEvent()
	if self.state ~= "waiting" then
		return
	end

	-- Remove entry teleport
	self:removeEntryTeleport()

	-- Register players currently in the waiting room
	local waitingPlayers = self:getPlayersInWaitingRoom()
	for _, player in ipairs(waitingPlayers) do
		self:registerPlayer(player)
	end

	local playerCount = #waitingPlayers
	if playerCount < self.config.minPlayers then
		Game.broadcastMessage(
			string.format("[CTF] Capture The Flag cancelled - not enough players (%d/%d).", playerCount, self.config.minPlayers),
			MESSAGE_EVENT_ADVANCE
		)
		-- Teleport waiting room players back to temple
		for _, player in ipairs(waitingPlayers) do
			player:teleportTo(self.config.exitPos)
			self.config.exitPos:sendMagicEffect(CONST_ME_TELEPORT)
		end
		self:cleanup()
		return
	end

	self.state = "running"
	self.lastFlagPos = {}

	-- Spawn flags on bases
	self:spawnAllBaseFlags()

	-- Assign teams
	self:assignTeams()

	-- Teleport players to their team spawns and apply outfits
	for guid, info in pairs(self.players) do
		local player = Player(info.name)
		if player then
			local spawnPos = self.config.teamSpawn[info.team]
			player:teleportTo(spawnPos)
			spawnPos:sendMagicEffect(CONST_ME_TELEPORT)
			player:setStorageValue(self.config.storageTeam, info.team)
			player:setStorageValue(self.config.storageHasFlag, -1)
			self:applyTeamOutfit(player)
			player:addHealth(player:getMaxHealth())
			player:addMana(player:getMaxMana())
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("[CTF] You are on the %s team! Steal the enemy flag and bring it to your base!", self.config.teamName[info.team]))
		else
			self.players[guid] = nil
		end
	end

	self:broadcast(
		string.format("Capture The Flag has started! %s vs %s - First to %d captures wins!", self.config.teamName[1], self.config.teamName[2], self.config.scoresToWin),
		MESSAGE_EVENT_ADVANCE
	)

	-- Schedule max duration timeout
	self.events.timeout = addEvent(function()
		if CTF.state == "running" then
			CTF:finishByTimeout()
		end
	end, self.config.maxDurationSeconds * 1000)
end

function CTF:finishByTimeout()
	if self.state ~= "running" then
		return
	end

	-- Determine winner by score
	local winnerTeam = nil
	if self.scores[1] > self.scores[2] then
		winnerTeam = 1
	elseif self.scores[2] > self.scores[1] then
		winnerTeam = 2
	end

	if winnerTeam then
		Game.broadcastMessage(
			string.format("[CTF] Time is up! The %s team wins with %d x %d!",
				self.config.teamName[winnerTeam],
				self.scores[1],
				self.scores[2]
			),
			MESSAGE_EVENT_ADVANCE
		)
		self:finish(winnerTeam)
	else
		-- Draw
		Game.broadcastMessage(
			string.format("[CTF] Time is up! The match ended in a draw %d x %d!",
				self.scores[1],
				self.scores[2]
			),
			MESSAGE_EVENT_ADVANCE
		)
		self:cleanup()
	end
end

function CTF:finish(winnerTeam)
	if self.state ~= "running" then
		return
	end

	self.state = "idle"
	self:stopAllEvents()

	local winnerName = self.config.teamName[winnerTeam]

	Game.broadcastMessage(
		string.format("[CTF] The %s team wins Capture The Flag! Final score: %s %d x %d %s",
			winnerName,
			self.config.teamName[1],
			self.scores[1],
			self.scores[2],
			self.config.teamName[2]
		),
		MESSAGE_EVENT_ADVANCE
	)

	-- Reward winners and cleanup all players
	for guid, info in pairs(self.players) do
		local player = Player(info.name)
		if player then
			self:restoreOutfit(player)
			self:removeFlagCarrierSlow(player)
			player:setStorageValue(self.config.storageActive, -1)
			player:setStorageValue(self.config.storageTeam, -1)
			player:setStorageValue(self.config.storageHasFlag, -1)

			if info.team == winnerTeam then
				player:addItem(60306, 1)
				player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "[CTF] Congratulations! Your team won! You received 1 Event Token.")
			else
				player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "[CTF] Your team lost. Better luck next time!")
			end

			player:teleportTo(self.config.exitPos)
			self.config.exitPos:sendMagicEffect(CONST_ME_TELEPORT)
			player:addHealth(player:getMaxHealth())
			player:addMana(player:getMaxMana())
		end
	end

	self:removeAllBaseFlags()
	self.players = {}
	self.scores = { [1] = 0, [2] = 0 }
	self.flagCarrier = { [1] = nil, [2] = nil }
	self.savedOutfits = {}
	self.lastFlagPos = {}
end

function CTF:cleanup()
	self:stopAllEvents()
	self:removeEntryTeleport()
	self:removeAllBaseFlags()

	for guid, info in pairs(self.players) do
		local player = Player(info.name)
		if player then
			self:restoreOutfit(player)
			self:removeFlagCarrierSlow(player)
			player:setStorageValue(self.config.storageActive, -1)
			player:setStorageValue(self.config.storageTeam, -1)
			player:setStorageValue(self.config.storageHasFlag, -1)
			player:teleportTo(self.config.exitPos)
			self.config.exitPos:sendMagicEffect(CONST_ME_TELEPORT)
		end
	end

	self.players = {}
	self.scores = { [1] = 0, [2] = 0 }
	self.flagCarrier = { [1] = nil, [2] = nil }
	self.savedOutfits = {}
	self.lastFlagPos = {}
	self.state = "idle"
end

-- ============================================================
-- Player Logout
-- ============================================================

function CTF:onPlayerLogout(player)
	local guid = player:getGuid()
	if not self.players[guid] then
		return
	end

	self:removePlayer(player, true)
end

-- ============================================================
-- Outfit change check
-- ============================================================

function CTF:isInEvent(player)
	return player:getStorageValue(self.config.storageActive) == 1
end

-- ============================================================
-- Register in Event Pool
-- ============================================================

EventPool:register(
	"Capture The Flag",
	function() return CTF.state == "idle" end,
	function() CTF:announce() end
)
