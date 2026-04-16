local internalNpcName = "Astrid the Starforger"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 3120,
	lookHead = 19,
	lookBody = 69,
	lookLegs = 58,
	lookFeet = 76,
	lookAddons = 3,
}

npcConfig.flags = {
	floorchange = false,
}

npcConfig.voices = {
	interval = 15000,
	chance = 30,
	{ text = "Reforge your cosmic equipment! Say 'trade' to see what I can do." },
	{ text = "Unhappy with your cosmic gear? I can reshape it into any other cosmic item for a small fee." },
}

local MODAL_ID = 5010
local EXCHANGE_COST = 50 -- transferable coins

-- All cosmic items grouped by slot/category
-- Items in the same group can be exchanged with each other
local cosmicGroups = {
	{
		name = "Helmets",
		items = {
			{ id = 60541, name = "cosmic helmet" },
			{ id = 60548, name = "cosmic mask" },
			{ id = 60554, name = "cosmic crown" },
			{ id = 60560, name = "cosmic headguard" },
		},
	},
	{
		name = "Armors",
		items = {
			{ id = 60542, name = "cosmic armor" },
			{ id = 60549, name = "cosmic mantle" },
			{ id = 60555, name = "cosmic robe" },
			{ id = 60561, name = "cosmic plate" },
		},
	},
	{
		name = "Legs",
		items = {
			{ id = 60543, name = "cosmic legs" },
			{ id = 60550, name = "cosmic pants" },
			{ id = 60556, name = "cosmic skirt" },
			{ id = 60562, name = "cosmic greaves" },
		},
	},
	{
		name = "Boots",
		items = {
			{ id = 60544, name = "cosmic boots" },
			{ id = 60551, name = "cosmic shoes" },
			{ id = 60557, name = "cosmic galoshes" },
			{ id = 60563, name = "cosmic stalkers" },
		},
	},
	{
		name = "Weapons",
		items = {
			{ id = 60545, name = "cosmic sword" },
			{ id = 60546, name = "cosmic club" },
			{ id = 60547, name = "cosmic axe" },
			{ id = 60553, name = "cosmic wand" },
			{ id = 60559, name = "cosmic rod" },
			{ id = 60565, name = "cosmic bow" },
			{ id = 60566, name = "cosmic crossbow" },
		},
	},
	{
		name = "Spellbooks & Quivers",
		items = {
			{ id = 60552, name = "cosmic folio" },
			{ id = 60558, name = "cosmic tome" },
			{ id = 60564, name = "cosmic quiver" },
		},
	},
}

-- Build lookup: cosmicId -> group index
local cosmicIdToGroup = {}
for groupIdx, group in ipairs(cosmicGroups) do
	for _, item in ipairs(group.items) do
		cosmicIdToGroup[item.id] = groupIdx
	end
end

-- Build set of all cosmic item ids
local allCosmicIds = {}
for id in pairs(cosmicIdToGroup) do
	allCosmicIds[id] = true
end

if not pendingCosmicExchange then
	pendingCosmicExchange = {}
end

-- Find ALL cosmic items with a given id in player inventory (equipment slots + containers)
local function findAllCosmicItems(player, itemId)
	local results = {}

	local function searchContainer(container)
		for i = 0, container:getSize() - 1 do
			local slotItem = container:getItem(i)
			if slotItem then
				if slotItem:getId() == itemId then
					table.insert(results, slotItem)
				end
				if slotItem:isContainer() then
					searchContainer(slotItem)
				end
			end
		end
	end

	for slot = CONST_SLOT_HEAD, CONST_SLOT_AMMO do
		local slotItem = player:getSlotItem(slot)
		if slotItem then
			if slotItem:getId() == itemId then
				table.insert(results, slotItem)
			end
			if slotItem:isContainer() then
				searchContainer(slotItem)
			end
		end
	end

	-- Search store inbox
	local inbox = player:getStoreInbox()
	if inbox then
		for _, inboxItem in ipairs(inbox:getItems()) do
			if inboxItem:getId() == itemId then
				table.insert(results, inboxItem)
			end
			if inboxItem:isContainer() then
				searchContainer(inboxItem)
			end
		end
	end

	return results
end

-- Find any cosmic item from a specific group
local function findAnyCosmicFromGroup(player, groupIdx)
	local group = cosmicGroups[groupIdx]
	if not group then
		return nil
	end
	for _, item in ipairs(group.items) do
		local allFound = findAllCosmicItems(player, item.id)
		if #allFound > 0 then
			return allFound[1]
		end
	end
	return nil
end

local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)

