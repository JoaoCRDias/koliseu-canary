local BattlePassRewards = {}

-- Deliver reward to player
function BattlePassRewards.deliverReward(player, reward)
	if not player then
		return false, "Player not found."
	end

	local rewardType = reward.type

	-- Items
	if rewardType == "items" then
		return BattlePassRewards.deliverItems(player, reward.items)

		-- Prey Wildcards
	elseif rewardType == "prey_wildcard" then
		return BattlePassRewards.deliverPreyWildcards(player, reward.amount)

		-- Charm Points
	elseif rewardType == "charm_points" then
		return BattlePassRewards.deliverCharmPoints(player, reward.amount)

		-- Wheel Points
	elseif rewardType == "wheel_points" then
		return BattlePassRewards.deliverWheelPoints(player, reward.amount)

		-- Outfit (base)
	elseif rewardType == "outfit" then
		return BattlePassRewards.deliverOutfit(player, reward)

		-- Outfit Addon
	elseif rewardType == "outfit_addon" then
		return BattlePassRewards.deliverOutfitAddon(player, reward)

		-- Mount
	elseif rewardType == "mount" then
		return BattlePassRewards.deliverMount(player, reward.mount_id)

		-- Outfit Full (base + all addons)
	elseif rewardType == "outfit_full" then
		return BattlePassRewards.deliverOutfitFull(player, reward)

		-- Custom (placeholder)
	elseif rewardType == "custom" then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Custom reward: " .. (reward.note or "Not implemented yet"))
		return true
	else
		return false, "Unknown reward type: " .. tostring(rewardType)
	end
end

function BattlePassRewards.deliverPreyWildcards(player, amount)
	local current = player:getPreyCards() or 0

	local MAX_PREY_WILDCARDS = (GameStore and GameStore.ItemLimit and GameStore.ItemLimit.PREY_WILDCARD) or 500

	if current >= MAX_PREY_WILDCARDS then
		player:sendCancelMessage("You already have the maximum of prey wildcards.")
		return true
	end

	local toAdd = amount
	if current + toAdd > MAX_PREY_WILDCARDS then
		toAdd = MAX_PREY_WILDCARDS - current
	end

	player:addPreyCards(toAdd)
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("You received %d Prey Wildcard%s!", toAdd, toAdd == 1 and "" or "s"))
	return true
end

-- Check if item is a house/furniture item that needs decoration kit wrapping
local function isHouseItem(itemId)
	local itemType = ItemType(itemId)
	if not itemType then
		return false
	end
	-- Check if item has wrapableto attribute (furniture items)
	local wrapId = itemType:getWrapableTo()
	return wrapId and wrapId > 0
end

-- Deliver items to player
function BattlePassRewards.deliverItems(player, items)
	local inbox = player:getStoreInbox()
	if not inbox then
		return false, "Failed to access store inbox."
	end

	for _, itemData in ipairs(items) do
		local count = itemData.count or 1
		local itemId = itemData.id

		-- Check if it's a house item that needs to be wrapped
		if isHouseItem(itemId) then
			-- Deliver as decoration kit
			for _ = 1, count do
				local decoKit = inbox:addItem(23398, 1) -- ITEM_DECORATION_KIT
				if decoKit then
					local itemType = ItemType(itemId)
					decoKit:setAttribute(ITEM_ATTRIBUTE_DESCRIPTION, "Battle Pass reward.\nUnwrap it in your own house to create a <" .. itemType:getName() .. ">.")
					decoKit:setCustomAttribute("unWrapId", itemId)
				end
			end
		else
			-- Regular item - add individually if not stackable
			for _ = 1, count do
				player:addItemStoreInbox(itemId, 1, true, false)
			end
		end
	end

	return true
end

-- Deliver charm points
function BattlePassRewards.deliverCharmPoints(player, amount)
	player:addCharmPoints(amount)
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("You received %d charm points!", amount))
	return true
end

-- Deliver wheel points
function BattlePassRewards.deliverWheelPoints(player, amount)
	player:addWheelPoints(amount)
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("You received %d wheel points!", amount))
	return true
end

-- Deliver outfit
function BattlePassRewards.deliverOutfit(player, reward)
	local looktype = player:getSex() == PLAYERSEX_FEMALE and reward.female_looktype or reward.male_looktype

	if not player:hasOutfit(looktype) then
		player:addOutfit(reward.female_looktype)
		player:addOutfit(reward.male_looktype)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You received a new outfit!")
		return true
	else
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You already have this outfit.")
		return true
	end
end

-- Deliver outfit addon
function BattlePassRewards.deliverOutfitAddon(player, reward)
	local looktype = player:getSex() == PLAYERSEX_FEMALE and reward.female_looktype or reward.male_looktype
	local addon = reward.addon

	if not player:hasOutfit(looktype) then
		-- Give base outfit first
		player:addOutfit(reward.female_looktype)
		player:addOutfit(reward.male_looktype)
	end

	if not player:hasOutfit(looktype, addon) then
		player:addOutfitAddon(reward.female_looktype, addon)
		player:addOutfitAddon(reward.male_looktype, addon)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("You received outfit addon %d!", addon))
		return true
	else
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You already have this addon.")
		return true
	end
end

-- Deliver mount
function BattlePassRewards.deliverMount(player, mountId)
	if not player:hasMount(mountId) then
		player:addMount(mountId)
		local mountName = Mount(mountId) and Mount(mountId):getName() or ("Mount #" .. mountId)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You received an exclusive mount: " .. mountName .. "!")
		player:getPosition():sendMagicEffect(CONST_ME_FIREWORK_YELLOW)
		return true
	else
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You already have this mount.")
		return true
	end
end

-- Deliver full outfit with all addons
function BattlePassRewards.deliverOutfitFull(player, reward)
	local looktype = player:getSex() == PLAYERSEX_FEMALE and reward.female_looktype or reward.male_looktype

	-- Add base outfit
	if not player:hasOutfit(looktype) then
		player:addOutfit(reward.female_looktype)
		player:addOutfit(reward.male_looktype)
	end

	-- Add addon 1
	if not player:hasOutfit(looktype, 1) then
		player:addOutfitAddon(reward.female_looktype, 1)
		player:addOutfitAddon(reward.male_looktype, 1)
	end

	-- Add addon 2
	if not player:hasOutfit(looktype, 2) then
		player:addOutfitAddon(reward.female_looktype, 2)
		player:addOutfitAddon(reward.male_looktype, 2)
	end

	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You received a full exclusive outfit with all addons!")
	player:getPosition():sendMagicEffect(CONST_ME_FIREWORK_RED)
	return true
end

return BattlePassRewards
