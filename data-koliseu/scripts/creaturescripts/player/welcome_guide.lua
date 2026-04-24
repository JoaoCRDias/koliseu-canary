local STORAGE_WELCOME_GUIDE = 90001

local welcomeGuide = CreatureEvent("WelcomeGuide")

function welcomeGuide.onLogin(player)
	if player:getStorageValue(STORAGE_WELCOME_GUIDE) == 1 then
		return true
	end

	local modal = ModalWindow({})
	modal:setTitle("Welcome to " .. SERVER_NAME .. "!")
	modal:setMessage(
		"Here are some useful commands to get you started:\n\n" ..
		"!settings - Toggle autoloot, chain system, flasks, damage log and more.\n\n" ..
		"!bless - Buy all blessings at once.\n\n" ..
		"!commands - See all available commands.\n\n" ..
		"!refill - Refill your potion containers.\n\n" ..
		"!checkvip - Check your VIP status and remaining days.\n\n" ..
		"!balance - Check your bank balance.\n\n" ..
		"!deposit all - Deposit all your gold to the bank.\n\n" ..
		"Tip: Your loot pouch and loot seller are in your Store Inbox. Equip them to start collecting loot automatically!"
	)

	modal:addButton("Got It", function(buttonPlayer)
		buttonPlayer:setStorageValue(STORAGE_WELCOME_GUIDE, 1)
		buttonPlayer:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You can use !commands at any time to see all available commands.")
	end)

	modal:addButton("Close")

	modal:setDefaultEnterButton(1)
	modal:setDefaultEscapeButton(2)

	addEvent(function(playerId)
		local p = Player(playerId)
		if p then
			modal:sendToPlayer(p)
		end
	end, 1500, player:getId())

	return true
end

welcomeGuide:register()
