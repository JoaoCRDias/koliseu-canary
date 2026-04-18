local relicSacrificer = Action()

function relicSacrificer.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if not player then
		return false
	end

	if not target or not target:isItem() then
		player:sendCancelMessage("Use this on a relic to sacrifice it.")
		return true
	end

	-- Prevent using on itself or other altar tools
	local targetId = target:getId()
	for _, toolId in ipairs(RelicSystem.ALTAR_TOOL_IDS) do
		if targetId == toolId then
			player:sendCancelMessage("Use this on a relic to sacrifice it.")
			return true
		end
	end

	return RelicAltar.handleSacrifice(player, target)
end

relicSacrificer:id(RelicSystem.ALTAR_SACRIFICER)
relicSacrificer:register()
