-- Talk action: !skillgem voc,level
-- Applies skill gem bonus to equipment in front of the god
-- Usage: !skillgem paladin,5 or !skillgem mage,10

local skillgemApply = TalkAction("!skillgem")

-- Mapping of vocation names to gem IDs
local VOCATION_GEM_MAP = {
	["paladin"] = SkillGems.PALADIN_GEM,
	["pala"] = SkillGems.PALADIN_GEM,
	["rp"] = SkillGems.PALADIN_GEM,
	["mage"] = SkillGems.MAGE_GEM,
	["sorcerer"] = SkillGems.MAGE_GEM,
	["druid"] = SkillGems.MAGE_GEM,
	["ms"] = SkillGems.MAGE_GEM,
	["ed"] = SkillGems.MAGE_GEM,
	["fist"] = SkillGems.MONK_GEM,
	["knight"] = SkillGems.KNIGHT_GEM,
	["ek"] = SkillGems.KNIGHT_GEM,
	["melee"] = SkillGems.KNIGHT_GEM,
}

function skillgemApply.onSay(player, words, param)
	-- Log command

	-- Validate param
	if param == "" then
		player:sendCancelMessage("Usage: !skillgem <voc>,<level>")
		player:sendCancelMessage("Vocations: paladin/pala/rp, mage/sorcerer/druid/ms/ed, monk/fist, knight/ek/melee")
		player:sendCancelMessage("Example: !skillgem paladin,5")
		return true
	end

	local split = param:split(",")
	if #split < 2 then
		player:sendCancelMessage("Usage: !skillgem <voc>,<level> (e.g., !skillgem paladin,5)")
		return true
	end

	local vocName = split[1]:lower():gsub("%s+", "")
	local level = tonumber(split[2])

	if not level then
		player:sendCancelMessage("Invalid level. Usage: !skillgem <voc>,<level>")
		return true
	end

	-- Clamp level between 0 and MAX_LEVEL
	if level < 0 then level = 0 end
	if level > SkillGems.MAX_LEVEL then level = SkillGems.MAX_LEVEL end

	-- Get gem ID from vocation name
	local gemId = VOCATION_GEM_MAP[vocName]
	if not gemId then
		player:sendCancelMessage("Unknown vocation. Use: paladin, mage, monk, or knight")
		return true
	end

	local gemInfo = SkillGems.GEM_TYPES[gemId]
	if not gemInfo then
		player:sendCancelMessage("Gem configuration error.")
		return true
	end

	-- Get position in front of player
	local position = player:getPosition()
	position:getNextPosition(player:getDirection(), 1)

	-- Get item at position
	local tile = Tile(position)
	if not tile then
		player:sendCancelMessage("No tile found.")
		return true
	end

	local item = tile:getTopVisibleThing(player)
	if not item or not item:isItem() then
		player:sendCancelMessage("No item found in front of you.")
		return true
	end

	-- Check if it's valid equipment
	if not SkillGems.isValidEquipment(item) then
		player:sendCancelMessage("This item is not valid equipment (must be helmet, armor, legs, or boots).")
		return true
	end

	-- Check if equipment has a different gem type already
	local existingGemId, existingGemInfo = SkillGems.getEquipmentGemType(item)
	if existingGemId and existingGemId ~= gemId and level > 0 then
		-- Remove existing gem bonus first
		local existingGemConfig = SkillGems.GEM_TYPES[existingGemId]
		if existingGemConfig then
			local attributeKey = string.format("skill_gem_%s_level", existingGemConfig.skillType)
			item:removeCustomAttribute(attributeKey)
		end
	end

	-- Apply the skill gem bonus
	SkillGems.setSkillBonus(item, gemInfo, level)

	-- Visual effect
	position:sendMagicEffect(CONST_ME_MAGIC_GREEN)

	-- Send message
	local itemType = item:getType()
	local itemName = itemType:getName()

	if level > 0 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("Applied %s +%d to %s", gemInfo.description, level, itemName))
	else
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("Removed %s bonus from %s", gemInfo.description, itemName))
	end

	return true
end

skillgemApply:separator(" ")
skillgemApply:groupType("god")
skillgemApply:register()
