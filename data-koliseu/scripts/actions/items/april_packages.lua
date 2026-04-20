-- April store packages: three chest tiers purchased from the Game Store
-- (offers in data/modules/scripts/gamestore/gamestore.lua). Each chest
-- uses Player:safeDeliverItem so rewards fall through to inventory/ground
-- if the Store Inbox is full.

local STARTER_CHEST = 63375
local STANDARD_CHEST = 63376
local BOOSTER_CHEST = 63374

local ITEMS = {
	PREMIUM_SCROLL = 14758,
	MYSTERY_BAG = 60077,
	BAG_YOU_DESIRE = 34109,
	BAG_YOU_COVET = 43895,
	PRIMAL_BAG = 39546,
	PREY_WILDCARD = 60101,
	INIT_GEM_BAG = 60316,
	IMPROVED_SURPRISE_GEM_BAG = 60673,
	BOOSTED_EXERCISE_TOKEN = 60648,
	EXERCISE_SPEED_IMPROVEMENT = 60647,
	LESSER_EXP_POTION = 60303,
	EXP_POTION = 60301,
	GREATER_EXP_POTION = 60302,
	STARLIGHT_POWER = 60148,
	SIGHT_OF_TRUTH = 60160,
	STAR_BACKPACK = 62545,
	WILDUCK_BACKPACK = 63364,
	ROULETE_COIN = 60104,
	IRONLORD_BACKPACK = 63365,
	COSMIC_TOKEN = 60535,
}

-- Random elemental protectors (Starter)
local PROTECTORS = { 60110, 60109, 60108, 60107, 60106, 60105 }

-- Random store dummies (Standard/Booster) — delivered as a decoration kit
local STORE_DUMMIES = { 60299, 60262, 60163, 60153, 60140, 60128, 60103, 60033, 60031, 60062, 60620 }

-- Booster exclusive outfit (Dark Wing)
local BOOSTER_OUTFIT_LOOKTYPE_MALE = 7248
local BOOSTER_OUTFIT_LOOKTYPE_FEMALE = 7245
local BOOSTER_OUTFIT_ADDON = 3

local packages = {
	[STARTER_CHEST] = {
		name = "Starter Package",
		items = {
			{ id = ITEMS.PREMIUM_SCROLL, count = 1 },
			{ id = ITEMS.MYSTERY_BAG, count = 1 },
			{ id = ITEMS.BAG_YOU_DESIRE, count = 1 },
			{ id = ITEMS.PREY_WILDCARD, count = 1 },
			{ id = ITEMS.INIT_GEM_BAG, count = 2 },
			{ id = ITEMS.EXP_POTION, count = 1 },
			{ id = ITEMS.LESSER_EXP_POTION, count = 2 },
			{ id = ITEMS.BOOSTED_EXERCISE_TOKEN, count = 1 },
			{ id = ITEMS.EXERCISE_SPEED_IMPROVEMENT, count = 1 },
			{ id = ITEMS.STAR_BACKPACK, count = 1 },
			{ id = ITEMS.ROULETE_COIN, count = 4 },
			{ id = ITEMS.COSMIC_TOKEN, count = 30 },
		},
		randomProtector = true,
		randomDummy = false,
		mount = 284,
		outfit = nil,
	},
	[STANDARD_CHEST] = {
		name = "Standard Package",
		items = {
			{ id = ITEMS.PREMIUM_SCROLL, count = 1 },
			{ id = ITEMS.MYSTERY_BAG, count = 2 },
			{ id = ITEMS.BAG_YOU_DESIRE, count = 1 },
			{ id = ITEMS.PRIMAL_BAG, count = 1 },
			{ id = ITEMS.EXP_POTION, count = 3 },
			{ id = ITEMS.LESSER_EXP_POTION, count = 3 },
			{ id = ITEMS.PREY_WILDCARD, count = 2 },
			{ id = ITEMS.INIT_GEM_BAG, count = 4 },
			{ id = ITEMS.BOOSTED_EXERCISE_TOKEN, count = 3 },
			{ id = ITEMS.EXERCISE_SPEED_IMPROVEMENT, count = 1 },
			{ id = ITEMS.STARLIGHT_POWER, count = 1 },
			{ id = ITEMS.WILDUCK_BACKPACK, count = 1 },
			{ id = ITEMS.ROULETE_COIN, count = 8 },
			{ id = ITEMS.COSMIC_TOKEN, count = 60 },
		},
		randomProtector = false,
		randomDummy = true,
		mount = 285,
		outfit = nil,
	},
	[BOOSTER_CHEST] = {
		name = "Booster Package",
		items = {
			{ id = ITEMS.PREMIUM_SCROLL, count = 1 },
			{ id = ITEMS.MYSTERY_BAG, count = 3 },
			{ id = ITEMS.BAG_YOU_COVET, count = 2 },
			{ id = ITEMS.PRIMAL_BAG, count = 2 },
			{ id = ITEMS.BAG_YOU_DESIRE, count = 2 },
			{ id = ITEMS.PREY_WILDCARD, count = 3 },
			{ id = ITEMS.INIT_GEM_BAG, count = 4 },
			{ id = ITEMS.IMPROVED_SURPRISE_GEM_BAG, count = 1 },
			{ id = ITEMS.BOOSTED_EXERCISE_TOKEN, count = 5 },
			{ id = ITEMS.EXERCISE_SPEED_IMPROVEMENT, count = 3 },
			{ id = ITEMS.GREATER_EXP_POTION, count = 3 },
			{ id = ITEMS.EXP_POTION, count = 3 },
			{ id = ITEMS.LESSER_EXP_POTION, count = 3 },
			{ id = ITEMS.SIGHT_OF_TRUTH, count = 1 },
			{ id = ITEMS.IRONLORD_BACKPACK, count = 1 },
			{ id = ITEMS.ROULETE_COIN, count = 12 },
			{ id = ITEMS.COSMIC_TOKEN, count = 100 },
		},
		randomProtector = false,
		randomDummy = true,
		mount = 286,
		outfit = { looktype_male = BOOSTER_OUTFIT_LOOKTYPE_MALE, looktype_female = BOOSTER_OUTFIT_LOOKTYPE_FEMALE, addon = BOOSTER_OUTFIT_ADDON },
	},
}

