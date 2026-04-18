local relicRevealer = Action()

function relicRevealer.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if not player then
		return false
	end

	-- Target must be an Unrevealed Relic
	if not target or not target:isItem() or target:getId() ~= RelicSystem.UNREVEALED_RELIC then
		player:sendCancelMessage("Use this on an Unrevealed Relic.")
		return false
	end

	-- Show reveal modal
	RelicReveal.showRevealModal(player, target, item)
	return true
end

-- Register for Relic Revealer item
relicRevealer:id(RelicSystem.RELIC_REVEALER)
relicRevealer:register()
