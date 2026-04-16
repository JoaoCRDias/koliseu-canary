-- Scroll of Cosmic Transformation
-- Transforms compatible equipment into their cosmic variants

local MODAL_ID = 5001

local cosmicTransformations = {
	-- Knight Equipment
	[39148] = 60541, -- spiritthorn helmet -> cosmic helmet
	[39147] = 60542, -- spiritthorn armor -> cosmic armor
	[43876] = 60543, -- sanguine legs -> cosmic legs
	[34097] = 60544, -- pair of soulwalkers -> cosmic boots

	-- Knight Weapons
	[43871] = 60545, -- grand sanguine razor -> cosmic sword
	[43865] = 60545, -- grand sanguine razor -> cosmic sword

	[43867] = 60546, -- grand sanguine bludgeon -> cosmic club
	[43873] = 60546, -- grand sanguine bludgeon -> cosmic club

	[43869] = 60547, -- grand sanguine battleaxe -> cosmic axe
	[43875] = 60547, -- grand sanguine battleaxe -> cosmic axe


	-- Sorcerer Equipment
	[39151] = 60548, -- arcanomancer regalia -> cosmic mask
	[34095] = 60549, -- soulmantle -> cosmic mantle
	[34092] = 60550, -- soulshanks -> cosmic pants
	[43884] = 60551, -- sanguine boots -> cosmic shoes
	[39152] = 60552, -- arcanomancer folio -> cosmic folio
	[43883] = 60553, -- grand sanguine coil -> cosmic wand

	-- Druid Equipment
	[39153] = 60554, -- arboreal crown -> cosmic crown
	[34096] = 60555, -- soulshroud -> cosmic robe
	[34093] = 60556, -- soulstrider -> cosmic skirt
	[43887] = 60557, -- sanguine galoshes -> cosmic galoshes
	[39154] = 60558, -- arboreal tome -> cosmic tome
	[43886] = 60559, -- grand sanguine rod -> cosmic rod

	-- Paladin Equipment
	[39149] = 60560, -- alicorn headguard -> cosmic headguard
	[34094] = 60561, -- soulshell -> cosmic plate
	[43881] = 60562, -- sanguine greaves -> cosmic greaves
	[34098] = 60563, -- pair of soulstalkers -> cosmic stalkers
	[39150] = 60564, -- alicorn quiver -> cosmic quiver
	[43878] = 60565, -- grand sanguine bow -> cosmic bow
	[43880] = 60566, -- grand sanguine crossbow -> cosmic crossbow
}

if not pendingCosmicTransform then
	pendingCosmicTransform = {}
end

local function findMarkedItem(player, itemId, mark)
	local function searchContainer(container)
		for i = 0, container:getSize() - 1 do
			local slotItem = container:getItem(i)
			if slotItem then
				if slotItem:getId() == itemId and slotItem:getCustomAttribute("cosmic_transform_mark") == mark then
					return slotItem
				end
				if slotItem:isContainer() then
					local found = searchContainer(slotItem)
					if found then
						return found
					end
				end
			end
		end
		return nil
	end

	-- Check equipment slots (1-11)
	for slot = CONST_SLOT_HEAD, CONST_SLOT_AMMO do
		local slotItem = player:getSlotItem(slot)
		if slotItem then
			if slotItem:getId() == itemId and slotItem:getCustomAttribute("cosmic_transform_mark") == mark then
				return slotItem
			end
			if slotItem:isContainer() then
				local found = searchContainer(slotItem)
				if found then
					return found
				end
			end
		end
	end

	return nil
end

-- Action: use scroll on item
local cosmicTransformationScroll = Action()

