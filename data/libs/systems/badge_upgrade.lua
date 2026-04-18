BadgeUpgrade = {
	COSTS = {
		[1] = { base = 100, gold = 100000000, chance = 45 }, -- 100kk
		[2] = { base = 200, gold = 250000000, chance = 40 }, -- 250kk
		[3] = { base = 400, gold = 400000000, chance = 35 }, -- 400kk
		[4] = { base = 600, gold = 600000000, chance = 30 }, -- 600kk
		[5] = { base = 800, gold = 800000000, chance = 25 }, -- 800kk
		[6] = { base = 1200, gold = 1000000000, chance = 20 }, -- 1kkk
		[7] = { base = 1600, gold = 1300000000, chance = 15 }, -- 1.3kkk
		[8] = { base = 2400, gold = 1600000000, chance = 10 }, -- 1.6kkk
		[9] = { base = 3500, gold = 1800000000, chance = 5 }, -- 1.8kkk
	},

	-- IMPORTANTE: Substituir pelos IDs reais dos recursos
	RESOURCES = {
		DAMAGE = 60537, -- [PLACEHOLDER] Configurar ID do recurso para Damage Badge
		EXP = 60528, -- [PLACEHOLDER] Configurar ID do recurso para Experience Badge
		LOOT = 60536, -- [PLACEHOLDER] Configurar ID do recurso para Loot Badge
		POTION = 19371, -- TODO: Configurar ID do recurso para Potion Badge
		HEAL = 12517, -- TODO: Configurar ID do recurso para Heal Badge
	},

	PITY_BONUS = 1, -- 1% por falha
}

-- Calculate bonus percentage based on tier
function BadgeUpgrade.calculateBonus(tier)
	if tier <= 5 then
		return tier * 2
	else
		return 10 + ((tier - 5) * 4)
	end
end

-- Get badge name
function BadgeUpgrade.getBadgeName(badgeType)
	if badgeType == "DAMAGE" then
		return "Damage Badge"
	elseif badgeType == "EXP" then
		return "Experience Badge"
	elseif badgeType == "LOOT" then
		return "Loot Badge"
	elseif badgeType == "POTION" then
		return "Potion Badge"
	elseif badgeType == "HEAL" then
		return "Heal Badge"
	end
	return "Unknown Badge"
end

-- Get resource name
function BadgeUpgrade.getResourceName(resourceId)
	if resourceId == 0 then
		return "[Resource Not Configured]"
	end
	local itemType = ItemType(resourceId)
	if itemType then
		return itemType:getName()
	end
	return "Unknown Resource"
end

-- Format gold amount
function BadgeUpgrade.formatGold(amount)
	if amount >= 1000000000 then
		return string.format("%.0fkkk", amount / 1000000000)
	elseif amount >= 1000000 then
		return string.format("%.0fkk", amount / 1000000)
	else
		return tostring(amount)
	end
end

