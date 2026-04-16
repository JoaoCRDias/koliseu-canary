-- Gnome Arena lever (AID 34700)

local arenaLever = Action()

function arenaLever.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	-- Must click lever while standing on the first waiting tile
    local firstTile = GnomeArena.WAITING_TILES[1]
	if player:getPosition() ~= firstTile then
		return false
	end

	-- Check arena availability
	if GnomeArena.isOccupied() then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The arena is occupied at the moment.")
		return true
	end

	-- Check team and cooldowns
	local ok, data = GnomeArena.checkTeamAndCooldown()
	if not ok then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, data)
		player:getPosition():sendMagicEffect(CONST_ME_POFF)
		return true
	end

	-- Start arena and teleport players
	if GnomeArena.start(data) then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Gnome Arena challenge started! Good luck.")
	else
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Failed to start Gnome Arena.")
	end
	return true
end

arenaLever:aid(GnomeArena.LEVER_AID)
arenaLever:register()
