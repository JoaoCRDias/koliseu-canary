-- Fishing action: grants SKILL_FISHING tries, no loot rewards.
-- Fish-loot removed intentionally (2026-04-20) — the setting toggle
-- was dropped and the action should never yield items regardless of
-- rod, water type, or bathtub.
local waterIds = { 629, 630, 631, 632, 633, 634, 4597, 4598, 4599, 4600, 4601, 4602, 4609, 4610, 4611, 4612, 4613, 4614, 7236, 9582, 12560, 12562, 12561, 12563, 13988, 13989, BATHTUB_FILLED }

local fishing = Action()

function fishing.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if not table.contains(waterIds, target.itemid) then
		return false
	end

	-- Check house permission for bathtub fishing
	if target.itemid == BATHTUB_FILLED then
		local tile = Tile(toPosition)
		if tile then
			local house = tile:getHouse()
			if house and not house:isInvited(player) then
				player:sendCancelMessage("You are not invited to this house.")
				return true
			end
		end
	end

	-- Fished-corpse variant (id 9582): consume/decay it but yield no loot.
	if target.itemid == 9582 then
		local owner = target:getAttribute(ITEM_ATTRIBUTE_CORPSEOWNER)
		if owner ~= 0 and owner ~= player:getId() then
			player:sendTextMessage(MESSAGE_FAILURE, "You are not the owner.")
			return true
		end

		toPosition:sendMagicEffect(CONST_ME_WATERSPLASH)
		target:transform(target.itemid + 1)
		target:decay()
		return true
	end

	if target.itemid ~= 7236 then
		toPosition:sendMagicEffect(CONST_ME_LOSEENERGY)
	end

	if target.itemid == 622 or target.itemid == 13989 then
		return true
	end

	-- Skill tries (still granted so players can level SKILL_FISHING)
	if item.itemid == 60674 then
		player:addSkillTries(SKILL_FISHING, 2, true)
	else
		player:addSkillTries(SKILL_FISHING, 1, true)
	end

	if target.itemid == BATHTUB_FILLED then
		player:addSkillTries(SKILL_FISHING, 1, true)
	end

	-- Decay sparkling pools (13988) and message-in-a-bottle water (7236) without dropping loot.
	if target.itemid == 13988 or target.itemid == 7236 then
		target:transform(target.itemid + 1)
		target:decay()
	end

	return true
end

fishing:id(3483, 9306, 60674)
fishing:allowFarUse(true)
fishing:register()
