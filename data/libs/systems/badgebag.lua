BadgeBag = {
	config = {
		CONTAINER_ID = 60402,
		UPGRADER_ID = 60477,

		BADGE_IDS = {
			DAMAGE = 60526,
			EXP = 60524,
			LOOT = 60525,
			POTION = 60629,
			HEAL = 60630,
		},
	},
}

-- Helper: Check if item is a badge
function BadgeBag.isBadge(item)
	if not item then
		return false
	end
	local itemId = item:getId()
	return itemId == BadgeBag.config.BADGE_IDS.DAMAGE
		or itemId == BadgeBag.config.BADGE_IDS.EXP
		or itemId == BadgeBag.config.BADGE_IDS.LOOT
		or itemId == BadgeBag.config.BADGE_IDS.POTION
		or itemId == BadgeBag.config.BADGE_IDS.HEAL
end

-- Helper: Check if item is damage badge
function BadgeBag.isDamageBadge(item)
	if not item then
		return false
	end
	return item:getId() == BadgeBag.config.BADGE_IDS.DAMAGE
end

-- Helper: Check if item is exp badge
function BadgeBag.isExpBadge(item)
	if not item then
		return false
	end
	return item:getId() == BadgeBag.config.BADGE_IDS.EXP
end

-- Helper: Check if item is loot badge
function BadgeBag.isLootBadge(item)
	if not item then
		return false
	end
	return item:getId() == BadgeBag.config.BADGE_IDS.LOOT
end

-- Helper: Check if item is potion badge
function BadgeBag.isPotionBadge(item)
	if not item then
		return false
	end
	return item:getId() == BadgeBag.config.BADGE_IDS.POTION
end

-- Helper: Check if item is heal badge
function BadgeBag.isHealBadge(item)
	if not item then
		return false
	end
	return item:getId() == BadgeBag.config.BADGE_IDS.HEAL
end

-- Get badge type from item
function BadgeBag.getBadgeType(item)
	if not item then
		return nil
	end
	local itemId = item:getId()
	if itemId == BadgeBag.config.BADGE_IDS.DAMAGE then
		return "DAMAGE"
	elseif itemId == BadgeBag.config.BADGE_IDS.EXP then
		return "EXP"
	elseif itemId == BadgeBag.config.BADGE_IDS.LOOT then
		return "LOOT"
	elseif itemId == BadgeBag.config.BADGE_IDS.POTION then
		return "POTION"
	elseif itemId == BadgeBag.config.BADGE_IDS.HEAL then
		return "HEAL"
	end
	return nil
end

-- Get badge tier from player's badge bag (reads from item tier directly)
function BadgeBag.getPlayerBadgeTier(player, badgeType)
	if not player then
		return 0
	end

	-- Find badge bag in store inbox
	local storeInbox = player:getStoreInbox()
	if not storeInbox then
		return 0
	end

	-- Find the badge bag container
	local badgeBag = nil
	for i = 0, storeInbox:getSize() - 1 do
		local item = storeInbox:getItem(i)
		if item and item:getId() == BadgeBag.config.CONTAINER_ID then
			badgeBag = Container(item:getUniqueId())
			break
		end
	end

	if not badgeBag then
		return 0
	end

	-- Find the badge item in the bag
	local badgeId
	if badgeType == "DAMAGE" then
		badgeId = BadgeBag.config.BADGE_IDS.DAMAGE
	elseif badgeType == "EXP" then
		badgeId = BadgeBag.config.BADGE_IDS.EXP
	elseif badgeType == "LOOT" then
		badgeId = BadgeBag.config.BADGE_IDS.LOOT
	elseif badgeType == "POTION" then
		badgeId = BadgeBag.config.BADGE_IDS.POTION
	elseif badgeType == "HEAL" then
		badgeId = BadgeBag.config.BADGE_IDS.HEAL
	else
		return 0
	end

	-- Search for the badge and return its tier
	for i = 0, badgeBag:getSize() - 1 do
		local item = badgeBag:getItem(i)
		if item and item:getId() == badgeId then
			return item:getTier()
		end
	end

	return 0
end

-- Create badge bag in player's store inbox (similar to GemBag)
function BadgeBag.createBadgeBag(player)
	if not player then
		return nil
	end

	-- Get store inbox
	local storeInbox = player:getStoreInbox()
	if not storeInbox then
		player:sendCancelMessage("Store inbox not found.")
		return nil
	end

	-- Create badge bag item
	local badgeBag = storeInbox:addItem(BadgeBag.config.CONTAINER_ID, 1, INDEX_WHEREEVER, FLAG_NOLIMIT)
	if not badgeBag then
		player:sendCancelMessage("Failed to create badge bag.")
		return nil
	end

	-- Set ITEM_ATTRIBUTE_STORE to make it immovable
	badgeBag:setAttribute(ITEM_ATTRIBUTE_STORE, os.time())

	-- Get container and ensure scaffold
	local container = Container(badgeBag:getUniqueId())
	if container then
		BadgeBag.ensureBadgeBagScaffold(container, player)
	end

	return badgeBag
