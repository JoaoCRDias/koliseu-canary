-- Antidote vial dropped by gloom spores in the poison room.
--   * Used on the central pedestal (aid) → adds one charge to the mechanism.
--   * Used on self (no target / target is the player) → resets the player's
--     curse tier back to 1, subject to a short cooldown.

local antidote = Action()

local function depositOnMechanism(player, item)
	if not SupremeVocation.poisonRoomIsActive() then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The pedestal is dormant.")
		return true
	end

	local accepted = SupremeVocation.poisonRoomDeposit(player)
	if not accepted then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The pedestal is already saturated.")
		return true
	end

	item:remove(1)
	local cfg = SupremeVocation.PoisonRoom
	local count = SupremeVocation.poisonRoomGetMechanismCount()
	for _, p in ipairs(SupremeVocation.poisonRoomGetPlayers()) do
		p:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format(
			"The pedestal absorbs the antidote. %d of %d offerings.",
			count, cfg.mechanismRequired))
	end
	cfg.center:sendMagicEffect(CONST_ME_MAGIC_GREEN)

	if count >= cfg.mechanismRequired then
		SupremeVocation.poisonRoomComplete()
	end
	return true
end

local function drink(player, item)
	if not SupremeVocation.poisonRoomCanDrink(player) then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Your stomach rejects another vial so soon.")
		return true
	end
	item:remove(1)
	SupremeVocation.poisonRoomMarkDrink(player)
	SupremeVocation.poisonRoomResetPlayerCurse(player)
	player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You drink the antidote. The curse loosens its grip.")
	return true
end

function antidote.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	-- If the player used the vial ON the pedestal, deposit it.
	if target and target.actionid == SupremeVocation.PoisonMechanismActionId then
		return depositOnMechanism(player, item)
	end
	-- Otherwise treat as a drink.
	return drink(player, item)
end

antidote:id(SupremeVocation.PoisonRoom.antidoteItemId)
antidote:register()
