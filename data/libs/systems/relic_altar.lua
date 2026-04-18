RelicAltar = {}

-- ============================================================
-- INFO (Parchment)
-- ============================================================

function RelicAltar.showInfo(player)
	if not player then
		return false
	end

	-- Sacrifice progress
	local commonSacrifices = player:kv():get(RelicSystem.KV_SACRIFICE_COMMON) or 0
	local rareSacrifices = player:kv():get(RelicSystem.KV_SACRIFICE_RARE) or 0

	-- Equipped reliquary info
	local reliquaryInfo = "None equipped"
	local equippedBonuses = {}
	local reliquary = RelicSystem.getEquippedReliquary(player)
	if reliquary then
		reliquaryInfo = reliquary:getName()
		local relics = RelicSystem.getRelicsInReliquary(reliquary)
		for _, relic in ipairs(relics) do
			local data = RelicSystem.getRelicData(relic)
			if data then
				local bonus = RelicSystem.getBonusDefinition(data.bonusId)
				local bonusName = bonus and bonus.name or data.bonusId
				local value = RelicSystem.getBonusValue(data.rarity, data.tier)
				local rarityName = data.rarity:sub(1, 1):upper() .. data.rarity:sub(2)
				table.insert(equippedBonuses, string.format(
					"  %s T%d - %s +%.1f%%", rarityName, data.tier, bonusName, value
				))
			end
		end
	end

	-- Relics in inventory
	local inventoryRelics = RelicSystem.findRelicsInInventory(player)

	-- Count relics by rarity
	local relicCounts = { common = 0, rare = 0, legendary = 0 }
	for _, relic in ipairs(inventoryRelics) do
		local data = RelicSystem.getRelicData(relic)
		if data then
			relicCounts[data.rarity] = (relicCounts[data.rarity] or 0) + 1
		end
	end

	-- Pity counters (only show non-zero)
	local pityLines = {}
	if reliquary then
		local relics = RelicSystem.getRelicsInReliquary(reliquary)
		for _, relic in ipairs(relics) do
			local data = RelicSystem.getRelicData(relic)
			if data then
				local pityKey = "relic_pity_" .. data.bonusId
				local pityCounter = player:kv():get(pityKey) or 0
				if pityCounter > 0 then
					local bonus = RelicSystem.getBonusDefinition(data.bonusId)
					local bonusName = bonus and bonus.name or data.bonusId
					table.insert(pityLines, string.format(
						"  %s: %d fails (+%d%%)", bonusName, pityCounter, pityCounter * RelicSystem.PITY_BONUS
					))
				end
			end
		end
	end

	-- Build message
	local message = "=== Relic Altar ===\n\n"

	message = message .. "-- Sacrifice Progress --\n"
	message = message .. string.format("Common: %d/%d", commonSacrifices, RelicSystem.SACRIFICE_REQUIRED.common)
	if commonSacrifices >= RelicSystem.SACRIFICE_REQUIRED.common then
		message = message .. " (READY for Rare trade-up!)"
	end
	message = message .. "\n"
	message = message .. string.format("Rare: %d/%d", rareSacrifices, RelicSystem.SACRIFICE_REQUIRED.rare)
	if rareSacrifices >= RelicSystem.SACRIFICE_REQUIRED.rare then
		message = message .. " (READY for Legendary trade-up!)"
	end
	message = message .. "\n\n"

	message = message .. "-- Equipped Reliquary --\n"
	message = message .. reliquaryInfo .. "\n"
	if #equippedBonuses > 0 then
		message = message .. "Active bonuses:\n"
		for _, line in ipairs(equippedBonuses) do
			message = message .. line .. "\n"
		end
	elseif reliquary then
		message = message .. "No relics inside.\n"
	end
	message = message .. "\n"

	message = message .. "-- Relics in Inventory --\n"
	message = message .. string.format("Common: %d | Rare: %d | Legendary: %d\n\n",
		relicCounts.common, relicCounts.rare, relicCounts.legendary
	)

	if #pityLines > 0 then
		message = message .. "-- Upgrade Pity Bonus --\n"
		for _, line in ipairs(pityLines) do
			message = message .. line .. "\n"
		end
		message = message .. "\n"
	end

	message = message .. "-- Upgrade Costs --\n"
	for tier = 1, RelicSystem.MAX_TIER - 1 do
		local cost = RelicSystem.UPGRADE_COSTS[tier]
		if cost then
			message = message .. string.format("T%d -> T%d: %s gold (%d%% base chance)\n",
				tier, tier + 1, RelicSystem.formatGold(cost.gold), cost.chance
			)
		end
	end

	local modal = ModalWindow({
		title = "Relic Altar - Information",
		message = message,
	})

	modal:addButton("Close")
	modal:setDefaultEnterButton(1)
	modal:setDefaultEscapeButton(1)

	modal:sendToPlayer(player)
	return true
