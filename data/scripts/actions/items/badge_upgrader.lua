local badgeUpgrader = Action()

function badgeUpgrader.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if not player then
		return false
	end

	-- Validate target is a badge
	if not target or not BadgeBag.isBadge(target) then
		player:sendCancelMessage("Use this on a badge to upgrade it.")
		return false
	end

	-- Validate badge is not at max tier
	local currentTier = target:getTier()
	if currentTier >= 10 then
		player:sendCancelMessage("This badge is already at maximum tier.")
		return false
	end

	-- Get badge type
	local badgeType = BadgeBag.getBadgeType(target)
	if not badgeType then
		player:sendCancelMessage("Invalid badge.")
		return false
	end

	-- Show upgrade modal
	BadgeUpgrade.showModal(player, target, badgeType, currentTier)
	return true
end

-- Register for badge upgrader item
badgeUpgrader:id(60477)
badgeUpgrader:register()
