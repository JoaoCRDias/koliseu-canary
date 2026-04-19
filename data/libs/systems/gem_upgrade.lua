-- Gem Upgrade System
GemUpgrade = GemUpgrade or {}

-- Configuration
GemUpgrade.config = {
	-- Progression from tier 1 (100%) to tier 9 (30%)
	-- Linear decrease: (100 - 30) / (9 - 1) = 8.75% per tier
	SUCCESS_CHANCE = {
		[1] = 50, -- tier 1 -> 2
		[2] = 45, -- tier 2 -> 3
		[3] = 40, -- tier 3 -> 4
		[4] = 35, -- tier 4 -> 5
		[5] = 25, -- tier 5 -> 6
		[6] = 20, -- tier 6 -> 7
		[7] = 15, -- tier 7 -> 8
		[8] = 10, -- tier 8 -> 9
		[9] = 5, -- tier 9 -> 10
	},

	-- Exponential cost progression: 2kk, 4kk, 8kk, 16kk, 32kk, 64kk, 128kk, 256kk, 512kk
	UPGRADE_COST = {
		[1] = 2000000, -- 2kk
		[2] = 4000000, -- 4kk
		[3] = 8000000, -- 8kk
		[4] = 16000000, -- 16kk
		[5] = 32000000, -- 32kk
		[6] = 64000000, -- 64kk
		[7] = 128000000, -- 128kk
		[8] = 256000000, -- 256kk
		[9] = 512000000, -- 512kk
	},
}

