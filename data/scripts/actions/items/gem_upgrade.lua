-- Gem Upgrade Action
-- Handles right-click on gem and use with another gem

local gemUpgradeAction = Action()

local function isInGemBag(item)
	local parent = item:getParent()
	if parent.isContainer and parent:isContainer() and parent:getId() == GemBag.config.ITEMID_GEM_BAG then
		return true
	end
	return false
end

function gemUpgradeAction.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if not player or not item or not target then
		return false
	end

	-- Prevent using gem upgrader on badges
	local targetId = target:getId()

	-- Check if target is also a gem
	if not GemBag or not GemBag.isGem(target) then
		player:sendTextMessage(MESSAGE_LOOK, "You can only upgrade using another gem.")
		return false
	end

	-- Check if target is the same item (can't upgrade with itself)
	-- if player:getItemCount(item:getId()) > 2 then
	-- 	player:sendTextMessage(MESSAGE_LOOK, "You need at least two gems to perform an upgrade.")
	-- 	return true
	-- end

	-- Both gems must be outside the Gem Bag
	if isInGemBag(item) or isInGemBag(target) then
		player:sendTextMessage(MESSAGE_LOOK, "Remova ambas as gemas da Gem Bag para fazer upgrade.")
		return true
	end

	-- Show upgrade modal
	return GemUpgrade.showUpgradeModal(player, item, target)
end

-- Register for all gem IDs
local gemIds = {
	-- Momentum Gems (60338-60347)
	60338, 60339, 60340, 60341, 60342, 60343, 60344, 60345, 60346, 60347,
	-- Onslaught Gems (60348-60357)
	60348, 60349, 60350, 60351, 60352, 60353, 60354, 60355, 60356, 60357,
	-- Transcendence Gems (60358-60367)
	60358, 60359, 60360, 60361, 60362, 60363, 60364, 60365, 60366, 60367,
	-- Ruse Gems (60368-60377)
	60368, 60369, 60370, 60371, 60372, 60373, 60374, 60375, 60376, 60377,
	-- Death Gems (60167-60176)
	60167, 60168, 60169, 60170, 60171, 60172, 60173, 60174, 60175, 60176,
	-- Energy Gems (60177-60186)
	60177, 60178, 60179, 60180, 60181, 60182, 60183, 60184, 60185, 60186,
	-- Fire Gems (60187-60196)
	60187, 60188, 60189, 60190, 60191, 60192, 60193, 60194, 60195, 60196,
	-- Holy Gems (60197-60206)
	60197, 60198, 60199, 60200, 60201, 60202, 60203, 60204, 60205, 60206,
	-- Ice Gems (60207-60216)
	60207, 60208, 60209, 60210, 60211, 60212, 60213, 60214, 60215, 60216,
	-- Physical Gems (60217-60226)
	60217, 60218, 60219, 60220, 60221, 60222, 60223, 60224, 60225, 60226,
	-- Earth Gems (60227-60166)
	60227, 60228, 60229, 60230, 60231, 60232, 60233, 60234, 60235, 60166,
}

-- Register each gem ID individually (Lua 5.1 compatible)
for _, gemId in ipairs(gemIds) do
	gemUpgradeAction:id(gemId)
end

gemUpgradeAction:register()