end

-- Ensure badge bag has all items (similar to GemBag scaffold)
function BadgeBag.ensureBadgeBagScaffold(container, player)
	if not container then
		return
	end

	-- Get current tiers from player's badges in inventory
	local damageTier = BadgeBag.getPlayerBadgeTier(player, "DAMAGE")
	local expTier = BadgeBag.getPlayerBadgeTier(player, "EXP")
	local lootTier = BadgeBag.getPlayerBadgeTier(player, "LOOT")
	local potionTier = BadgeBag.getPlayerBadgeTier(player, "POTION")
	local healTier = BadgeBag.getPlayerBadgeTier(player, "HEAL")

	-- Clear container first
	for i = container:getSize() - 1, 0, -1 do
		local item = container:getItem(i)
		if item then
			item:remove()
		end
	end

	-- Create and add badges with correct tiers

	-- Damage Badge
	local damageBadge = Game.createItem(BadgeBag.config.BADGE_IDS.DAMAGE, 1)
	if damageBadge then
		damageBadge:setTier(damageTier)
		damageBadge:setAttribute(ITEM_ATTRIBUTE_STORE, os.time())
		container:addItemEx(damageBadge, INDEX_WHEREEVER, FLAG_NOLIMIT)
	end

	-- Experience Badge
	local expBadge = Game.createItem(BadgeBag.config.BADGE_IDS.EXP, 1)
	if expBadge then
		expBadge:setTier(expTier)
		expBadge:setAttribute(ITEM_ATTRIBUTE_STORE, os.time())
		container:addItemEx(expBadge, INDEX_WHEREEVER, FLAG_NOLIMIT)
	end

	-- Loot Badge
	local lootBadge = Game.createItem(BadgeBag.config.BADGE_IDS.LOOT, 1)
	if lootBadge then
		lootBadge:setTier(lootTier)
		lootBadge:setAttribute(ITEM_ATTRIBUTE_STORE, os.time())
		container:addItemEx(lootBadge, INDEX_WHEREEVER, FLAG_NOLIMIT)
	end

	-- Potion Badge
	local potionBadge = Game.createItem(BadgeBag.config.BADGE_IDS.POTION, 1)
	if potionBadge then
		potionBadge:setTier(potionTier)
		potionBadge:setAttribute(ITEM_ATTRIBUTE_STORE, os.time())
		container:addItemEx(potionBadge, INDEX_WHEREEVER, FLAG_NOLIMIT)
	end

	-- Heal Badge
	local healBadge = Game.createItem(BadgeBag.config.BADGE_IDS.HEAL, 1)
	if healBadge then
		healBadge:setTier(healTier)
		healBadge:setAttribute(ITEM_ATTRIBUTE_STORE, os.time())
		container:addItemEx(healBadge, INDEX_WHEREEVER, FLAG_NOLIMIT)
	end

	-- Upgrader
	local upgrader = Game.createItem(BadgeBag.config.UPGRADER_ID, 1)
	if upgrader then
		upgrader:setAttribute(ITEM_ATTRIBUTE_STORE, os.time())
		container:addItemEx(upgrader, INDEX_WHEREEVER, FLAG_NOLIMIT)
	else
		print("[BadgeBag] Error: Failed to create Badge Upgrader with ID " .. tostring(BadgeBag.config.UPGRADER_ID))
	end
end

-- Helper: Safely check if a cylinder is the badge bag container
local function isBadgeBagContainer(cylinder)
	if not cylinder then
		return false
	end

	-- Try to get ID - cylinders that are containers/items have getId()
	local success, id = pcall(function() return cylinder:getId() end)
	if success and id == BadgeBag.config.CONTAINER_ID then
		return true
	end

	return false
end

-- Validate item movement (prevent moving items out or wrong items in)
function BadgeBag.onMoveItem(player, item, fromPosition, toPosition, fromCylinder, toCylinder)
	if not player or not item then
		return nil
	end

	-- Check if source is badge container (prevent removing items)
	if isBadgeBagContainer(fromCylinder) then
		player:sendCancelMessage("Items in the Badge Bag cannot be moved.")
		return false
	end

	-- Check if destination is badge container (prevent adding items manually)
	if isBadgeBagContainer(toCylinder) then
		player:sendCancelMessage("You cannot manually add items to the Badge Bag.")
		return false
	end

	return nil -- Allow other moves
end

return BadgeBag
