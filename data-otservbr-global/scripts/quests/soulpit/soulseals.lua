local soulSealsAction = Action()

function soulSealsAction.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if not target or not target:isPlayer() then
		return false
	end

	if target:getId() ~= player:getId() then
		return false
	end

	player:sendSoulSealsWindow()
	return true
end

soulSealsAction:id(SoulPit.obeliskInactive)
soulSealsAction:register()
