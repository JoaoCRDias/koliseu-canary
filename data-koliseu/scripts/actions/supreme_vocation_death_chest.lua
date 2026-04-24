-- Chest at the end of the labyrinth. Hands out the totem key (21192) one time
-- per player. The key itself is not consumed on use, but the player cannot
-- take another one from the chest.

local chest = Action()

function chest.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local cfg = SupremeVocation.DeathChamber

	if SupremeVocation.hasTakenLabyrinthKey(player) then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have already taken the key from this chest.")
		return true
	end

	if not player:addItem(cfg.labyrinthKeyItemId, 1) then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have no space for the key. Free a slot and try again.")
		return true
	end

	SupremeVocation.markLabyrinthKeyTaken(player)
	item:getPosition():sendMagicEffect(CONST_ME_MAGIC_GREEN)
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You take the totem key from the chest.")
	return true
end

chest:aid(SupremeVocation.DeathLabyrinthChestActionId)
chest:register()
