local setting = {
	requiredLevel = 300,
	centerDemonRoomPosition = Position(760, 1306, 9),
	hellfirePositions = {
		Position(756, 1306, 9),
		Position(755, 1306, 9),
		Position(762, 1306, 9),
		Position(763, 1306, 9)
	},
	demonsPositions = {
		Position(758, 1304, 9),
		Position(760, 1304, 9),
		Position(759, 1308, 9),
		Position(761, 1308, 9),
		Position(758, 1309, 9),
		Position(760, 1309, 9),
		Position(759, 1303, 9),
		Position(761, 1303, 9)
	},
	playersPositions = {
		{ fromPos = Position(761, 1318, 9), toPos = Position(758, 1306, 9) },
		{ fromPos = Position(762, 1318, 9), toPos = Position(759, 1306, 9) },
		{ fromPos = Position(763, 1318, 9), toPos = Position(760, 1306, 9) },
		{ fromPos = Position(764, 1318, 9), toPos = Position(761, 1306, 9) },
	},
}

local DAILY_KEY = "exercise-daily-quest"
local DAILY_COOLDOWN = 20 * 60 * 60 -- 20 horas em segundos

local lever = Action()

function lever.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if item.itemid == 2772 then
		for i = 1, #setting.playersPositions do
			local creature = Tile(setting.playersPositions[i].fromPos):getTopCreature()
			if creature and creature:isPlayer() then
				if creature:getLevel() < setting.requiredLevel then
					player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "All the players need to be level " .. setting.requiredLevel .. " or higher.")
					return true
				end

				local lastTime = creature:kv():get(DAILY_KEY)
				if lastTime and (os.time() - lastTime < DAILY_COOLDOWN) then
					player:sendTextMessage(MESSAGE_EVENT_ADVANCE, creature:getName() .. " must wait before doing this quest again.")
					return true
				end
			end
		end

		if roomIsOccupied(setting.centerDemonRoomPosition, true, 4, 4) then
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "A team is already inside the quest room.")
			return true
		end


		for i = 1, #setting.hellfirePositions do
			Game.createMonster("Hellfire Fighter", setting.hellfirePositions[i])
		end
		for i = 1, #setting.demonsPositions do
			Game.createMonster("Angry Demon", setting.demonsPositions[i])
		end



		for i = 1, #setting.playersPositions do
			local creature2 = Tile(setting.playersPositions[i].fromPos):getTopCreature()
			if creature2 and creature2:isPlayer() then
				creature2:teleportTo(setting.playersPositions[i].toPos)
				creature2:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
				creature2:kv():set(DAILY_KEY, os.time())
			end
		end
		item:transform(2773)
	elseif item.itemid == 2773 then
		if roomIsOccupied(setting.centerDemonRoomPosition, true, 4, 4) then
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "A team is already inside the quest room.")
			return true
		end
		if Position.removeMonster(setting.centerDemonRoomPosition, 6, 6) then
			return true
		end
		item:transform(2772)
	end
	return true
end

lever:uid(30026)
lever:register()