-- Show upgrade modal
function BadgeUpgrade.showModal(player, badge, badgeType, currentTier)
	local nextTier = currentTier + 1
	local cost = BadgeUpgrade.COSTS[nextTier]
	local resourceId = BadgeUpgrade.RESOURCES[badgeType]

	-- Check if resource is configured
	if not resourceId or resourceId == 0 then
		player:sendCancelMessage("Badge upgrade system is not fully configured. Please contact an administrator.")
		return
	end

	-- Calculate chance with pity
	local pityKey = "badge_pity_" .. badgeType
	local pityCounter = player:kv():get(pityKey) or 0
	local successChance = cost.chance + (pityCounter * BadgeUpgrade.PITY_BONUS)
	-- Event 08/03/2026: +5% badge upgrade chance
	local today = os.date("%Y-%m-%d")
	if today == "2026-03-08" then
		successChance = successChance + 5
	end
	successChance = math.min(100, successChance)

	-- Validate resources - getItemCount without second parameter searches everywhere
	local itemCount = player:getItemCount(resourceId)
	local hasResources = itemCount >= cost.base
	local bankBalance = player:getMoney() + player:getBankBalance()
	local hasGold = bankBalance >= cost.gold

	local canUpgrade = hasResources and hasGold

	-- Calculate current and next bonus
	local currentBonus = BadgeUpgrade.calculateBonus(currentTier)
	local nextBonus = BadgeUpgrade.calculateBonus(nextTier)

	-- Build message
	local badgeName = BadgeUpgrade.getBadgeName(badgeType)
	local resourceName = BadgeUpgrade.getResourceName(resourceId)
	local goldFormatted = BadgeUpgrade.formatGold(cost.gold)

	local pityText = ""
	if pityCounter > 0 then
		pityText = string.format(" (Pity: +%d%%)", pityCounter * BadgeUpgrade.PITY_BONUS)
	end

	local message = string.format([[Upgrade %s?

Current: Tier %d (+%d%%)
Target: Tier %d (+%d%%)

Requirements:
%dx %s
%s gold coins

Success Chance: %d%%%s
On Failure: Badge remains at current Tier

SUCCESS: Badge upgraded to Tier %d]], badgeName, currentTier, currentBonus, nextTier, nextBonus, cost.base, resourceName, goldFormatted, successChance, pityText, nextTier)

	if not canUpgrade then
		player:showTextDialog(badge:getId(), message .. "\n\nYou don't have the required resources!")
		return
	end

	local modal = ModalWindow({
		title = "Badge Upgrade System",
		message = message,
	})

	modal:setDefaultCallback(function(clickedPlayer, button)
		if button.id == 1 then
			BadgeUpgrade.performUpgrade(clickedPlayer, badge, badgeType, currentTier)
		else
			clickedPlayer:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Upgrade cancelled.")
		end
	end)

	modal:addButton("Upgrade")
	modal:addButton("Cancel")

	modal:sendToPlayer(player)
end

-- Perform upgrade
function BadgeUpgrade.performUpgrade(player, badge, badgeType, currentTier)
	local nextTier = currentTier + 1
	local cost = BadgeUpgrade.COSTS[nextTier]
	local resourceId = BadgeUpgrade.RESOURCES[badgeType]

	-- Validate resources again
	if player:getItemCount(resourceId) < cost.base then
		player:sendCancelMessage("You don't have enough resources.")
		return
	end

	if player:getBankBalance() < cost.gold then
		player:sendCancelMessage("You don't have enough gold in your bank.")
		return
	end

	-- Consume resources
	player:removeItem(resourceId, cost.base)
	player:setBankBalance(player:getBankBalance() - cost.gold)

	-- Calculate success
	local pityKey = "badge_pity_" .. badgeType
	local pityCounter = player:kv():get(pityKey) or 0
	local successChance = cost.chance + (pityCounter * BadgeUpgrade.PITY_BONUS)
	-- Event 08/03/2026: +5% badge upgrade chance
	local today = os.date("%Y-%m-%d")
	if today == "2026-03-08" then
		successChance = successChance + 5
	end
	successChance = math.min(100, successChance)

	local roll = math.random(1, 100)
	local success = roll <= successChance

	-- Get badge ID and parent container
	local badgeId = badge:getId()
	local parent = badge:getParent()

	if success then
		-- SUCCESS
		local newBonus = BadgeUpgrade.calculateBonus(nextTier)

		-- Transform badge in-place to maintain position
		badge:transform(badgeId)
		badge:setTier(nextTier)

		-- Force visual update by refreshing the badge bag scaffold
		if parent and BadgeBag then
			BadgeBag.ensureBadgeBagScaffold(parent, player)
		end

		player:kv():set(pityKey, 0) -- Reset pity
		player:getPosition():sendMagicEffect(CONST_ME_MAGIC_GREEN)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("Success! Your badge is now Tier %d (+%d%% bonus)!", nextTier, newBonus))
	else
		-- FAILURE
		player:getPosition():sendMagicEffect(CONST_ME_BLOCKHIT)

		local currentBonus = BadgeUpgrade.calculateBonus(currentTier)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("Failure! Badge remains at Tier %d (+%d%%).", currentTier, currentBonus))

		-- Increment pity
		player:kv():set(pityKey, pityCounter + 1)
	end
end

return BadgeUpgrade
