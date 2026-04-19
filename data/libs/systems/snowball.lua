-- Snowball Fight Event System
-- Storage IDs: 54050 (SB active)

Snowball = {
	-- State
	state = "idle", -- idle, waiting, running
	events = {}, -- scheduled event IDs

	-- Config
	config = {
		waitingTimeSeconds = 5 * 60, -- 5 minutes waiting room
		announceIntervalSeconds = 60, -- announce every minute during waiting
		minPlayers = 2,
		maxDurationSeconds = 30 * 60, -- 30 minutes max
		playerSpeed = 150, -- fixed speed during event
		snowballRange = 7, -- max tiles the snowball travels
		snowballSpeed = 150, -- ms between each tile step

		-- Arena area
		arenaArea = {
			fromPos = Position(678, 376, 7),
			toPos = Position(747, 415, 7),
		},

		-- Waiting room area
		waitingRoom = Position(699, 400, 5), -- teleport destination
		waitingRoomArea = {
			fromPos = Position(695, 396, 5),
			toPos = Position(703, 404, 5),
		},

		exitPos = Position(1000, 1000, 7), -- temple/exit position

		-- Teleport entry
		teleportId = 1949,
		teleportPos = Position(1015, 998, 7),
		teleportActionId = 54230,

		-- Storage keys
		storageActive = 54050,
	},
}

-- ============================================================
-- Utility
-- ============================================================

