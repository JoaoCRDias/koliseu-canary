-- Main Crafting Window -- This is the modal window that is displayed first
function Player:sendMainCraftWindow(config)
	local function buttonCallback(player, button, choice)
		-- Modal Window Functionallity
		if button.name == "Select" then
			self:sendVocCraftWindow(config, choice.id)
		end
	end

	-- Modal window design
	local window = ModalWindow {
		title = config.mainTitleMsg, -- Title of the main craft modal window
		message = config.mainMsg .. "\n\n" -- Message of the main craft modal window
	}

	-- Add buttons to the window (Note: if you change the names of these you must change the functions in the modal window functionallity!)
	window:addButton("Select", buttonCallback)
	window:addButton("Exit", buttonCallback)

	-- Add choices from the action script
	for i = 1, #config.system do
		window:addChoice(config.system[i].vocation)
	end

	-- Set what button is pressed when the player presses enter or escape.
	window:setDefaultEnterButton(0)
	window:setDefaultEscapeButton(1)

	-- Send the window to player
	window:sendToPlayer(self)
end

-- End of the first modal window



-- This is the modal window that displays all avalible items for the chosen vocation.
function Player:sendVocCraftWindow(config, lastChoice)
	local function buttonCallback(player, button, choice)
		-- Modal Window Functionallity
		-- If the user presses the back button they will be redirected to the main window.
		if button.name == "Back" then
			self:sendMainCraftWindow(config)
		end
		-- If the user presses the details button they will be redirected to a text window with information about the item they want to craft.
		if button.name == "Details" then
			local item = config.system[lastChoice].items[choice.id].item
			local details = "In order to craft " .. item .. " you must collect the following items.\n\n"
			if config.system[lastChoice].items[choice.id].price > 0 then
				details = details .. "\nCraft price: " .. config.system[lastChoice].items[choice.id].price .. "KK\n\nRequired Items:"
			end

			for i = 1, #config.system[lastChoice].items[choice.id].reqItems do
				local reqItems = config.system[lastChoice].items[choice.id].reqItems[i].item
				local reqItemsCount = config.system[lastChoice].items[choice.id].reqItems[i].count
				local reqItemsOnPlayer = self:getItemCount(config.system[lastChoice].items[choice.id].reqItems[i].item)
				details = details .. "\n- " .. capAll(getItemName(reqItems) .. " [" .. reqItemsOnPlayer .. "/" .. reqItemsCount .. "]")
			end
			self:sendVocCraftWindow(config, lastChoice)
			self:showTextDialog(item, details)
		end

		-- if the player presses the craft button then begin checks.
		if button.name == "Craft" then
			local craftItem = config.system[lastChoice].items[choice.id]
			-- If the item has a warning, show confirmation modal first
			if craftItem.warning then
				self:sendCraftWarningModal(config, lastChoice, choice.id)
				return
			end
			self:executeCraft(config, lastChoice, choice.id)
		end
	end

	-- Modal window design
	local window = ModalWindow {
		title = config.craftTitle .. config.system[lastChoice].vocation, -- The title of the vocation specific window
		message = config.craftMsg .. config.system[lastChoice].vocation .. ".\n\n", -- The message of the vocation specific window
	}

	-- Add buttons to the window (Note: if you change the names of these you must change the functions in the modal window functionallity!)
	window:addButton("Back", buttonCallback)
	window:addButton("Exit")
	window:addButton("Details", buttonCallback)
	window:addButton("Craft", buttonCallback)

	-- Set what button is pressed when the player presses enter or escape
	window:setDefaultEnterButton(0)
	window:setDefaultEscapeButton(1)

	-- Add choices from the action script
	for i = 1, #config.system[lastChoice].items do
		window:addChoice(config.system[lastChoice].items[i].item)
	end

	-- Send the window to player
	window:sendToPlayer(self)
end

-- Check if player has any reliquary with relics inside (anywhere in inventory)
function Player:hasRelicInReliquary()
	for i = CONST_SLOT_HEAD, CONST_SLOT_AMMO do
		local slotItem = self:getSlotItem(i)
		if slotItem then
			if RelicSystem.isReliquary(slotItem) then
				local container = Container(slotItem:getUniqueId())
				if container then
					for j = 0, container:getSize() - 1 do
						local item = container:getItem(j)
						if item and RelicSystem.isRelic(item) then
							return true
						end
					end
				end
			end
			-- Check inside backpacks for reliquaries
			local container = Container(slotItem:getUniqueId())
			if container and not RelicSystem.isReliquary(slotItem) then
				if self:_findRelicInReliquaryInContainer(container) then
					return true
				end
			end
		end
	end

	local inbox = self:getStoreInbox()
	if inbox then
		if self:_findRelicInReliquaryInContainer(inbox) then
			return true
		end
	end

	return false
end

function Player:_findRelicInReliquaryInContainer(container)
	for i = 0, container:getSize() - 1 do
		local item = container:getItem(i)
		if item then
			if RelicSystem.isReliquary(item) then
				local subContainer = Container(item:getUniqueId())
				if subContainer then
					for j = 0, subContainer:getSize() - 1 do
						local subItem = subContainer:getItem(j)
						if subItem and RelicSystem.isRelic(subItem) then
							return true
						end
					end
				end
			else
				local subContainer = Container(item:getUniqueId())
				if subContainer then
					if self:_findRelicInReliquaryInContainer(subContainer) then
						return true
					end
				end
			end
		end
	end
	return false
end

-- Execute the actual craft (shared by direct craft and post-warning craft)
function Player:executeCraft(config, lastChoice, itemIndex)
	local craftItem = config.system[lastChoice].items[itemIndex]

	-- Block craft if player has relics inside reliquaries (they would be lost)
	if craftItem.warning and self:hasRelicInReliquary() then
		self:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have relics inside a reliquary. Remove them before crafting to avoid losing them!")
		return false
	end

	if craftItem.price > 0 then
		if self:getMoney() + self:getBankBalance() < (craftItem.price + 1000000) then
			self:say("You do not have enough money to craft this item.", TALKTYPE_MONSTER_SAY)
			return false
		end
	end
	-- Check if player has required items to craft the item.
	for i = 1, #craftItem.reqItems do
		if self:getItemCount(craftItem.reqItems[i].item) < craftItem.reqItems[i].count then
			self:say(config.needItems .. craftItem.item, TALKTYPE_MONSTER_SAY)
			return false
		end
	end
	-- Remove the required items and their count from the player.
	for i = 1, #craftItem.reqItems do
		self:removeItem(craftItem.reqItems[i].item, craftItem.reqItems[i].count)
	end
	-- Send effect and give player item.
	self:addItem(craftItem.itemID)
	self:getPosition():sendMagicEffect(CONST_ME_FIREATTACK)
	return true
end

-- Warning modal shown before crafting items that have a warning property
function Player:sendCraftWarningModal(config, lastChoice, itemIndex)
	local craftItem = config.system[lastChoice].items[itemIndex]
	local function buttonCallback(player, button, choice)
		if button.name == "Proceed" then
			self:executeCraft(config, lastChoice, itemIndex)
		else
			self:sendVocCraftWindow(config, lastChoice)
		end
	end

	local window = ModalWindow {
		title = "Warning",
		message = craftItem.warning .. "\n\nDo you want to proceed?",
	}

	window:addButton("Proceed", buttonCallback)
	window:addButton("Cancel", buttonCallback)
	window:setDefaultEnterButton(0)
	window:setDefaultEscapeButton(1)
	window:sendToPlayer(self)
end
