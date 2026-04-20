local ELIGIBLE_ACCOUNTS = {
	[2] = true,
	[11] = true, [12] = true, [13] = true, [310] = true, [22] = true,
	[24] = true, [26] = true, [517] = true, [34] = true, [36] = true,
	[40] = true, [1076] = true, [754] = true, [293] = true, [100] = true,
	[304] = true, [120] = true, [121] = true, [163] = true, [197] = true,
	[212] = true, [214] = true, [219] = true, [910] = true, [306] = true,
	[904] = true, [224] = true, [210] = true, [281] = true, [291] = true,
	[1058] = true, [300] = true, [353] = true, [427] = true, [308] = true,
	[315] = true, [341] = true, [153] = true, [430] = true, [466] = true,
	[469] = true, [516] = true, [531] = true, [533] = true, [571] = true,
	[580] = true, [143] = true, [615] = true, [662] = true, [682] = true,
	[297] = true, [679] = true, [277] = true, [753] = true, [641] = true,
	[1044] = true, [749] = true, [782] = true, [808] = true, [831] = true,
	[920] = true, [950] = true, [991] = true,
}

local REWARD_ITEMS = { 52664, 5958, 62001 }
local KV_KEY = "survivor-season-reward"

local survivorReward = TalkAction("!survivor")

function survivorReward.onSay(player, words, param)
	local accountId = player:getAccountId()

	if not ELIGIBLE_ACCOUNTS[accountId] then
		player:sendTextMessage(MESSAGE_LOOK, "Your account is not eligible for the survivor reward.")
		return true
	end

	local kvScope = kv.scoped("account-rewards"):scoped(tostring(accountId))
	if kvScope:get(KV_KEY) then
		player:sendTextMessage(MESSAGE_LOOK, "You have already claimed your survivor reward on this account.")
		return true
	end

	local inbox = player:getStoreInbox()
	if not inbox then
		player:sendTextMessage(MESSAGE_LOOK, "Could not access your store inbox. Please try again.")
		return true
	end

	local inboxItems = inbox:getItems()
	if #inboxItems + #REWARD_ITEMS > inbox:getMaxCapacity() then
		player:sendTextMessage(MESSAGE_LOOK, "Your store inbox does not have enough free slots. Please free up space and try again.")
		return true
	end

	for _, itemId in ipairs(REWARD_ITEMS) do
		inbox:addItem(itemId, 1)
	end

	kv.scoped("account-rewards"):scoped(tostring(accountId)):set(KV_KEY, true)
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have claimed your survivor season reward! Check your store inbox.")
	return true
end

survivorReward:separator(" ")
survivorReward:groupType("normal")
survivorReward:register()