end

-- ============================================================
-- HELPER: Find a relic in player inventory by its attributes
-- ============================================================

function RelicAltar.findRelicByAttributes(player, search)
	local allRelics = RelicSystem.findRelicsInInventory(player)
	for _, relic in ipairs(allRelics) do
		if relic:getId() == search.itemId then
			local data = RelicSystem.getRelicData(relic)
			if data
				and data.rarity == search.rarity
				and data.type == search.type
				and data.bonusId == search.bonusId
				and data.tier == search.tier
			then
				return relic
			end
		end
	end
	return nil
end

-- ============================================================
-- SACRIFICE
-- ============================================================

function RelicAltar.handleSacrifice(player, target)
	if not player or not target then
		return false
	end

	if not target:isItem() then
		player:sendCancelMessage("Use this on a relic to sacrifice it.")
		return false
	end

	if not RelicSystem.isRelic(target) then
		player:sendCancelMessage("This is not a relic.")
		return false
	end

	local data = RelicSystem.getRelicData(target)
	if not data then
		player:sendCancelMessage("Invalid relic.")
		return false
	end

	if data.rarity == "legendary" then
		player:sendCancelMessage("Legendary relics cannot be sacrificed.")
		return false
	end

	-- Show confirmation modal
	local bonus = RelicSystem.getBonusDefinition(data.bonusId)
	local bonusName = bonus and bonus.name or data.bonusId
	local value = RelicSystem.getBonusValue(data.rarity, data.tier)
	local rarityName = data.rarity:sub(1, 1):upper() .. data.rarity:sub(2)

	-- Store relic identifying attributes for re-location in callback
	local relicSearch = {
		itemId = target:getId(),
		rarity = data.rarity,
		type = data.type,
		bonusId = data.bonusId,
		tier = data.tier,
	}

	local message = string.format([[Sacrifice %s %s Relic?

Bonus: %s +%.1f%% (Tier %d)

The relic will be DESTROYED.
This counts towards your trade-up progress.]],
		rarityName, data.type,
		bonusName, value, data.tier
	)

	local modal = ModalWindow({
		title = "Sacrifice Relic",
		message = message,
	})

	modal:addButton("Sacrifice")
	modal:addButton("Cancel")
	modal:setDefaultEnterButton(1)
	modal:setDefaultEscapeButton(2)

	modal:setDefaultCallback(function(clickedPlayer, button)
		if button.id == 1 then
			local relic = RelicAltar.findRelicByAttributes(clickedPlayer, relicSearch)
			if relic then
				RelicAltar.performSacrifice(clickedPlayer, relic)
			else
				clickedPlayer:sendCancelMessage("Relic no longer exists in your inventory.")
			end
		else
			clickedPlayer:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Sacrifice cancelled.")
		end
	end)

	modal:sendToPlayer(player)
	return true
end

function RelicAltar.performSacrifice(player, relic)
	if not relic or not RelicSystem.isRelic(relic) then
		player:sendCancelMessage("Invalid relic.")
		return false
	end

	local data = RelicSystem.getRelicData(relic)
	if not data then
		player:sendCancelMessage("Invalid relic data.")
		return false
	end

	local rarity = data.rarity
	local kvKey
	if rarity == "common" then
		kvKey = RelicSystem.KV_SACRIFICE_COMMON
	elseif rarity == "rare" then
		kvKey = RelicSystem.KV_SACRIFICE_RARE
	else
		player:sendCancelMessage("Legendary relics cannot be sacrificed.")
		return false
	end

	-- Destroy the relic
	relic:remove()

	-- Increment counter
	local current = player:kv():get(kvKey) or 0
	player:kv():set(kvKey, current + 1)

	local required = RelicSystem.SACRIFICE_REQUIRED[rarity]
	local newCount = current + 1
	local targetRarity = rarity == "common" and "Rare" or "Legendary"

	player:getPosition():sendMagicEffect(CONST_ME_MAGIC_RED)
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format(
		"Relic sacrificed! Progress: %d/%d towards %s trade-up.",
		newCount, required, targetRarity
	))

	-- Recalculate bonuses in case relic was inside equipped reliquary
	if RelicBonus then
		RelicBonus.recalculateBonuses(player)
	end

	return true