-- Gem type groups (gems of same type that can be upgraded together)
-- Format: [base_id] = { start_id, gem_type_name }
GemUpgrade.gemTypes = {
	-- Upgrade Momentum Gems (60338-41703)
	[60338] = { baseId = 60338, name = "Momentum Gem", maxTier = 10 },
	[60339] = { baseId = 60338, name = "Momentum Gem", maxTier = 10 },
	[60340] = { baseId = 60338, name = "Momentum Gem", maxTier = 10 },
	[60341] = { baseId = 60338, name = "Momentum Gem", maxTier = 10 },
	[60342] = { baseId = 60338, name = "Momentum Gem", maxTier = 10 },
	[60343] = { baseId = 60338, name = "Momentum Gem", maxTier = 10 },
	[60344] = { baseId = 60338, name = "Momentum Gem", maxTier = 10 },
	[60345] = { baseId = 60338, name = "Momentum Gem", maxTier = 10 },
	[60346] = { baseId = 60338, name = "Momentum Gem", maxTier = 10 },
	[60347] = { baseId = 60338, name = "Momentum Gem", maxTier = 10 },

	-- Upgrade Onslaught Gems (60348-60357)
	[60348] = { baseId = 60348, name = "Onslaught Gem", maxTier = 10 },
	[60349] = { baseId = 60348, name = "Onslaught Gem", maxTier = 10 },
	[60350] = { baseId = 60348, name = "Onslaught Gem", maxTier = 10 },
	[60351] = { baseId = 60348, name = "Onslaught Gem", maxTier = 10 },
	[60352] = { baseId = 60348, name = "Onslaught Gem", maxTier = 10 },
	[60353] = { baseId = 60348, name = "Onslaught Gem", maxTier = 10 },
	[60354] = { baseId = 60348, name = "Onslaught Gem", maxTier = 10 },
	[60355] = { baseId = 60348, name = "Onslaught Gem", maxTier = 10 },
	[60356] = { baseId = 60348, name = "Onslaught Gem", maxTier = 10 },
	[60357] = { baseId = 60348, name = "Onslaught Gem", maxTier = 10 },

	-- Upgrade Transcendence Gems (60358-41723)
	[60358] = { baseId = 60358, name = "Transcendence Gem", maxTier = 10 },
	[60359] = { baseId = 60358, name = "Transcendence Gem", maxTier = 10 },
	[60360] = { baseId = 60358, name = "Transcendence Gem", maxTier = 10 },
	[60361] = { baseId = 60358, name = "Transcendence Gem", maxTier = 10 },
	[60362] = { baseId = 60358, name = "Transcendence Gem", maxTier = 10 },
	[60363] = { baseId = 60358, name = "Transcendence Gem", maxTier = 10 },
	[60364] = { baseId = 60358, name = "Transcendence Gem", maxTier = 10 },
	[60365] = { baseId = 60358, name = "Transcendence Gem", maxTier = 10 },
	[60366] = { baseId = 60358, name = "Transcendence Gem", maxTier = 10 },
	[60367] = { baseId = 60358, name = "Transcendence Gem", maxTier = 10 },

	-- Upgrade Ruse Gems (60368-41733)
	[60368] = { baseId = 60368, name = "Ruse Gem", maxTier = 10 },
	[60369] = { baseId = 60368, name = "Ruse Gem", maxTier = 10 },
	[60370] = { baseId = 60368, name = "Ruse Gem", maxTier = 10 },
	[60371] = { baseId = 60368, name = "Ruse Gem", maxTier = 10 },
	[60372] = { baseId = 60368, name = "Ruse Gem", maxTier = 10 },
	[60373] = { baseId = 60368, name = "Ruse Gem", maxTier = 10 },
	[60374] = { baseId = 60368, name = "Ruse Gem", maxTier = 10 },
	[60375] = { baseId = 60368, name = "Ruse Gem", maxTier = 10 },
	[60376] = { baseId = 60368, name = "Ruse Gem", maxTier = 10 },
	[60377] = { baseId = 60368, name = "Ruse Gem", maxTier = 10 },

	-- Death Gems (60167-61013)
	[60167] = { baseId = 60167, name = "Death Gem", maxTier = 10 },
	[60168] = { baseId = 60167, name = "Death Gem", maxTier = 10 },
	[60169] = { baseId = 60167, name = "Death Gem", maxTier = 10 },
	[60170] = { baseId = 60167, name = "Death Gem", maxTier = 10 },
	[60171] = { baseId = 60167, name = "Death Gem", maxTier = 10 },
	[60172] = { baseId = 60167, name = "Death Gem", maxTier = 10 },
	[60173] = { baseId = 60167, name = "Death Gem", maxTier = 10 },
	[60174] = { baseId = 60167, name = "Death Gem", maxTier = 10 },
	[60175] = { baseId = 60167, name = "Death Gem", maxTier = 10 },
	[60176] = { baseId = 60167, name = "Death Gem", maxTier = 10 },

	-- Energy Gems (60177-61023)
	[60177] = { baseId = 60177, name = "Energy Gem", maxTier = 10 },
	[60178] = { baseId = 60177, name = "Energy Gem", maxTier = 10 },
	[60179] = { baseId = 60177, name = "Energy Gem", maxTier = 10 },
	[60180] = { baseId = 60177, name = "Energy Gem", maxTier = 10 },
	[60181] = { baseId = 60177, name = "Energy Gem", maxTier = 10 },
	[60182] = { baseId = 60177, name = "Energy Gem", maxTier = 10 },
	[60183] = { baseId = 60177, name = "Energy Gem", maxTier = 10 },
	[60184] = { baseId = 60177, name = "Energy Gem", maxTier = 10 },
	[60185] = { baseId = 60177, name = "Energy Gem", maxTier = 10 },
	[60186] = { baseId = 60177, name = "Energy Gem", maxTier = 10 },

	-- Fire Gems (60187-61033)
	[60187] = { baseId = 60187, name = "Fire Gem", maxTier = 10 },
	[60188] = { baseId = 60187, name = "Fire Gem", maxTier = 10 },
	[60189] = { baseId = 60187, name = "Fire Gem", maxTier = 10 },
	[60190] = { baseId = 60187, name = "Fire Gem", maxTier = 10 },
	[60191] = { baseId = 60187, name = "Fire Gem", maxTier = 10 },
	[60192] = { baseId = 60187, name = "Fire Gem", maxTier = 10 },
	[60193] = { baseId = 60187, name = "Fire Gem", maxTier = 10 },
	[60194] = { baseId = 60187, name = "Fire Gem", maxTier = 10 },
	[60195] = { baseId = 60187, name = "Fire Gem", maxTier = 10 },
	[60196] = { baseId = 60187, name = "Fire Gem", maxTier = 10 },

	-- Holy Gems (60197-61043)
	[60197] = { baseId = 60197, name = "Holy Gem", maxTier = 10 },
	[60198] = { baseId = 60197, name = "Holy Gem", maxTier = 10 },
	[60199] = { baseId = 60197, name = "Holy Gem", maxTier = 10 },
	[60200] = { baseId = 60197, name = "Holy Gem", maxTier = 10 },
	[60201] = { baseId = 60197, name = "Holy Gem", maxTier = 10 },
	[60202] = { baseId = 60197, name = "Holy Gem", maxTier = 10 },
	[60203] = { baseId = 60197, name = "Holy Gem", maxTier = 10 },
	[60204] = { baseId = 60197, name = "Holy Gem", maxTier = 10 },
	[60205] = { baseId = 60197, name = "Holy Gem", maxTier = 10 },
	[60206] = { baseId = 60197, name = "Holy Gem", maxTier = 10 },

	-- Ice Gems (60207-61053)
	[60207] = { baseId = 60207, name = "Ice Gem", maxTier = 10 },
	[60208] = { baseId = 60207, name = "Ice Gem", maxTier = 10 },
	[60209] = { baseId = 60207, name = "Ice Gem", maxTier = 10 },
	[60210] = { baseId = 60207, name = "Ice Gem", maxTier = 10 },
	[60211] = { baseId = 60207, name = "Ice Gem", maxTier = 10 },
	[60212] = { baseId = 60207, name = "Ice Gem", maxTier = 10 },
	[60213] = { baseId = 60207, name = "Ice Gem", maxTier = 10 },
	[60214] = { baseId = 60207, name = "Ice Gem", maxTier = 10 },
	[60215] = { baseId = 60207, name = "Ice Gem", maxTier = 10 },
	[60216] = { baseId = 60207, name = "Ice Gem", maxTier = 10 },

	-- Physical Gems (60217-61063)
	[60217] = { baseId = 60217, name = "Physical Gem", maxTier = 10 },
	[60218] = { baseId = 60217, name = "Physical Gem", maxTier = 10 },
	[60219] = { baseId = 60217, name = "Physical Gem", maxTier = 10 },
	[60220] = { baseId = 60217, name = "Physical Gem", maxTier = 10 },
	[60221] = { baseId = 60217, name = "Physical Gem", maxTier = 10 },
	[60222] = { baseId = 60217, name = "Physical Gem", maxTier = 10 },
	[60223] = { baseId = 60217, name = "Physical Gem", maxTier = 10 },
	[60224] = { baseId = 60217, name = "Physical Gem", maxTier = 10 },
	[60225] = { baseId = 60217, name = "Physical Gem", maxTier = 10 },
	[60226] = { baseId = 60217, name = "Physical Gem", maxTier = 10 },

	-- Earth Gems (60227-61073)
	[60227] = { baseId = 60227, name = "Earth Gem", maxTier = 10 },
	[60228] = { baseId = 60227, name = "Earth Gem", maxTier = 10 },
	[60229] = { baseId = 60227, name = "Earth Gem", maxTier = 10 },
	[60230] = { baseId = 60227, name = "Earth Gem", maxTier = 10 },
	[60231] = { baseId = 60227, name = "Earth Gem", maxTier = 10 },
	[60232] = { baseId = 60227, name = "Earth Gem", maxTier = 10 },
	[60233] = { baseId = 60227, name = "Earth Gem", maxTier = 10 },
	[60234] = { baseId = 60227, name = "Earth Gem", maxTier = 10 },
	[60235] = { baseId = 60227, name = "Earth Gem", maxTier = 10 },
	[60166] = { baseId = 60227, name = "Earth Gem", maxTier = 10 },
}

