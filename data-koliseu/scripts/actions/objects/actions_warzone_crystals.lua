local crystalDuration = 1

local crystals = {
	[57358] = 57358,
}

local function createCrystal(player)
	local itemId = 27509

	local item = Game.createItem(itemId, 1)
	local ret = player:addItemEx(item)
	if ret ~= RETURNVALUE_NOERROR then
		player:sendCancelMessage(Game.getReturnMessage(ret))
		return false
	end

	return true
end

local dangerousDepthWarzoneCrystals = Action()
function dangerousDepthWarzoneCrystals.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local crystalTimer = player:getStorageValue(crystals[item:getActionId()])
	if not crystalTimer or crystalTimer > os.time() then
		return true
	end

	local crystal = createCrystal(player)
	if crystal then
		player:setStorageValue(crystals[item:getActionId()], os.time() + crystalDuration)
	end

	return true
end

dangerousDepthWarzoneCrystals:aid(57358)

dangerousDepthWarzoneCrystals:register()
