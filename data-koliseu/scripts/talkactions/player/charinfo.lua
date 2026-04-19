local STORAGE_HTP_ATK_SPEED = 55001
local STORAGE_HTP_CRIT_CAP = 55002
local STORAGE_HTP_MITIGATION = 55003

local function formatNumber(n)
	local formatted = tostring(n)
	local k
	while true do
		formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", "%1.%2")
		if k == 0 then
			break
		end
	end
	return formatted
end

local function getStorageSafe(player, id)
	local val = player:getStorageValue(id)
	return val > 0 and val or 0
end

local function getBlessingCount(player)
	local count = 0
	for i = 1, 8 do
		if player:hasBlessing(i) then
			count = count + 1
		end
	end
	return count
end

-- Extract only the CUMULATIVE TOTALS section from a bonus description string
local function extractTotals(description)
	local totals = description:match("=== CUMULATIVE TOTALS ===\n(.+)")
	if not totals then
		return nil
	end
	-- Remove trailing whitespace and any "Note:" lines
	local lines = {}
	for line in totals:gmatch("[^\n]+") do
		local trimmed = line:match("^%s*(.-)%s*$")
		if trimmed and trimmed ~= "" then
			table.insert(lines, "  " .. trimmed)
		end
	end
	if #lines == 0 then
		return nil
	end
	return table.concat(lines, "\n")
end

local charinfo = TalkAction("!charinfo")