npcType.onThink = function(npc, interval) npcHandler:onThink(npc, interval) end
npcType.onAppear = function(npc, creature) npcHandler:onAppear(npc, creature) end
npcType.onDisappear = function(npc, creature) npcHandler:onDisappear(npc, creature) end
npcType.onMove = function(npc, creature, fromPosition, toPosition) npcHandler:onMove(npc, creature, fromPosition, toPosition) end
npcType.onSay = function(npc, creature, type, message) npcHandler:onSay(npc, creature, type, message) end
npcType.onCloseChannel = function(npc, creature) npcHandler:onCloseChannel(npc, creature) end

local function creatureSayCallback(npc, creature, type, message)
	local player = Player(creature)
	if not player then
		return false
	end

	if not npcHandler:checkInteraction(npc, creature) then
		return false
	end

	if MsgContains(message, "trade") or MsgContains(message, "exchange") or MsgContains(message, "swap") then
		-- Find which cosmic items the player has (only clean items without tier, upgrades or skill gems)
		local skillGemAttributes = {
			"skill_gem_distance_level",
			"skill_gem_magic_level",
			"skill_gem_fist_level",
			"skill_gem_melee_level",
		}

		local ownedGroups = {}
		for groupIdx, group in ipairs(cosmicGroups) do
			for _, item in ipairs(group.items) do
				local allFound = findAllCosmicItems(player, item.id)
				for _, found in ipairs(allFound) do
					local tier = found:getTier()
					local upgradeLevel = found:getCustomAttribute("upgrade_level")
					local hasTier = tier and tier > 0
					local hasUpgrade = upgradeLevel and upgradeLevel > 0

					local hasGem = false
					for _, attr in ipairs(skillGemAttributes) do
						local gemLevel = found:getCustomAttribute(attr)
						if gemLevel and gemLevel > 0 then
							hasGem = true
							break
						end
					end

					if not hasTier and not hasUpgrade and not hasGem then
						table.insert(ownedGroups, { groupIdx = groupIdx, itemId = item.id, itemName = item.name })
						break -- only need one clean item per type
					end
				end
			end
		end

		if #ownedGroups == 0 then
			npcHandler:say("You don't have any cosmic equipment to exchange. Come back when you have some!", npc, creature)
			return true
		end

		-- Show modal with owned items to exchange FROM
		local modal = ModalWindow(MODAL_ID, "Cosmic Exchange", "Select the cosmic item you want to exchange.\nCost: " .. EXCHANGE_COST .. " Tibia Coins.\n\nYour cosmic items:")
		for i, owned in ipairs(ownedGroups) do
			modal:addChoice(i, owned.itemName)
		end
		modal:addButton(1, "Select")
		modal:addButton(2, "Cancel")
		modal:setDefaultEnterButton(1)
		modal:setDefaultEscapeButton(2)

		pendingCosmicExchange[player:getId()] = {
			step = 1,
			ownedGroups = ownedGroups,
		}

		modal:sendToPlayer(player)
		return true
	end

	if MsgContains(message, "help") or MsgContains(message, "info") then
		npcHandler:say({
			"I can reforge your cosmic equipment into any other cosmic item, regardless of slot.",
			"For example, I can turn your {cosmic helmet} into a {cosmic sword} or {cosmic armor}.",
			"The cost is {" .. EXCHANGE_COST .. " Tibia Coins} per exchange. The item must have no tier or upgrades.",
			"Say {trade} to begin!"
		}, npc, creature)
		return true
	end

	return false
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:setMessage(MESSAGE_GREET, "Welcome, |PLAYERNAME|! I am Astrid, master of cosmic reforging. Say {trade} to exchange your cosmic equipment, or {help} for more information.")
npcHandler:setMessage(MESSAGE_FAREWELL, "May the cosmos smile upon you, |PLAYERNAME|!")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Until the stars align again...")
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, false)

npcType.onBuyItem = function(npc, player, itemId, subType, amount, ignore, inBackpacks, totalCost) end
npcType.onSellItem = function(npc, player, itemId, subtype, amount, ignore, name, totalCost) end
npcType.onCheckItem = function(npc, player, clientId, subType) end

npcType:register(npcConfig)

-- Modal handler
local cosmicExchangeModal = CreatureEvent("CosmicExchangeModal")

