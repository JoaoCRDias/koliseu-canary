local upgraderItem = 60022

local ITEM_IMBUEMENT_SLOT = 500

local function hasActiveImbuements(item)
	local imbuementSlots = item:getImbuementSlot()
	if not imbuementSlots or imbuementSlots == 0 then
		return false
	end

	for slot = 0, imbuementSlots - 1 do
		local attributeKey = tostring(ITEM_IMBUEMENT_SLOT + slot)
		local imbuementData = item:getCustomAttribute(attributeKey)
		if imbuementData and imbuementData > 0 then
			return true
		end
	end
	return false
end

local tierUpgrade = Action()
function tierUpgrade.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local targetUpgradeItem = target and target:isItem() and Item(target.uid)
	if not targetUpgradeItem then
		player:say("You need to use this on another item.", TALKTYPE_MONSTER_SAY)
		return false
	end

	if item:getId() ~= upgraderItem then
		player:say("You can't use this for a tier upgrade.", TALKTYPE_MONSTER_SAY)
		return false
	end

	if BadgeBag.isBadge(targetUpgradeItem) then
		player:say("You cannot use the tier upgrader on badges.", TALKTYPE_MONSTER_SAY)
		return false
	end

	if RelicSystem and RelicSystem.isRelic(targetUpgradeItem) then
		player:say("You cannot use the tier upgrader on relics. Use the Relic Altar to upgrade relics.", TALKTYPE_MONSTER_SAY)
		return false
	end

	if hasActiveImbuements(targetUpgradeItem) then
		player:say("You cannot upgrade an item with active imbuements. Please remove them first.", TALKTYPE_MONSTER_SAY)
		return false
	end

	local currentTier = targetUpgradeItem:getTier()
	local classification = targetUpgradeItem:getClassification()

	local maxTier = 0
	if classification == 1 then
		maxTier = 1
	elseif classification == 2 then
		maxTier = 2
	elseif classification == 3 then
		maxTier = 3
	elseif classification == 4 then
		maxTier = 10
	else
		player:say("Invalid item classification.", TALKTYPE_MONSTER_SAY)
		return false
	end

	if currentTier >= maxTier then
		player:say("This item has already reached its maximum tier.", TALKTYPE_MONSTER_SAY)
		return false
	end

	local requiredItems
	if (currentTier >= 0 and currentTier <= 3) then
		requiredItems = 1
	elseif (currentTier > 3 and currentTier < 8) then
		requiredItems = 2
	else
		requiredItems = 4
	end

	local playerItemCount = player:getItemCount(upgraderItem)
	if playerItemCount < requiredItems then
		player:say("You need " .. requiredItems .. " items to upgrade to the next tier.", TALKTYPE_MONSTER_SAY)
		return false
	end

	local newTier = currentTier + 1

	local inbox = player:getStoreInbox()
	if not inbox then
		player:say("Failed to access your store inbox.", TALKTYPE_MONSTER_SAY)
		return false
	end

	-- Clone the item to preserve all attributes
	local clonedItem = targetUpgradeItem:clone()
	if not clonedItem then
		player:say("Failed to clone item. Please try again.", TALKTYPE_MONSTER_SAY)
		return false
	end

	-- Apply new tier to the cloned item
	if not clonedItem:setTier(newTier) then
		player:say("Failed to set item tier. Please try again.", TALKTYPE_MONSTER_SAY)
		return false
	end

	-- Add cloned item to store inbox
	if not inbox:addItemEx(clonedItem) then
		player:say("Failed to add item to store inbox. Please try again.", TALKTYPE_MONSTER_SAY)
		return false
	end

	-- Remove original item and upgrader items
	targetUpgradeItem:remove()
	player:removeItem(upgraderItem, requiredItems)

	player:say("Upgrade successful! Your Tier " .. newTier .. " item has been sent to your store inbox.", TALKTYPE_MONSTER_SAY)
	return true
end

tierUpgrade:id(upgraderItem)
tierUpgrade:register()
