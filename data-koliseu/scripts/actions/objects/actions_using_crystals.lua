local function startWarzoneIV()
	addEvent(function()
		Game.createMonster("The Baron From Below", Position(1134, 942, 15))
	end, 10 * 1000)
end

local function startWarzoneV()
	addEvent(function()
		Game.createMonster("The Count Of The Core", Position(1166, 974, 15))
	end, 5 * 1000)
end

local function startWarzoneVI()
	addEvent(function()
		Game.createMonster("The Duke Of The Depths", Position(1197, 942, 15))
	end, 10 * 1000)
end

local dangerousDepthCrystals = Action()
function dangerousDepthCrystals.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if not player then
		return true
	end

	if not target or type(target) ~= "userdata" or not target:isItem() then
		return false
	end

	if target:isCreature() then
		return false
	end

	local WarzoneIV = Position(1154, 826, 15)
	local WarzoneV = Position(1159, 826, 15)
	local WarzoneVI = Position(1164, 826, 15)
	local geodeId = 27510
	local targetPosition = target:getPosition()

	if targetPosition == WarzoneIV and target:getId() == geodeId then -- Warzone 4 BOSS!!!
		if Game.getStorageValue(Storage.DangerousDepths.Geodes.WarzoneIV) < 5 then
			targetPosition:sendMagicEffect(CONST_ME_HITAREA)
			item:remove(1)
			if Game.getStorageValue(Storage.DangerousDepths.Geodes.WarzoneIV) < 0 then
				Game.setStorageValue(Storage.DangerousDepths.Geodes.WarzoneIV, 0)
			end
			Game.setStorageValue(Storage.DangerousDepths.Geodes.WarzoneIV, Game.getStorageValue(Storage.DangerousDepths.Geodes.WarzoneIV) + 1)
			if Game.getStorageValue(Storage.DangerousDepths.Geodes.WarzoneIV) == 5 then
				local spectators = Game.getSpectators(targetPosition, false, true, 3, 3, 3, 3)
				for _, spectator in pairs(spectators) do
					if spectator:isPlayer() then
						spectator:sendTextMessage(MESSAGE_EVENT_ADVANCE, "This crystal geode is shaking from a battle nearby.")
					end
				end
				local stalagmites = Tile(Position(1155, 826, 15)):getItemById(388)
				if stalagmites then
					stalagmites:remove()
					local teleport = Game.createItem(1949, 1, Position(1155, 826, 15))
					teleport:setDestination(Position(1133, 942, 15))
					addEvent(function()
						if teleport then
							teleport:remove(1)
							Game.createItem(388, 1, Position(1155, 826, 15))
						end
					end, 8 * 1000)
					addEvent(clearForgotten, 30 * 60 * 1000, Position(1122, 930, 15), Position(1147, 954, 15), Position(1159, 831, 15), Storage.DangerousDepths.Geodes.WarzoneIV)
					startWarzoneIV()
				end
			end
		else
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The crystal geode can't carry any more crystals.")
		end
	end

	if targetPosition == WarzoneV and target:getId() == geodeId then -- Warzone 5 BOSS!!!
		if Game.getStorageValue(Storage.DangerousDepths.Geodes.WarzoneV) < 5 then
			targetPosition:sendMagicEffect(CONST_ME_HITAREA)
			item:remove(1)
			if Game.getStorageValue(Storage.DangerousDepths.Geodes.WarzoneV) < 0 then
				Game.setStorageValue(Storage.DangerousDepths.Geodes.WarzoneV, 0)
			end
			Game.setStorageValue(Storage.DangerousDepths.Geodes.WarzoneV, Game.getStorageValue(Storage.DangerousDepths.Geodes.WarzoneV) + 1)
			if Game.getStorageValue(Storage.DangerousDepths.Geodes.WarzoneV) == 5 then
				local spectators = Game.getSpectators(targetPosition, false, true, 3, 3, 3, 3)
				for _, spectator in pairs(spectators) do
					if spectator:isPlayer() then
						spectator:sendTextMessage(MESSAGE_EVENT_ADVANCE, "This crystal geode is shaking from a battle nearby.")
					end
				end
				local stalagmites = Tile(Position(1160, 826, 15)):getItemById(388)
				if stalagmites then
					stalagmites:remove()
					local teleport = Game.createItem(1949, 1, Position(1160, 826, 15))
					teleport:setDestination(Position(1165, 974, 15))
					addEvent(function()
						if teleport then
							teleport:remove(1)
							Game.createItem(388, 1, Position(1160, 826, 15))
						end
					end, 8 * 1000)
					addEvent(clearForgotten, 30 * 60 * 1000, Position(1151, 963, 15), Position(1180, 982, 15), Position(1159, 831, 15), Storage.DangerousDepths.Geodes.WarzoneV)
					startWarzoneV()
				end
			end
		else
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The crystal geode can't carry any more crystals.")
		end
	end

	if targetPosition == WarzoneVI and target:getId() == geodeId then -- Warzone 6 BOSS!!!
		if Game.getStorageValue(Storage.DangerousDepths.Geodes.WarzoneVI) < 5 then
			targetPosition:sendMagicEffect(CONST_ME_HITAREA)
			item:remove(1)
			if Game.getStorageValue(Storage.DangerousDepths.Geodes.WarzoneVI) < 0 then
				Game.setStorageValue(Storage.DangerousDepths.Geodes.WarzoneVI, 0)
			end
			Game.setStorageValue(Storage.DangerousDepths.Geodes.WarzoneVI, Game.getStorageValue(Storage.DangerousDepths.Geodes.WarzoneVI) + 1)
			if Game.getStorageValue(Storage.DangerousDepths.Geodes.WarzoneVI) == 5 then
				local spectators = Game.getSpectators(targetPosition, false, true, 3, 3, 3, 3)
				for _, spectator in pairs(spectators) do
					if spectator:isPlayer() then
						spectator:sendTextMessage(MESSAGE_EVENT_ADVANCE, "This crystal geode is shaking from a battle nearby.")
					end
				end
				local stalagmites = Tile(Position(1165, 826, 15)):getItemById(388)
				if stalagmites then
					stalagmites:remove()
					local teleport = Game.createItem(1949, 1, Position(1165, 826, 15))
					teleport:setDestination(Position(1198, 942, 15))
					addEvent(function()
						if teleport then
							teleport:remove(1)
							Game.createItem(388, 1, Position(1165, 826, 15))
						end
					end, 8 * 1000)
					addEvent(clearForgotten, 30 * 60 * 1000, Position(1185, 930, 15), Position(1209, 954, 15), Position(1159, 831, 15), Storage.DangerousDepths.Geodes.WarzoneVI)
					startWarzoneVI()
				end
			end
		else
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The crystal geode can't carry any more crystals.")
		end
	end

	return true
end

dangerousDepthCrystals:id(27509)
dangerousDepthCrystals:register()
