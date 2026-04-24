local weaponUpgrade = require("data.libs.systems.weapon_upgrade")

local upgradeStone = Action()

function upgradeStone.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	-- Check if target exists and is an item
	if not target or type(target) ~= "userdata" or not target:isItem() then
		player:sendCancelMessage("You need to use this stone on a weapon.")
		return false
	end

	-- Prevent using stone on itself
	if item:getUniqueId() == target:getUniqueId() then
		player:sendCancelMessage("You cannot use the stone on itself.")
		return false
	end

	-- Check if target is a weapon
	if not weaponUpgrade.isWeapon(target) then
		player:sendCancelMessage("You can only use upgrade stones on weapons (swords, axes, clubs, distance weapons, wands, rods).")
		return false
	end

	local stoneId = item:getId()
	local currentLevel = weaponUpgrade.getCurrentLevel(target)
	local maxLevel = weaponUpgrade.getMaxLevel(stoneId)

	-- Check if weapon can be upgraded with this stone
	if currentLevel >= maxLevel then
		local stoneName = weaponUpgrade.STONE_NAMES[stoneId] or "This stone"
		player:sendCancelMessage(string.format("%s can only upgrade weapons up to level +%d.", stoneName, maxLevel))
		return false
	end

	-- Check if upgrade is possible
	if not weaponUpgrade.canUpgrade(target, stoneId) then
		player:sendCancelMessage("This weapon cannot be upgraded with this stone.")
		return false
	end

	-- Show upgrade confirmation modal
	weaponUpgrade.showUpgradeModal(player, target, item)

	return true
end

-- Register all three upgrade stone types
upgradeStone:id(weaponUpgrade.BASIC_STONE, weaponUpgrade.MEDIUM_STONE, weaponUpgrade.EPIC_STONE)
upgradeStone:register()
