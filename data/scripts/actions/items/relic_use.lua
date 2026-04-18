local relicUse = Action()

function relicUse.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if not player then
		return false
	end

	-- Show relic info
	local data = RelicSystem.getRelicData(item)
	if not data then
		player:sendCancelMessage("This relic has no data.")
		return true
	end

	local bonus = RelicSystem.getBonusDefinition(data.bonusId)
	local bonusName = bonus and bonus.name or data.bonusId
	local value = RelicSystem.getBonusValue(data.rarity, data.tier)
	local rarityName = data.rarity:sub(1, 1):upper() .. data.rarity:sub(2)
	local typeName = data.type:sub(1, 1):upper() .. data.type:sub(2)

	local info = string.format(
		"Rarity: %s\nType: %s\nBonus: %s +%.1f%%\nTier: %d/%d",
		rarityName, typeName, bonusName, value, data.tier, RelicSystem.MAX_TIER
	)

	player:showTextDialog(item:getId(), info)
	return true
end

-- Register for all relic item IDs
for itemId, _ in pairs(RelicSystem.RELIC_ID_LOOKUP) do
	relicUse:id(itemId)
end
relicUse:register()
