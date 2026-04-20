local forgeTestItems = TalkAction("/forgetest")

local FORGE_ITEMS = {
	{ name = "Energy Protector", count = 1 },
	{ name = "Fire Protector", count = 1 },
	{ name = "Death Protector", count = 1 },
	{ name = "Ice Protector", count = 1 },
	{ name = "Holy Protector", count = 1 },
	{ name = "Earth Protector", count = 1 },
	{ name = "Tainted Heart", count = 1000 },
	{ name = "Darklight Heart", count = 1000 },
	{ name = "The Essence Of Murcion", count = 10 },
	{ name = "The Essence Of Ichgahal", count = 10 },
	{ name = "The Essence Of Vemiath", count = 10 },
	{ name = "The Essence Of Chagorz", count = 10 },
	{ name = "Bakragore's Amalgamation", count = 10 },
	{ name = "Silver Token", count = 1000 },
	{ name = "Gold Token", count = 1000 },
}

function forgeTestItems.onSay(player, words, param)
	local added = 0
	local failed = {}

	for _, entry in ipairs(FORGE_ITEMS) do
		local itemType = ItemType(entry.name)
		if itemType:getId() == 0 then
			table.insert(failed, entry.name)
		else
			if itemType:isStackable() then
				local remaining = entry.count
				local stackSize = itemType:getStackSize()
				while remaining > 0 do
					local countToAdd = math.min(remaining, stackSize)
					local item = player:addItem(itemType:getId(), countToAdd)
					if item then
						remaining = remaining - countToAdd
					else
						break
					end
				end
			else
				for i = 1, entry.count do
					player:addItem(itemType:getId(), 1)
				end
			end
			added = added + 1
		end
	end

	if #failed > 0 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Forge test items created (" .. added .. "/" .. #FORGE_ITEMS .. "). Failed: " .. table.concat(failed, ", "))
	else
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "All " .. added .. " forge test items created successfully.")
	end

	player:getPosition():sendMagicEffect(CONST_ME_MAGIC_GREEN)
	return true
end

forgeTestItems:separator(" ")
forgeTestItems:groupType("god")
forgeTestItems:register()
