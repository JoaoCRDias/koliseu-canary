local bossForms = {
	["snake god essence"] = {
		text = "IT'S NOT THAT EASY MORTALS! FEEL THE POWER OF THE GOD!",
		newForm = "snake thing",
	},
	["snake thing"] = {
		text = "NOOO! NOW YOU HERETICS WILL FACE MY GODLY WRATH!",
		newForm = "lizard abomination",
	},
	["lizard abomination"] = {
		text = "YOU ... WILL ... PAY WITH ETERNITY ... OF AGONY!",
		newForm = "mutated zalamon",
	},
}

local function removeTeleport(position)
	local teleportItem = Tile(position):getItemById(1949)
	if teleportItem then
		teleportItem:remove()
		position:sendMagicEffect(CONST_ME_POFF)
	end
	Game.setStorageValue(Storage.WrathOfTheEmperor.Mission11, -1)
end

local zalamonKill = CreatureEvent("ZalamonDeath")
function zalamonKill.onDeath(creature)
	if creature:getName():lower() == "mutated zalamon" then
		local position = creature:getPosition()
		local blood = Tile(position):getItemById(2886)
		if blood then
			blood:remove()
		end
		position:sendMagicEffect(CONST_ME_TELEPORT)
		local item = Game.createItem(1949, 1, position)
		local teleportToPosition = Position(757, 1500, 11)
		if item:isTeleport() then
			item:setDestination(teleportToPosition)
		end
		creature:say("Congratulations! You have completed the mission!", TALKTYPE_MONSTER_SAY, 0, 0,
			position)
		addEvent(removeTeleport, 2 * 60 * 1000, position)
		return true
	end

	local name = creature:getName():lower()
	local bossConfig = bossForms[name]
	if not bossConfig then
		return true
	end

	local found = false
	for k, v in ipairs(Game.getSpectators(creature:getPosition())) do
		if v:getName():lower() == bossConfig.newForm then
			found = true
			break
		end
	end

	if not found then
		local monster = Game.createMonster(bossConfig.newForm, creature:getPosition(), false, true)
		if monster then
			monster:say(bossConfig.text, TALKTYPE_MONSTER_SAY)
		end
	end
	return true
end

zalamonKill:register()
