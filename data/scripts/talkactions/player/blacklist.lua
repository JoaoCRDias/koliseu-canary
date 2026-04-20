local KV_KEY = "lootseller.blacklist"
local MAX_BLACKLIST = 50

local function getBlacklist(player)
	return player:kv():get(KV_KEY) or {}
end

local function saveBlacklist(player, list)
	player:kv():set(KV_KEY, list)
end

local function findItemId(param)
	local id = tonumber(param)
	if id then
		local itemType = ItemType(id)
		if itemType and itemType:getId() ~= 0 then
			return id
		end
		return nil
	end

	local itemType = ItemType(param)
	if itemType and itemType:getId() ~= 0 then
		return itemType:getId()
	end
	return nil
end

local blacklist = TalkAction("!blacklist")

function blacklist.onSay(player, words, param)
	if param == "" then
		local list = getBlacklist(player)
		if #list == 0 then
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "[Blacklist] Your blacklist is empty.\nUsage: !blacklist <item-id or item-name> to add/remove items.")
			return true
		end

		local msg = "[Blacklist] Your blacklisted items (" .. #list .. "/" .. MAX_BLACKLIST .. "):\n"
		for i, itemId in ipairs(list) do
			local itemType = ItemType(itemId)
			local name = itemType and itemType:getName() or "unknown"
			msg = msg .. i .. ". " .. name .. " (ID: " .. itemId .. ")\n"
		end
		msg = msg .. "\nUse !blacklist <item-id or item-name> to remove an item."
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, msg)
		return true
	end

	if param:lower() == "clear" then
		saveBlacklist(player, {})
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "[Blacklist] Your blacklist has been cleared.")
		player:getPosition():sendMagicEffect(CONST_ME_MAGIC_RED)
		return true
	end

	local itemId = findItemId(param)
	if not itemId then
		player:sendCancelMessage("[Blacklist] Item not found: " .. param)
		return true
	end

	local itemType = ItemType(itemId)
	local itemName = itemType:getName()

	local list = getBlacklist(player)

	for i, id in ipairs(list) do
		if id == itemId then
			table.remove(list, i)
			saveBlacklist(player, list)
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "[Blacklist] Removed '" .. itemName .. "' (ID: " .. itemId .. ") from your blacklist.")
			player:getPosition():sendMagicEffect(CONST_ME_MAGIC_RED)
			return true
		end
	end

	if #list >= MAX_BLACKLIST then
		player:sendCancelMessage("[Blacklist] Your blacklist is full (" .. MAX_BLACKLIST .. " items max).")
		return true
	end

	table.insert(list, itemId)
	saveBlacklist(player, list)
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "[Blacklist] Added '" .. itemName .. "' (ID: " .. itemId .. ") to your blacklist. This item will not be sold by the Loot Seller.")
	player:getPosition():sendMagicEffect(CONST_ME_MAGIC_GREEN)
	return true
end

blacklist:separator(" ")
blacklist:groupType("normal")
blacklist:register()
