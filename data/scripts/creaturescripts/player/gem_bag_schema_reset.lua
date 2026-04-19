local migrationScope = "gembag"
local migrationKey = "schema-reset-202602061"

local SHOPPING_BAG_ID = 21411

local gemBagSchemaReset = CreatureEvent("GemBagSchemaReset")

local function collectGemIds(container)
	if not container then
		return {}
	end

	local gemIds = {}
	local size = container:getSize()
	for slot = 0, size - 1 do
		local slotItem = container:getItem(slot)
		if slotItem and GemBag.isGem(slotItem) then
			table.insert(gemIds, slotItem:getId())
		end
	end
	return gemIds
end

function gemBagSchemaReset.onLogin(player)
	if not GemBag then
		return true
	end

	local kv = player:kv():scoped(migrationScope)
	if kv:get(migrationKey) then
		return true
	end

	local storeInbox = player:getStoreInbox()
	if not storeInbox then
		return true
	end

	local allGemIds = {}
	local bagCount = 0

	GemBag.scanPlayerGemBags(player, function(bagItem, bagContainer)
		bagCount = bagCount + 1
		local gemIds = collectGemIds(bagContainer)
		for _, gemId in ipairs(gemIds) do
			table.insert(allGemIds, gemId)
		end
		bagItem:remove()
		return false
	end)

	if bagCount == 0 then
		kv:set(migrationKey, true)
		return true
	end

	if #allGemIds > 0 then
		local shoppingBag = storeInbox:addItem(SHOPPING_BAG_ID, 1, INDEX_WHEREEVER, FLAG_NOLIMIT)
		if shoppingBag then
			local shoppingContainer = Container(shoppingBag:getUniqueId())
			if shoppingContainer then
				local addedCount = 0
				for _, gemId in ipairs(allGemIds) do
					local newGem = shoppingContainer:addItem(gemId, 1, INDEX_WHEREEVER, FLAG_NOLIMIT)
					if newGem then
						addedCount = addedCount + 1
					end
				end

				if addedCount > 0 then
					player:sendTextMessage(
						MESSAGE_EVENT_ADVANCE,
						string.format("Uma Shopping Bag com %d gema(s) da sua Gem Bag foi enviada para sua Store Inbox.", addedCount)
					)
				end
			end
		else
			player:sendTextMessage(MESSAGE_FAILURE, "Não foi possível criar a Shopping Bag. Entre em contato com um administrador.")
		end
	end

	GemBag.invalidateCache(player)

	local hasExtender = GemBag.playerHasExtender(player)
	local newBag = GemBag.createGemBag(player, { player = player, hasExtender = hasExtender })
	if not newBag then
		player:sendTextMessage(MESSAGE_FAILURE, "Não foi possível recriar sua Gem Bag. Entre em contato com um administrador.")
		return true
	end

	GemBag.invalidateCache(player)
	GemBag.applyStatBonuses(player)

	kv:set(migrationKey, true)

	return true
end

gemBagSchemaReset:register()
