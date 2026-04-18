-- Mount Quest
-- Lever at Position(880, 628, 7), player must stand at Position(880, 629, 7)
-- Teleports to quest room Position(856, 627, 6) for 2 minutes
-- After timer: teleport to reward room Position(880, 625, 7)
-- Reward chest teleports out to Position(880, 630, 7)

local STORAGE_COOLDOWN = 54500
local COOLDOWN_SECONDS = 48 * 60 * 60 -- 48 hours

local LEVER_ACTION_ID = 64501
local CHEST_ACTION_ID = 64502

local PLAYER_STAND_POS = Position(880, 629, 7)
local QUEST_ROOM_POS = Position(856, 627, 6)
local REWARD_ROOM_POS = Position(880, 625, 7)
local EXIT_POS = Position(880, 630, 7)

local QUEST_DURATION = 2 * 60 * 1000 -- 2 minutes in ms
local COUNTDOWN_START = 120

local _questEventId = nil
local _countdownEventId = nil

local function countdownTick(pid, remaining)
	_countdownEventId = nil

	local p = Player(pid)
	if not p then
		return
	end

	-- Stop if player left the quest room (died, logged out, or teleported out)
	if p:getHealth() <= 0 or p:getPosition() ~= QUEST_ROOM_POS then
		return
	end

	p:say(tostring(remaining), TALKTYPE_MONSTER_SAY)

	if remaining > 0 then
		_countdownEventId = addEvent(countdownTick, 1000, pid, remaining - 1)
	end
end

-- Mount data (reuse from mount talkaction)
local addonMountData = dofile(DATA_DIRECTORY .. "/lib/tables/addon_mounts.lua")
local MOUNT_INFO = addonMountData.mounts or {}

local function buildMountChoices()
	local choices = {}
	for key, _ in pairs(MOUNT_INFO) do
		table.insert(choices, key)
	end
	table.sort(choices)
	return choices
end

local MOUNT_CHOICES = buildMountChoices()

-- ============================================================
-- Lever Action: Enter the quest
-- ============================================================
local lever = Action()

function lever.onUse(player, item, fromPosition, target, toPosition, isHotkey)

	if player:getPosition() ~= PLAYER_STAND_POS then
		player:sendCancelMessage("You must stand in front of the lever to use it.")
		return true
	end

	-- Check if quest room tile has a player on it
	local questTile = Tile(QUEST_ROOM_POS)
	if questTile then
		local creature = questTile:getTopCreature()
		if creature and creature:isPlayer() then
			player:sendCancelMessage("The quest room is currently occupied. Please wait.")
			return true
		end
	end

	-- Cancel previous timer if still running
	if _questEventId then
		stopEvent(_questEventId)
		_questEventId = nil
	end
	if _countdownEventId then
		stopEvent(_countdownEventId)
		_countdownEventId = nil
	end

	local lastUse = player:getStorageValue(STORAGE_COOLDOWN)
	if lastUse > 0 then
		local remaining = lastUse - os.time()
		if remaining > 0 then
			local hours = math.floor(remaining / 3600)
			local minutes = math.floor((remaining % 3600) / 60)
			player:sendCancelMessage(string.format("You must wait %dh %dm before entering again.", hours, minutes))
			return true
		end
	end

	-- Set cooldown
	player:setStorageValue(STORAGE_COOLDOWN, os.time() + COOLDOWN_SECONDS)

	-- Toggle lever visual
	local newId = item:getId() == 2772 and 2773 or 2772
	item:transform(newId)

	-- Teleport player to quest room
	player:teleportTo(QUEST_ROOM_POS)
	QUEST_ROOM_POS:sendMagicEffect(CONST_ME_TELEPORT)
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have 2 minutes to survive! Good luck!")

	-- Timer: after 2 minutes, teleport to reward room
	local playerId = player:getId()
	_questEventId = addEvent(function(pid)
		_questEventId = nil

		local p = Player(pid)
		if not p then
			return
		end

		-- Player is alive and still in quest room
		if p:getHealth() > 0 and p:getPosition() == QUEST_ROOM_POS then
			p:teleportTo(REWARD_ROOM_POS)
			REWARD_ROOM_POS:sendMagicEffect(CONST_ME_TELEPORT)
			p:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Time is up! Open the chest to claim your reward.")
		end
	end, QUEST_DURATION, playerId)

	-- Countdown: send orange talktype message every second from 120 to 0
	_countdownEventId = addEvent(countdownTick, 1000, playerId, COUNTDOWN_START)

	return true
end

lever:aid(LEVER_ACTION_ID)
lever:register()

-- ============================================================
-- Reward Chest Action: Open mount selection modal
-- ============================================================
local chest = Action()

function chest.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local available = {}
	for _, name in ipairs(MOUNT_CHOICES) do
		local info = MOUNT_INFO[name]
		if info and not player:hasMount(info.mount) then
			table.insert(available, name)
		end
	end

	if #available == 0 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You already own all available mounts!")
		player:teleportTo(EXIT_POS)
		EXIT_POS:sendMagicEffect(CONST_ME_TELEPORT)
		return true
	end

	local window = ModalWindow({
		title = "Mount Reward",
		message = "Choose a mount as your reward:",
	})

	for _, name in ipairs(available) do
		window:addChoice(name)
	end

	window:addButton("Select", function(clickedPlayer, button, choice)
		if not choice or not choice.text then
			clickedPlayer:sendCancelMessage("You must select a mount.")
			return true
		end

		local info = MOUNT_INFO[choice.text]
		if not info then
			clickedPlayer:sendCancelMessage("Invalid mount selection.")
			return true
		end

		if clickedPlayer:hasMount(info.mount) then
			clickedPlayer:sendCancelMessage("You already have this mount. Open the chest again.")
			return true
		end

		clickedPlayer:addMount(info.mount)
		clickedPlayer:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Congratulations! You obtained the mount: " .. choice.text .. "!")
		clickedPlayer:getPosition():sendMagicEffect(CONST_ME_HOLYDAMAGE)

		-- Teleport out
		clickedPlayer:teleportTo(EXIT_POS)
		EXIT_POS:sendMagicEffect(CONST_ME_TELEPORT)
		return true
	end)

	window:addButton("Cancel")
	window:setDefaultEnterButton(1)
	window:setDefaultEscapeButton(2)
	window:sendToPlayer(player)

	return true
end

chest:aid(CHEST_ACTION_ID)
chest:register()
