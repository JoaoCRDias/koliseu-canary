SkillGems = {
	-- Gem IDs
	PALADIN_GEM = 58051,
	MAGE_GEM = 58052,
	MONK_GEM = 58053,
	KNIGHT_GEM = 58054,

	-- Maximum skill bonus level
	MAX_LEVEL = 10,

	-- Success chances per level
	SUCCESS_CHANCE = {
		[0] = 70, -- +0 -> +1: 100%
		[1] = 60, -- +1 -> +2: 80%
		[2] = 50, -- +2 -> +3: 60%
		[3] = 40, -- +3 -> +4: 40%
		[4] = 30, -- +4 -> +5: 30%
		[5] = 22, -- +5 -> +6: 22%
		[6] = 16, -- +6 -> +7: 16%
		[7] = 12, -- +7 -> +8: 12%
		[8] = 8, -- +8 -> +9: 8%
		[9] = 6, -- +9 -> +10: 6%
	},

	-- Chance to lose level on failure (only applies to +9 and +10 upgrades)
	DOWNGRADE_CHANCE = 10,
	DOWNGRADE_MIN_LEVEL = 7, -- downgrade only happens when current level >= this

	-- Gem type configurations
	GEM_TYPES = {
		[58051] = {
			name = "Paladin Skill Gem",
			skillType = "distance",
			description = "Distance Fighting",
		},
		[58052] = {
			name = "Mage Skill Gem",
			skillType = "magic",
			description = "Magic Level",
		},
		[58053] = {
			name = "Monk Skill Gem",
			skillType = "fist",
			description = "Fist Fighting",
		},
		[58054] = {
			name = "Knight Skill Gem",
			skillType = "melee",
			description = "Melee Skills (Sword, Axe, Club)",
		},
	},
}

-- Check if item is valid equipment (helmet, armor, legs, boots)
function SkillGems.isValidEquipment(item)
	if not item or not item:isItem() then
		return false
	end

	local itemType = item:getType()
	local slotPosition = itemType:getSlotPosition()

	-- Check if it's helmet, armor, legs or boots using bitwise AND
	-- Items can have multiple slot flags, so we need to check if ANY of these flags are set
	if bit.band(slotPosition, SLOTP_HEAD) ~= 0 then
		return true
	end
	if bit.band(slotPosition, SLOTP_ARMOR) ~= 0 then
		return true
	end
	if bit.band(slotPosition, SLOTP_LEGS) ~= 0 then
		return true
	end
	if bit.band(slotPosition, SLOTP_FEET) ~= 0 then
		return true
	end

	return false
end

-- Get current skill bonus level from equipment
function SkillGems.getCurrentLevel(item, gemId)
	local gemInfo = SkillGems.GEM_TYPES[gemId]
	if not gemInfo then
		return 0
	end

	local attributeKey = string.format("skill_gem_%s_level", gemInfo.skillType)
	return item:getCustomAttribute(attributeKey) or 0
end

-- Get success chance for current level
function SkillGems.getSuccessChance(currentLevel)
	return SkillGems.SUCCESS_CHANCE[currentLevel] or 0
end

-- Check if equipment has any skill bonus from other gem types
function SkillGems.getEquipmentGemType(equipment)
	for gemId, gemInfo in pairs(SkillGems.GEM_TYPES) do
		local level = SkillGems.getCurrentLevel(equipment, gemId)
		if level > 0 then
			return gemId, gemInfo
		end
	end
	return nil, nil
end

-- Apply skill gem to equipment
function SkillGems.applyGem(player, gem, equipment)
	local gemId = gem:getId()
	local gemInfo = SkillGems.GEM_TYPES[gemId]

	if not gemInfo then
		player:sendCancelMessage("Invalid skill gem.")
		return false
	end

	-- Check if equipment has a different gem type
	local existingGemId, existingGemInfo = SkillGems.getEquipmentGemType(equipment)
	if existingGemId and existingGemId ~= gemId then
		player:sendCancelMessage(string.format("This equipment already has %s bonus. You can only use one type of skill gem per equipment.", existingGemInfo.description))
		return false
	end

	-- Get current level
	local currentLevel = SkillGems.getCurrentLevel(equipment, gemId)

	-- Check if already at max level
	if currentLevel >= SkillGems.MAX_LEVEL then
		player:sendCancelMessage(string.format("This equipment already has the maximum %s bonus (+%d).", gemInfo.description, SkillGems.MAX_LEVEL))
		return false
	end

	-- Get success chance
	local successChance = SkillGems.getSuccessChance(currentLevel)
	local nextLevel = currentLevel + 1

	-- Show confirmation modal
	SkillGems.showGemModal(player, gem, equipment, gemInfo, currentLevel, nextLevel, successChance)

	return true
end

