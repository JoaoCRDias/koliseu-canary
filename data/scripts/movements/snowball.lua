-- Snowball Fight - Entry Teleport
-- Action ID: 54230

local sbEntry = MoveEvent()
function sbEntry.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	if Snowball.state ~= "waiting" then
		player:sendTextMessage(MESSAGE_STATUS_SMALL, "The Snowball Fight event is not accepting players right now.")
		player:teleportTo(fromPosition)
		return false
	end

	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "[Snowball] You entered the arena! Use 'exori infir ico' to throw snowballs when the event starts.")
	return true
end
sbEntry:type("stepin")
sbEntry:aid(54230)
sbEntry:register()
