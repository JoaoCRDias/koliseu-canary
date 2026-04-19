local skillGems = require("data.libs.systems.skill_gems")

local skillGemAction = Action()

function skillGemAction.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	-- Check if target exists and is an item
	if not target or type(target) ~= "userdata" or not target:isItem() then
		player:sendCancelMessage("You need to use this gem on equipment (helmet, armor, legs or boots).")
		return false
	end

	-- Prevent using gem on itself
	if item:getUniqueId() == target:getUniqueId() then
		player:sendCancelMessage("You cannot use the gem on itself.")
		return false
	end

	-- Check if target is valid equipment
	if not skillGems.isValidEquipment(target) then
		player:sendCancelMessage("You can only use skill gems on helmets, armors, legs or boots.")
		return false
	end

	-- Apply the gem
	return skillGems.applyGem(player, item, target)
end

-- Register all skill gem types
skillGemAction:id(skillGems.PALADIN_GEM, skillGems.MAGE_GEM, skillGems.KNIGHT_GEM)
skillGemAction:register()
