-- Fire Or Ice - Entry Teleport
-- Action ID: 54210

local foiEntry = MoveEvent()
function foiEntry.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	if FireOrIce.state ~= "waiting" then
		player:sendTextMessage(MESSAGE_STATUS_SMALL, "The Fire Or Ice event is not accepting players right now.")
		player:teleportTo(fromPosition)
		return false
	end

	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "[Fire Or Ice] You entered the arena! Choose a side: FIRE or ICE. The event will start soon.")
	return true
end
foiEntry:type("stepin")
foiEntry:aid(54210)
foiEntry:register()
