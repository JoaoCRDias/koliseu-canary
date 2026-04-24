local BASIC_STONE = 60429
local MEDIUM_STONE = 60428
local EPIC_STONE = 60427

local upgradestones = TalkAction("!upgradestones")

function upgradestones.onSay(player, words, param)
	param = param:lower():trim()

	if param == "medium" then
		-- 5 Basic Upgrade Stone -> 1 Medium Upgrade Stone
		if player:getItemCount(BASIC_STONE) < 5 then
			player:sendCancelMessage("You need 5 Basic Upgrade Stones to exchange for 1 Medium Upgrade Stone.")
			return true
		end

		player:removeItem(BASIC_STONE, 5)
		player:addItem(MEDIUM_STONE, 1)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You exchanged 5 Basic Upgrade Stones for 1 Medium Upgrade Stone.")
		player:getPosition():sendMagicEffect(CONST_ME_HOLYAREA)
		return true

	elseif param == "epic" then
		-- 5 Medium Upgrade Stone -> 1 Epic Upgrade Stone
		if player:getItemCount(MEDIUM_STONE) < 5 then
			player:sendCancelMessage("You need 5 Medium Upgrade Stones to exchange for 1 Epic Upgrade Stone.")
			return true
		end

		player:removeItem(MEDIUM_STONE, 5)
		player:addItem(EPIC_STONE, 1)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You exchanged 5 Medium Upgrade Stones for 1 Epic Upgrade Stone.")
		player:getPosition():sendMagicEffect(CONST_ME_HOLYAREA)
		return true

	else
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "[Upgrade Stones Exchange]\n"
			.. "!upgradestones medium - Exchange 5 Basic Upgrade Stones for 1 Medium Upgrade Stone\n"
			.. "!upgradestones epic - Exchange 5 Medium Upgrade Stones for 1 Epic Upgrade Stone")
		return true
	end
end

upgradestones:separator(" ")
upgradestones:groupType("normal")
upgradestones:register()
