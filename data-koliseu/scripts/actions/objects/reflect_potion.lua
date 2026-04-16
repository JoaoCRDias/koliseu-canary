local reflectPotion = Action()

function reflectPotion.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local kv = player:kv()
	local currentSkill = kv:get("reflect_skill") or 0

	if currentSkill >= 100 then
		player:sendCancelMessage("Your reflect skill is already at the maximum level.")
		return true
	end

	item:remove(1) -- Remove o item após o uso

	local chance = math.random(1, 100)
	if chance <= 50 then
		local newSkill = currentSkill + 1
		if newSkill > 100 then newSkill = 100 end

		kv:set("reflect_skill", newSkill)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Your reflect skill increased to " .. newSkill .. "!")
	else
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You failed to improve your reflect skill.")
	end

	return true
end

reflectPotion:id(49272)
reflectPotion:register()
