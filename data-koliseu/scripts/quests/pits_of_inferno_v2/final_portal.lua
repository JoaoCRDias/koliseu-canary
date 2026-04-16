-- POI v2 - Final portal
-- Only players who have absorbed all 6 throne spirits can pass

local REQUIRED_THRONES = {
	Storage.PitsOfInfernoV2.ThroneRoom1,
	Storage.PitsOfInfernoV2.ThroneRoom2,
	Storage.PitsOfInfernoV2.ThroneRoom3,
	Storage.PitsOfInfernoV2.ThroneRoom4,
	Storage.PitsOfInfernoV2.ThroneRoom5,
	Storage.PitsOfInfernoV2.ThroneRoom6,
}

local finalPortal = MoveEvent()

function finalPortal.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	for _, storageKey in ipairs(REQUIRED_THRONES) do
		if player:getStorageValue(storageKey) ~= 1 then
			player:teleportTo(fromPosition, true)
			player:getPosition():sendMagicEffect(CONST_ME_POFF)
			player:say("You have not yet conquered all six chambers. Return when you are worthy.", TALKTYPE_MONSTER_SAY)
			return true
		end
	end

	player:teleportTo(Position(619, 1803, 9)) -- TODO: set destination (reward room / next area)
	player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	player:say("The ancient spirits recognize your worth. Proceed.", TALKTYPE_MONSTER_SAY)
	return true
end

finalPortal:type("stepin")
finalPortal:aid(21230)
finalPortal:register()
