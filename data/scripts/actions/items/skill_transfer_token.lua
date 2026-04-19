local skillTransfer = require("data.libs.systems.skill_transfer")
local skillGems = require("data.libs.systems.skill_gems")

local skillTransferToken = Action()

function skillTransferToken.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	-- Check if target exists and is an item
	if not target or type(target) ~= "userdata" or not target:isItem() then
		player:sendCancelMessage("You need to use this token on equipment.")
		return false
	end

	-- Prevent using token on itself
	if item:getUniqueId() == target:getUniqueId() then
		player:sendCancelMessage("You cannot use the token on itself.")
		return false
	end

	-- Check if target is valid equipment
	if not skillGems.isValidEquipment(target) then
		player:sendCancelMessage("You can only use skill transfer tokens on helmets, armors, legs or boots.")
		return false
	end

	-- Check if token has stored bonuses
	local tokenBonuses = skillTransfer.getTokenBonuses(item)

	if not next(tokenBonuses) then
		-- Token is empty - try to extract bonuses from equipment
		return skillTransfer.extractBonuses(player, item, target)
	else
		-- Token has bonuses - try to apply to equipment
		return skillTransfer.applyBonuses(player, item, target)
	end
end

-- Register the skill transfer token
skillTransferToken:id(skillTransfer.SKILL_TRANSFER_TOKEN_ID)
skillTransferToken:register()
