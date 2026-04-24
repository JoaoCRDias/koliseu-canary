-- Gnome Arena core module

GnomeArena = {}

-- Configuration
GnomeArena.ZONE_NAME = "arena.gnome"
GnomeArena.AREA_FROM = Position(1069, 1103, 7)
GnomeArena.AREA_TO = Position(1095, 1126, 7)

-- Spawn sub-area inside arena
GnomeArena.SPAWN_FROM = Position(1074, 1109, 7)
GnomeArena.SPAWN_TO = Position(1083, 1118, 7)

-- Waiting tiles (lever participants positions)
GnomeArena.WAITING_TILES = {
	Position(1080, 1110, 6),
	Position(1080, 1111, 6),
	Position(1080, 1112, 6),
	Position(1080, 1113, 6),
	Position(1080, 1114, 6),
}

-- Teleport destination inside arena (players are placed around this)
GnomeArena.ENTRY_POS = Position(1079, 1113, 7)

-- Exit position when arena ends or cleaned
GnomeArena.EXIT_POS = Position(1080, 1117, 6)

-- Action id for the exit teleport inside the arena
GnomeArena.EXIT_TELEPORT_AID = 34701

-- Action id for lever
GnomeArena.LEVER_AID = 34700

-- Cooldown (seconds): 20 hours in PRD, disabled on DEV so testers can loop runs.
GnomeArena.COOLDOWN = serverEnvironment == "PRD" and 20 * 60 * 60 or 0

-- Wave cadence (milliseconds)
GnomeArena.WAVE_INTERVAL = 30 * 1000
GnomeArena.MONSTERS_PER_WAVE = 18

-- Base monsters used for waves
GnomeArena.MONSTER_POOL = {
	"Gnome Minion",
	"Gnome Servant",
	"Gnome Adept",
}

-- Internal state
GnomeArena._active = false
GnomeArena._wave = 0
GnomeArena._teamGuids = {}
GnomeArena._event = nil
GnomeArena._rewardedGuids = {}
GnomeArena._activePlayerGuids = {}
GnomeArena._waveMonsterCount = 0 -- Track remaining monsters in current wave

local function gaSelectPlayer(playerId)
	local res = db.storeQuery(('SELECT `best_wave`, `last_play_ready_at`, `total_runs`, `total_waves` FROM `gnome_arena_stats` WHERE `player_id` = %d'):format(playerId))
	if not res then
		return nil
	end
	local data = {
		best_wave = Result.getNumber(res, 'best_wave'),
		last_play_ready_at = Result.getNumber(res, 'last_play_ready_at'),
		total_runs = Result.getNumber(res, 'total_runs'),
		total_waves = Result.getNumber(res, 'total_waves'),
	}
	Result.free(res)
	return data
end

local function gaSetCooldownAndRun(playerId, readyAt)
	db.query(('INSERT INTO `gnome_arena_stats` (`player_id`, `last_play_ready_at`, `total_runs`) VALUES (%d, %d, 1) ON DUPLICATE KEY UPDATE `last_play_ready_at` = VALUES(`last_play_ready_at`), `total_runs` = `total_runs` + 1'):format(playerId, readyAt))
end

local function gaUpdateResult(playerId, wavesCompleted)
	db.query(('INSERT INTO `gnome_arena_stats` (`player_id`, `best_wave`, `total_waves`) VALUES (%d, %d, %d) ON DUPLICATE KEY UPDATE `best_wave` = GREATEST(`best_wave`, VALUES(`best_wave`)), `total_waves` = `total_waves` + VALUES(`total_waves`)'):format(playerId, wavesCompleted, wavesCompleted))
end

local function gaCheckArenaState()
	if not GnomeArena._active then
		return
	end

	if GnomeArena.zone():countPlayers(IgnoredByMonsters) > 0 then
		return
	end

	if GnomeArena.hasActivePlayers and GnomeArena.hasActivePlayers() then
		return
	end

	GnomeArena.stop()
end

-- Zone helpers
function GnomeArena.zone()
	local zone = Zone(GnomeArena.ZONE_NAME)
	if not GnomeArena._zoneInitialized then
		zone:addArea(GnomeArena.AREA_FROM, GnomeArena.AREA_TO)
		zone:blockFamiliars()
		zone:setRemoveDestination(GnomeArena.EXIT_POS)
		GnomeArena._zoneInitialized = true
	end
	return zone
end

