local supremeCube = Action()

local config = {
	price = 50000,
	storage = 9007,
	cooldown = 60,
	towns = {
		{ name = "Rocket Town", teleport = Position(1000, 1000, 7) },
		{ name = "Teleports Room", teleport = Position(781, 1133, 3) },
	}
}

local function supremeCubeMessage(player, effect, message)
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, message)
	player:getPosition():sendMagicEffect(effect)
end

function supremeCube.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local inPz = player:getTile():hasFlag(TILESTATE_PROTECTIONZONE)
	local inFight = player:isPzLocked() or player:getCondition(CONDITION_INFIGHT, CONDITIONID_DEFAULT)

	if not inPz and inFight then
		supremeCubeMessage(player, CONST_ME_POFF, "You can't use this when you're in a fight.")
		return false
	end

	if player:getMoney() + player:getBankBalance() < config.price then
		supremeCubeMessage(player, CONST_ME_POFF, "You don't have enough money.")
		return false
	end

	if player:getStorageValue(config.storage) > os.time() then
		local remainingTime = player:getStorageValue(config.storage) - os.time()
		supremeCubeMessage(player, CONST_ME_POFF, "You can use it again in: " .. remainingTime .. " seconds.")
		return false
	end

	local window = ModalWindow({
		title = "Supreme Cube",
		message = "Select a City - Price: " .. config.price .. " gold.",
	})

	for _, town in pairs(config.towns) do
		if town.name then
			window:addChoice(town.name, function(player, button, choice)
				if button.name == "Select" then
					player:teleportTo(town.teleport, true)
					player:removeMoneyBank(config.price)
					supremeCubeMessage(player, CONST_ME_TELEPORT, "Welcome to " .. town.name)
					player:setStorageValue(config.storage, os.time() + config.cooldown)
				end
				return true
			end)
		end
	end

	-- Opção de teleportar para a casa do jogador
	window:addChoice("House", function(player, button, choice)
		if button.name == "Select" then
			local house = player:getHouse()
			if house then
				player:teleportTo(house:getExitPosition(), true)
				player:removeMoneyBank(config.price)
				supremeCubeMessage(player, CONST_ME_TELEPORT, "Welcome to your house.")
				player:setStorageValue(config.storage, os.time() + config.cooldown)
			else
				supremeCubeMessage(player, CONST_ME_POFF, "You don't have a house.")
			end
		end
		return true
	end)

	window:addButton("Select")
	window:addButton("Close")
	window:setDefaultEnterButton(0)
	window:setDefaultEscapeButton(1)
	window:sendToPlayer(player)

	return true
end

supremeCube:id(31633)
supremeCube:register()