local aprilPackages = Action()

function aprilPackages.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local package = packages[item.itemid]
	if not package then
		return false
	end

	local inbox = player:getStoreInbox()
	if not inbox then
		player:sendCancelMessage("Could not access your store inbox. Please try again.")
		return true
	end

	local itemsReceived = {}
	local itemsFailed = {}

	for _, itemData in ipairs(package.items) do
		local itemType = ItemType(itemData.id)
		if not itemType or itemType:getId() == 0 then
			goto continue
		end

		if itemType:isStackable() then
			local addedItem = player:safeDeliverItem(itemData.id, itemData.count, package.name)
			if addedItem then
				table.insert(itemsReceived, string.format("%dx %s", itemData.count, itemType:getName()))
			else
				table.insert(itemsFailed, string.format("%dx %s", itemData.count, itemType:getName()))
			end
		else
			local addedCount = 0
			for i = 1, itemData.count do
				local addedItem = player:safeDeliverItem(itemData.id, 1, package.name)
				if addedItem then
					addedCount = addedCount + 1
				end
			end
			if addedCount > 0 then
				table.insert(itemsReceived, string.format("%dx %s", addedCount, itemType:getName()))
			end
			if addedCount < itemData.count then
				table.insert(itemsFailed, string.format("%dx %s", itemData.count - addedCount, itemType:getName()))
			end
		end

		::continue::
	end

	if package.randomProtector then
		local protectorId = PROTECTORS[math.random(#PROTECTORS)]
		local addedItem = player:safeDeliverItem(protectorId, 1, package.name)
		if addedItem then
			local itemType = ItemType(protectorId)
			table.insert(itemsReceived, string.format("1x %s", itemType:getName()))
		else
			table.insert(itemsFailed, "1x Elemental Protector")
		end
	end

	if package.randomDummy then
		local dummyId = STORE_DUMMIES[math.random(#STORE_DUMMIES)]
		local decoKit = player:safeDeliverItem(ITEM_DECORATION_KIT, 1, package.name)
		if decoKit then
			local itemType = ItemType(dummyId)
			decoKit:setAttribute(ITEM_ATTRIBUTE_DESCRIPTION, "Unwrap it in your own house to create a <" .. itemType:getName() .. ">.")
			decoKit:setCustomAttribute("unWrapId", dummyId)
			decoKit:setAttribute(ITEM_ATTRIBUTE_STORE, systemTime())
			decoKit:setAttribute(ITEM_ATTRIBUTE_OWNER, player:getGuid())
			table.insert(itemsReceived, string.format("1x %s (random)", itemType:getName()))
		else
			table.insert(itemsFailed, "1x Random Dummy")
		end
	end

	if package.mount then
		if not player:hasMount(package.mount) then
			player:addMount(package.mount)
			table.insert(itemsReceived, "Exclusive Mount (Cosmic Dog)")
		else
			table.insert(itemsReceived, "Mount already owned")
		end
	end

	if package.outfit then
		local isFemale = player:getSex() == PLAYERSEX_FEMALE
		local looktype = isFemale and package.outfit.looktype_female or package.outfit.looktype_male
		local addon = package.outfit.addon

		if not player:hasOutfit(looktype, addon) then
			player:addOutfit(looktype)
			player:addOutfitAddon(looktype, addon)
			table.insert(itemsReceived, "Exclusive Outfit (Dark Wing) with full addons")
		else
			table.insert(itemsReceived, "Outfit already owned")
		end
	end

	player:getPosition():sendMagicEffect(CONST_ME_GIFT_WRAPS)

	local message = string.format("You have opened the %s!\nYour items have been sent to your Store Inbox:\n%s", package.name, table.concat(itemsReceived, "\n"))
	if #itemsFailed > 0 then
		message = message .. string.format("\n\n[WARNING] The following items could NOT be delivered:\n%s\nPlease contact an administrator.", table.concat(itemsFailed, "\n"))
		logger.error("[AprilPackage] Player {} failed to receive items from {}: {}", player:getName(), package.name, table.concat(itemsFailed, ", "))
	end
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, message)
	player:say(string.format("You opened a %s!", package.name), TALKTYPE_MONSTER_SAY)

	item:remove(1)

	return true
end

aprilPackages:id(STARTER_CHEST)
aprilPackages:id(STANDARD_CHEST)
aprilPackages:id(BOOSTER_CHEST)
aprilPackages:register()
