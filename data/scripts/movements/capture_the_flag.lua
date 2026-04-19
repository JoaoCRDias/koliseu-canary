-- Capture The Flag - Entry Teleport and Flag Tiles
-- Action IDs:
--   54200 = Entry teleport (appears in temple during waiting phase)
--   54201 = Green flag tile (red steals here / green delivers here)
--   54202 = Red flag tile (green steals here / red delivers here)

-- ============================================================
-- Entry Teleport (sends player to waiting room, no registration)
-- ============================================================

local ctfEntry = MoveEvent()
function ctfEntry.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	if CTF.state ~= "waiting" then
		player:sendTextMessage(MESSAGE_STATUS_SMALL, "The Capture The Flag event is not accepting players right now.")
		player:teleportTo(fromPosition)
		return false
	end

	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "[CTF] You entered the waiting room! The event will start soon.")
	-- Teleport is handled by the TP item itself, no registration here
	return true
end
ctfEntry:type("stepin")
ctfEntry:aid(54200)
ctfEntry:register()

-- ============================================================
-- Flag Tiles (same tile handles steal by enemy AND delivery by owner)
-- ============================================================

local function onFlagTileStep(flagTeam)
	return function(creature, item, position, fromPosition)
		local player = creature:getPlayer()
		if not player then
			return true
		end

		if CTF.state ~= "running" then
			return true
		end

		local guid = player:getGuid()
		if not CTF.players[guid] then
			return true
		end

		local playerTeam = CTF:getTeam(player)

		if playerTeam == flagTeam then
			-- Own flag tile: try to deliver enemy flag here
			local delivered = CTF:deliverFlag(flagTeam, player)
			if delivered then
				position:sendMagicEffect(flagTeam == 1 and CONST_ME_FIREWORK_GREEN or CONST_ME_FIREWORK_RED)
			end
		else
			-- Enemy flag tile: try to steal
			local picked = CTF:pickupFlag(flagTeam, player)
			if picked then
				fromPosition:sendMagicEffect(flagTeam == 1 and CONST_ME_MAGIC_GREEN or CONST_ME_MAGIC_RED)
			end
		end

		-- Push player back only if event is still running
		-- (finish/resetRound may have already teleported the player)
		if CTF.state == "running" then
			player:teleportTo(fromPosition)
		end
		return true
	end
end

-- Green flag tile (team 1)
local greenFlagTile = MoveEvent()
greenFlagTile.onStepIn = onFlagTileStep(1)
greenFlagTile:type("stepin")
greenFlagTile:aid(CTF.config.flagTileActionId[1])
greenFlagTile:register()

-- Red flag tile (team 2)
local redFlagTile = MoveEvent()
redFlagTile.onStepIn = onFlagTileStep(2)
redFlagTile:type("stepin")
redFlagTile:aid(CTF.config.flagTileActionId[2])
redFlagTile:register()
