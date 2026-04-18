local relicParchment = Action()

function relicParchment.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if not player then
		return false
	end

	-- Check if this parchment is inside a relic altar container
	local parent = item:getParent()
	if not parent then
		return false
	end

	local parentContainer = Container(parent:getUniqueId())
	if not parentContainer or parentContainer:getId() ~= RelicSystem.RELIC_ALTAR then
		-- Not inside a relic altar, let the engine handle normally
		return false
	end

	RelicAltar.showInfo(player)
	return true
end

relicParchment:id(RelicSystem.ALTAR_PARCHMENT)
relicParchment:register()