end

-- ============================================================
-- UPGRADE
-- ============================================================

function RelicAltar.handleUpgrade(player, target)
	if not player or not target then
		return false
	end

	if not target:isItem() then
		player:sendCancelMessage("Use this on a relic to upgrade it.")
		return false
	end

	if not RelicSystem.isRelic(target) then
		player:sendCancelMessage("This is not a relic.")
		return false
	end

	local data = RelicSystem.getRelicData(target)
	if not data then
		player:sendCancelMessage("Invalid relic.")
		return false
	end

	local currentTier = data.tier
	local cost = RelicSystem.UPGRADE_COSTS[currentTier]
	if not cost then
		player:sendCancelMessage("This relic is already at maximum tier.")
		return false
	end

	-- Show upgrade confirmation modal
	local bonus = RelicSystem.getBonusDefinition(data.bonusId)
	local bonusName = bonus and bonus.name or data.bonusId
	local currentValue = RelicSystem.getBonusValue(data.rarity, currentTier)
	local nextTier = currentTier + 1
	local nextValue = RelicSystem.getBonusValue(data.rarity, nextTier)
	local rarityName = data.rarity:sub(1, 1):upper() .. data.rarity:sub(2)

	-- Calculate pity
	local pityKey = "relic_pity_" .. data.bonusId
	local pityCounter = player:kv():get(pityKey) or 0
	local successChance = math.min(100, cost.chance + (pityCounter * RelicSystem.PITY_BONUS))

	local bankBalance = player:getBankBalance()
	local hasGold = bankBalance >= cost.gold

	local pityText = ""
	if pityCounter > 0 then
		pityText = string.format(" (Pity: +%d%%)", pityCounter * RelicSystem.PITY_BONUS)
	end

	local message = string.format([[Upgrade %s %s Relic?

Bonus: %s
Current: Tier %d (+%.1f%%)
Target: Tier %d (+%.1f%%)

Gold Cost: %s
Your Bank: %s
Success Chance: %d%%%s

On Failure: Gold consumed, relic stays at Tier %d]],
		rarityName, data.type,
		bonusName,
		currentTier, currentValue,
		nextTier, nextValue,
		RelicSystem.formatGold(cost.gold),
		RelicSystem.formatGold(bankBalance),
		successChance, pityText,
		currentTier
	)

	if not hasGold then
		player:showTextDialog(target:getId(), message .. "\n\nYou don't have enough gold in your bank!")
		return true
	end

	-- Store relic identifying attributes for re-location in callback
	local relicSearch = {
		itemId = target:getId(),
		rarity = data.rarity,
		type = data.type,
		bonusId = data.bonusId,
		tier = data.tier,
	}

	local modal = ModalWindow({
		title = "Upgrade Relic",
		message = message,
	})

	modal:addButton("Upgrade")
	modal:addButton("Cancel")
	modal:setDefaultEnterButton(1)
	modal:setDefaultEscapeButton(2)

	modal:setDefaultCallback(function(clickedPlayer, button)
		if button.id == 1 then
			local relic = RelicAltar.findRelicByAttributes(clickedPlayer, relicSearch)
			if relic then
				RelicAltar.performUpgrade(clickedPlayer, relic)
			else
				clickedPlayer:sendCancelMessage("Relic no longer exists in your inventory.")
			end
		else
			clickedPlayer:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Upgrade cancelled.")
		end
	end)

	modal:sendToPlayer(player)
	return true
end

