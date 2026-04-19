SkillTransfer = {
	SKILL_TRANSFER_TOKEN_ID = 60431,
}

local SKILL_TYPES = { "distance", "magic", "fist", "melee" }

-- Check if token has stored skill bonuses
function SkillTransfer.getTokenBonuses(token)
	local bonuses = {}

	-- Check for each skill type
	for _, skillType in ipairs(SKILL_TYPES) do
		local attributeKey = string.format("stored_skill_%s", skillType)
		local level = token:getCustomAttribute(attributeKey)
		if level and level > 0 then
			bonuses[skillType] = level
		end
	end

	return bonuses
end

-- Set skill bonuses in the token
function SkillTransfer.setTokenBonuses(token, bonuses)
	if not bonuses or not next(bonuses) then
		-- Clear all bonuses
		for _, skillType in ipairs(SKILL_TYPES) do
			local attributeKey = string.format("stored_skill_%s", skillType)
			token:removeCustomAttribute(attributeKey)
		end

		-- Reset token
		token:removeAttribute(ITEM_ATTRIBUTE_NAME)
		token:setAttribute(ITEM_ATTRIBUTE_DESCRIPTION, "A special token that can extract and transfer skill bonuses from equipment. Use it on equipment with skill bonus to extract it, then use it on another equipment to apply the bonus.")
	else
		-- Set bonuses
		for skillType, level in pairs(bonuses) do
			local attributeKey = string.format("stored_skill_%s", skillType)
			token:setCustomAttribute(attributeKey, level)
		end

		-- Update token name and description
		local bonusStrings = {}
		local skillNames = {
			distance = "DIST",
			magic = "ML",
			fist = "FIST",
			melee = "MELEE"
		}

		for skillType, level in pairs(bonuses) do
			table.insert(bonusStrings, string.format("%s+%d", skillNames[skillType], level))
		end

		local newName = string.format("skill transfer token [%s]", table.concat(bonusStrings, " "))
		token:setAttribute(ITEM_ATTRIBUTE_NAME, newName)

		local description = "This token contains skill bonuses:\n"
		for skillType, level in pairs(bonuses) do
			description = description .. string.format("  %s: +%d\n", skillType, level)
		end
		description = description .. "\nUse it on equipment to transfer these bonuses."
		token:setAttribute(ITEM_ATTRIBUTE_DESCRIPTION, description)
	end
end

-- Extract skill bonuses from equipment
function SkillTransfer.extractBonuses(player, token, equipment)
	-- Import SkillGems module
	local skillGems = require("data.libs.systems.skill_gems")

	-- Validate token is empty
	local tokenBonuses = SkillTransfer.getTokenBonuses(token)
	if next(tokenBonuses) then
		player:sendCancelMessage("This skill transfer token already contains bonuses. Use it on equipment first.")
		return false
	end

	-- Get all bonuses from equipment
	local equipmentBonuses = skillGems.getAllBonuses(equipment)
	if not next(equipmentBonuses) then
		player:sendCancelMessage("This equipment has no skill bonuses to extract.")
		return false
	end

	-- Show confirmation modal
	local itemType = equipment:getType()
	local equipmentName = itemType:getName()

	local bonusStrings = {}
	for skillType, level in pairs(equipmentBonuses) do
		table.insert(bonusStrings, string.format("%s: +%d", skillType, level))
	end

	local message = string.format([[Extract Skill Bonuses from Equipment?

Equipment: %s
Bonuses to Extract:
%s

This will:
- Remove all skill bonuses from the equipment
- Store the bonuses in the token
- Equipment returns to base stats

Continue?]], equipmentName, table.concat(bonusStrings, "\n"))

	local modal = ModalWindow({
		title = "Extract Skill Bonuses",
		message = message,
	})

	modal:addButton("Confirm")
	modal:addButton("Cancel")
	modal:setDefaultEnterButton(1)
	modal:setDefaultEscapeButton(2)

	-- Store data for callback
	local confirmKey = "extract_skill_" .. player:getId()
	if not _G.SkillTransferConfirmations then
		_G.SkillTransferConfirmations = {}
	end

	_G.SkillTransferConfirmations[confirmKey] = {
		token = token,
		equipment = equipment,
		bonuses = equipmentBonuses
	}

	modal:setDefaultCallback(function(clickedPlayer, button)
		local data = _G.SkillTransferConfirmations[confirmKey]
		if button.id == 1 and data then
			-- Perform extraction
			SkillTransfer.performExtraction(clickedPlayer, data.token, data.equipment, data.bonuses)
		else
			clickedPlayer:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Extraction cancelled.")
		end
		-- Clean up
		_G.SkillTransferConfirmations[confirmKey] = nil
	end)

	modal:sendToPlayer(player)
	return true
