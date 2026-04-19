-- Safezone - Entry Teleport
-- Action ID: 54220

local szEntry = MoveEvent()
function szEntry.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	if Safezone.state ~= "waiting" then
		player:sendTextMessage(MESSAGE_STATUS_SMALL, "The Safezone event is not accepting players right now.")
		player:teleportTo(fromPosition)
		return false
	end

	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "[Safezone] You entered the arena! Stand on the safe tiles when they appear to survive.")
	return true
end
szEntry:type("stepin")
szEntry:aid(54220)
szEntry:register()

-- ============================================================
-- Anti-stack: prevent two players on the same SQM inside the arena
-- Registered on the arena ground tile IDs
-- ============================================================

local function onArenaStep(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	-- Only apply while the event is running
	if Safezone.state ~= "running" then
		return true
	end

	-- Check if inside the arena area
	if not position:isInRange(Safezone.config.arenaArea.fromPos, Safezone.config.arenaArea.toPos) then
		return true
	end

	-- Check if another player is already on this tile
	local tile = Tile(position)
	if tile then
		local creatures = tile:getCreatures()
		if creatures then
			for _, c in ipairs(creatures) do
				if c:isPlayer() and c:getId() ~= player:getId() then
					player:teleportTo(fromPosition)
					fromPosition:sendMagicEffect(CONST_ME_POFF)
					player:sendCancelMessage("You cannot stack on another player!")
					return false
				end
			end
		end
	end

	return true
end

local szAntiStack1 = MoveEvent()
szAntiStack1.onStepIn = onArenaStep
szAntiStack1:type("stepin")
szAntiStack1:id(Safezone.config.normalTileId)
szAntiStack1:register()

local szAntiStack2 = MoveEvent()
szAntiStack2.onStepIn = onArenaStep
szAntiStack2:type("stepin")
szAntiStack2:id(Safezone.config.safeTileId)
szAntiStack2:register()
