RelicReveal = {}

-- Revelation chances
RelicReveal.CHANCES = {
	normal = {
		common = 70,
		rare = 25,
		legendary = 5,
	},
	enhanced = {
		common = 40,
		rare = 40,
		legendary = 20,
	},
}

-- Roll a rarity based on chances
function RelicReveal.rollRarity(useEnhancement)
	local chances = useEnhancement and RelicReveal.CHANCES.enhanced or RelicReveal.CHANCES.normal
	local roll = math.random(1, 100)

	if roll <= chances.legendary then
		return "legendary"
	elseif roll <= chances.legendary + chances.rare then
		return "rare"
	else
		return "common"
	end
end

-- Roll a random type
function RelicReveal.rollType()
	local types = RelicSystem.TYPES
	return types[math.random(1, #types)]
end

-- Roll a random bonus for a given type
function RelicReveal.rollBonus(rtype)
	local bonuses = RelicSystem.BONUSES[rtype]
	if not bonuses or #bonuses == 0 then
		return nil
	end
	return bonuses[math.random(1, #bonuses)]
end

-- Show reveal modal
function RelicReveal.showRevealModal(player, gem, revealer)
	local hasEnhancement = player:getItemCount(RelicSystem.RELIC_REVEAL_ENHANCEMENT) > 0

	local confirmKey = "relic_reveal_" .. player:getId()
	if not _G.RelicRevealConfirmations then
		_G.RelicRevealConfirmations = {}
	end

	_G.RelicRevealConfirmations[confirmKey] = {
		gem = gem,
		revealer = revealer,
	}

	if hasEnhancement then
		local message = [[Reveal Relic

You have a Relic Reveal Enhancement in your inventory.

Normal chances:
- Common: 70%
- Rare: 25%
- Legendary: 5%

Enhanced chances:
- Common: 40%
- Rare: 40%
- Legendary: 20%

The Enhancement will be consumed if used.]]

		local modal = ModalWindow({
			title = "Relic Revelation",
			message = message,
		})

		modal:addButton("Use Enhancement")
		modal:addButton("Reveal Normal")
		modal:addButton("Cancel")
		modal:setDefaultEnterButton(1)
		modal:setDefaultEscapeButton(3)

		modal:setDefaultCallback(function(clickedPlayer, button)
			local data = _G.RelicRevealConfirmations[confirmKey]
			if not data then
				return
			end

			if button.id == 1 then
				RelicReveal.performReveal(clickedPlayer, data.gem, data.revealer, true)
			elseif button.id == 2 then
				RelicReveal.performReveal(clickedPlayer, data.gem, data.revealer, false)
			else
				clickedPlayer:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Revelation cancelled.")
			end
			_G.RelicRevealConfirmations[confirmKey] = nil
		end)

		modal:sendToPlayer(player)
	else
		local message = [[Reveal Relic

Chances:
- Common: 70%
- Rare: 25%
- Legendary: 5%

The Unrevealed Relic will be consumed.
Proceed?]]

		local modal = ModalWindow({
			title = "Relic Revelation",
			message = message,
		})

		modal:addButton("Reveal")
		modal:addButton("Cancel")
		modal:setDefaultEnterButton(1)
		modal:setDefaultEscapeButton(2)

		modal:setDefaultCallback(function(clickedPlayer, button)
			local data = _G.RelicRevealConfirmations[confirmKey]
			if not data then
				return
			end

			if button.id == 1 then
				RelicReveal.performReveal(clickedPlayer, data.gem, data.revealer, false)
			else
				clickedPlayer:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Revelation cancelled.")
			end
			_G.RelicRevealConfirmations[confirmKey] = nil
		end)

		modal:sendToPlayer(player)
	end
end

-- Perform the reveal
function RelicReveal.performReveal(player, gem, revealer, useEnhancement)
	-- Validate items still exist
	if not gem or not revealer then
		player:sendCancelMessage("Item not found.")
		return false
	end

	-- Consume enhancement if used
	if useEnhancement then
		if player:getItemCount(RelicSystem.RELIC_REVEAL_ENHANCEMENT) < 1 then
			player:sendCancelMessage("You no longer have a Relic Reveal Enhancement.")
			return false
		end
		player:removeItem(RelicSystem.RELIC_REVEAL_ENHANCEMENT, 1)
	end

	-- Roll relic properties
	local rarity = RelicReveal.rollRarity(useEnhancement)
	local rtype = RelicReveal.rollType()
	local bonus = RelicReveal.rollBonus(rtype)

	if not bonus then
		player:sendCancelMessage("Error: could not determine relic bonus.")
		return false
	end

	-- Get the correct item ID for this rarity+type
	local relicItemId = RelicSystem.getRelicItemId(rarity, rtype)
	if not relicItemId then
		player:sendCancelMessage("Error: invalid relic configuration.")
		return false
	end

	-- Create relic, set all attributes BEFORE adding to inventory
	-- This ensures the client sees tier 1 from the start
	local relic = Game.createItem(relicItemId, 1)
	if not relic then
		player:sendCancelMessage("Error: could not create relic.")
		return false
	end

	RelicSystem.setRelicData(relic, rarity, rtype, bonus.id, 1)
	relic:setTier(1)
	RelicSystem.updateRelicName(relic)

	-- Try to add to store inbox (guarantees delivery + correct tier visual)
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

	-- Consume the unrevealed relic and revealer after new relic is safely created
	gem:remove(1)
	revealer:remove(1)

	-- Visual effects and message
	local rarityName = rarity:sub(1, 1):upper() .. rarity:sub(2)
	local typeName = rtype:sub(1, 1):upper() .. rtype:sub(2)
	local value = RelicSystem.getBonusValue(rarity, 1)

	player:getPosition():sendMagicEffect(CONST_ME_MAGIC_GREEN)
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format(
		"You revealed a %s %s Relic!\nBonus: %s +%d%%\nCheck your store inbox.",
		rarityName, typeName, bonus.name, value
	))

	return true
end

return RelicReveal