-- Get gem tier from item ID
function GemUpgrade.getGemTier(itemId)
	local gemInfo = GemUpgrade.gemTypes[itemId]
	if not gemInfo then
		return nil
	end

	-- Calculate tier based on offset from base ID
	local tier = (itemId - gemInfo.baseId) + 1
	return tier
end

-- Get next tier gem ID
function GemUpgrade.getNextTierGemId(itemId)
	local tier = GemUpgrade.getGemTier(itemId)
	if not tier then
		return nil
	end

	local gemInfo = GemUpgrade.gemTypes[itemId]
	if not gemInfo or tier >= gemInfo.maxTier then
		return nil -- Already max tier
	end

	return itemId + 1
end

-- Check if two gems are the same type
function GemUpgrade.areSameType(itemId1, itemId2)
	local info1 = GemUpgrade.gemTypes[itemId1]
	local info2 = GemUpgrade.gemTypes[itemId2]

	if not info1 or not info2 then
		return false
	end

	return info1.baseId == info2.baseId
end

-- Format gold amount for display
function GemUpgrade.formatGold(amount)
	if amount >= 1000000 then
		return string.format("%.1fkk", amount / 1000000)
	elseif amount >= 1000 then
		return string.format("%.1fk", amount / 1000)
	else
		return tostring(amount)
	end
