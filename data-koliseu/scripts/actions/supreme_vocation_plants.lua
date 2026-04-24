-- Supreme Vocation: harvestable plants scattered across the continent.
-- Each plant is identified by its uniqueId in the map editor and hands out a
-- single extract item per use, entering a per-player 4h cooldown afterwards.

local function formatRemaining(seconds)
	local hours = math.floor(seconds / 3600)
	local minutes = math.floor((seconds % 3600) / 60)
	if hours > 0 then
		return string.format("%dh %02dm", hours, minutes)
	end
	return string.format("%dm", minutes)
end

local harvest = Action()

function harvest.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local uid = item:getUniqueId()
	local extractId = SupremeVocation.Plants[uid]
	if not extractId then
		return false
	end

	local remaining = SupremeVocation.getPlantCooldownRemaining(player, uid)
	if remaining > 0 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format(
			"The plant is spent. It will yield again in %s.", formatRemaining(remaining)))
		return true
	end

	if not player:addItem(extractId, 1) then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have no space to carry the extract.")
		return true
	end

	SupremeVocation.setPlantCooldown(player, uid)
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You harvest an extract from the plant.")
	toPosition:sendMagicEffect(CONST_ME_GREEN_RINGS)
	return true
end

for uniqueId in pairs(SupremeVocation.Plants) do
	harvest:uid(uniqueId)
end
harvest:register()
