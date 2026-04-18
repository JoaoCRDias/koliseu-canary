-- /setrelic bonusId
-- Changes the bonus of a relic on the ground in front of the player.
-- The new bonus must belong to the same type (attack/support/defense) as the relic.
-- Usage: /setrelic fire_resist
-- List bonuses: /setrelic list

local setRelic = TalkAction("/setrelic")

function setRelic.onSay(player, words, param)

	if param == "" then
		player:sendCancelMessage("Usage: /setrelic bonusId (use '/setrelic list' to see all bonus IDs).")
		return true
	end

	-- List all available bonus IDs
	if param:lower() == "list" then
		local lines = {}
		for _, rtype in ipairs(RelicSystem.TYPES) do
			table.insert(lines, "\n[" .. rtype:upper() .. "]")
			for _, bonus in ipairs(RelicSystem.BONUSES[rtype]) do
				table.insert(lines, "  " .. bonus.id .. " - " .. bonus.name)
			end
		end
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Available relic bonus IDs:" .. table.concat(lines, "\n"))
		return true
	end

	local bonusId = param:lower():gsub("%s+", "")

	-- Validate bonus exists
	local bonusDef = RelicSystem.BONUS_LOOKUP[bonusId]
	if not bonusDef then
		player:sendCancelMessage("Unknown bonus ID: '" .. param .. "'. Use '/setrelic list' to see all IDs.")
		return true
	end

	-- Find relic on the ground in front of the player
	local position = player:getPosition()
	position:getNextPosition(player:getDirection(), 1)

	local tile = Tile(position)
	if not tile then
		player:sendCancelMessage("No tile found in front of you.")
		return true
	end

	-- Search for a relic on the tile
	local relic = nil
	local items = tile:getItems()
	if items then
		for _, item in ipairs(items) do
			if item and RelicSystem.isRelic(item) then
				relic = item
				break
			end
		end
	end

	if not relic then
		player:sendCancelMessage("No relic found on the tile in front of you.")
		return true
	end

	local data = RelicSystem.getRelicData(relic)

	-- Relic without data (created by god with /i) - initialize it
	if not data then
		local lookup = RelicSystem.RELIC_ID_LOOKUP[relic:getId()]
		if not lookup then
			player:sendCancelMessage("This item is not a recognized relic.")
			return true
		end

		-- Validate that the bonus belongs to the relic's type
		if bonusDef.bonusType ~= lookup.type then
			player:sendCancelMessage(
				"Bonus '" .. bonusId .. "' is of type '" .. bonusDef.bonusType
				.. "' but this relic is of type '" .. lookup.type .. "'."
			)
			return true
		end

		RelicSystem.setRelicData(relic, lookup.rarity, lookup.type, bonusId, 1)
		relic:setTier(1)
		RelicSystem.updateRelicName(relic)

		local value = RelicSystem.getBonusValue(lookup.rarity, 1)
		player:sendTextMessage(
			MESSAGE_EVENT_ADVANCE,
			string.format(
				"Relic initialized: %s (+%d%%, %s T1).",
				bonusDef.name, value, lookup.rarity
			)
		)
		position:sendMagicEffect(CONST_ME_MAGIC_GREEN)
		return true
	end

	-- Validate that the bonus belongs to the relic's type
	if bonusDef.bonusType ~= data.type then
		player:sendCancelMessage(
			"Bonus '" .. bonusId .. "' is of type '" .. bonusDef.bonusType
			.. "' but this relic is of type '" .. data.type .. "'."
		)
		return true
	end

	-- Check if already has this bonus
	if data.bonusId == bonusId then
		player:sendCancelMessage("This relic already has the bonus '" .. bonusId .. "'.")
		return true
	end

	local oldBonusName = "unknown"
	local oldDef = RelicSystem.BONUS_LOOKUP[data.bonusId]
	if oldDef then
		oldBonusName = oldDef.name
	end

	-- Apply the new bonus
	relic:setCustomAttribute("relic_bonus_id", bonusId)
	RelicSystem.updateRelicName(relic)

	local value = RelicSystem.getBonusValue(data.rarity, data.tier)
	player:sendTextMessage(
		MESSAGE_EVENT_ADVANCE,
		string.format(
			"Relic bonus changed: %s -> %s (+%d%%, %s T%d).",
			oldBonusName, bonusDef.name, value, data.rarity, data.tier
		)
	)
	position:sendMagicEffect(CONST_ME_MAGIC_GREEN)

	return true
end

setRelic:separator(" ")
setRelic:groupType("god")
setRelic:register()
