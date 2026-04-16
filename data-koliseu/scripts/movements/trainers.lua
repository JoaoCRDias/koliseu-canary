local trainerTp = MoveEvent()
trainerTp:type("stepin")

local config = {
	leftTopCorner = { x = 508, y = 943 },
	rightDownCorner = { x = 552, y = 985 },
	zPos = 7,
	tileItemId = 28455, --tile item id for scanner, where you want to teleport player, ez to change for tile with uid if someone need
}

local function findFirstEmpty()
	for x = config.leftTopCorner.x, config.rightDownCorner.x do
		for y = config.leftTopCorner.y, config.rightDownCorner.y do
			local tmpPos = { x = x, y = y, z = config.zPos };
			local t = Tile(tmpPos)
			if t ~= nil then
				if (t:getThing():getId() == config.tileItemId and not t:getTopCreature()) then
					return tmpPos
				end
			end
		end
	end
	return false
end

function trainerTp.onStepIn(creature, item, position, fromPosition)
	local availableTrainingSlot = findFirstEmpty()
	if (availableTrainingSlot) then
		creature:teleportTo(availableTrainingSlot)
		creature:sendTextMessage(MESSAGE_FAILURE, "Welcome.")
	else
		creature:teleportTo(fromPosition)
		creature:sendTextMessage(MESSAGE_FAILURE, "No available slots.")
	end
	return true
end

trainerTp:aid(10500)
trainerTp:register()

local trainerExitTp = MoveEvent()
trainerExitTp:type("stepin")


function trainerExitTp.onStepIn(creature, item, position, fromPosition)
	creature:teleportTo(Position(1000, 1000, 7))

	return true
end

trainerExitTp:aid(40015)
trainerExitTp:register()
