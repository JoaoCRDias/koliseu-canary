local setting = {
	-- At what level can do the quest?
	requiredLevel = 100,
	-- Can it be done daily? true = yes, false = no
	daily = false,
	-- Do not change from here down
	centerDemonRoomPosition = Position(712, 1307, 9),
	demonsPositions = {
		Position(710, 1305, 9),
		Position(712, 1305, 9),
		Position(711, 1309, 9),
		Position(713, 1309, 9),
		Position(714, 1307, 9),
		Position(715, 1307, 9),
	},
	playersPositions = {
		{ fromPos = Position(713, 1319, 9), toPos = Position(710, 1307, 9) },
		{ fromPos = Position(714, 1319, 9), toPos = Position(711, 1307, 9) },
		{ fromPos = Position(715, 1319, 9), toPos = Position(712, 1307, 9) },
		{ fromPos = Position(716, 1319, 9), toPos = Position(713, 1307, 9) },
	},
}

local lever = Action()

function lever.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if item.itemid == 2772 then
		-- Checks if you have the 4 players and if they have the required level
		for i = 1, #setting.playersPositions do
			local creature = Tile(setting.playersPositions[i].fromPos):getTopCreature()
			if creature and creature:isPlayer() and creature:getLevel() < setting.requiredLevel then
				player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "All the players need to be level " .. setting.requiredLevel .. " or higher.")
				return true
			end
		end

		-- Checks if there are still players inside the room, if so, return true
		if roomIsOccupied(setting.centerDemonRoomPosition, true, 4, 4) then
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "A team is already inside the quest room.")
			return true
		end

		-- Create monsters
		for i = 1, #setting.demonsPositions do
			Game.createMonster("Angry Demon", setting.demonsPositions[i])
		end

		-- Get players from the tiles "playersPositions" and teleport to the demons room if all of the above requirements are met
		for i = 1, #setting.playersPositions do
			local creature2 = Tile(setting.playersPositions[i].fromPos):getTopCreature()
			if creature2 then
				creature2:teleportTo(setting.playersPositions[i].toPos)
				creature2:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
			end
		end
		item:transform(2773)
	elseif item.itemid == 2773 then
		-- If it has "daily = true" then it will execute this function
		if setting.daily then
			player:sendCancelMessage(RETURNVALUE_NOTPOSSIBLE)
			return true
		end
		-- Not be able to push the lever back if someone is still inside the monsters room
		if roomIsOccupied(setting.centerDemonRoomPosition, true, 4, 4) then
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "A team is already inside the quest room.")
			return true
		end
		-- Removes all monsters so that the next team can enter
		if Position.removeMonster(setting.centerDemonRoomPosition, 4, 4) then
			return true
		end
		item:transform(2772)
	end
	return true
end

lever:uid(30025)
lever:register()