end

-- Show upgrade confirmation modal
-- Supports both: single stacked gem (count >= 2) OR two separate gems of same type/tier
function GemUpgrade.showUpgradeModal(player, sourceGem, targetGem)
	local sourceId = sourceGem:getId()
	local sourceCount = sourceGem:getCount()

	-- Check if using a single stacked gem (targetGem is nil or same as sourceGem)
	local usingSingleStack = (targetGem == nil or targetGem == sourceGem)

	if usingSingleStack then
		-- Single stack mode: need at least 2 gems in the stack
		if sourceCount < 2 then
			player:sendCancelMessage("Voce precisa de pelo menos 2 gemas no stack para fazer upgrade.")
			return false
		end
	else
		-- Two separate gems mode: validate they are same type and tier
		local targetId = targetGem:getId()

		if not GemUpgrade.areSameType(sourceId, targetId) then
			player:sendCancelMessage("As gemas devem ser do mesmo tipo para fazer upgrade.")
			return false
		end

		local sourceTier = GemUpgrade.getGemTier(sourceId)
		local targetTier = GemUpgrade.getGemTier(targetId)

		if sourceTier ~= targetTier then
			player:sendCancelMessage("As gemas devem ser do mesmo tier para fazer upgrade.")
			return false
		end
	end

	local sourceTier = GemUpgrade.getGemTier(sourceId)

	-- Check if can upgrade (not max tier)
	local nextTierId = GemUpgrade.getNextTierGemId(sourceId)
	if not nextTierId then
		player:sendCancelMessage("Esta gema ja esta no tier maximo.")
		return false
	end



	-- Get upgrade info
	local successChance = GemUpgrade.config.SUCCESS_CHANCE[sourceTier] or 0
	local upgradeCost = GemUpgrade.config.UPGRADE_COST[sourceTier] or 0
	local gemInfo = GemUpgrade.gemTypes[sourceId]

	-- Event 06-07/03/2026: +10% gem fusion chance
	local today = os.date("%Y-%m-%d")
	if today == "2026-03-06" or today == "2026-03-07" then
		successChance = math.min(100, successChance + 10)
	end

	-- Create modal window
	local modal = ModalWindow({
		title = "Gem Upgrade",
		message = string.format(
			"Upgrade %s\n\n" ..
			"2x %s Tier %d -> 1x %s Tier %d\n\n" ..
			"Success Chance: %.2f%%\n" ..
			"Cost: %s gold coins\n\n" ..
			"SUCCESS: 2 gemas sao consumidas e voce recebe 1 gema Tier %d\n" ..
			"FAILURE: 1 gema e destruida e o dinheiro e gasto",
			gemInfo.name,
			gemInfo.name,
			sourceTier,
			gemInfo.name,
			sourceTier + 1,
			successChance,
			GemUpgrade.formatGold(upgradeCost),
			sourceTier + 1
		),
	})

	-- Use default callback to handle button clicks
	modal:setDefaultCallback(function(clickedPlayer, button, choice)
		if button.id == 1 then
			-- Button "Confirm" clicked
			GemUpgrade.performUpgrade(clickedPlayer, sourceGem, targetGem, upgradeCost, successChance, nextTierId, usingSingleStack)
		else
			-- Button "Cancel" clicked or window closed
			clickedPlayer:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Upgrade cancelado.")
		end
	end)

	-- Add buttons (without individual callbacks)
	modal:addButton("Confirm")
	modal:addButton("Cancel")

	modal:setDefaultEnterButton(1)
	modal:setDefaultEscapeButton(2)

	modal:sendToPlayer(player)
	return true
