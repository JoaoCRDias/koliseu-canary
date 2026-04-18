-- Badge Bag container action - updates scaffold when opened

local badgeBagAction = Action()

function badgeBagAction.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if not player or not item then
		return false
	end

	-- Get container from the badge bag item
	local container = Container(item:getUniqueId())
	if container then
		-- Ensure scaffold is up to date with current badge tiers
		BadgeBag.ensureBadgeBagScaffold(container, player)
	end

	-- Let the default container opening behavior continue
	return false
end

badgeBagAction:id(60402)
badgeBagAction:register()