function RelicAltar.performUpgrade(player, relic)
	if not relic or not RelicSystem.isRelic(relic) then
		player:sendCancelMessage("Invalid relic.")
		return false
	end

	local data = RelicSystem.getRelicData(relic)
	if not data then
		player:sendCancelMessage("Invalid relic data.")
		return false
	end

	local currentTier = data.tier
	local cost = RelicSystem.UPGRADE_COSTS[currentTier]
	if not cost then
		player:sendCancelMessage("This relic is already at maximum tier.")
		return false
	end

	-- Validate gold
	if player:getBankBalance() < cost.gold then
		player:sendCancelMessage("You don't have enough gold in your bank.")
		return false
	end

	-- Consume gold
	player:setBankBalance(player:getBankBalance() - cost.gold)

	-- Calculate success
	local pityKey = "relic_pity_" .. data.bonusId
	local pityCounter = player:kv():get(pityKey) or 0
	local successChance = math.min(100, cost.chance + (pityCounter * RelicSystem.PITY_BONUS))

	local roll = math.random(1, 100)
	local success = roll <= successChance

	if success then
		local newTier = currentTier + 1

		-- Clone relic, apply new tier, move to store inbox (forces client visual update)
		local inbox = player:getStoreInbox()
		if not inbox then
			player:sendCancelMessage("Failed to access store inbox.")
			-- Refund gold since we consumed it above
			player:setBankBalance(player:getBankBalance() + cost.gold)
			return false
		end

		local cloned = relic:clone()
		if not cloned then
			player:sendCancelMessage("Failed to clone relic.")
			player:setBankBalance(player:getBankBalance() + cost.gold)
			return false
		end

		cloned:setCustomAttribute("relic_tier", newTier)
		cloned:setTier(newTier)
		RelicSystem.updateRelicName(cloned)

		local ret = inbox:addItemEx(cloned)
		if ret ~= RETURNVALUE_NOERROR then
			player:sendCancelMessage("Failed to add relic to store inbox. Make sure it is not full.")
			player:setBankBalance(player:getBankBalance() + cost.gold)
			return false
		end

		-- Remove original only after clone is safely in inbox
		relic:remove()

		player:kv():set(pityKey, 0)
		player:getPosition():sendMagicEffect(CONST_ME_MAGIC_GREEN)

		local newValue = RelicSystem.getBonusValue(data.rarity, newTier)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format(
			"Success! Relic upgraded to Tier %d (+%.1f%%)! Check your store inbox.",
			newTier, newValue
		))

		-- Recalculate bonuses (relic moved out of reliquary if it was inside)
		if RelicBonus then
			RelicBonus.recalculateBonuses(player)
		end
	else
		player:kv():set(pityKey, pityCounter + 1)
		player:getPosition():sendMagicEffect(CONST_ME_BLOCKHIT)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format(
			"Upgrade failed! Gold consumed. Relic remains at Tier %d. (Pity: %d)",
			currentTier, pityCounter + 1
		))
	end

	return true
end

-- ============================================================
-- TRADE-UP
-- ============================================================

function RelicAltar.handleTradeUp(player, target)
	if not player or not target then
		return false
	end

	if not target:isItem() then
		player:sendCancelMessage("Use this on a relic to trade it up.")
		return true
	end

	if not RelicSystem.isRelic(target) then
		player:sendCancelMessage("This is not a relic.")
		return true
	end

	local data = RelicSystem.getRelicData(target)
	if not data then
		player:sendCancelMessage("Invalid relic.")
		return true
	end

	local fromRarity = data.rarity
	if fromRarity == "legendary" then
		player:sendCancelMessage("Legendary relics cannot be traded up further.")
		return true
	end

	local kvKey, required, targetRarity
	if fromRarity == "common" then
		kvKey = RelicSystem.KV_SACRIFICE_COMMON
		required = RelicSystem.SACRIFICE_REQUIRED.common
		targetRarity = "rare"
	elseif fromRarity == "rare" then
		kvKey = RelicSystem.KV_SACRIFICE_RARE
		required = RelicSystem.SACRIFICE_REQUIRED.rare
		targetRarity = "legendary"
	end

	local current = player:kv():get(kvKey) or 0
	if current < required then
		player:sendCancelMessage(string.format(
			"Not enough %s sacrifices for trade-up (%d/%d).",
			fromRarity, current, required
		))
		return true
	end

	local bonus = RelicSystem.getBonusDefinition(data.bonusId)
	local bonusName = bonus and bonus.name or data.bonusId
	local value = RelicSystem.getBonusValue(data.rarity, data.tier)
	local rarityName = fromRarity:sub(1, 1):upper() .. fromRarity:sub(2)
	local targetRarityName = targetRarity:sub(1, 1):upper() .. targetRarity:sub(2)

	-- Store relic attributes for re-location in callback
	local relicSearch = {
		itemId = target:getId(),
		rarity = data.rarity,
		type = data.type,
		bonusId = data.bonusId,
		tier = data.tier,
	}

	local message = string.format([[Trade-Up %s Relic -> %s?

This relic will be CONSUMED:
  %s T%d - %s +%.1f%%

Sacrifices used: %d/%d %s

A new %s relic with random type and bonus will be created at Tier 1.
Check your store inbox after trade-up.]],
		rarityName, targetRarityName,
		rarityName, data.tier, bonusName, value,
		required, required, fromRarity,
		targetRarityName
	)

	local modal = ModalWindow({
		title = "Trade-Up Relic",
		message = message,
	})

	modal:addButton("Trade-Up")
	modal:addButton("Cancel")
	modal:setDefaultEnterButton(1)
	modal:setDefaultEscapeButton(2)

	local capturedFromRarity = fromRarity

	modal:setDefaultCallback(function(clickedPlayer, button)
		if button.id == 1 then
			local relic = RelicAltar.findRelicByAttributes(clickedPlayer, relicSearch)
			if relic then
				RelicAltar.performTradeUp(clickedPlayer, capturedFromRarity, relic)
			else
				clickedPlayer:sendCancelMessage("Relic no longer exists in your inventory.")
			end
		else
			clickedPlayer:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Trade-up cancelled.")
		end
	end)

	modal:sendToPlayer(player)
	return true
