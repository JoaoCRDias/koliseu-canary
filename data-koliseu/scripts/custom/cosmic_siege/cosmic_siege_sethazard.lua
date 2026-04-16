-- Cosmic Siege - Set Hazard Command
-- Allows GOD to set a player's hazard level

local setHazard = TalkAction("!sethazard")

function setHazard.onSay(player, words, param)
	-- Check if player is GOD
	if player:getAccountType() < ACCOUNT_TYPE_GOD then
		player:sendCancelMessage("You need to be a GOD to use this command.")
		return true
	end

	-- Parse parameters: player name, level
	local split = param:split(",")
	if #split ~= 2 then
		player:sendCancelMessage("Usage: !sethazard <player name>, <level>")
		player:sendCancelMessage("Example: !sethazard PlayerName, 15")
		return true
	end

	local targetName = split[1]:trim()
	local hazardLevel = tonumber(split[2]:trim())

	-- Validate hazard level
	if not hazardLevel or hazardLevel < 0 then
		player:sendCancelMessage("Hazard level must be a valid number (0 or higher).")
		return true
	end

	-- Find target player
	local targetPlayer = Player(targetName)
	if not targetPlayer then
		player:sendCancelMessage(string.format("Player '%s' is not online.", targetName))
		return true
	end

	-- Set hazard level using Cosmic Siege hazard system
	local hazard = CosmicSiege and CosmicSiege.getHazard()

	if not hazard then
		player:sendCancelMessage("Cosmic Siege hazard system not found.")
		return true
	end

	-- Set max level if needed
	if hazardLevel > hazard:getPlayerMaxLevel(targetPlayer) then
		hazard:setPlayerMaxLevel(targetPlayer, hazardLevel)
	end

	-- Set current level
	hazard:setPlayerCurrentLevel(targetPlayer, hazardLevel)

	-- Send confirmation messages
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("Set hazard level of %s to %d.", targetPlayer:getName(), hazardLevel))
	targetPlayer:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("Your hazard level has been set to %d by %s.", hazardLevel, player:getName()))

	return true
end

setHazard:separator(" ")
setHazard:groupType("god")
setHazard:register()
