-- Fire Or Ice Event System
-- Storage IDs: 54040 (FOI active)

FireOrIce = {
	-- State
	state = "idle", -- idle, waiting, running
	events = {}, -- scheduled event IDs

	-- Config
	config = {
		waitingTimeSeconds = 5 * 60, -- 5 minutes waiting room
		roundIntervalSeconds = 10, -- 10 seconds per round
		announceIntervalSeconds = 60, -- announce every minute during waiting
		minPlayers = 2,

		-- Positions (MUST BE CONFIGURED for your map)
		waitingRoom = Position(726, 499, 7), -- teleport destination (center of arena)

		-- Fire side area
		fireSide = {
			fromPos = Position(715, 488, 7),
			toPos = Position(726, 512, 7),
		},
		-- Ice side area
		iceSide = {
			fromPos = Position(727, 490, 7),
			toPos = Position(738, 511, 7),
		},

		-- Totem position (NPC or item that shows countdown text)
		totemPos = Position(727, 500, 7),

		exitPos = Position(1000, 1000, 7), -- temple/exit position

		-- Teleport entry
		teleportId = 1949,
		teleportPos = Position(1015, 998, 7), -- where the TP appears in temple
		teleportActionId = 54210,

		-- Storage keys
		storageActive = 54040,
	},
}

-- ============================================================
-- Utility
-- ============================================================

function FireOrIce:getPlayersInArena()
	local list = {}
	for _, player in ipairs(Game.getPlayers()) do
		if player:getStorageValue(self.config.storageActive) == 1 and not player:getGroup():getAccess() then
			list[#list + 1] = player
		end
	end
	return list
end

function FireOrIce:isOnFireSide(player)
	return player:getPosition():isInRange(self.config.fireSide.fromPos, self.config.fireSide.toPos)
end

function FireOrIce:isOnIceSide(player)
	return player:getPosition():isInRange(self.config.iceSide.fromPos, self.config.iceSide.toPos)
end

function FireOrIce:broadcast(msg, msgType)
	msgType = msgType or MESSAGE_STATUS_WARNING
	for _, player in ipairs(self:getPlayersInArena()) do
		player:sendTextMessage(msgType, "[Fire Or Ice] " .. msg)
	end
end

function FireOrIce:stopAllEvents()
	for _, eventId in pairs(self.events) do
		stopEvent(eventId)
	end
	self.events = {}
end

function FireOrIce:totemSay(text)
	local spectators = Game.getSpectators(self.config.totemPos, false, true, 15, 15, 15, 15)
	for i = 1, #spectators do
		spectators[i]:say(text, TALKTYPE_MONSTER_SAY, false, spectators[i], self.config.totemPos)
	end
end

-- ============================================================
-- Teleport Management
-- ============================================================

function FireOrIce:createEntryTeleport()
	local item = Game.createItem(self.config.teleportId, 1, self.config.teleportPos)
	if item and item:isTeleport() then
		item:setDestination(self.config.waitingRoom)
		item:setActionId(self.config.teleportActionId)
	end
	self.config.teleportPos:sendMagicEffect(CONST_ME_TELEPORT)
end

function FireOrIce:removeEntryTeleport()
	local tile = Tile(self.config.teleportPos)
	if tile then
		local item = tile:getItemById(self.config.teleportId)
		if item then
			item:remove()
			self.config.teleportPos:sendMagicEffect(CONST_ME_POFF)
		end
	end
end

-- ============================================================
-- Player Management
-- ============================================================

function FireOrIce:removePlayer(player, silent)
	player:setStorageValue(self.config.storageActive, -1)
	player:teleportTo(self.config.exitPos)
	self.config.exitPos:sendMagicEffect(CONST_ME_TELEPORT)
	if not silent then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "[Fire Or Ice] You have been eliminated!")
	end
end

-- ============================================================
-- Event Flow
-- ============================================================