function GnomeArena.spawnZone()
	local name = GnomeArena.ZONE_NAME .. ".spawn"
	local zone = Zone(name)
	if not GnomeArena._spawnZoneInitialized then
		zone:addArea(GnomeArena.SPAWN_FROM, GnomeArena.SPAWN_TO)
		zone:blockFamiliars()
		GnomeArena._spawnZoneInitialized = true
	end
	return zone
end

function GnomeArena.isOccupied()
	return GnomeArena.zone():countPlayers(IgnoredByMonsters) > 0 or GnomeArena._active
end

function GnomeArena.playersInArena()
	return GnomeArena.zone():getPlayers()
end

function GnomeArena.hasActivePlayers()
	for guid in pairs(GnomeArena._activePlayerGuids) do
		local player = Player(guid)
		if player and GnomeArena.isPlayerInside(player) and player:getIp() ~= 0 then
			return true
		end
		GnomeArena._activePlayerGuids[guid] = nil
	end
	return false
end

-- Remove disconnected players (client closed on no-logout tile)
function GnomeArena.removeDisconnectedPlayers()
	local zone = GnomeArena.zone()
	for _, player in ipairs(zone:getPlayers()) do
		if player:getIp() == 0 then
			GnomeArena.finishPlayer(player, {
				reason = "disconnect",
				wavesCompleted = math.max(0, GnomeArena._wave - 1),
				force = true,
			})
		end
	end
end

local function gaCleanupActivePlayer(guid)
	if guid and guid > 0 then
		GnomeArena._activePlayerGuids[guid] = nil
	end
end

function GnomeArena.isInside(position)
	if not position then
		return false
	end
	return position:isInRange(GnomeArena.AREA_FROM, GnomeArena.AREA_TO)
end

function GnomeArena.isPlayerInside(player)
	return player and player:isPlayer() and GnomeArena.isInside(player:getPosition())
end

function GnomeArena.currentWave()
	return GnomeArena._wave
end

-- Called when an arena monster dies to check if wave is cleared
function GnomeArena.onMonsterDeath()
	if not GnomeArena._active then
		return
	end

	GnomeArena._waveMonsterCount = GnomeArena._waveMonsterCount - 1

	-- If all monsters are dead, start next wave immediately
	if GnomeArena._waveMonsterCount <= 0 then
		-- Cancel the scheduled wave timer
		if GnomeArena._event then
			stopEvent(GnomeArena._event)
			GnomeArena._event = nil
		end

		-- Announce wave cleared
		local zone = GnomeArena.zone()
		zone:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("Wave %d cleared! Next wave incoming!", GnomeArena._wave))

		-- Start next wave after a short delay (2 seconds)
		GnomeArena._event = addEvent(GnomeArena.spawnWave, 2000)
	end
end

function GnomeArena.finishPlayer(player, opts)
	if not player or not player:isPlayer() then
		return false
	end

	opts = opts or {}
	if not opts.force and not GnomeArena.isPlayerInside(player) then
		return false
	end

	local wavesCompleted = math.max(0, opts.wavesCompleted or GnomeArena._wave)
	local destination = opts.destination or GnomeArena.EXIT_POS
	local reason = opts.reason or "leave"
	local guid = player:getGuid()
	local rewardDelivered = false
	local missingHealth = player:getMaxHealth() - player:getHealth()
	if missingHealth > 0 then
		player:addHealth(missingHealth)
	end

	local missingMana = player:getMaxMana() - player:getMana()
	if missingMana > 0 then
		player:addMana(missingMana)
	end

	if guid > 0 and not GnomeArena._rewardedGuids[guid] then
		GnomeArena.grantReward(player, wavesCompleted)
		GnomeArena._rewardedGuids[guid] = true
		rewardDelivered = true
	end
	gaCleanupActivePlayer(guid)

	local fromPosition = player:getPosition()
	fromPosition:sendMagicEffect(CONST_ME_TELEPORT)
	player:teleportTo(destination, true)
	destination:sendMagicEffect(CONST_ME_TELEPORT)

	local message
	if reason == "death" then
		message = "You were defeated inside the Gnome Arena."
	elseif reason == "exit" then
		message = "You left the Gnome Arena through the exit."
	elseif reason == "disconnect" then
		message = "You were removed from the Gnome Arena due to disconnection."
	else
		message = "You left the Gnome Arena."
	end

	if wavesCompleted > 0 then
		if rewardDelivered then
			message = string.format("%s Wave %d rewards have been delivered.", message, wavesCompleted)
		else
			message = string.format("%s You have already received the reward for wave %d.", message, wavesCompleted)
		end
	else
		message = message .. " No reward, no waves completed."
	end

	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, message)

	if not opts.skipStopCheck then
		addEvent(gaCheckArenaState, 50)
	end
	return true
