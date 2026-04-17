local mountCommand = TalkAction("!mount")

local addonMountData = dofile(DATA_DIRECTORY .. "/lib/tables/addon_mounts.lua")
local MOUNT_INFO = addonMountData.mounts or {}

local function buildMountChoices()
	local choices = {}
	for key, _ in pairs(MOUNT_INFO) do
		table.insert(choices, key)
	end
	table.sort(choices)
	return choices
end

local MOUNT_CHOICES = buildMountChoices()

local function formatRequirements(info)
	local lines = {}
	local items = info.items or {}
	if #items > 0 then
		local parts = {}
		for _, item in ipairs(items) do
			local itemType = ItemType(item[1])
			local name = itemType and itemType:getName() or ("item " .. tostring(item[1]))
			table.insert(parts, string.format("%dx %s", item[2], name))
		end
		table.insert(lines, "Items: " .. table.concat(parts, ", "))
	end
	if info.cost and info.cost > 0 then
		table.insert(lines, "Gold: " .. FormatNumber(info.cost) .. " gp")
	end
	if #lines == 0 then
		return "No requirements."
	end
	return table.concat(lines, "\n")
end

local function hasRequirements(player, info)
	if info.cost and info.cost > 0 and player:getMoney() < info.cost then
		return false
	end
	local items = info.items or {}
	for _, item in ipairs(items) do
		if player:getItemCount(item[1]) < item[2] then
			return false
		end
	end
	return true
end

local function removeRequirements(player, info)
	if info.cost and info.cost > 0 then
		player:removeMoney(info.cost)
	end
	local items = info.items or {}
	for _, item in ipairs(items) do
		player:removeItem(item[1], item[2])
	end
end

local function sendRequirementsModal(player, displayName, info)
	local message = "Requirements for " .. displayName .. ":\n" .. formatRequirements(info)
	if player:hasMount(info.mount) then
		message = message .. "\n\nYou already own this mount."
	end

	local window = ModalWindow({
		title = "Mount Requirements",
		message = message,
	})

	window:addButton("Ok", function(clickedPlayer)
		if clickedPlayer:hasMount(info.mount) then
			clickedPlayer:sendCancelMessage("You already have this mount.")
			return true
		end
		if not hasRequirements(clickedPlayer, info) then
			clickedPlayer:sendCancelMessage("You do not have the required items.")
			return true
		end
		removeRequirements(clickedPlayer, info)
		clickedPlayer:addMount(info.mount)
		clickedPlayer:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Mount obtained: " .. displayName .. ".")
		return true
	end)

	window:addButton("Close")
	window:setDefaultEnterButton(1)
	window:setDefaultEscapeButton(2)
	window:sendToPlayer(player)
end

local function sendMountModal(player)
	local available = {}
	for _, name in ipairs(MOUNT_CHOICES) do
		local info = MOUNT_INFO[name]
		if info and not player:hasMount(info.mount) then
			table.insert(available, name)
		end
	end

	if #available == 0 then
		player:sendCancelMessage("You already own all available mounts.")
		return
	end

	local window = ModalWindow({
		title = "Mounts",
		message = "Select a mount to obtain:",
	})

	for _, name in ipairs(available) do
		window:addChoice(name)
	end

	window:addButton("Obtain", function(clickedPlayer, button, choice)
		if not choice or not choice.text then
			clickedPlayer:sendCancelMessage("Select a mount first.")
			return true
		end

		local info = MOUNT_INFO[choice.text]
		if not info then
			clickedPlayer:sendCancelMessage("Invalid mount selection.")
			return true
		end

		sendRequirementsModal(clickedPlayer, choice.text, info)
		return true
	end)

	window:addButton("Close")
	window:setDefaultEnterButton(1)
	window:setDefaultEscapeButton(2)
	window:sendToPlayer(player)
end

function mountCommand.onSay(player, words, param)
	sendMountModal(player)
	return true
end

mountCommand:groupType("normal")
mountCommand:register()
