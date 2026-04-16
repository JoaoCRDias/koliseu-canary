local openPassage = false

local startup = GlobalEvent("CreateBloodGuardian")

function startup.onStartup()
	local monster = Game.createMonster("Blood Guardian", Position(32913, 31427, 7), false, true)
	if monster then
		openPassage = false
	end
	return true
end

startup:register()

local function removeTalism(position)
	local tile = Tile(position)
	if tile then
		local item = tile:getItemById(51714)
		if item then
			item:remove()
			return
		end

		item = tile:getItemById(51487)
		if item then
			item:remove()
		end
	end
end

local function hasPossessedBehemoth()
	local creaturesList = Game.getSpectators(Position(32924, 31427, 7), false, false, 10, 10, 3, 3)
	for _, creature in ipairs(creaturesList) do
		if creature and creature:isMonster() and creature:getName() == "Possessed Behemoth" then
			return true
		end
	end
	return false
end

local function hasBloodGuardian()
	local creaturesList = Game.getSpectators(Position(32911, 31428, 7), false, false, 2, 2, 2, 2)
	for _, creature in ipairs(creaturesList) do
		if creature:isMonster() and creature:getName() == "Blood Guardian" then
			creature:say("WHACK!!!", TALKTYPE_MONSTER_SAY)
			creature:remove()
			return true
		end
	end
	return false
end

local callback = EventCallback("BreakingIn")

function callback.playerOnMoveItem(player, item, count, fromPos, toPos, fromCylinder, toCylinder)
	if item:getId() == 51714 or item:getId() == 51487 then
		if (toPos.x >= 32915 and toPos.x <= 32932) and (toPos.y >= 31426 and toPos.y <= 31429) then
			local stonePosition = Position(32914, 31427, 7)
			if stonePosition then
				local stoneTile = Tile(stonePosition)
				if stoneTile then
					local stoneItem = stoneTile:getItemById(1791)
					if stoneItem then
						if toPos.x == 32932 and not hasPossessedBehemoth() then
							local monster = Game.createMonster("Possessed Behemoth", Position(32932, 31427, 7), false, true)
						else
							local spectators = Game.getSpectators(toPos, false, false, 1, 1)
							for _, spectator in ipairs(spectators) do
								if spectator and spectator:isMonster() and spectator:getName() == "Possessed Behemoth" then
									local monsterPosition = spectator:getPosition()
									local positionMonsterX = monsterPosition.x
									if monsterPosition.x > toPos.x then
										positionMonsterX = monsterPosition.x - 1
									elseif monsterPosition.x < toPos.x then
										positionMonsterX = monsterPosition.x + 1
									end

									local goPosition = Position(positionMonsterX, monsterPosition.y, 7)
									if goPosition then
										if positionMonsterX == 32915 then
											if hasBloodGuardian() then
												Game.createItem(51312, 1, Position(32913, 31427, 7))

												stoneItem:transform(51311)

												goPosition:sendMagicEffect(CONST_ME_POFF)
												Position(32914, 31427, 7):sendMagicEffect(CONST_ME_POFF)
												Position(32913, 31426, 7):sendMagicEffect(CONST_ME_DRAWBLOOD)
												Position(32912, 31427, 7):sendMagicEffect(CONST_ME_DRAWBLOOD)
												Position(32913, 31427, 7):sendMagicEffect(CONST_ME_DRAWBLOOD)

												openPassage = true

												addEvent(function()
													local stonePositionOne = Position(32914, 31427, 7)
													if stonePositionOne then
														local stoneTileOne = Tile(stonePositionOne)
														if stoneTileOne then
															local stoneItemOne = stoneTileOne:getItemById(51311)
															if stoneItemOne then
																stoneItemOne:transform(1791)
															end
														end
													end

													local stonePositionTwo = Position(32913, 31427, 7)
													if stonePositionTwo then
														local stoneTileTwo = Tile(stonePositionTwo)
														if stoneTileTwo then
															local stoneItemTwo = stoneTileTwo:getItemById(51312)
															if stoneItemTwo then
																stoneItemTwo:remove()
															end
														end
													end

													local monster = Game.createMonster("Blood Guardian", stonePositionTwo, false, true)
													if monster then
														openPassage = false
													end
												end, 5 * 60 * 1000)
											end

											spectator:remove()
										else
											local haste = Condition(CONDITION_HASTE)
											haste:setParameter(CONDITION_PARAM_TICKS, 800)
											haste:setParameter(CONDITION_PARAM_SPEED, 20)
											spectator:addCondition(haste)
											spectator:walkTo(goPosition)
											goPosition:sendMagicEffect(CONST_ME_HEARTS)
										end
									end

									goPosition:sendMagicEffect(CONST_ME_HEARTS)
								end
							end
						end
					end
				end
			end

			addEvent(removeTalism, 500, toPos)
		end
	end
	return true
end

callback:register()

local movementEnter = MoveEvent()

function movementEnter.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return false
	end

	local breakingInStorage = player:getStorageValue(Storage.Quest.U15_10.BloodyTusks.BreakingIn) or 0
	if not openPassage or breakingInStorage < 1 then
		player:teleportTo(fromPosition)
		return true
	end

	player:teleportTo(Position(32912, 31429, 8))

	if breakingInStorage == 1 then
		player:setStorageValue(Storage.Quest.U15_10.BloodyTusks.BreakingIn, 2)
		player:setStorageValue(Storage.Quest.U15_10.BloodyTusks.IntoTheVampiresLair, 1)
	end

	return true
end

movementEnter:type("stepin")
movementEnter:position(Position(32912, 31431, 7))

movementEnter:register()

local movementExit = MoveEvent()

function movementExit.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return false
	end

	player:teleportTo(Position(32912, 31432, 7))

	return true
end

movementExit:type("stepin")
movementExit:position(Position(32912, 31428, 8))

movementExit:register()