end

-- Entry validation
function GnomeArena.checkTeamAndCooldown()
	local team = {}
	for i, pos in ipairs(GnomeArena.WAITING_TILES) do
		local tile = pos:getTile()
		if not tile then
			return false, "Invalid waiting tile configured."
		end
		local creature = tile:getTopCreature()
		if creature and creature:isPlayer() then
			team[#team+1] = creature:getPlayer()
		end
	end

	if #team == 0 then
		return false, "At least one player must stand on the waiting tiles."
	end

	-- Cooldown checks
	local now = os.time()
	for _, player in ipairs(team) do
		local guid = player:getGuid()
		local rec = gaSelectPlayer(guid)
		if rec and rec.last_play_ready_at > now then
			local timeLeft = rec.last_play_ready_at - now
			return false, string.format("%s must wait %s to enter again.", player:getName(), Game.getTimeInWords(timeLeft))
		end
	end

	return true, team
end

-- Start arena run
function GnomeArena.start(team)
	if GnomeArena._active then
		return false
	end

	-- Mark cooldown and set state
	local readyAt = os.time() + GnomeArena.COOLDOWN
	GnomeArena._teamGuids = {}
	GnomeArena._rewardedGuids = {}
	GnomeArena._activePlayerGuids = {}
	for _, p in ipairs(team) do
		gaSetCooldownAndRun(p:getGuid(), readyAt)
		table.insert(GnomeArena._teamGuids, p:getGuid())
		GnomeArena._activePlayerGuids[p:getGuid()] = true
	end

	-- Teleport players around entry
	local base = GnomeArena.ENTRY_POS
	local offsets = {
		{ 0, 0 }, { 1, 0 }, { -1, 0 }, { 0, 1 }, { 0, -1 }
	}
	for i, p in ipairs(team) do
		local off = offsets[((i - 1) % #offsets) + 1]
		local dest = Position(base.x + off[1], base.y + off[2], base.z)
		p:teleportTo(dest, true)
		dest:sendMagicEffect(CONST_ME_TELEPORT)
	end

	GnomeArena._active = true
	GnomeArena._wave = 0
	GnomeArena._waveMonsterCount = 0
	GnomeArena.scheduleNextWave(true)
	return true
end

-- Stop and cleanup arena
function GnomeArena.stop()
	local zone = GnomeArena.zone()
	if GnomeArena._event then
		stopEvent(GnomeArena._event)
		GnomeArena._event = nil
	end

	local wavesCompleted = GnomeArena._wave
	for _, player in ipairs(zone:getPlayers()) do
		GnomeArena.finishPlayer(player, {
			reason = "stop",
			wavesCompleted = wavesCompleted,
			skipStopCheck = true,
			force = true,
		})
	end

	for _, guid in ipairs(GnomeArena._teamGuids) do
		if not GnomeArena._rewardedGuids[guid] then
			gaUpdateResult(guid, wavesCompleted)
		end
	end

	-- Remove monsters and players
	zone:removeMonsters()
	zone:removePlayers()

	-- Reset state
	GnomeArena._active = false
	GnomeArena._wave = 0
	GnomeArena._teamGuids = {}
	GnomeArena._rewardedGuids = {}
	GnomeArena._activePlayerGuids = {}
end

-- Wave management
function GnomeArena.scheduleNextWave(initial)
	if not GnomeArena._active then
		return
	end
	if GnomeArena._event then
		stopEvent(GnomeArena._event)
		GnomeArena._event = nil
	end
	local delay = initial and 1000 or GnomeArena.WAVE_INTERVAL
	GnomeArena._event = addEvent(GnomeArena.spawnWave, delay)
end

function GnomeArena.spawnWave()
	GnomeArena._event = nil
	-- Remove disconnected players before checking arena state
	GnomeArena.removeDisconnectedPlayers()
	-- Check if there are players inside; otherwise free arena
	local zone = GnomeArena.zone()
	if zone:countPlayers(IgnoredByMonsters) == 0 then
		GnomeArena.stop()
		return
	end

	-- Next wave
	GnomeArena._wave = GnomeArena._wave + 1
	local wave = GnomeArena._wave

	-- Spawn configured amount of monsters for this wave
	local lastName = nil
	local spawnZone = GnomeArena.spawnZone()
	for i = 1, GnomeArena.MONSTERS_PER_WAVE do
		local mname = GnomeArena.MONSTER_POOL[math.random(1, #GnomeArena.MONSTER_POOL)]
		lastName = mname
		local dest = spawnZone:randomPosition() or GnomeArena.ENTRY_POS
		local monster = Game.createMonster(mname, dest, true, true)
		if monster then
			-- Scale monster based on wave
			local baseMax = monster:getMaxHealth()
			local multiplier = 1.0 + (wave - 1) * 0.20 -- +35% health per wave
			local newMax = math.max(1, math.floor(baseMax * multiplier))
			monster:setMaxHealth(newMax)
			monster:setHealth(newMax)
			-- Add some defense and speed per wave
			monster:changeSpeed(wave * 5)
			-- Apply % buffs: damage dealt +20%/wave (no cap);
			-- defense +1.5%/wave capped at 70% (i.e., damage received not below 30%)
			local dmgPercent = 100 + ((wave - 1) * 10)
			local defenseBonus = math.min(70, math.floor((wave - 1) * 1.5)) -- 0..70
			local recvPercent = 100 - defenseBonus -- 100..30
			local cond = Condition(CONDITION_ATTRIBUTES)
			cond:setParameter(CONDITION_PARAM_TICKS, -1)
			cond:setParameter(CONDITION_PARAM_SUBID, 47001)
			cond:setParameter(CONDITION_PARAM_BUFF_DAMAGEDEALT, dmgPercent)
			cond:setParameter(CONDITION_PARAM_BUFF_DAMAGERECEIVED, recvPercent)
			monster:addCondition(cond)
			-- Mark monster with storage and register scaling event if needed
			monster:setIcon("gnome_arena_wave", CreatureIconCategory_Modifications, CreatureIconModifications_ReducedHealth, wave)
			monster:setStorageValue(47001, wave)
			monster:setStorageValue(47002, 1) -- mark as arena minion
			-- Register death event to track wave completion
			monster:registerEvent("GnomeArenaMonsterDeath")
			-- Increment monster counter
			GnomeArena._waveMonsterCount = GnomeArena._waveMonsterCount + 1
		end
	end

	-- Announce wave (use last spawned name as representative)
	zone:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("Gnome Arena - Wave %d: %d monsters have appeared!", wave, GnomeArena.MONSTERS_PER_WAVE))

	-- Schedule next wave
	GnomeArena.scheduleNextWave(false)
end

-- Rewards
function GnomeArena.grantReward(player, wavesCompleted)
	if not player then return end
	local tokenId = 60133
	local tokenCount = math.max(0, wavesCompleted) * 2 -- 2 tokens per wave completed
	local coins = math.max(0, wavesCompleted) * 100000 -- gold per wave (adjust as desired)
	if tokenCount > 0 then
		-- Send tokens to store inbox (ignores cap)
		local inbox = player:getStoreInbox()
		if inbox then
			local remaining = tokenCount
			local success = true
			-- Add items in stacks of 100 (item stack limit)
			while remaining > 0 do
				local amount = math.min(100, remaining)
				local item = inbox:addItem(tokenId, amount)
				if not item then
					success = false
					break
				end
				remaining = remaining - amount
			end

			if success then
				player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("Reward: %d token(s) for %d completed wave(s). Check your Store Inbox!", tokenCount, wavesCompleted))
			else
				player:sendTextMessage(MESSAGE_FAILURE, "Reward delivery failed: could not add item to Store Inbox.")
			end
		else
			player:sendTextMessage(MESSAGE_FAILURE, "Reward delivery failed: Store Inbox not available.")
		end
	else
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "No reward, no waves completed.")
	end
	if coins > 0 then
		player:addMoney(coins)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("Reward: %d gold for %d completed wave(s).", coins, wavesCompleted))
	end
	-- persist personal result
	if player and player.getGuid then
		gaUpdateResult(player:getGuid(), wavesCompleted)
	end
end

-- Utility to expose current status
function GnomeArena.status()
	return {
		active = GnomeArena._active,
		wave = GnomeArena._wave,
		team = GnomeArena._teamGuids,
	}
end

return GnomeArena