end

function RelicAltar.performTradeUp(player, fromRarity, sourceRelic)
	local kvKey, required, targetRarity
	if fromRarity == "common" then
		kvKey = RelicSystem.KV_SACRIFICE_COMMON
		required = RelicSystem.SACRIFICE_REQUIRED.common
		targetRarity = "rare"
	elseif fromRarity == "rare" then
		kvKey = RelicSystem.KV_SACRIFICE_RARE
		required = RelicSystem.SACRIFICE_REQUIRED.rare
		targetRarity = "legendary"
	else
		player:sendCancelMessage("Invalid trade-up.")
		return false
	end

	local current = player:kv():get(kvKey) or 0
	if current < required then
		player:sendCancelMessage(string.format("Not enough sacrifices (%d/%d).", current, required))
		return false
	end

	-- Roll new relic properties
	local rtype = RelicReveal.rollType()
	local bonus = RelicReveal.rollBonus(rtype)
	if not bonus then
		player:sendCancelMessage("Error: could not determine relic bonus.")
		return false
	end

	local relicItemId = RelicSystem.getRelicItemId(targetRarity, rtype)
	if not relicItemId then
		player:sendCancelMessage("Error: invalid relic configuration.")
		return false
	end

	-- Create relic with all attributes set BEFORE adding to inventory
	local relic = Game.createItem(relicItemId, 1)
	if not relic then
		player:sendCancelMessage("Error: could not create relic.")
		return false
	end

	RelicSystem.setRelicData(relic, targetRarity, rtype, bonus.id, 1)
	relic:setTier(1)
	RelicSystem.updateRelicName(relic)

	local inbox = player:getStoreInbox()
	if not inbox then
		player:sendCancelMessage("Error: could not access store inbox.")
		return false
	end

	local ret = inbox:addItemEx(relic)
	if ret ~= RETURNVALUE_NOERROR then
		player:sendCancelMessage("Error: store inbox is full.")
		return false
	end

	-- Consume the source relic
	sourceRelic:remove()

	-- Reset sacrifice counter only after relic is safely created
	player:kv():set(kvKey, current - required)

	local targetRarityName = targetRarity:sub(1, 1):upper() .. targetRarity:sub(2)
	local typeName = rtype:sub(1, 1):upper() .. rtype:sub(2)
	local value = RelicSystem.getBonusValue(targetRarity, 1)

	player:getPosition():sendMagicEffect(CONST_ME_MAGIC_GREEN)
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format(
		"Trade-Up successful! You received a %s %s Relic!\nBonus: %s +%.1f%%\nCheck your store inbox.",
		targetRarityName, typeName, bonus.name, value
	))

	-- Recalculate bonuses in case source relic was inside equipped reliquary
	if RelicBonus then
		RelicBonus.recalculateBonuses(player)
	end

	return true
end

return RelicAltar
