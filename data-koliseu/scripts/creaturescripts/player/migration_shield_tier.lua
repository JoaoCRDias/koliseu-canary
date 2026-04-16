-- Migration: Remove tier from shields on login (one-time per player)
-- Storage 50010 = migration flag

local STORAGE_MIGRATION_SHIELD_TIER = 50010

local function removeShieldTierFromContainer(container)
	local count = 0
	if not container then
		return count
	end

	for i = 0, container:getSize() - 1 do
		local item = container:getItem(i)
		if item then
			if item:isContainer() then
				count = count + removeShieldTierFromContainer(item)
			else
				local itemType = ItemType(item:getId())
				if itemType and itemType:getWeaponType() == WEAPON_SHIELD and item:getTier() > 0 then
					item:setTier(0)
					count = count + 1
				end
			end
		end
	end
	return count
end

local migrationShieldTier = CreatureEvent("MigrationShieldTier")

function migrationShieldTier.onLogin(player)
	if player:getStorageValue(STORAGE_MIGRATION_SHIELD_TIER) == 1 then
		return true
	end

	local count = 0

	-- Check all equipment slots
	for slot = CONST_SLOT_HEAD, CONST_SLOT_AMMO do
		local item = player:getSlotItem(slot)
		if item then
			local itemType = ItemType(item:getId())
			if itemType and itemType:getWeaponType() == WEAPON_SHIELD and item:getTier() > 0 then
				item:setTier(0)
				count = count + 1
			end

			-- Check inside containers (backpack etc)
			if item:isContainer() then
				count = count + removeShieldTierFromContainer(item)
			end
		end
	end

	if count > 0 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("Migration: tier removed from %d shield(s).", count))
	end

	player:setStorageValue(STORAGE_MIGRATION_SHIELD_TIER, 1)
	return true
end

migrationShieldTier:register()
