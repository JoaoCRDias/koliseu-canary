-- Poison room driver: single 1-second tick that handles every dynamic of the
-- room (mushroom spawns + explosions, curse escalation + DOT, quadrant
-- flooding, mechanism decay, timeout detonation).
--
-- The room is started by the entry step-in (see supreme_vocation_poison_entry)
-- and stops itself when the mechanism is filled, when everyone leaves, or when
-- the timeout triggers a wipe.

local TICK_MS = 1000

local function cfg() return SupremeVocation.PoisonRoom end

-- Random element with weights ------------------------------------------------

local function weightedPick(weights)
	local total = 0
	for _, w in pairs(weights) do total = total + w end
	local roll = math.random(1, total)
	local acc = 0
	for k, w in pairs(weights) do
		acc = acc + w
		if roll <= acc then return k end
	end
	return next(weights)
end

-- Mushroom spawning + detonation --------------------------------------------

local function ringPositionAround(centerPos, ringMin, ringMax)
	local c = cfg()
	for _ = 1, 12 do -- few attempts to find a walkable tile
		local dx = math.random(-ringMax, ringMax)
		local dy = math.random(-ringMax, ringMax)
		if math.max(math.abs(dx), math.abs(dy)) >= ringMin then
			local pos = Position(centerPos.x + dx, centerPos.y + dy, centerPos.z)
			if pos.x >= c.from.x and pos.x <= c.to.x
				and pos.y >= c.from.y and pos.y <= c.to.y
				and not (pos.x == c.center.x and pos.y == c.center.y) then
				local tile = Tile(pos)
				if tile and tile:isWalkable(false, false, false, false, true) and not tile:getTopCreature() then
					return pos
				end
			end
		end
	end
	return nil
end

local function detonateMushroom(monsterId, posX, posY, posZ)
	local pos = Position(posX, posY, posZ)
	local creature = Creature(monsterId)
	if creature then
		creature:remove()
	end
	pos:sendMagicEffect(CONST_ME_POISONAREA)

	local r = cfg().mushroomExplosionRadius
	for dx = -r, r do
		for dy = -r, r do
			local ep = Position(pos.x + dx, pos.y + dy, pos.z)
			local tile = Tile(ep)
			if tile then
				ep:sendMagicEffect(CONST_ME_HITBYPOISON)
				local creatures = tile:getCreatures()
				if creatures then
					for _, c in ipairs(creatures) do
						local p = c:getPlayer()
						if p then
							local dmg = math.floor(p:getMaxHealth() * cfg().mushroomDamageFraction)
							if dmg > 0 then
								doTargetCombatHealth(0, p, COMBAT_EARTHDAMAGE, -dmg, -dmg, CONST_ME_NONE)
							end
						end
					end
				end
			end
		end
	end

	-- Drop antidote on the ground (so any player can pick it up).
	if math.random(1, 100) <= cfg().mushroomDropChance then
		local item = Game.createItem(cfg().antidoteItemId, 1, pos)
		if item then
			pos:sendMagicEffect(CONST_ME_GREEN_RINGS)
			addEvent(function(itemId, x, y, z)
				local tile = Tile(Position(x, y, z))
				if not tile then return end
				local stale = tile:getItemById(itemId)
				if stale then
					stale:remove()
					Position(x, y, z):sendMagicEffect(CONST_ME_POFF)
				end
			end, cfg().antidoteDecaySeconds * 1000, cfg().antidoteItemId, pos.x, pos.y, pos.z)
		end
	end
end

local function spawnMushroom(targetPlayer)
	local pos = ringPositionAround(targetPlayer:getPosition(),
		cfg().mushroomSpawnRingMin, cfg().mushroomSpawnRingMax)
	if not pos then return end

	local mushroom = Game.createMonster(cfg().mushroomMonsterName, pos, false, true)
	if not mushroom then return end
	pos:sendMagicEffect(CONST_ME_POISONAREA)

	addEvent(detonateMushroom, cfg().mushroomFuseSeconds * 1000,
		mushroom:getId(), pos.x, pos.y, pos.z)
end

