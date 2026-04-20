local kegCooldowns = {}
local COOLDOWN_TIME = 60 -- 1 minute in seconds
local POTION_AMOUNT = 500 -- Amount of potions to give

local kegs = {
	-- Supreme Health Kegs
	[25879] = { potion = 23375, name = "supreme health potion" }, -- Health Cask
	[25903] = { potion = 23375, name = "supreme health potion" }, -- Health Keg
	[25907] = { potion = 60259, name = "cosmic health potion" }, -- Supreme Health Keg (Store)

	-- Ultimate Mana Kegs
	[25889] = { potion = 23373, name = "ultimate mana potion" }, -- Mana Cask
	[25908] = { potion = 23373, name = "ultimate mana potion" }, -- Mana Keg
	[25911] = { potion = 60258, name = "cosmic mana potion" }, -- Ultimate Mana Keg (Store)

	-- Ultimate Spirit Kegs
	[25899] = { potion = 23374, name = "ultimate spirit potion" }, -- Spirit Cask
	[25913] = { potion = 23374, name = "ultimate spirit potion" }, -- Spirit Keg
	[25914] = { potion = 60260, name = "cosmic spirit potion" }, -- Ultimate Spirit Keg (Store)

	-- Great Health Potions
	[25880] = { potion = 239, name = "great health potion" },
	[25904] = { potion = 239, name = "great health potion" },

	-- Great Mana Potions
	[25890] = { potion = 238, name = "great mana potion" },
	[25909] = { potion = 238, name = "great mana potion" },

	-- Great Spirit Potions
	[25900] = { potion = 7642, name = "great spirit potion" },

	-- Health Potions
	[25881] = { potion = 266, name = "health potion" },
	[25905] = { potion = 266, name = "health potion" },

	-- Mana Potions
	[25891] = { potion = 237, name = "mana potion" },
	[25910] = { potion = 237, name = "mana potion" },

	-- Strong Health Potions
	[25882] = { potion = 7643, name = "strong health potion" },
	[25906] = { potion = 7643, name = "strong health potion" },

	-- Strong Mana Potions
	[25892] = { potion = 236, name = "strong mana potion" },

	-- Ultimate Health Potions
	[25883] = { potion = 268, name = "ultimate health potion" },
}

local function onUseKeg(player, item, fromPosition, target, toPosition, isHotkey)
	local playerId = player:getId()
	local itemId = item:getId()
	local currentTime = os.time()

	local kegConfig = kegs[itemId]
	if not kegConfig then
		return false
	end

	if kegCooldowns[playerId] and kegCooldowns[playerId][itemId] then
		local timeLeft = kegCooldowns[playerId][itemId] - currentTime
		if timeLeft > 0 then
			player:sendCancelMessage("You need to wait " .. timeLeft .. " seconds before using this keg again.")
			player:getPosition():sendMagicEffect(CONST_ME_POFF)
			return true
		end
	end

	local potionWeight = ItemType(kegConfig.potion):getWeight()
	if player:getFreeCapacity() < (potionWeight * POTION_AMOUNT) then
		player:sendCancelMessage("You don't have enough capacity.")
		player:getPosition():sendMagicEffect(CONST_ME_POFF)
		return true
	end

	local addedItem = player:addItem(kegConfig.potion, POTION_AMOUNT, true)
	if not addedItem then
		player:sendCancelMessage("Could not add the potions. Check your capacity.")
		player:getPosition():sendMagicEffect(CONST_ME_POFF)
		return true
	end

	if not kegCooldowns[playerId] then
		kegCooldowns[playerId] = {}
	end
	kegCooldowns[playerId][itemId] = currentTime + COOLDOWN_TIME

	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You received " .. POTION_AMOUNT .. " " .. kegConfig.name .. "s from the keg.")
	player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)

	return true
end

for kegId, _ in pairs(kegs) do
	local keg = Action()
	keg:id(kegId)
	keg.onUse = onUseKeg
	keg:register()
end
