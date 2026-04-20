local BOSS_CD_REDUCER_ID = 16262
local TARGET_CD_SECONDS = 8 * 3600 -- 8 hours

local bossCdReducer = Action()

function bossCdReducer.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local bossCooldownKV = player:kv():scoped("boss.cooldown")
	local keys = bossCooldownKV:keys()
	local now = os.time()
	local reducedCount = 0

	for _, key in ipairs(keys) do
		local cooldown = bossCooldownKV:get(key)
		if cooldown and cooldown > now then
			local remaining = cooldown - now
			if remaining > TARGET_CD_SECONDS then
				bossCooldownKV:set(key, now + TARGET_CD_SECONDS)
				reducedCount = reducedCount + 1
			end
		end
	end

	if reducedCount > 0 then
		player:sendBosstiaryCooldownTimer()
		player:getPosition():sendMagicEffect(CONST_ME_MAGIC_GREEN)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("Boss cooldowns reduced! %d boss(es) had their cooldown set to 8 hours.", reducedCount))
	else
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "No boss cooldowns above 8 hours to reduce.")
	end

	return true
end

bossCdReducer:id(BOSS_CD_REDUCER_ID)
bossCdReducer:register()