function cosmicExchangeModal.onModalWindow(player, modalWindowId, buttonId, choiceId)
	if modalWindowId ~= MODAL_ID then
		return true
	end

	local playerId = player:getId()
	local pending = pendingCosmicExchange[playerId]

	if buttonId ~= 1 or not pending then
		pendingCosmicExchange[playerId] = nil
		return true
	end

	if pending.step == 1 then
		-- Player selected which item to exchange FROM
		local selected = pending.ownedGroups[choiceId]
		if not selected then
			pendingCosmicExchange[playerId] = nil
			player:sendTextMessage(MESSAGE_FAILURE, "Invalid selection.")
			return true
		end

		-- Show second modal: what to exchange TO (any cosmic item from any slot)
		local choices = {}
		for _, group in ipairs(cosmicGroups) do
			for _, item in ipairs(group.items) do
				if item.id ~= selected.itemId then
					table.insert(choices, item)
				end
			end
		end

		local modal = ModalWindow(MODAL_ID, "Cosmic Exchange", "Exchange your " .. selected.itemName .. " into:\nCost: " .. EXCHANGE_COST .. " Tibia Coins.")
		for i, item in ipairs(choices) do
			modal:addChoice(i, item.name)
		end
		modal:addButton(1, "Confirm")
		modal:addButton(2, "Cancel")
		modal:setDefaultEnterButton(1)
		modal:setDefaultEscapeButton(2)

		pendingCosmicExchange[playerId] = {
			step = 2,
			sourceId = selected.itemId,
			sourceName = selected.itemName,
			groupIdx = selected.groupIdx,
			choices = choices,
		}

		modal:sendToPlayer(player)
		return true
	end

	if pending.step == 2 then
		-- Player selected what to exchange TO
		local target = pending.choices[choiceId]
		pendingCosmicExchange[playerId] = nil

		if not target then
			player:sendTextMessage(MESSAGE_FAILURE, "Invalid selection.")
			return true
		end

		-- Validate: player still has a clean source item (no tier, upgrades or skill gems)
		local skillGemAttributes = {
			"skill_gem_distance_level",
			"skill_gem_magic_level",
			"skill_gem_fist_level",
			"skill_gem_melee_level",
		}

		local sourceItem = nil
		local allFound = findAllCosmicItems(player, pending.sourceId)
		for _, found in ipairs(allFound) do
			local tier = found:getTier()
			local upgradeLevel = found:getCustomAttribute("upgrade_level")
			local hasTier = tier and tier > 0
			local hasUpgrade = upgradeLevel and upgradeLevel > 0

			local hasGem = false
			for _, attr in ipairs(skillGemAttributes) do
				local gemLevel = found:getCustomAttribute(attr)
				if gemLevel and gemLevel > 0 then
					hasGem = true
					break
				end
			end

			if not hasTier and not hasUpgrade and not hasGem then
				sourceItem = found
				break
			end
		end

		if not sourceItem then
			player:sendTextMessage(MESSAGE_FAILURE, "You no longer have a clean " .. pending.sourceName .. " (without tier, upgrades or skill gems).")
			return true
		end

		-- Validate: player has enough coins
		if not player:canRemoveTransferableCoins(EXCHANGE_COST) then
			player:sendTextMessage(MESSAGE_FAILURE, string.format("You need %d Tibia Coins to exchange. You don't have enough.", EXCHANGE_COST))
			return true
		end

		-- Get store inbox
		local inbox = player:getStoreInbox()
		if not inbox then
			player:sendTextMessage(MESSAGE_FAILURE, "Failed to access your store inbox.")
			return true
		end

		-- Create new item
		local newItem = Game.createItem(target.id, 1)
		if not newItem then
			player:sendTextMessage(MESSAGE_FAILURE, "Failed to create the new item.")
			return true
		end

		-- Add to store inbox
		if inbox:addItemEx(newItem) ~= RETURNVALUE_NOERROR then
			player:sendTextMessage(MESSAGE_FAILURE, "Failed to add item to store inbox. Please try again.")
			return true
		end

		-- Remove source item and charge coins
		sourceItem:remove()
		player:removeTransferableCoinsBalance(EXCHANGE_COST)

		-- Effects
		player:getPosition():sendMagicEffect(CONST_ME_HOLYAREA)
		player:getPosition():sendMagicEffect(CONST_ME_PURPLESMOKE)

		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("Your %s has been reforged into a %s! It has been sent to your store inbox.", pending.sourceName, target.name))
		return true
	end

	pendingCosmicExchange[playerId] = nil
	return true
end

cosmicExchangeModal:register()

-- Register modal handler on login
local cosmicExchangeLogin = CreatureEvent("CosmicExchangeModalLogin")

function cosmicExchangeLogin.onLogin(player)
	player:registerEvent("CosmicExchangeModal")
	return true
end

cosmicExchangeLogin:register()