function charinfo.onSay(player, words, param)
	local voc = player:getVocation()
	local text = ""

	-- == GENERAL INFO ==
	text = text .. "========== GENERAL INFO ==========\n"
	text = text .. string.format("Name: %s\n", player:getName())
	text = text .. string.format("Level: %d\n", player:getLevel())
	text = text .. string.format("Vocation: %s\n", voc:getName())
	text = text .. string.format("HP: %d / %d\n", player:getHealth(), player:getMaxHealth())
	text = text .. string.format("Mana: %d / %d\n", player:getMana(), player:getMaxMana())
	text = text .. string.format("Capacity: %s\n", formatNumber(math.floor(player:getCapacity() / 100)))
	text = text .. string.format("Speed: %d\n", player:getSpeed())
	text = text .. string.format("Soul: %d\n", player:getSoul())
	text = text .. string.format("Stamina: %d:%02d h\n", math.floor(player:getStamina() / 60), player:getStamina() % 60)
	text = text .. string.format("Blessings: %d/8\n", getBlessingCount(player))
	text = text .. string.format("Premium: %s\n", player:isPremium() and "Yes" or "No")

	-- == SKILLS ==
	text = text .. "\n========== SKILLS ==========\n"
	local skillNames = {
		[SKILL_FIST] = "Fist Fighting",
		[SKILL_CLUB] = "Club Fighting",
		[SKILL_SWORD] = "Sword Fighting",
		[SKILL_AXE] = "Axe Fighting",
		[SKILL_DISTANCE] = "Distance Fighting",
		[SKILL_SHIELD] = "Shielding",
		[SKILL_FISHING] = "Fishing",
	}
	for skillId, skillName in pairs(skillNames) do
		local level = player:getSkillLevel(skillId)
		if level > 10 then
			text = text .. string.format("%s: %d\n", skillName, level)
		end
	end
	local ml = player:getMagicLevel()
	local baseML = player:getBaseMagicLevel()
	if ml ~= baseML then
		text = text .. string.format("Magic Level: %d (base: %d)\n", ml, baseML)
	else
		text = text .. string.format("Magic Level: %d\n", ml)
	end

	-- Attack Speed Skill
	local atkSpeedSkill = player:getSkillLevel(SKILL_ATTACK_SPEED)
	if atkSpeedSkill > 0 then
		text = text .. string.format("Attack Speed Skill: %d\n", atkSpeedSkill)
	end

	-- Mining Skill
	local miningSkill = player:getSkillLevel(SKILL_MINING)
	if miningSkill > 0 then
		text = text .. string.format("Mining Skill: %d\n", miningSkill)
	end

	-- == COMBAT STATS ==
	text = text .. "\n========== COMBAT ==========\n"

	-- Attack Speed
	local atkSpeed = player:getAttackSpeed()
	text = text .. string.format("Attack Speed: %d ms\n", atkSpeed)

	-- Critical
	local critChance = player:getEffectiveSkillLevel(SKILL_CRITICAL_HIT_CHANCE)
	local critDamage = player:getEffectiveSkillLevel(SKILL_CRITICAL_HIT_DAMAGE)
	text = text .. string.format("Critical Chance: %.2f%%\n", critChance / 100)
	text = text .. string.format("Critical Damage: +%.2f%%\n", critDamage / 100)

	-- Leech
	local lifeLeech = player:getEffectiveSkillLevel(SKILL_LIFE_LEECH_AMOUNT)
	local manaLeech = player:getEffectiveSkillLevel(SKILL_MANA_LEECH_AMOUNT)
	text = text .. string.format("Life Leech: %.2f%%\n", lifeLeech / 100)
	text = text .. string.format("Mana Leech: %.2f%%\n", manaLeech / 100)

	-- Mitigation Skill (from KV, +0.2% per level, max 100 levels)
	local mitSkillLevel = player:kv():get("mitigation_skill") or 0
	if mitSkillLevel > 0 then
		local mitBonus = math.min(mitSkillLevel, 100) * 0.2
		text = text .. string.format("Mitigation Skill: %d (+%.1f%% mitigation)\n", mitSkillLevel, mitBonus)
	end

	-- Fishing Loot Bonus
	local fishingLevel = player:getSkillLevel(SKILL_FISHING)
	if fishingLevel > 0 then
		local fishingBonusPercent = fishingLevel * 0.3
		text = text .. string.format("Fishing Loot Bonus: +%.1f%%\n", fishingBonusPercent)
	end

	-- == HTP BONUSES ==
	local htpAtkSpeed = getStorageSafe(player, STORAGE_HTP_ATK_SPEED)
	local htpCrit = getStorageSafe(player, STORAGE_HTP_CRIT_CAP)
	local htpMit = getStorageSafe(player, STORAGE_HTP_MITIGATION)

	if htpAtkSpeed > 0 or htpCrit > 0 or htpMit > 0 then
		text = text .. "\n========== HTP BONUS ==========\n"
		if htpAtkSpeed > 0 then
			text = text .. string.format("Attack Speed Cap: %d/50 (-%dms, cap: %dms)\n",
				htpAtkSpeed, htpAtkSpeed, math.max(250 - htpAtkSpeed, 200))
		end
		if htpCrit > 0 then
			text = text .. string.format("Critical Chance Cap: %d/250 (+%.1f%%, cap: %.1f%%)\n",
				htpCrit, htpCrit * 0.1, 50 + htpCrit * 0.1)
		end
		if htpMit > 0 then
			text = text .. string.format("Mitigation Cap: %d/150 (+%.1f%%)\n",
				htpMit, htpMit * 0.1)
		end
		text = text .. string.format("Hunting Task Points: %s\n", formatNumber(player:getTaskHuntingPoints()))
	end

	-- == XP BONUSES ==
	text = text .. "\n========== EXPERIENCE ==========\n"
	local baseXp = player:getBaseXpGain()
	local voucherXp = player:getVoucherXpBoost()
	local grindXp = player:getGrindingXpBoost()
	local boostXp = player:getXpBoostPercent()
	local staminaXp = player:getStaminaXpBoost()
	local boostTime = player:getXpBoostTime()

	text = text .. string.format("Base XP Rate: %d%%\n", baseXp)
	if staminaXp ~= 100 then
		text = text .. string.format("Stamina Bonus: %d%%\n", staminaXp)
	end
	if voucherXp > 0 then
		text = text .. string.format("Voucher Boost: +%d%%\n", voucherXp)
	end
	if grindXp > 0 then
		text = text .. string.format("Grinding Boost: +%d%%\n", grindXp)
	end
	if boostXp > 0 then
		local mins = math.floor(boostTime / 60)
		text = text .. string.format("XP Boost: +%d%% (%d min remaining)\n", boostXp, mins)
	end

	-- == MOUNT BONUSES (summary) ==
	local mountDesc = player:getMountBonusDescription()
	if mountDesc and not mountDesc:find("don't have any mounts") then
		local mountTotals = extractTotals(mountDesc)
		if mountTotals then
			text = text .. "\n========== MOUNT BONUSES ==========\n"
			text = text .. mountTotals .. "\n"
		end
	end

	-- == ADDON BONUSES (summary) ==
	local addonDesc = player:getOutfitBonusDescription()
	if addonDesc and not addonDesc:find("don't have any outfits") then
		local addonTotals = extractTotals(addonDesc)
		if addonTotals then
			text = text .. "\n========== ADDON BONUSES ==========\n"
			text = text .. addonTotals .. "\n"
		end
	end

	-- == LOYALTY ==
	local loyaltySkill = getStorageSafe(player, 50005)
	local loyaltyStat = getStorageSafe(player, 50006)
	if loyaltySkill > 0 or loyaltyStat > 0 then
		text = text .. "\n========== LOYALTY ==========\n"
		if loyaltySkill > 0 then
			text = text .. string.format("Loyalty Skill Bonus: +%d\n", loyaltySkill)
		end
		if loyaltyStat > 0 then
			text = text .. string.format("Loyalty Magic Level Bonus: +%d\n", loyaltyStat)
		end
	end

	-- == SUPPRESSION ==
	local dmgLogSuppressed = player:getStorageValue(53001)
	local magicEffectsSuppressed = player:getStorageValue(53002)
	if (dmgLogSuppressed and dmgLogSuppressed > 0) or (magicEffectsSuppressed and magicEffectsSuppressed > 0) then
		text = text .. "\n========== PERFORMANCE ==========\n"
		if dmgLogSuppressed and dmgLogSuppressed > 0 then
			text = text .. "Damage Log: Suppressed\n"
		end
		if magicEffectsSuppressed and magicEffectsSuppressed > 0 then
			text = text .. "Magic Effects: Suppressed\n"
		end
	end

	player:popupFYI(text)
	return false
end

charinfo:separator(" ")
charinfo:groupType("normal")
charinfo:register()
