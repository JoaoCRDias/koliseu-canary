-- Auto-create Badge Bag on login if player doesn't have one in store inbox

local badgeBagAutoCreate = CreatureEvent("BadgeBagAutoCreate")
local BADGE_BAG_MIGRATION_KEY = "badge-bag-migration-20260203"

function badgeBagAutoCreate.onLogin(player)
	-- Get store inbox
	local storeInbox = player:getStoreInbox()
	if not storeInbox then
		return true
	end

	-- Check if player already has a badge bag in store inbox
	local badgeBagItem = nil
	for i = 0, storeInbox:getSize() - 1 do
		local item = storeInbox:getItem(i)
		if item and item:getId() == BadgeBag.config.CONTAINER_ID then
			badgeBagItem = item
			break
		end
	end

	-- If no badge bag found, create one
	if not badgeBagItem then
		local badgeBag = BadgeBag.createBadgeBag(player)
		if badgeBag then
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "A Badge Bag has been added to your store inbox!")
			player:kv():set(BADGE_BAG_MIGRATION_KEY, true)
		end
	elseif not player:kv():get(BADGE_BAG_MIGRATION_KEY) then
		local container = Container(badgeBagItem:getUniqueId())
		if container then
			BadgeBag.ensureBadgeBagScaffold(container, player)
			player:kv():set(BADGE_BAG_MIGRATION_KEY, true)
		end
	end

	return true
end

badgeBagAutoCreate:register()