function Snowball:getPlayersInEvent()
	local list = {}
	for _, player in ipairs(Game.getPlayers()) do
		if player:getStorageValue(self.config.storageActive) == 1 and not player:getGroup():getAccess() then
			list[#list + 1] = player
		end
	end
	return list
end

function Snowball:getPlayersInArena()
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

function Snowball:getPlayersInWaitingRoom()
	local list = {}
	for _, player in ipairs(Game.getPlayers()) do
		if not player:getGroup():getAccess() then
			if player:getPosition():isInRange(self.config.waitingRoomArea.fromPos, self.config.waitingRoomArea.toPos) then
				list[#list + 1] = player
			end
		end
	end
	return list
end

function Snowball:getRandomArenaPositions(count)
	local positions = {}
	local from = self.config.arenaArea.fromPos
	local to = self.config.arenaArea.toPos

	for x = from.x, to.x do
		for y = from.y, to.y do
			for z = from.z, to.z do
				local pos = Position(x, y, z)
				local tile = Tile(pos)
				if tile and tile:getGround() and tile:isWalkable(false, false, false, false, true) then
					positions[#positions + 1] = pos
				end
			end
		end
	end

	-- Shuffle
	for i = #positions, 2, -1 do
		local j = math.random(i)
		positions[i], positions[j] = positions[j], positions[i]
	end

	-- Return up to 'count' positions
	local result = {}
	for i = 1, math.min(count, #positions) do
		result[i] = positions[i]
	end
	return result
end

function Snowball:broadcast(msg, msgType)
	msgType = msgType or MESSAGE_STATUS_WARNING
	for _, player in ipairs(self:getPlayersInEvent()) do
		player:sendTextMessage(msgType, "[Snowball] " .. msg)
	end
end

function Snowball:stopAllEvents()
	for _, eventId in pairs(self.events) do
		stopEvent(eventId)
	end
	self.events = {}
end

-- ============================================================
-- Teleport Management
-- ============================================================

function Snowball:createEntryTeleport()
	local item = Game.createItem(self.config.teleportId, 1, self.config.teleportPos)
	if item and item:isTeleport() then
		item:setDestination(self.config.waitingRoom)
		item:setActionId(self.config.teleportActionId)
	end
	self.config.teleportPos:sendMagicEffect(CONST_ME_TELEPORT)
end

function Snowball:removeEntryTeleport()
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
-- Speed Management
-- ============================================================

function Snowball:applySpeed(player)
	local currentSpeed = player:getSpeed()
	local targetSpeed = self.config.playerSpeed
	if currentSpeed ~= targetSpeed then
		player:changeSpeed(targetSpeed - currentSpeed)
	end
end

function Snowball:startSpeedEnforce(player)
	local playerName = player:getName()
	self:enforceSpeed(playerName)
end

function Snowball:enforceSpeed(playerName)
	local player = Player(playerName)
	if not player then
		return
	end
	if Snowball.state ~= "running" then
		return
	end
	if player:getStorageValue(Snowball.config.storageActive) ~= 1 then
		return
	end

	-- Remove haste
	player:removeCondition(CONDITION_HASTE)
	player:removeCondition(CONDITION_PARALYZE)

	-- Force speed
	local currentSpeed = player:getSpeed()
	local targetSpeed = Snowball.config.playerSpeed
	if currentSpeed ~= targetSpeed then
		player:changeSpeed(targetSpeed - currentSpeed)
	end

	-- Reschedule every second
	Snowball.events["speed_" .. playerName] = addEvent(function()
		Snowball:enforceSpeed(playerName)
	end, 1000)
end

function Snowball:stopSpeedEnforce(player)
	local playerName = player:getName()
	local eventKey = "speed_" .. playerName
	if self.events[eventKey] then
		stopEvent(self.events[eventKey])
		self.events[eventKey] = nil
	end

	-- Restore normal speed
	local currentSpeed = player:getSpeed()
	local baseSpeed = player:getBaseSpeed()
	if currentSpeed ~= baseSpeed then
		player:changeSpeed(baseSpeed - currentSpeed)
	end
end

-- ============================================================
-- Snowball Projectile
-- ============================================================

function Snowball:throwSnowball(player)
	if self.state ~= "running" then
		return false
	end

	if player:getStorageValue(self.config.storageActive) ~= 1 then
		return false
	end

	local direction = player:getDirection()
	local offset = Position.directionOffset[direction]
	if not offset then
		return false
	end

	local startPos = player:getPosition()
	local casterGuid = player:getGuid()

	-- Launch snowball: move tile by tile
	self:moveSnowball(startPos, offset, casterGuid, 0)
	return true
end

function Snowball:moveSnowball(currentPos, offset, casterGuid, step)
	if Snowball.state ~= "running" then
		return
	end

	if step >= Snowball.config.snowballRange then
		-- Snowball fizzled out
		currentPos:sendMagicEffect(CONST_ME_ICEAREA)
		return
	end

	local nextPos = Position(currentPos.x + offset.x, currentPos.y + offset.y, currentPos.z)

	-- Check if the next tile is walkable (not a wall/block)
	local tile = Tile(nextPos)
	if not tile or not tile:getGround() then
		-- Hit a void/wall
		currentPos:sendMagicEffect(CONST_ME_ICEAREA)
		return
	end

	-- Check for blocking items (walls, etc)
	if not tile:isWalkable(false, false, false, false, false) then
		currentPos:sendMagicEffect(CONST_ME_ICEAREA)
		return
	end

	-- Show the snowball animation from current to next position
	currentPos:sendDistanceEffect(nextPos, CONST_ANI_SNOWBALL)

	-- Check if there's a player on the next tile
	local creatures = tile:getCreatures()
	if creatures then
		for _, creature in ipairs(creatures) do
			if creature:isPlayer() and not creature:getGroup():getAccess() then
				local targetGuid = creature:getGuid()
				-- Don't hit yourself
				if targetGuid ~= casterGuid and creature:getStorageValue(Snowball.config.storageActive) == 1 then
					-- Hit! Eliminate the player
					nextPos:sendMagicEffect(CONST_ME_ICEAREA)
					Snowball:eliminatePlayer(creature, casterGuid)
					return
				end
			end
		end
	end

	-- Continue moving the snowball
	addEvent(function()
		Snowball:moveSnowball(nextPos, offset, casterGuid, step + 1)
	end, Snowball.config.snowballSpeed)
end

-- ============================================================
-- Player Management
-- ============================================================

function Snowball:eliminatePlayer(player, killerGuid)
	local killerName = "a snowball"
	for _, p in ipairs(self:getPlayersInEvent()) do
		if p:getGuid() == killerGuid then
			killerName = p:getName()
			break
		end
	end

	self:broadcast(string.format("%s was eliminated by %s!", player:getName(), killerName), MESSAGE_EVENT_ADVANCE)
	self:removePlayer(player)

	-- Check remaining players
	local remaining = self:getPlayersInEvent()
	if #remaining <= 1 then
		self:finish(remaining)
	end
end

function Snowball:removePlayer(player, silent)
	self:stopSpeedEnforce(player)
	player:setStorageValue(self.config.storageActive, -1)
	player:teleportTo(self.config.exitPos)
	self.config.exitPos:sendMagicEffect(CONST_ME_TELEPORT)
	if not silent then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "[Snowball] You have been eliminated!")
	end
end

-- ============================================================
-- Event Flow
-- ============================================================

function Snowball:announce()
	if self.state ~= "idle" then
		return
	end

	self.state = "waiting"
	self:createEntryTeleport()

	Game.broadcastMessage("[Snowball] Snowball Fight event starting in 5 minutes! Enter the teleport in the temple to join!", MESSAGE_EVENT_ADVANCE)

	-- Periodic announcements
	local announceCount = 0
	local maxAnnouncements = math.floor(self.config.waitingTimeSeconds / self.config.announceIntervalSeconds) - 1

	local function announceRemaining()
		announceCount = announceCount + 1
		if Snowball.state ~= "waiting" then
			return
		end
		if announceCount >= maxAnnouncements then
			return
		end

		local remaining = Snowball.config.waitingTimeSeconds - (announceCount * Snowball.config.announceIntervalSeconds)
		local players = Snowball:getPlayersInWaitingRoom()

		Game.broadcastMessage(
			string.format("[Snowball] Event starts in %d minute(s)! %d player(s) in waiting room.", math.floor(remaining / 60), #players),
			MESSAGE_EVENT_ADVANCE
		)
		Snowball.events.announce = addEvent(announceRemaining, Snowball.config.announceIntervalSeconds * 1000)
	end

	self.events.announce = addEvent(announceRemaining, self.config.announceIntervalSeconds * 1000)

	-- Schedule start
	self.events.start = addEvent(function()
		Snowball:startEvent()
	end, self.config.waitingTimeSeconds * 1000)
end

function Snowball:startEvent()
	if self.state ~= "waiting" then
		return
	end

	self:removeEntryTeleport()

	-- Register players currently in the waiting room
	local players = self:getPlayersInWaitingRoom()
	for _, player in ipairs(players) do
		player:setStorageValue(self.config.storageActive, 1)
	end

	if #players < self.config.minPlayers then
		Game.broadcastMessage(
			string.format("[Snowball] Event cancelled - not enough players (%d/%d).", #players, self.config.minPlayers),
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

	-- Teleport players to random positions in the arena and apply speed
	local spawnPositions = self:getRandomArenaPositions(#players)
	for i, player in ipairs(players) do
		local spawnPos = spawnPositions[i]
		if spawnPos then
			player:teleportTo(spawnPos)
			spawnPos:sendMagicEffect(CONST_ME_TELEPORT)
		end
		self:startSpeedEnforce(player)
	end

	self:broadcast("Snowball Fight has started! Use 'exori infir ico' to throw snowballs!", MESSAGE_EVENT_ADVANCE)

	-- Schedule max duration timeout
	self.events.timeout = addEvent(function()
		if Snowball.state == "running" then
			Game.broadcastMessage("[Snowball] Time is up! No winner this time.", MESSAGE_EVENT_ADVANCE)
			Snowball:cleanup()
		end
	end, self.config.maxDurationSeconds * 1000)
end

function Snowball:finish(survivors)
	if self.state ~= "running" then
		return
	end

	self.state = "idle"
	self:stopAllEvents()

	if #survivors == 1 then
		local winner = survivors[1]
		Game.broadcastMessage(
			string.format("[Snowball] %s wins the Snowball Fight!", winner:getName()),
			MESSAGE_EVENT_ADVANCE
		)
		self:stopSpeedEnforce(winner)
		winner:addItem(60306, 1)
		winner:sendTextMessage(MESSAGE_EVENT_ADVANCE, "[Snowball] Congratulations! You won! You received 1 Event Token.")
		winner:setStorageValue(self.config.storageActive, -1)
		winner:teleportTo(self.config.exitPos)
		self.config.exitPos:sendMagicEffect(CONST_ME_TELEPORT)
	else
		Game.broadcastMessage("[Snowball] No one survived the Snowball Fight!", MESSAGE_EVENT_ADVANCE)
	end
end

function Snowball:cleanup()
	self:stopAllEvents()
	self:removeEntryTeleport()

	-- Kick registered players (running phase)
	for _, player in ipairs(self:getPlayersInEvent()) do
		self:stopSpeedEnforce(player)
		player:setStorageValue(self.config.storageActive, -1)
		player:teleportTo(self.config.exitPos)
		self.config.exitPos:sendMagicEffect(CONST_ME_TELEPORT)
	end

	-- Kick players in waiting room (waiting phase, different floor)
	for _, player in ipairs(self:getPlayersInWaitingRoom()) do
		player:teleportTo(self.config.exitPos)
		self.config.exitPos:sendMagicEffect(CONST_ME_TELEPORT)
	end

	self.state = "idle"
end

-- ============================================================
-- Player Logout
-- ============================================================

function Snowball:onPlayerLogout(player)
	if player:getStorageValue(self.config.storageActive) ~= 1 then
		return
	end
	self:stopSpeedEnforce(player)
	player:setStorageValue(self.config.storageActive, -1)

	-- Check remaining players
	local remaining = self:getPlayersInEvent()
	if self.state == "running" and #remaining <= 1 then
		self:finish(remaining)
	end
end

-- ============================================================
-- Storage check
-- ============================================================

function Snowball:isInEvent(player)
	return player:getStorageValue(self.config.storageActive) == 1
end

-- ============================================================
-- Register in Event Pool
-- ============================================================

EventPool:register(
	"Snowball Fight",
	function() return Snowball.state == "idle" end,
	function() Snowball:announce() end
)
