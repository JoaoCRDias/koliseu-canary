-- Quest storage keys (same as in viola.lua)
local VIOLA_BOOK_QUEST_START = 100010
local VIOLA_BOOK_QUEST_DONE = 100011
local BOOK_CHEST_OPENED = 100012

-- Book of Wisdom item ID
local BOOK_OF_WISDOM_ID = 44774

local bookOfWisdomChest = Action()

function bookOfWisdomChest.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local questStart = player:getStorageValue(VIOLA_BOOK_QUEST_START)
	local questDone = player:getStorageValue(VIOLA_BOOK_QUEST_DONE)
	local chestOpened = player:getStorageValue(BOOK_CHEST_OPENED)

	-- Check if player has started the quest
	if questStart ~= 1 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The chest is locked. Maybe someone in the village knows about this place.")
		return true
	end

	-- Check if quest is already done
	if questDone == 1 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The chest is empty.")
		return true
	end

	-- Check if player already got the book
	if chestOpened == 1 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The chest is empty. You have already taken the Book of Wisdom.")
		return true
	end

	-- Give the book to the player
	if player:addItem(BOOK_OF_WISDOM_ID, 1) then
		player:setStorageValue(BOOK_CHEST_OPENED, 1)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You found the Book of Wisdom! Return it to Viola.")
		item:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
	else
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You don't have enough space in your inventory.")
	end

	return true
end

-- Register for unique ID (set this on the chest in the map editor)
bookOfWisdomChest:uid(30201)
bookOfWisdomChest:register()
