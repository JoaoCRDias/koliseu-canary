-- Central pedestal of the poison room. Just shows a status hint when used
-- without the antidote vial; the actual deposit happens via using the vial
-- on this tile (see supreme_vocation_poison_antidote.lua).

local pedestal = Action()

function pedestal.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local cfg = SupremeVocation.PoisonRoom
	local count = SupremeVocation.poisonRoomGetMechanismCount()
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format(
		"The pedestal pulses faintly. %d of %d offerings.",
		count, cfg.mechanismRequired))
	return true
end

pedestal:aid(SupremeVocation.PoisonMechanismActionId)
pedestal:register()
