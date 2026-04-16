local config = {
	enableTemples = true,
	Temples = {
		{ fromPos = Position(997, 997, 7), toPos = Position(1003, 1003, 7), townId = TOWNS_LIST.ROCKET_TOWN },
		{ fromPos = Position(3253, 3316, 8), toPos = Position(3270, 3326, 8), townId = TOWNS_LIST.EDRON_KINGDOM },
	},
}

local adventurersStone = Action()

local function doNotTeleport(player)
	local enabledLocations = {}
	if config.enableTemples then
		table.insert(enabledLocations, "temple")
	end

	local message = "Try to move more to the center of a " .. table.concat(enabledLocations, " or ") .. " to use the spiritual energy for a teleport."
	player:getPosition():sendMagicEffect(CONST_ME_POFF)
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, message)
end

function adventurersStone.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local tile = Tile(player:getPosition())
	if not tile:hasFlag(TILESTATE_PROTECTIONZONE) or tile:hasFlag(TILESTATE_HOUSE) or player:isPzLocked() then
		doNotTeleport(player)
		return false
	end

	local playerPos, allowed, townId = player:getPosition(), false, player:getTown():getId()

	if config.enableTemples then
		for _, temple in ipairs(config.Temples) do
			if playerPos:isInRange(temple.fromPos, temple.toPos) then
				allowed, townId = true, temple.townId
				break
			end
		end
	end

	if not allowed then
		doNotTeleport(player)
		return false
	end

	player:setStorageValue(Storage.CrystalServer.AdventurersGuild.Stone, townId)
	playerPos:sendMagicEffect(CONST_ME_TELEPORT)

	local destination = Position(352, 643, 6)
	player:teleportTo(destination)
	destination:sendMagicEffect(CONST_ME_TELEPORT)
	return true
end

adventurersStone:id(16277)
adventurersStone:register()
