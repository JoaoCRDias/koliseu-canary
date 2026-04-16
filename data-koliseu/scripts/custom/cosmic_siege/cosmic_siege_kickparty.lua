-- Cosmic Siege - Kick Party Command
-- Allows party leader to kick a player from the party

local kickParty = TalkAction("!kickparty")

function kickParty.onSay(player, words, param)
	-- Check if player is in a party
	local party = player:getParty()
	if not party then
		player:sendCancelMessage("You are not in a party.")
		return true
	end

	-- Check if player is party leader
	if party:getLeader() ~= player then
		player:sendCancelMessage("Only the party leader can kick members.")
		return true
	end

	-- Check if parameter (player name) was provided
	if param == "" then
		player:sendCancelMessage("Usage: !kickparty <player name>")
		return true
	end

	-- Find the target player
	local targetPlayer = Player(param)
	if not targetPlayer then
		player:sendCancelMessage(string.format("Player '%s' is not online.", param))
		return true
	end

	-- Check if target is in the same party
	local targetParty = targetPlayer:getParty()
	if not targetParty or targetParty ~= party then
		player:sendCancelMessage(string.format("%s is not in your party.", targetPlayer:getName()))
		return true
	end

	-- Check if trying to kick themselves
	if targetPlayer:getId() == player:getId() then
		player:sendCancelMessage("You cannot kick yourself from the party.")
		return true
	end

	-- Remove the player from the party
	local success = party:removeMember(targetPlayer)

	if not success then
		player:sendCancelMessage(string.format("Failed to kick %s from the party.", targetPlayer:getName()))
		return true
	end

	-- Send messages
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("You kicked %s from the party.", targetPlayer:getName()))
	targetPlayer:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("You were kicked from the party by %s.", player:getName()))

	-- Notify other party members
	local members = party:getMembers()
	for _, member in ipairs(members) do
		if member:getId() ~= player:getId() and member:getId() ~= targetPlayer:getId() then
			member:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("%s was kicked from the party by %s.", targetPlayer:getName(), player:getName()))
		end
	end

	return true
end

kickParty:separator(" ")
kickParty:groupType("normal")
kickParty:register()
