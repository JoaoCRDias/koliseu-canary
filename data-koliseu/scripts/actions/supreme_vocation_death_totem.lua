-- Using the labyrinth key (21192) on one of the four terrace totems tries to
-- release the corresponding ghost. If the ghost matches the next expected slot
-- in the order, it is released and must be killed. Otherwise the room spawns
-- the punishment wave.
--
-- Registered on the key itemId; the totem is identified by its action id on
-- the target.

local totemKey = Action()

local function totemIndexFromActionId(aid)
	for i, taid in ipairs(SupremeVocation.DeathTotemActionIds) do
		if taid == aid then return i end
	end
	return nil
end

function totemKey.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if not target or not target.actionid then return false end
	local totemIndex = totemIndexFromActionId(target.actionid)
	if not totemIndex then return false end

	if not SupremeVocation.deathTerraceIsActive() then
		SupremeVocation.deathTerraceBegin()
	end

	local activeId = SupremeVocation.deathTerraceActiveGhostId()
	if activeId and Creature(activeId) then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "A spectre still walks. Put it down first.")
		return true
	end

	local step = SupremeVocation.deathTerraceProgress() + 1
	local expected = SupremeVocation.deathTerraceExpectedAt(step)

	if totemIndex == expected then
		local ghost = SupremeVocation.deathTerraceSpawnGhost(totemIndex)
		if ghost then
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format(
				"The %s totem flares and a spectre rises.",
				SupremeVocation.DeathChamber.ghosts[totemIndex].cardinal))
		end
	else
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The totem rejects the rite. The dead answer.")
		SupremeVocation.deathTerracePunish()
	end

	return true
end

totemKey:id(SupremeVocation.DeathChamber.labyrinthKeyItemId)
totemKey:register()
