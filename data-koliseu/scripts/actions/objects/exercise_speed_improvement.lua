local EXERCISE_SPEED_KV = "exercise-speed-improvement"
local DURATION = 3 * 60 * 60

local function consumeCharge(item)
	if item:hasAttribute(ITEM_ATTRIBUTE_CHARGES) then
		local charges = item:getAttribute(ITEM_ATTRIBUTE_CHARGES) or 0
		if charges > 1 then
			item:setAttribute(ITEM_ATTRIBUTE_CHARGES, charges - 1)
		else
			item:remove(1)
		end
		return
	end

	item:remove(1)
end

local action = Action()
function action.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local kv = player:kv():scoped(EXERCISE_SPEED_KV)
	local remaining = kv:get("remaining") or 0
	remaining = remaining + DURATION
	kv:set("remaining", remaining)

	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You gained 3 hours of boosted exercise training.")
	player:getPosition():sendMagicEffect(CONST_ME_MAGIC_GREEN)

	consumeCharge(item)
	return true
end

action:id(60647)
action:register()