local function spawnMushroomsForTick(players)
	-- Each player gets a fixed number of mushrooms spawned around them.
	for _, player in ipairs(players) do
		for _ = 1, cfg().mushroomsPerPlayer do
			spawnMushroom(player)
		end
	end
end

-- Curse logic ---------------------------------------------------------------

local function applyCursePulse(player)
	local state = SupremeVocation.poisonRoomEnsurePlayerState(player)
	local now = os.time()

	-- Escalate?
	if now >= state.nextEscalateAt and state.curseTier < #cfg().curseTiers then
		state.curseTier = state.curseTier + 1
		state.nextEscalateAt = now + cfg().curseTierIntervalSeconds
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE,
			string.format("The curse deepens (tier %d).", state.curseTier))
	end

	-- DOT pulse?
	if now >= state.nextDotAt then
		state.nextDotAt = now + cfg().curseDotIntervalSeconds
		local pct = cfg().curseTiers[state.curseTier] or 1
		local dmg = math.floor(player:getMaxHealth() * pct / 100)
		if dmg > 0 then
			doTargetCombatHealth(0, player, COMBAT_DEATHDAMAGE, -dmg, -dmg, CONST_ME_HITBYPOISON)
		end
	end
end

-- Quadrant flooding ---------------------------------------------------------

local function quadrantBoundsLocal(index)
	local c = cfg()
	local cx, cy = c.center.x, c.center.y
	if index == 1 then     return c.from.x, c.from.y, cx - 1, cy - 1
	elseif index == 2 then return cx + 1, c.from.y, c.to.x, cy - 1
	elseif index == 3 then return c.from.x, cy + 1, cx - 1, c.to.y
	else                   return cx + 1, cy + 1, c.to.x, c.to.y end
end

local function unflood()
	for _, q in ipairs(PoisonRoom.currentQuadrants) do
		local x1, y1, x2, y2 = quadrantBoundsLocal(q)
		for x = x1, x2 do
			for y = y1, y2 do
				local pos = Position(x, y, cfg().center.z)
				local tile = Tile(pos)
				if tile then
					local fld = tile:getItemById(cfg().floodItemId)
					if fld then
						fld:remove()
					end
				end
			end
		end
	end
	PoisonRoom.currentQuadrants = {}
end