function cosmicTransformationScroll.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if not target or not target:isItem() then
		player:sendTextMessage(MESSAGE_FAILURE, "You need to use this scroll on a compatible item.")
		return true
	end

	local targetItem = Item(target.uid)
	if not targetItem then
		player:sendTextMessage(MESSAGE_FAILURE, "You need to use this scroll on a compatible item.")
		return true
	end

	local targetId = targetItem:getId()
	local cosmicId = cosmicTransformations[targetId]

	if not cosmicId then
		player:sendTextMessage(MESSAGE_FAILURE, "This item cannot be transformed with the cosmic scroll.")
		return true
	end

	local targetName = targetItem:getName()
	local cosmicName = ItemType(cosmicId):getName()

	-- Build warning message
	local warnings = {}
	local tier = targetItem:getTier()
	if tier and tier > 0 then
		table.insert(warnings, "- Tier " .. tier .. " (forge classification) will be LOST")
	end

	local upgradeLevel = targetItem:getCustomAttribute("upgrade_level")
	if upgradeLevel and upgradeLevel > 0 then
		table.insert(warnings, "- Upgrade level +" .. upgradeLevel .. " will be LOST")
	end

	local warningText = "You are about to transform your " .. targetName .. " into a " .. cosmicName .. ".\n\n"

	if #warnings > 0 then
		warningText = warningText .. "WARNING! The following will be permanently lost:\n"
		for _, w in ipairs(warnings) do
			warningText = warningText .. w .. "\n"
		end
		warningText = warningText .. "\n"
	end

	warningText = warningText .. "All gems, attributes and enchantments will also be removed.\nThe new cosmic item will be sent to your store inbox.\n\nAre you sure you want to proceed?"

	-- Mark the exact items with a temporary custom attribute
	local mark = os.time()
	targetItem:setCustomAttribute("cosmic_transform_mark", mark)
	item:setCustomAttribute("cosmic_transform_mark", mark)

	-- Store pending data
	pendingCosmicTransform[player:getId()] = {
		targetId = targetId,
		cosmicId = cosmicId,
		mark = mark,
	}

	-- Show modal
	local modal = ModalWindow(MODAL_ID, "Cosmic Transformation", warningText)
	modal:addButton(1, "Confirm")
	modal:addButton(2, "Cancel")
	modal:setDefaultEnterButton(1)
	modal:setDefaultEscapeButton(2)
	modal:sendToPlayer(player)

	return true
end

cosmicTransformationScroll:id(60540)
cosmicTransformationScroll:register()

-- CreatureEvent: handle modal response
local cosmicModalHandler = CreatureEvent("CosmicTransformModal")

function cosmicModalHandler.onModalWindow(player, modalWindowId, buttonId, choiceId)
	if modalWindowId ~= MODAL_ID then
		return true
	end

	local playerId = player:getId()
	local pending = pendingCosmicTransform[playerId]
	pendingCosmicTransform[playerId] = nil

	if buttonId ~= 1 or not pending then
		-- Clean up marks on cancel
		if pending then
			local scroll = findMarkedItem(player, 60540, pending.mark)
			if scroll then scroll:removeCustomAttribute("cosmic_transform_mark") end
			local target = findMarkedItem(player, pending.targetId, pending.mark)
			if target then target:removeCustomAttribute("cosmic_transform_mark") end
		end
		player:sendTextMessage(MESSAGE_FAILURE, "Cosmic transformation cancelled.")
		return true
	end

	-- Find the exact marked scroll
	local scroll = findMarkedItem(player, 60540, pending.mark)
	if not scroll then
		player:sendTextMessage(MESSAGE_FAILURE, "You no longer have the cosmic transformation scroll.")
		return true
	end

	-- Find the exact marked target item
	local targetItem = findMarkedItem(player, pending.targetId, pending.mark)
	if not targetItem then
		scroll:removeCustomAttribute("cosmic_transform_mark")
		player:sendTextMessage(MESSAGE_FAILURE, "You no longer have the item to transform.")
		return true
	end

	-- Get store inbox
	local inbox = player:getStoreInbox()
	if not inbox then
		player:sendTextMessage(MESSAGE_FAILURE, "Failed to access your store inbox.")
		return true
	end

	-- Create the new cosmic item (fresh, no attributes from original)
	local cosmicItem = Game.createItem(pending.cosmicId, 1)
	if not cosmicItem then
		player:sendTextMessage(MESSAGE_FAILURE, "Failed to create cosmic item.")
		return true
	end

	-- Add cosmic item to store inbox
	if inbox:addItemEx(cosmicItem) ~= RETURNVALUE_NOERROR then
		player:sendTextMessage(MESSAGE_FAILURE, "Failed to add item to store inbox. Please try again.")
		return true
	end

	-- Remove the original item and scroll
	targetItem:remove()
	scroll:remove(1)

	-- Visual and sound effects
	player:getPosition():sendMagicEffect(CONST_ME_HOLYAREA)
	player:getPosition():sendMagicEffect(CONST_ME_PURPLESMOKE)

	-- Send success message
	local cosmicName = ItemType(pending.cosmicId):getName()
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The cosmic energy transforms your item into a " .. cosmicName .. "! It has been sent to your store inbox.")

	return true
end

cosmicModalHandler:register()

-- Register the modal handler on login
local cosmicModalLogin = CreatureEvent("CosmicTransformModalLogin")

function cosmicModalLogin.onLogin(player)
	player:registerEvent("CosmicTransformModal")
	return true
end

cosmicModalLogin:register()
