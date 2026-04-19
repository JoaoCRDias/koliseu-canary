-- /resetgembag [playerName]
-- Removes ALL gem bags (and all gems inside) from a player, then creates a fresh empty one
-- in their Store Inbox. Intended for dev/test purposes.

local resetGemBag = TalkAction("/resetgembag")

local function removeAllGemBags(target)
	local removed = 0
	if not GemBag or not GemBag.scanPlayerGemBags then
		return removed
	end

	-- Collect first, remove after (don't mutate while iterating)
	local toRemove = {}
	GemBag.scanPlayerGemBags(target, function(bagItem)
		toRemove[#toRemove + 1] = bagItem
		return false -- keep scanning to find all bags
	end)

	for _, bagItem in ipairs(toRemove) do
		if bagItem and not bagItem:isRemoved() then
			bagItem:remove()
			removed = removed + 1
		end
	end
	return removed
end

local function clearBonusStorages(target)
	-- Reset all 910xxx gembag storages + 53404 (xp display) so stats update cleanly
	local ids = {
		910001, 910002, 910003, 910004, 910005, 910006,
		910010, 910011, 910012, 910013, 910014, 910015, 910016,
		910020, 910021, 910022, 910023, 910024, 910025, 910026,
		910030, 910031, 910032, 910033, 910034, 910035,
		53404,
	}
	for _, storageId in ipairs(ids) do
		target:setStorageValue(storageId, -1)
	end
end

function resetGemBag.onSay(player, words, param)
	if not GemBag then
		player:sendCancelMessage("GemBag system is not loaded.")
		return true
	end

	local target = player
	local targetName = param and param:trim() or ""
	if targetName ~= "" then
		local found = Player(targetName)
		if not found then
			player:sendCancelMessage(string.format("Player '%s' is not online.", targetName))
			return true
		end
		target = found
	end

	local removed = removeAllGemBags(target)
	clearBonusStorages(target)

	local created = GemBag.createGemBag(target, { player = target })
	if not created then
		player:sendCancelMessage("Failed to create a new Gem Bag.")
		return true
	end

	-- Recompute cache and push stats refresh
	if GemBag.invalidateCache then
		GemBag.invalidateCache(target)
	end
	if GemBag.applyStatBonuses then
		GemBag.applyStatBonuses(target)
	end
	target:sendStats()
	target:sendSkills()

	local msg = string.format("Gem Bag reset: %d old bag(s) removed, new empty bag added to Store Inbox.", removed)
	target:sendTextMessage(MESSAGE_EVENT_ADVANCE, msg)
	if target ~= player then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("%s on %s.", msg, target:getName()))
	end
	return true
end

resetGemBag:separator(" ")
resetGemBag:groupType("god")
resetGemBag:register()
