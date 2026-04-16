
local exhaust = 6 -- in hours

local freeBlessStatue = Action()

function freeBlessStatue.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local lastBlessPicked = player:getStorageValue(Storage.LastBlessPicked)
	if(os.time() < lastBlessPicked) then
		local remainingTime = lastBlessPicked - os.time()
		local hours = math.floor((remainingTime % (24 * 3600)) / 3600)
		local minutes = math.floor((remainingTime % 3600) / 60)
		player:sendTextMessage(MESSAGE_STATUS, string.format("You can use this statue again in %d hours and %d minutes", hours, minutes))
		return true
	end
	local missingBless = false
	for i = 1, 8 do
		if not player:hasBlessing(i) then
			player:addBlessing(i, 1)
			missingBless = true
			player:setStorageValue(Storage.LastBlessPicked, os.time() + (exhaust * 3600))
		end
	end
	if(missingBless) then
		player:getPosition():sendMagicEffect(CONST_ME_HOLYAREA)
		player:sendTextMessage(MESSAGE_STATUS,"You have been blessed by the gods.")
	end
	player:sendTextMessage(MESSAGE_STATUS,"You already have all blessings.")
	return true
end

freeBlessStatue:id(60307)
freeBlessStatue:register()
