local thorgrimHazardCap = CreatureEvent("ThorgrimHazardCap")

local HAZARD_NAME = "hazard.edron-kingdom"
local MAX_ALLOWED = 3

function thorgrimHazardCap.onLogin(player)
	if player:kv():scoped("thorgrim"):get("hazard-capped") then
		return true
	end

	local kv = player:kv():scoped(HAZARD_NAME)
	local maxLevel = kv:get("max-level")
	local currentLevel = kv:get("current-level")
	local changed = false

	if maxLevel and maxLevel > MAX_ALLOWED then
		kv:set("max-level", MAX_ALLOWED)
		changed = true
	end

	if currentLevel and currentLevel > MAX_ALLOWED then
		kv:set("current-level", MAX_ALLOWED)
		changed = true
	end

	if changed then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("Your Thorgrim hazard level has been adjusted to the maximum of %d.", MAX_ALLOWED))
	end

	player:kv():scoped("thorgrim"):set("hazard-capped", true)
	return true
end

thorgrimHazardCap:register()
