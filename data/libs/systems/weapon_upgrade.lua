WeaponUpgrade = {
	-- Item IDs
	EPIC_STONE = 60427,
	MEDIUM_STONE = 60428,
	BASIC_STONE = 60429,

	-- Maximum upgrade levels per stone type
	MAX_LEVEL = {
		[60427] = 12, -- Epic Stone
		[60428] = 7, -- Medium Stone
		[60429] = 4, -- Basic Stone
	},

	-- Success chances per upgrade level and stone type
	-- Format: [upgrade_level] = { [stone_id] = chance }
	-- Epic Stone (60427): up to +12, Medium Stone (60428): up to +7, Basic Stone (60429): up to +4
	-- Higher tier stones have better chances at all levels they can use
	SUCCESS_CHANCE = {
		[0] = { [60427] = 100, [60428] = 100, [60429] = 100 }, -- +0 -> +1
		[1] = { [60427] = 95, [60428] = 90, [60429] = 80 }, -- +1 -> +2
		[2] = { [60427] = 90, [60428] = 80, [60429] = 65 }, -- +2 -> +3
		[3] = { [60427] = 85, [60428] = 70, [60429] = 50 }, -- +3 -> +4
		[4] = { [60427] = 65, [60428] = 55, [60429] = 0 }, -- +4 -> +5 (Basic can't go past +4)
		[5] = { [60427] = 45, [60428] = 40, [60429] = 0 }, -- +5 -> +6
		[6] = { [60427] = 30, [60428] = 25, [60429] = 0 }, -- +6 -> +7
		[7] = { [60427] = 25, [60428] = 0, [60429] = 0 }, -- +7 -> +8 (Medium can't go past +7)
		[8] = { [60427] = 20, [60428] = 0, [60429] = 0 }, -- +8 -> +9
		[9] = { [60427] = 15, [60428] = 0, [60429] = 0 }, -- +9 -> +10
		[10] = { [60427] = 10, [60428] = 0, [60429] = 0 }, -- +10 -> +11
		[11] = { [60427] = 5, [60428] = 0, [60429] = 0 }, -- +11 -> +12
	},

	-- Attack bonus to ADD per upgrade level (incremental, not total)
	ATTACK_BONUS_PER_LEVEL = {
		[1] = 1, -- +0 -> +1: add 1 attack
		[2] = 1, -- +1 -> +2: add 1 attack
		[3] = 1, -- +2 -> +3: add 1 attack
		[4] = 1, -- +3 -> +4: add 1 attack
		[5] = 1, -- +4 -> +5: add 1 attack
		[6] = 1, -- +5 -> +6: add 1 attack
		[7] = 1, -- +6 -> +7: add 1 attack
		[8] = 2, -- +7 -> +8: add 2 attack
		[9] = 2, -- +8 -> +9: add 2 attack
		[10] = 2, -- +9 -> +10: add 2 attack
		[11] = 2, -- +10 -> +11: add 2 attack
		[12] = 2, -- +11 -> +12: add 2 attack
	},

	-- Stone type names for messages
	STONE_NAMES = {
		[60427] = "Epic Upgrade Stone",
		[60428] = "Medium Upgrade Stone",
		[60429] = "Basic Upgrade Stone",
	},
}

function WeaponUpgrade.isWeapon(item)
	if not item or not item:isItem() then
		return false
	end

	local itemType = item:getType()
	local weaponType = itemType:getWeaponType()

	-- Only allow weapons/wands/rods/bows/crossbows (distance)
	return weaponType == WEAPON_SWORD
			or weaponType == WEAPON_AXE
			or weaponType == WEAPON_CLUB
			or weaponType == WEAPON_DISTANCE
			or weaponType == WEAPON_WAND
			or weaponType == WEAPON_ROD
			or weaponType == WEAPON_FIST
end

function WeaponUpgrade.getCurrentLevel(item)
	return item:getCustomAttribute("upgrade_level") or 0
end

function WeaponUpgrade.getSuccessChance(currentLevel, stoneId)
	if not WeaponUpgrade.SUCCESS_CHANCE[currentLevel] then
		return 0
	end
	return WeaponUpgrade.SUCCESS_CHANCE[currentLevel][stoneId] or 0
end

function WeaponUpgrade.getMaxLevel(stoneId)
	return WeaponUpgrade.MAX_LEVEL[stoneId] or 0
end

function WeaponUpgrade.canUpgrade(item, stoneId)
	local currentLevel = WeaponUpgrade.getCurrentLevel(item)
	local maxLevel = WeaponUpgrade.getMaxLevel(stoneId)
	local successChance = WeaponUpgrade.getSuccessChance(currentLevel, stoneId)

	return currentLevel < maxLevel and successChance > 0
end

function WeaponUpgrade.getAttackBonusForLevel(level)
	-- Returns how much attack to ADD when upgrading TO this level
	return WeaponUpgrade.ATTACK_BONUS_PER_LEVEL[level] or 1
end

function WeaponUpgrade.getTotalAttackBonus(level)
	-- Returns total attack bonus for a given upgrade level
	local total = 0
	for i = 1, level do
		total = total + WeaponUpgrade.getAttackBonusForLevel(i)
	end
	return total
end

function WeaponUpgrade.updateWeaponName(item)
	local currentLevel = WeaponUpgrade.getCurrentLevel(item)
	if currentLevel == 0 then
		-- Remove custom name if no upgrade
		item:removeAttribute(ITEM_ATTRIBUTE_NAME)
		return
	end

	local itemType = item:getType()
	local baseName = itemType:getName()
	local newName = string.format("%s +%d", baseName, currentLevel)
	item:setAttribute(ITEM_ATTRIBUTE_NAME, newName)
end

function WeaponUpgrade.updateWeaponDescription(item)
	local currentLevel = WeaponUpgrade.getCurrentLevel(item)
	if currentLevel == 0 then
		item:removeAttribute(ITEM_ATTRIBUTE_DESCRIPTION)
		return
	end

	local totalBonus = WeaponUpgrade.getTotalAttackBonus(currentLevel)
	local description = string.format("This weapon has been upgraded to level +%d.\nAttack bonus: +%d", currentLevel, totalBonus)
	item:setAttribute(ITEM_ATTRIBUTE_DESCRIPTION, description)
end

function WeaponUpgrade.performUpgrade(player, weapon, stone)
	-- Validate items still exist
	if not weapon or not stone then
		player:sendCancelMessage("The weapon or stone could not be found.")
		return false
	end

	local currentLevel = WeaponUpgrade.getCurrentLevel(weapon)
	local stoneId = stone:getId()
	local successChance = WeaponUpgrade.getSuccessChance(currentLevel, stoneId)

	-- Roll for success
	local roll = math.random(1, 10000) / 100 -- 0.01 to 100.00
	local success = roll <= successChance

	-- Remove the stone
	stone:remove(1)

	if success then
		-- Upgrade successful
		local newLevel = currentLevel + 1
		local attackBonusToAdd = WeaponUpgrade.getAttackBonusForLevel(newLevel)

		-- Update weapon attributes
		weapon:setCustomAttribute("upgrade_level", newLevel)

		-- Increase attack
		local currentAttack = weapon:getAttribute(ITEM_ATTRIBUTE_ATTACK)

		-- If currentAttack is nil or 0, get it from item type
		if not currentAttack or currentAttack == 0 then
			local itemType = weapon:getType()
			currentAttack = itemType:getAttack()
		end

		local newAttack = currentAttack + attackBonusToAdd
		weapon:setAttribute(ITEM_ATTRIBUTE_ATTACK, newAttack)

		-- Update name and description
		WeaponUpgrade.updateWeaponName(weapon)
		WeaponUpgrade.updateWeaponDescription(weapon)

		-- Visual effects and message
		weapon:getPosition():sendMagicEffect(CONST_ME_MAGIC_GREEN)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("Success! Your weapon has been upgraded to level +%d!", newLevel))

		return true
	else
		-- Upgrade failed
		weapon:getPosition():sendMagicEffect(CONST_ME_BLOCKHIT)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The upgrade failed! The stone was consumed but your weapon remains intact.")

		return false
	end
end

function WeaponUpgrade.showUpgradeModal(player, weapon, stone)
	local currentLevel = WeaponUpgrade.getCurrentLevel(weapon)
	local stoneId = stone:getId()
	local successChance = WeaponUpgrade.getSuccessChance(currentLevel, stoneId)
	local nextLevel = currentLevel + 1
	local attackBonusToAdd = WeaponUpgrade.getAttackBonusForLevel(nextLevel)
	local totalBonusAfterUpgrade = WeaponUpgrade.getTotalAttackBonus(nextLevel)
	local stoneName = WeaponUpgrade.STONE_NAMES[stoneId] or "Upgrade Stone"

	local itemType = weapon:getType()
	local weaponName = itemType:getName()

	-- Create a confirmation key to store the upgrade data
	local confirmKey = "upgrade_confirm_" .. player:getId()

	-- Store weapon and stone in a global table for later retrieval
	if not _G.UpgradeConfirmations then
		_G.UpgradeConfirmations = {}
	end

	_G.UpgradeConfirmations[confirmKey] = {
		weapon = weapon,
		stone = stone,
		player = player
	}

	local message = string.format([[Upgrade Weapon with %s?

Weapon: %s
Current Level: +%d
Target Level: +%d
Success Chance: %.2f%%
Attack Bonus on Success: +%d
Total Attack Bonus at +%d: +%d

SUCCESS: Weapon upgraded to +%d
FAILURE: Stone consumed, weapon remains at +%d]], stoneName, weaponName, currentLevel, nextLevel, successChance, attackBonusToAdd, nextLevel, totalBonusAfterUpgrade, nextLevel, currentLevel)

	local modal = ModalWindow({
		title = "Weapon Upgrade System",
		message = message,
	})

	modal:addButton("Confirm")
	modal:addButton("Cancel")
	modal:setDefaultEnterButton(1)
	modal:setDefaultEscapeButton(2)

	modal:setDefaultCallback(function(clickedPlayer, button)
		local data = _G.UpgradeConfirmations[confirmKey]

		if button.id == 1 and data then
			-- Perform the upgrade
			WeaponUpgrade.performUpgrade(clickedPlayer, data.weapon, data.stone)
		else
			clickedPlayer:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Upgrade cancelled.")
		end
		-- Clean up
		_G.UpgradeConfirmations[confirmKey] = nil
	end)

	modal:sendToPlayer(player)
end

return WeaponUpgrade
