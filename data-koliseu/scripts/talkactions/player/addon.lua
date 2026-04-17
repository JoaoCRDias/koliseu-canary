local addonCommand = TalkAction("!addon")

local addonMountData = dofile(DATA_DIRECTORY .. "/lib/tables/addon_mounts.lua")
local ADDON_INFO = addonMountData.addons or {}

local function buildAddonChoicesAndLookup()
	local lookup = {}
	local used = {}
	for key, _ in pairs(ADDON_INFO) do
		local display = key
		if used[display] then
			display = key
		end
		used[display] = true
		lookup[display] = key
	end

	local choices = {}
	for display, _ in pairs(lookup) do
		table.insert(choices, display)
	end
	table.sort(choices)
	return choices, lookup
end

local ADDON_CHOICES, ADDON_LOOKUP = buildAddonChoicesAndLookup()

local function hasFullAddon(player, info)
	if info.outfit_male and player:hasOutfit(info.outfit_male, 3) then
		return true
	end
	if info.outfit_female and player:hasOutfit(info.outfit_female, 3) then
		return true
	end
	return false
end

local function buildAddonChoicesForPlayer(player)
	local choices = {}
	local playerSex = player:getSex()
	for display, key in pairs(ADDON_LOOKUP) do
		local info = ADDON_INFO[key]
		if info and not hasFullAddon(player, info) then
			-- Filter by player sex
			local isMaleOnly = info.outfit_male and not info.outfit_female
			local isFemaleOnly = info.outfit_female and not info.outfit_male

			if isMaleOnly and playerSex ~= PLAYERSEX_MALE then
				-- Skip male-only addons for female characters
			elseif isFemaleOnly and playerSex ~= PLAYERSEX_FEMALE then
				-- Skip female-only addons for male characters
			else
				table.insert(choices, display)
			end
		end
	end
	table.sort(choices)
	return choices
end

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
	if info.cost and info.cost > 0 and (player:getMoney() + player:getBankBalance()) < info.cost then
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
		player:removeMoneyBank(info.cost)
	end
	local items = info.items or {}
	for _, item in ipairs(items) do
		player:removeItem(item[1], item[2])
	end
end

local function grantAddon(player, info)
	if info.outfit_male then
		player:addOutfitAddon(info.outfit_male, 3)
	end
	if info.outfit_female then
		player:addOutfitAddon(info.outfit_female, 3)
	end
end

local function sendRequirementsModal(player, displayName, info)
	local message = "Requirements for " .. displayName .. ":\n" .. formatRequirements(info)
	if hasFullAddon(player, info) then
		message = message .. "\n\nYou already own this addon."
	end

	local window = ModalWindow({
		title = "Addon Requirements",
		message = message,
	})

	window:addButton("Ok", function(clickedPlayer)
		if hasFullAddon(clickedPlayer, info) then
			clickedPlayer:sendCancelMessage("You already have this addon.")
			return true
		end
		if not hasRequirements(clickedPlayer, info) then
			clickedPlayer:sendCancelMessage("You do not have the required items.")
			return true
		end
		removeRequirements(clickedPlayer, info)
		grantAddon(clickedPlayer, info)
		clickedPlayer:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Addon obtained: " .. displayName .. ".")
		return true
	end)

	window:addButton("Close")
	window:setDefaultEnterButton(1)
	window:setDefaultEscapeButton(2)
	window:sendToPlayer(player)
end

local function sendAddonModal(player)
	local choices = buildAddonChoicesForPlayer(player)
	if #choices == 0 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You already have all available addons.")
		return
	end

	local window = ModalWindow({
		title = "Addons",
		message = "Select an addon to obtain:",
	})

	for _, name in ipairs(choices) do
		window:addChoice(name)
	end

	window:addButton("Obtain", function(clickedPlayer, button, choice)
		if not choice or not choice.text then
			clickedPlayer:sendCancelMessage("Select an addon first.")
			return true
		end

		local key = ADDON_LOOKUP[choice.text]
		local info = key and ADDON_INFO[key]
		if not info then
			clickedPlayer:sendCancelMessage("Invalid addon selection.")
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

function addonCommand.onSay(player, words, param)
	sendAddonModal(player)
	return true
end

addonCommand:groupType("normal")
addonCommand:register()