end

-- Perform the gem upgrade
-- usingSingleStack: true if upgrading from a single stacked gem, false if using two separate gems
function GemUpgrade.performUpgrade(player, sourceGem, targetGem, cost, successChance, nextTierId, usingSingleStack)
	-- Validate source gem still exists
	if not sourceGem then
		player:sendCancelMessage("A gema nao foi encontrada.")
		return false
	end

	-- Validate based on upgrade mode
	if usingSingleStack then
		-- Single stack mode: need at least 2 in the stack
		local currentCount = sourceGem:getCount()
		if currentCount < 2 then
			player:sendCancelMessage("Voce precisa de pelo menos 2 gemas no stack para fazer upgrade.")
			return false
		end
	else
		-- Two separate gems mode: validate target exists
		if not targetGem then
			player:sendCancelMessage("A segunda gema nao foi encontrada.")
			return false
		end
	end

	-- Check if player has enough money (bank + inventory)
	local totalMoney = player:getMoney() + player:getBankBalance()
	if totalMoney < cost then
		player:sendCancelMessage("Voce nao tem dinheiro suficiente.")
		return false
	end

	-- Remove money from bank (and inventory if needed)
	if not player:removeMoneyBank(cost) then
		player:sendCancelMessage("Erro ao remover dinheiro.")
		return false
	end

	-- Roll for success
	local roll = math.random(1, 10000) / 100 -- Generate random number with 2 decimal places
	local success = roll <= successChance

	if success then
		-- SUCCESS: Remove 2 gems and create new tier gem
		local pos = player:getPosition()

		if usingSingleStack then
			-- Remove 2 from the stack
			sourceGem:remove(2)
		else
			-- Remove both separate gems
			sourceGem:remove(1)
			targetGem:remove(1)
		end

		-- Add new gem directly to player's backpack
		local newGem = player:addItem(nextTierId, 1)
		if newGem then
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Upgrade bem sucedido!")
			pos:sendMagicEffect(CONST_ME_FIREWORK_YELLOW)
		else
			player:sendCancelMessage("Erro ao criar a nova gema. Dinheiro reembolsado.")
			-- Refund money since we couldn't create the gem
			player:setBankBalance(player:getBankBalance() + cost)
		end
	else
		-- FAILURE: Remove 1 gem
		if usingSingleStack then
			-- Remove 1 from the stack
			sourceGem:remove(1)
		else
			-- Randomly choose which separate gem to remove
			local gemToRemove = math.random(1, 2) == 1 and sourceGem or targetGem
			gemToRemove:remove(1)
		end

		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Upgrade falhou! Uma gema foi destruida.")
		player:getPosition():sendMagicEffect(CONST_ME_POFF)
	end

	-- Invalidate gem bag cache if using gem bag system
	if GemBag and GemBag.invalidateCache then
		GemBag.invalidateCache(player)
		if GemBag.applyStatBonuses then
			GemBag.applyStatBonuses(player)
		end
	end

	return true
end

return GemUpgrade
