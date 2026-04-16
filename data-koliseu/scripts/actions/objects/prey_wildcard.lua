local preyWildcard = Action()

-- Config
local PREY_WILDCARDS_PER_USE = 20
local MAX_PREY_WILDCARDS = (GameStore and GameStore.ItemLimit and GameStore.ItemLimit.PREY_WILDCARD) or 500

function preyWildcard.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local current = player:getPreyCards() or 0

	if current >= MAX_PREY_WILDCARDS then
		player:sendCancelMessage("You already have the maximum of prey wildcards.")
		return true
	end

	local toAdd = PREY_WILDCARDS_PER_USE
	if current + toAdd > MAX_PREY_WILDCARDS then
		toAdd = MAX_PREY_WILDCARDS - current
	end

	player:addPreyCards(toAdd)
	player:getPosition():sendMagicEffect(CONST_ME_MAGIC_GREEN)
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("You received %d Prey Wildcard%s.", toAdd, toAdd == 1 and "" or "s"))

	item:remove(1) -- consume the item
	return true
end

preyWildcard:id(60101)
preyWildcard:register()
