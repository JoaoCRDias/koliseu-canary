-- Grant or revoke Gem Extender to a player
-- /gemextender add, playername
-- /gemextender remove, playername
local gemExtenderGrant = TalkAction("/gemextender")

local gemExtenderAdd = TalkAction("/grantextender")
local gemExtenderRemove = TalkAction("/revokeextender")

function gemExtenderGrant.onSay(player, words, param)
	if param == "" then
		player:sendCancelMessage("Command param required. Usage: /gemextender add|remove, playername")
		return true
	end

	local params = param:split(",")
	if #params < 2 then
		player:sendCancelMessage('Usage: /gemextender add|remove, playername')
		return true
	end

	local action = string.trim(params[1]):lower()
	local targetName = string.trim(params[2])

	if action ~= "add" and action ~= "remove" then
		player:sendCancelMessage('Action must be "add" or "remove".')
		return true
	end

	local target = Player(targetName)
	if not target then
		player:sendCancelMessage(string.format('Player "%s" not found.', targetName))
		return true
	end

	if action == "add" then
		if GemBag.grantGemExtender(target) then
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format('Gem Extender granted to player "%s".', targetName))
		else
			player:sendCancelMessage(string.format('Player "%s" already has Gem Extender.', targetName))
		end
	elseif action == "remove" then
		if GemBag.revokeGemExtender(target) then
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format('Gem Extender revoked from player "%s".', targetName))
		else
			player:sendCancelMessage(string.format('Player "%s" does not have Gem Extender.', targetName))
		end
	end

	return true
end

gemExtenderGrant:separator(" ")
gemExtenderGrant:groupType("gamemaster")
gemExtenderGrant:register()

function gemExtenderAdd.onSay(player, words, param)
	if param == "" then
		player:sendCancelMessage("Command param required. Usage: /grantextender playername")
		return true
	end

	local targetName = string.trim(param)
	local target = Player(targetName)
	if not target then
		player:sendCancelMessage(string.format('Player "%s" not found.', targetName))
		return true
	end

	if GemBag.grantGemExtender(target) then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format('Gem Extender granted to player "%s".', targetName))
	else
		player:sendCancelMessage(string.format('Player "%s" already has Gem Extender.', targetName))
	end

	return true
end

gemExtenderAdd:separator(" ")
gemExtenderAdd:groupType("gamemaster")
gemExtenderAdd:register()

function gemExtenderRemove.onSay(player, words, param)
	if param == "" then
		player:sendCancelMessage("Command param required. Usage: /revokeextender playername")
		return true
	end

	local targetName = string.trim(param)
	local target = Player(targetName)
	if not target then
		player:sendCancelMessage(string.format('Player "%s" not found.', targetName))
		return true
	end

	if GemBag.revokeGemExtender(target) then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format('Gem Extender revoked from player "%s".', targetName))
	else
		player:sendCancelMessage(string.format('Player "%s" does not have Gem Extender.', targetName))
	end

	return true
end

gemExtenderRemove:separator(" ")
gemExtenderRemove:groupType("gamemaster")
gemExtenderRemove:register()
