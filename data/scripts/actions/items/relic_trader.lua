local relicTrader = Action()

function relicTrader.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if not player then
		return false
	end

	if not target or not target:isItem() then
		player:sendCancelMessage("Use this on a relic to trade it up.")
		return true
	end

	-- Prevent using on itself or other altar tools
	local targetId = target:getId()
	for _, toolId in ipairs(RelicSystem.ALTAR_TOOL_IDS) do
		if targetId == toolId then
			player:sendCancelMessage("Use this on a relic to trade it up.")
			return true
		end
	end

	return RelicAltar.handleTradeUp(player, target)
end

relicTrader:id(RelicSystem.ALTAR_TRADER)
relicTrader:register()