-- Show confirmation modal
function SkillGems.showGemModal(player, gem, equipment, gemInfo, currentLevel, nextLevel, successChance)
	local itemType = equipment:getType()
	local equipmentName = itemType:getName()

	local canDowngrade = currentLevel >= (SkillGems.DOWNGRADE_MIN_LEVEL or 0) and currentLevel > 0
	local message
	if canDowngrade then
		message = string.format([[Apply %s?

Equipment: %s
Current %s Bonus: +%d
Target Bonus: +%d
Success Chance: %.2f%%

SUCCESS: Bonus increased to +%d
FAILURE (%.0f%%): Gem consumed, bonus stays at +%d
FAILURE (%.0f%%): Gem consumed, bonus REDUCED to +%d

Continue?]], gemInfo.name, equipmentName, gemInfo.description, currentLevel, nextLevel, successChance, nextLevel, (100 - successChance) * 0.9, currentLevel, (100 - successChance) * 0.1, math.max(0, currentLevel - 1))
	else
		message = string.format([[Apply %s?

Equipment: %s
Current %s Bonus: +%d
Target Bonus: +%d
Success Chance: %.2f%%

SUCCESS: Bonus increased to +%d
FAILURE (%.0f%%): Gem consumed, bonus stays at +%d

Continue?]], gemInfo.name, equipmentName, gemInfo.description, currentLevel, nextLevel, successChance, nextLevel, (100 - successChance), currentLevel)
	end

	local modal = ModalWindow({
		title = "Skill Gem Application",
		message = message,
	})

	modal:addButton("Confirm")
	modal:addButton("Cancel")
	modal:setDefaultEnterButton(1)
	modal:setDefaultEscapeButton(2)

	-- Store data for callback
	local confirmKey = "skill_gem_" .. player:getId()
	if not _G.SkillGemConfirmations then
		_G.SkillGemConfirmations = {}
	end

	_G.SkillGemConfirmations[confirmKey] = {
		gem = gem,
		equipment = equipment,
		gemInfo = gemInfo,
		currentLevel = currentLevel,
		nextLevel = nextLevel,
		successChance = successChance
	}

	modal:setDefaultCallback(function(clickedPlayer, button)
		local data = _G.SkillGemConfirmations[confirmKey]
		if button.id == 1 and data then
			-- Perform application
			SkillGems.performApplication(clickedPlayer, data.gem, data.equipment, data.gemInfo, data.currentLevel, data.nextLevel, data.successChance)
		else
			clickedPlayer:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Skill gem application cancelled.")
		end
		-- Clean up
		_G.SkillGemConfirmations[confirmKey] = nil
	end)

	modal:sendToPlayer(player)
end

-- Perform the actual gem application
function SkillGems.performApplication(player, gem, equipment, gemInfo, currentLevel, nextLevel, successChance)
	-- Validate items still exist
	if not gem or not equipment then
		player:sendCancelMessage("Item not found.")
		return false
	end

	-- Roll for success
	local roll = math.random(1, 10000) / 100
	local success = roll <= successChance

	-- Remove the gem
	gem:remove(1)

	if success then
		-- Success - increase skill bonus
		SkillGems.setSkillBonus(equipment, gemInfo, nextLevel)

		-- Visual effects and message
		equipment:getPosition():sendMagicEffect(CONST_ME_MAGIC_GREEN)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("Success! %s bonus increased to +%d!", gemInfo.description, nextLevel))

		return true
	else
		-- Failure - check if should downgrade (only at high levels)
		local downgradeRoll = math.random(1, 100)
		local canDowngrade = currentLevel >= (SkillGems.DOWNGRADE_MIN_LEVEL or 0) and currentLevel > 0
		local shouldDowngrade = canDowngrade and downgradeRoll <= SkillGems.DOWNGRADE_CHANCE

		if shouldDowngrade then
			-- Downgrade by 1 level
			local newLevel = currentLevel - 1
			SkillGems.setSkillBonus(equipment, gemInfo, newLevel)

			equipment:getPosition():sendMagicEffect(CONST_ME_BLOCKHIT)
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("Failed! %s bonus reduced to +%d.", gemInfo.description, newLevel))
		else
			-- Failed but no downgrade
			equipment:getPosition():sendMagicEffect(CONST_ME_POFF)
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("Failed! Gem consumed but %s bonus remains at +%d.", gemInfo.description, currentLevel))
		end

		return false
	end
end

-- Set skill bonus on equipment
function SkillGems.setSkillBonus(equipment, gemInfo, level)
	local attributeKey = string.format("skill_gem_%s_level", gemInfo.skillType)

	if level > 0 then
		-- Set the custom attribute
		equipment:setCustomAttribute(attributeKey, level)

		-- Update equipment name and description
		SkillGems.updateEquipmentName(equipment)
		SkillGems.updateEquipmentDescription(equipment)
	else
		-- Remove bonus
		equipment:removeCustomAttribute(attributeKey)
		equipment:removeAttribute(ITEM_ATTRIBUTE_NAME)
		equipment:removeAttribute(ITEM_ATTRIBUTE_DESCRIPTION)
	end
end

-- Update equipment name to show skill bonus
function SkillGems.updateEquipmentName(equipment)
	-- Don't change the name, just keep it as is
	-- Bonuses will be shown only in description
	equipment:removeAttribute(ITEM_ATTRIBUTE_NAME)
end

-- Update equipment description
function SkillGems.updateEquipmentDescription(equipment)
	local descriptions = {}

	for gemId, gemInfo in pairs(SkillGems.GEM_TYPES) do
		local level = SkillGems.getCurrentLevel(equipment, gemId)
		if level > 0 then
			table.insert(descriptions, string.format("%s: +%d", gemInfo.description, level))
		end
	end

	if #descriptions > 0 then
		local fullDescription = "Skill Bonuses:\n" .. table.concat(descriptions, "\n")
		equipment:setAttribute(ITEM_ATTRIBUTE_DESCRIPTION, fullDescription)
	else
		equipment:removeAttribute(ITEM_ATTRIBUTE_DESCRIPTION)
	end
end

-- Get all skill bonuses from an equipment
function SkillGems.getAllBonuses(equipment)
	local bonuses = {}

	for gemId, gemInfo in pairs(SkillGems.GEM_TYPES) do
		local level = SkillGems.getCurrentLevel(equipment, gemId)
		if level > 0 then
			bonuses[gemInfo.skillType] = level
		end
	end

	return bonuses
end

return SkillGems
