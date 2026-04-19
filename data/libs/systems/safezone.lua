-- Safezone Event System
-- Storage IDs: 54030 (SZ active)

Safezone = {
	-- State
	state = "idle", -- idle, waiting, running
	events = {}, -- scheduled event IDs
	safeTiles = {}, -- positions of currently active safe tiles

	-- Config
	config = {
		waitingTimeSeconds = 5 * 60, -- 5 minutes waiting room
		safeDisplaySeconds = 7, -- safe tiles visible for 7 seconds
		roundPauseSeconds = 3, -- pause between rounds
		announceIntervalSeconds = 60, -- announce every minute during waiting
		minPlayers = 2,

		-- Tile IDs
		normalTileId = 429, -- stone tile (normal floor)
		safeTileId = 409, -- green tile (safe zone)

		-- Arena area (all tiles inside this area are used for spawning safe zones)
		arenaArea = {
			fromPos = Position(648, 495, 7),
			toPos = Position(663, 510, 7),
		},

		-- Teleport destination (center of arena)
		waitingRoom = Position(655, 502, 7),

		exitPos = Position(1000, 1000, 7), -- temple/exit position

		-- Teleport entry
		teleportId = 1949,
		teleportPos = Position(1015, 998, 7),
		teleportActionId = 54220,

		-- Storage keys
		storageActive = 54030,
	},
}

-- ============================================================
-- Utility
-- ============================================================

