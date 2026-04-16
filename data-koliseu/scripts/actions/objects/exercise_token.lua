local config = {
	charges = 14400,
	items = {
		{ id = 35285 },
		{ id = 35286 },
		{ id = 35287 },
		{ id = 35288 },
		{ id = 35289 },
		{ id = 35290 },
		{ id = 44067 },
	},
}

local function sendExerciseRewardModal(player, item)
	local window = ModalWindow({
		title = "Exercise Reward",
		message = "choose a item",
	})
	for _, it in pairs(config.items) do
		local iType = ItemType(it.id)
		if iType then
			window:addChoice(iType:getName(), function(player, button, choice)
				if button.name ~= "Select" then
					return true
				end

				local inbox = player:getStoreInbox()
				local inboxItems = inbox:getItems()
				if inbox and #inboxItems < inbox:getMaxCapacity() and player:getFreeCapacity() >= iType:getWeight() then
					local exercise = inbox:addItem(it.id, it.charges)
					if exercise then
						exercise:setActionId(IMMOVABLE_ACTION_ID)
						exercise:setAttribute(ITEM_ATTRIBUTE_STORE, systemTime())
						exercise:setAttribute(ITEM_ATTRIBUTE_DESCRIPTION, "You received a exercise weapon.")
					else
						player:sendTextMessage(MESSAGE_LOOK, "You need to have capacity and empty slots to receive.")
						return
					end
					item:remove(1)
				else
					player:sendTextMessage(MESSAGE_LOOK, "You need to have capacity and empty slots to receive.")
				end
			end)
		end
	end
	window:addButton("Select")
	window:addButton("Close")
	window:setDefaultEnterButton(0)
	window:setDefaultEscapeButton(1)
	window:sendToPlayer(player)
end

local exerciseRewardModal = Action()
function exerciseRewardModal.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	sendExerciseRewardModal(player, item)
	return true
end

exerciseRewardModal:id(60141)
exerciseRewardModal:register()
