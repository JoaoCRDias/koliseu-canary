local movementEnter = MoveEvent()

function movementEnter.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return false
	end

	if player:getStorageValue(Storage.Quest.U15_10.BloodyTusks.TheBloodRitual) < 1 then
		player:teleportTo(fromPosition)
		return true
	end

	player:teleportTo(Position(32954, 31429, 15))

	return true
end

movementEnter:type("stepin")
movementEnter:position(Position(32882, 31439, 10))

movementEnter:register()

local movementExit = MoveEvent()

function movementExit.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return false
	end

	player:teleportTo(Position(32883, 31427, 10))

	return true
end

movementExit:type("stepin")
movementExit:position(Position(32956, 31430, 15))

movementExit:register()