function Safezone:getPlayersInEvent()
	local list = {}
	for _, player in ipairs(Game.getPlayers()) do
		if player:getStorageValue(self.config.storageActive) == 1 and not player:getGroup():getAccess() then
			list[#list + 1] = player
		end
	end
	return list
end

function Safezone:getPlayersInArena()
	local list = {}
	for _, player in ipairs(Game.getPlayers()) do
		if not player:getGroup():getAccess() then
			if player:getPosition():isInRange(self.config.arenaArea.fromPos, self.config.arenaArea.toPos) then
				list[#list + 1] = player
			end
		end
	end
	return list
end

function Safezone:broadcast(msg, msgType)
	msgType = msgType or MESSAGE_STATUS_WARNING
	for _, player in ipairs(self:getPlayersInEvent()) do
		player:sendTextMessage(msgType, "[Safezone] " .. msg)
	end
end

function Safezone:stopAllEvents()
	for _, eventId in pairs(self.events) do
		stopEvent(eventId)
	end
	self.events = {}
end

-- ============================================================
-- Teleport Management
-- ============================================================

function Safezone:createEntryTeleport()
	local item = Game.createItem(self.config.teleportId, 1, self.config.teleportPos)
	if item and item:isTeleport() then
		item:setDestination(self.config.waitingRoom)
		item:setActionId(self.config.teleportActionId)
	end
	self.config.teleportPos:sendMagicEffect(CONST_ME_TELEPORT)
end

function Safezone:removeEntryTeleport()
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
-- Tile Management
-- ============================================================

function Safezone:getAvailablePositions()
	-- Get all walkable positions in the arena that don't already have a safe tile
	local positions = {}
	local from = self.config.arenaArea.fromPos
	local to = self.config.arenaArea.toPos

	for x = from.x, to.x do
		for y = from.y, to.y do
			for z = from.z, to.z do
				local pos = Position(x, y, z)
				local tile = Tile(pos)
				if tile and tile:getGround() then
					if tile:isWalkable(false, false, false, false, true) then
						-- Skip positions that already have a safe tile
						if not tile:getItemById(self.config.safeTileId) then
							positions[#positions + 1] = pos
						end
					end
				end
			end
		end
	end
	return positions
end

function Safezone:spawnSafeTiles(count)
	local available = self:getAvailablePositions()
	self.safeTiles = {}

	-- Shuffle available positions
	for i = #available, 2, -1 do
		local j = math.random(i)
		available[i], available[j] = available[j], available[i]
	end

	-- Pick 'count' positions and transform ground to safe tile
	local spawned = 0
	for _, pos in ipairs(available) do
		if spawned >= count then
			break
		end

		local tile = Tile(pos)
		if tile then
			local ground = tile:getGround()
			if ground then
				ground:transform(self.config.safeTileId)
				pos:sendMagicEffect(CONST_ME_MAGIC_GREEN)
				-- Save a copy of the position (x, y, z)
				self.safeTiles[#self.safeTiles + 1] = { x = pos.x, y = pos.y, z = pos.z }
				spawned = spawned + 1
			end
		end
	end
end

function Safezone:clearSafeTiles()
	for _, saved in ipairs(self.safeTiles) do
		local pos = Position(saved.x, saved.y, saved.z)
		local tile = Tile(pos)
		if tile then
			local ground = tile:getGround()
			if ground then
				ground:transform(self.config.normalTileId)
			end
		end
	end
	self.safeTiles = {}
end

function Safezone:isOnSafeTile(player)
	local pos = player:getPosition()
	for _, safePos in ipairs(self.safeTiles) do
		if pos.x == safePos.x and pos.y == safePos.y and pos.z == safePos.z then
			return true
		end
	end
	return false
end

-- ============================================================
-- Player Management
-- ============================================================

function Safezone:removePlayer(player, silent)
	player:setStorageValue(self.config.storageActive, -1)
	player:teleportTo(self.config.exitPos)
	self.config.exitPos:sendMagicEffect(CONST_ME_TELEPORT)
	if not silent then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "[Safezone] You have been eliminated!")
	end
end

-- ============================================================
-- Event Flow
-- ============================================================

function Safezone:announce()
	if self.state ~= "idle" then
		return
	end

	self.state = "waiting"
	self:createEntryTeleport()

	Game.broadcastMessage("[Safezone] Safezone event starting in 5 minutes! Enter the teleport in the temple to join!", MESSAGE_EVENT_ADVANCE)

	-- Start totem waiting countdown
	self:startWaitingCountdown()

	-- Periodic announcements
	local announceCount = 0
	local maxAnnouncements = math.floor(self.config.waitingTimeSeconds / self.config.announceIntervalSeconds) - 1

	local function announceRemaining()
		announceCount = announceCount + 1
		if Safezone.state ~= "waiting" then
			return
		end
		if announceCount >= maxAnnouncements then
			return
		end

		local remaining = Safezone.config.waitingTimeSeconds - (announceCount * Safezone.config.announceIntervalSeconds)
		local players = Safezone:getPlayersInArena()

		Game.broadcastMessage(
			string.format("[Safezone] Event starts in %d minute(s)! %d player(s) in waiting room. Enter the teleport in the temple to join!", math.floor(remaining / 60), #players),
			MESSAGE_EVENT_ADVANCE
		)
		Safezone.events.announce = addEvent(announceRemaining, Safezone.config.announceIntervalSeconds * 1000)
	end

	self.events.announce = addEvent(announceRemaining, self.config.announceIntervalSeconds * 1000)

	-- Schedule start
	self.events.start = addEvent(function()
		Safezone:startEvent()
	end, self.config.waitingTimeSeconds * 1000)
end

function Safezone:startWaitingCountdown()
	local remaining = self.config.waitingTimeSeconds

	local function tick()
		if Safezone.state ~= "waiting" then
			return
		end
		if remaining <= 0 then
			return
		end

		remaining = remaining - 1
		Safezone.events.waitingCountdown = addEvent(tick, 1000)
	end

	tick()
end

function Safezone:startEvent()
	if self.state ~= "waiting" then
		return
	end

	self:removeEntryTeleport()

	-- Register players currently in the arena
	local players = self:getPlayersInArena()
	for _, player in ipairs(players) do
		player:setStorageValue(self.config.storageActive, 1)
	end

	if #players < self.config.minPlayers then
		Game.broadcastMessage(
			string.format("[Safezone] Event cancelled - not enough players (%d/%d).", #players, self.config.minPlayers),
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

	self:broadcast("The event has started! Stand on the safe tiles to survive!", MESSAGE_EVENT_ADVANCE)

	-- Start first round
	self:startRound()
end

function Safezone:startRound()
	if self.state ~= "running" then
		return
	end

	local players = self:getPlayersInEvent()
	local playerCount = #players

	-- Check end condition before starting a new round
	if playerCount <= 1 then
		self:finish(players)
		return
	end

	-- Spawn N-1 safe tiles
	local safeTileCount = playerCount - 1
	self:spawnSafeTiles(safeTileCount)

	self:broadcast(
		string.format("%d safe zones appeared! You have %d seconds!", safeTileCount, self.config.safeDisplaySeconds),
		MESSAGE_EVENT_ADVANCE
	)

	-- Start countdown on totem
	local remaining = self.config.safeDisplaySeconds

	local function tick()
		if Safezone.state ~= "running" then
			return
		end

		if remaining <= 0 then
			Safezone:resolveRound()
			return
		end

		remaining = remaining - 1
		Safezone.events.roundCountdown = addEvent(tick, 1000)
	end

	tick()
end

function Safezone:resolveRound()
	if self.state ~= "running" then
		return
	end

	-- Check who is on a safe tile
	local survivors = {}
	local eliminated = {}

	for _, player in ipairs(self:getPlayersInEvent()) do
		if self:isOnSafeTile(player) then
			survivors[#survivors + 1] = player
		else
			eliminated[#eliminated + 1] = player
		end
	end

	-- Remove eliminated players
	for _, player in ipairs(eliminated) do
		self:removePlayer(player)
	end

	-- Clear safe tiles back to normal
	self:clearSafeTiles()

	if #eliminated > 0 then
		self:broadcast(
			string.format("%d player(s) eliminated! %d remaining.", #eliminated, #survivors),
			MESSAGE_EVENT_ADVANCE
		)
	end

	-- Check end condition
	if #survivors <= 1 then
		self:finish(survivors)
		return
	end

	-- Pause then start next round
	self:broadcast(
		string.format("Next round in %d seconds...", self.config.roundPauseSeconds),
		MESSAGE_EVENT_ADVANCE
	)
	self.events.nextRound = addEvent(function()
		if Safezone.state == "running" then
			Safezone:startRound()
		end
	end, self.config.roundPauseSeconds * 1000)
end

function Safezone:finish(survivors)
	if self.state ~= "running" then
		return
	end

	self.state = "idle"
	self:stopAllEvents()
	self:clearSafeTiles()

	if #survivors == 1 then
		local winner = survivors[1]
		Game.broadcastMessage(
			string.format("[Safezone] %s is the last one standing and wins the event!", winner:getName()),
			MESSAGE_EVENT_ADVANCE
		)
		winner:addItem(60306, 1)
		winner:sendTextMessage(MESSAGE_EVENT_ADVANCE, "[Safezone] Congratulations! You won! You received 1 Event Token.")
		winner:setStorageValue(self.config.storageActive, -1)
		winner:teleportTo(self.config.exitPos)
		self.config.exitPos:sendMagicEffect(CONST_ME_TELEPORT)
	else
		Game.broadcastMessage("[Safezone] No one survived! The event ends with no winner.", MESSAGE_EVENT_ADVANCE)
	end
end

function Safezone:cleanup()
	self:stopAllEvents()
	self:removeEntryTeleport()
	self:clearSafeTiles()

	-- Kick registered players (running phase)
	for _, player in ipairs(self:getPlayersInEvent()) do
		player:setStorageValue(self.config.storageActive, -1)
		player:teleportTo(self.config.exitPos)
		self.config.exitPos:sendMagicEffect(CONST_ME_TELEPORT)
	end

	-- Kick players in waiting room (waiting phase)
	for _, player in ipairs(self:getPlayersInArena()) do
		player:teleportTo(self.config.exitPos)
		self.config.exitPos:sendMagicEffect(CONST_ME_TELEPORT)
	end

	self.state = "idle"
end

-- ============================================================
-- Player Logout
-- ============================================================

function Safezone:onPlayerLogout(player)
	if player:getStorageValue(self.config.storageActive) ~= 1 then
		return
	end
	player:setStorageValue(self.config.storageActive, -1)
end

-- ============================================================
-- Storage check
-- ============================================================

function Safezone:isInEvent(player)
	return player:getStorageValue(self.config.storageActive) == 1
end

-- ============================================================
-- Register in Event Pool
-- ============================================================

EventPool:register(
	"Safezone",
	function() return Safezone.state == "idle" end,
	function() Safezone:announce() end
)