function FireOrIce:announce()
	if self.state ~= "idle" then
		return
	end

	self.state = "waiting"
	self:createEntryTeleport()

	Game.broadcastMessage("[Fire Or Ice] Fire Or Ice event starting in 5 minutes! Enter the teleport in the temple to join!", MESSAGE_EVENT_ADVANCE)

	-- Start totem waiting countdown
	self:startWaitingCountdown()

	-- Periodic announcements during waiting
	local announceCount = 0
	local maxAnnouncements = math.floor(self.config.waitingTimeSeconds / self.config.announceIntervalSeconds) - 1

	local function announceRemaining()
		announceCount = announceCount + 1
		if FireOrIce.state ~= "waiting" then
			return
		end
		if announceCount >= maxAnnouncements then
			return
		end

		local remaining = FireOrIce.config.waitingTimeSeconds - (announceCount * FireOrIce.config.announceIntervalSeconds)
		local players = FireOrIce:getPlayersInArena()

		Game.broadcastMessage(
			string.format("[Fire Or Ice] Event starts in %d minute(s)! %d player(s) in waiting room. Enter the teleport in the temple to join!", math.floor(remaining / 60), #players),
			MESSAGE_EVENT_ADVANCE
		)
		FireOrIce.events.announce = addEvent(announceRemaining, FireOrIce.config.announceIntervalSeconds * 1000)
	end

	self.events.announce = addEvent(announceRemaining, self.config.announceIntervalSeconds * 1000)

	-- Schedule start
	self.events.start = addEvent(function()
		FireOrIce:startEvent()
	end, self.config.waitingTimeSeconds * 1000)
end

function FireOrIce:startWaitingCountdown()
	local remaining = self.config.waitingTimeSeconds

	local function tick()
		if FireOrIce.state ~= "waiting" then
			return
		end

		if remaining <= 0 then
			return
		end

		local minutes = math.floor(remaining / 60)
		local seconds = remaining % 60
		FireOrIce:totemSay(string.format("%02d:%02d", minutes, seconds))

		remaining = remaining - 1
		FireOrIce.events.waitingCountdown = addEvent(tick, 1000)
	end

	tick()
end

function FireOrIce:startEvent()
	if self.state ~= "waiting" then
		return
	end

	self:removeEntryTeleport()

	-- Register players currently in the arena
	local players = {}
	for _, player in ipairs(Game.getPlayers()) do
		if not player:getGroup():getAccess() then
			local pos = player:getPosition()
			local inFire = pos:isInRange(self.config.fireSide.fromPos, self.config.fireSide.toPos)
			local inIce = pos:isInRange(self.config.iceSide.fromPos, self.config.iceSide.toPos)
			if inFire or inIce then
				player:setStorageValue(self.config.storageActive, 1)
				players[#players + 1] = player
			end
		end
	end

	if #players < self.config.minPlayers then
		Game.broadcastMessage(
			string.format("[Fire Or Ice] Event cancelled - not enough players (%d/%d).", #players, self.config.minPlayers),
			MESSAGE_EVENT_ADVANCE
		)
		for _, player in ipairs(players) do
			player:setStorageValue(self.config.storageActive, -1)
			player:teleportTo(self.config.exitPos)
			self.config.exitPos:sendMagicEffect(CONST_ME_TELEPORT)
		end
		self:cleanup()
		return
	end

	self.state = "running"

	self:broadcast("The event has started! Choose your side wisely!", MESSAGE_EVENT_ADVANCE)

	-- Start first round
	self:startRound()
end

function FireOrIce:startRound()
	if self.state ~= "running" then
		return
	end

	local remaining = self.config.roundIntervalSeconds

	local function tick()
		if FireOrIce.state ~= "running" then
			return
		end

		if remaining <= 0 then
			FireOrIce:resolveRound()
			return
		end

		FireOrIce:totemSay(tostring(remaining))
		remaining = remaining - 1
		FireOrIce.events.roundCountdown = addEvent(tick, 1000)
	end

	tick()
end

function FireOrIce:resolveRound()
	if self.state ~= "running" then
		return
	end

	-- Pick a random side: "FIRE" or "ICE" (the SAFE side)
	local safeSide = math.random(2) == 1 and "FIRE" or "ICE"
	self:totemSay(safeSide .. "!")

	-- Effects on the arena
	if safeSide == "FIRE" then
		self.config.fireSide.fromPos:sendMagicEffect(CONST_ME_FIREAREA)
		self.config.iceSide.fromPos:sendMagicEffect(CONST_ME_ICEAREA)
	else
		self.config.fireSide.fromPos:sendMagicEffect(CONST_ME_ICEAREA)
		self.config.iceSide.fromPos:sendMagicEffect(CONST_ME_FIREAREA)
	end

	self:broadcast(safeSide .. "! Players on the wrong side are eliminated!", MESSAGE_EVENT_ADVANCE)

	-- Eliminate players on the wrong side
	local survivors = {}
	local eliminated = {}

	for _, player in ipairs(self:getPlayersInArena()) do
		local onFire = self:isOnFireSide(player)
		local onIce = self:isOnIceSide(player)

		if safeSide == "FIRE" and onFire then
			survivors[#survivors + 1] = player
		elseif safeSide == "ICE" and onIce then
			survivors[#survivors + 1] = player
		else
			eliminated[#eliminated + 1] = player
		end
	end

	-- Remove eliminated players
	for _, player in ipairs(eliminated) do
		self:removePlayer(player)
	end

	-- Check end condition
	if #survivors <= 1 then
		self:finish(survivors)
		return
	end

	-- Start next round after a brief pause
	self.events.nextRound = addEvent(function()
		if FireOrIce.state == "running" then
			FireOrIce:startRound()
		end
	end, 2000)
end

function FireOrIce:finish(survivors)
	if self.state ~= "running" then
		return
	end

	self.state = "idle"
	self:stopAllEvents()

	if #survivors == 1 then
		local winner = survivors[1]
		Game.broadcastMessage(
			string.format("[Fire Or Ice] %s is the last one standing and wins the event!", winner:getName()),
			MESSAGE_EVENT_ADVANCE
		)
		winner:addItem(60306, 1)
		winner:sendTextMessage(MESSAGE_EVENT_ADVANCE, "[Fire Or Ice] Congratulations! You won! You received 1 Event Token.")
		winner:setStorageValue(self.config.storageActive, -1)
		winner:teleportTo(self.config.exitPos)
		self.config.exitPos:sendMagicEffect(CONST_ME_TELEPORT)
	else
		-- No survivors (all eliminated at once)
		Game.broadcastMessage("[Fire Or Ice] No one survived! The event ends with no winner.", MESSAGE_EVENT_ADVANCE)
	end
end

function FireOrIce:cleanup()
	self:stopAllEvents()
	self:removeEntryTeleport()

	for _, player in ipairs(self:getPlayersInArena()) do
		player:setStorageValue(self.config.storageActive, -1)
		player:teleportTo(self.config.exitPos)
		self.config.exitPos:sendMagicEffect(CONST_ME_TELEPORT)
	end

	self.state = "idle"
end

-- ============================================================
-- Player Logout
-- ============================================================

function FireOrIce:onPlayerLogout(player)
	if player:getStorageValue(self.config.storageActive) ~= 1 then
		return
	end
	player:setStorageValue(self.config.storageActive, -1)
end

-- ============================================================
-- Storage check
-- ============================================================

function FireOrIce:isInEvent(player)
	return player:getStorageValue(self.config.storageActive) == 1
end

-- ============================================================
-- Register in Event Pool
-- ============================================================

EventPool:register(
	"Fire Or Ice",
	function() return FireOrIce.state == "idle" end,
	function() FireOrIce:announce() end
)