local function pickQuadrants()
	-- Pick the count first.
	local count = weightedPick(cfg().quadrantWeights)
	-- Pick random distinct quadrants.
	local pool = { 1, 2, 3, 4 }
	local picks = {}
	for _ = 1, count do
		local idx = math.random(1, #pool)
		picks[#picks + 1] = pool[idx]
		table.remove(pool, idx)
	end
	return picks
end

local function warnQuadrants(quadrants)
	PoisonRoom.warningQuadrants = quadrants
	for _, q in ipairs(quadrants) do
		local x1, y1, x2, y2 = quadrantBoundsLocal(q)
		for x = x1, x2 do
			for y = y1, y2 do
				Position(x, y, cfg().center.z):sendMagicEffect(CONST_ME_POISONAREA)
			end
		end
	end
end

local function floodQuadrants(quadrants)
	for _, q in ipairs(quadrants) do
		local x1, y1, x2, y2 = quadrantBoundsLocal(q)
		for x = x1, x2 do
			for y = y1, y2 do
				local pos = Position(x, y, cfg().center.z)
				local tile = Tile(pos)
				if tile and not tile:getItemById(cfg().floodItemId) then
					Game.createItem(cfg().floodItemId, 1, pos)
					pos:sendMagicEffect(CONST_ME_HITBYPOISON)
				end
			end
		end
	end
	PoisonRoom.currentQuadrants = quadrants
	PoisonRoom.warningQuadrants = {}
end

-- Damage players standing in any flooded quadrant (1s pulses).
local function damageInFloodedQuadrants(players)
	for _, p in ipairs(players) do
		if SupremeVocation.poisonRoomIsFlooded(p:getPosition()) then
			local dmg = math.floor(p:getMaxHealth() * cfg().quadrantFloodDotPercentPerSecond / 100)
			if dmg > 0 then
				doTargetCombatHealth(0, p, COMBAT_EARTHDAMAGE, -dmg, -dmg, CONST_ME_HITBYPOISON)
			end
		end
	end
end

-- Tick orchestrator ---------------------------------------------------------

local function broadcastTimeoutImminent(secondsLeft)
	for _, p in ipairs(SupremeVocation.poisonRoomGetPlayers()) do
		p:sendTextMessage(MESSAGE_EVENT_ADVANCE,
			string.format("The chamber will detonate in %ds!", secondsLeft))
	end
end

local function detonateRoom()
	local players = SupremeVocation.poisonRoomGetPlayers()
	for _, p in ipairs(players) do
		local dmg = math.floor(p:getMaxHealth() * cfg().timeoutAgonyFraction)
		if dmg > 0 then
			doTargetCombatHealth(0, p, COMBAT_AGONYDAMAGE, -dmg, -dmg, CONST_ME_BLACKSMOKE)
		end
		p:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The chamber detonates! The curse claims you all.")
	end
	SupremeVocation.poisonRoomStop("timeout")
end

local function tick()
	PoisonRoom.tickEvent = nil
	if PoisonRoom.phase == "idle" then return end

	local players = SupremeVocation.poisonRoomGetPlayers()
	if #players == 0 then
		SupremeVocation.poisonRoomStop("empty")
		return
	end

	local now = os.time()

	-- Waiting phase: just count down to seal. No mechanics.
	if PoisonRoom.phase == "waiting" then
		local left = PoisonRoom.waitingUntil - now
		if left == 5 then
			for _, p in ipairs(players) do
				p:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The chamber will seal in 5 seconds.")
			end
		end
		if now >= PoisonRoom.waitingUntil then
			SupremeVocation.poisonRoomSeal()
		end
		PoisonRoom.tickEvent = addEvent(tick, TICK_MS)
		return
	end

	-- Sealed phase: full mechanics.
	local elapsed = now - PoisonRoom.startedAt

	-- Timeout warnings + trigger
	local left = cfg().timeoutSeconds - elapsed
	if left == 60 or left == 30 or left == 10 then
		broadcastTimeoutImminent(left)
	end
	if elapsed >= cfg().timeoutSeconds then
		detonateRoom()
		return
	end

	-- Mushroom spawn
	if now >= PoisonRoom.nextMushroomAt then
		spawnMushroomsForTick(players)
		PoisonRoom.nextMushroomAt = now + cfg().mushroomSpawnIntervalSeconds
	end

	-- Quadrant flooding cycle
	if now >= PoisonRoom.nextQuadrantAt then
		if #PoisonRoom.warningQuadrants > 0 then
			-- Was warning -> flood now
			floodQuadrants(PoisonRoom.warningQuadrants)
			PoisonRoom.nextQuadrantAt = now + cfg().quadrantCycleSeconds - cfg().quadrantWarnSeconds
		else
			-- Was active or idle -> clear and start new warning
			unflood()
			local picks = pickQuadrants()
			warnQuadrants(picks)
			PoisonRoom.nextQuadrantAt = now + cfg().quadrantWarnSeconds
		end
	end

	-- Mechanism decay (only between deposits)
	if now - PoisonRoom.lastDepositAt >= cfg().mechanismDecayIntervalSeconds and PoisonRoom.mechanismCount > 0 then
		PoisonRoom.mechanismCount = PoisonRoom.mechanismCount - 1
		PoisonRoom.lastDepositAt = now -- restart the timer
		for _, p in ipairs(players) do
			p:sendTextMessage(MESSAGE_EVENT_ADVANCE,
				string.format("The pedestal fades. %d of %d offerings remain.",
					PoisonRoom.mechanismCount, cfg().mechanismRequired))
		end
	end

	-- Per-player damage and curse
	damageInFloodedQuadrants(players)
	for _, p in ipairs(players) do
		applyCursePulse(p)
	end

	PoisonRoom.tickEvent = addEvent(tick, TICK_MS)
end

-- Public start hook (called from entry step-in).
function SupremeVocation.poisonRoomStartTick()
	if PoisonRoom.tickEvent then return end
	PoisonRoom.tickEvent = addEvent(tick, TICK_MS)
end