end

-- Perform the actual extraction
function SkillTransfer.performExtraction(player, token, equipment, bonuses)
	-- Import SkillGems module
	local skillGems = require("data.libs.systems.skill_gems")

	-- Validate items still exist
	if not token or not equipment then
		player:sendCancelMessage("Item not found.")
		return false
	end

	-- Store bonuses in token FIRST (before modifying equipment)
	SkillTransfer.setTokenBonuses(token, bonuses)

	-- Verify that the token actually stored the bonuses
	local storedBonuses = SkillTransfer.getTokenBonuses(token)
	if not next(storedBonuses) then
		player:sendCancelMessage("Failed to store bonuses in token.")
		return false
	end

	-- Only now remove bonuses from equipment (token is safe)
	for gemId, gemInfo in pairs(skillGems.GEM_TYPES) do
		local attributeKey = string.format("skill_gem_%s_level", gemInfo.skillType)
		equipment:removeCustomAttribute(attributeKey)
	end

	-- Reset equipment name and description
	equipment:removeAttribute(ITEM_ATTRIBUTE_NAME)
	equipment:removeAttribute(ITEM_ATTRIBUTE_DESCRIPTION)

	-- Visual effects and message
	equipment:getPosition():sendMagicEffect(CONST_ME_ENERGYAREA)
	token:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Successfully extracted skill bonuses to transfer token!")

	return true
end

-- Apply bonuses from token to equipment
function SkillTransfer.applyBonuses(player, token, equipment)
	-- Import SkillGems module
	local skillGems = require("data.libs.systems.skill_gems")

	-- Validate token has bonuses
	local tokenBonuses = SkillTransfer.getTokenBonuses(token)
	if not next(tokenBonuses) then
		player:sendCancelMessage("This skill transfer token is empty. Use it on equipment with skill bonuses first to extract them.")
		return false
	end

	-- Validate equipment has no bonuses
	local equipmentBonuses = skillGems.getAllBonuses(equipment)
	if next(equipmentBonuses) then
		player:sendCancelMessage("This equipment already has skill bonuses. You can only transfer to equipment without bonuses.")
		return false
	end

	-- Show confirmation modal
	local itemType = equipment:getType()
	local equipmentName = itemType:getName()

	local bonusStrings = {}
	for skillType, level in pairs(tokenBonuses) do
		table.insert(bonusStrings, string.format("%s: +%d", skillType, level))
	end

	local message = string.format([[Transfer Skill Bonuses to Equipment?

Target Equipment: %s
Bonuses to Apply:
%s

This will:
- Apply all bonuses to the equipment
- Consume the transfer token

Continue?]], equipmentName, table.concat(bonusStrings, "\n"))

	local modal = ModalWindow({
		title = "Apply Skill Bonuses",
		message = message,
	})

	modal:addButton("Confirm")
	modal:addButton("Cancel")
	modal:setDefaultEnterButton(1)
	modal:setDefaultEscapeButton(2)

	-- Store data for callback
	local confirmKey = "apply_skill_" .. player:getId()
	if not _G.SkillTransferConfirmations then
		_G.SkillTransferConfirmations = {}
	end

	_G.SkillTransferConfirmations[confirmKey] = {
		token = token,
		equipment = equipment,
		bonuses = tokenBonuses
	}

	modal:setDefaultCallback(function(clickedPlayer, button)
		local data = _G.SkillTransferConfirmations[confirmKey]
		if button.id == 1 and data then
			-- Perform application
			SkillTransfer.performApplication(clickedPlayer, data.token, data.equipment, data.bonuses)
		else
			clickedPlayer:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Transfer cancelled.")
		end
		-- Clean up
		_G.SkillTransferConfirmations[confirmKey] = nil
	end)

	modal:sendToPlayer(player)
	return true
end

-- Perform the actual application
function SkillTransfer.performApplication(player, token, equipment, bonuses)
	-- Import SkillGems module
	local skillGems = require("data.libs.systems.skill_gems")

	-- Validate items still exist
	if not token or not equipment then
		player:sendCancelMessage("Item not found.")
		return false
	end

	-- Apply all bonuses to equipment
	for skillType, level in pairs(bonuses) do
		local attributeKey = string.format("skill_gem_%s_level", skillType)
		equipment:setCustomAttribute(attributeKey, level)
	end

	-- Update equipment name and description
	skillGems.updateEquipmentName(equipment)
	skillGems.updateEquipmentDescription(equipment)

	-- Remove the token
	token:remove(1)

	-- Visual effects and message
	equipment:getPosition():sendMagicEffect(CONST_ME_MAGIC_GREEN)
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Successfully applied skill bonuses to equipment!")

	return true
end

return SkillTransfer
