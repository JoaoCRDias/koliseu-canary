local berserk = Condition(CONDITION_ATTRIBUTES)
berserk:setParameter(CONDITION_PARAM_TICKS, 10 * 60 * 1000)
berserk:setParameter(CONDITION_PARAM_SUBID, JeanPierreMelee)
berserk:setParameter(CONDITION_PARAM_SKILL_MELEE, 5)
berserk:setParameter(CONDITION_PARAM_SKILL_SHIELD, -10)
berserk:setParameter(CONDITION_PARAM_BUFF_SPELL, true)

local mastermind = Condition(CONDITION_ATTRIBUTES)
mastermind:setParameter(CONDITION_PARAM_TICKS, 10 * 60 * 1000)
mastermind:setParameter(CONDITION_PARAM_SUBID, JeanPierreMagicLevel)
mastermind:setParameter(CONDITION_PARAM_STAT_MAGICPOINTS, 3)
mastermind:setParameter(CONDITION_PARAM_BUFF_SPELL, true)

local bullseye = Condition(CONDITION_ATTRIBUTES)
bullseye:setParameter(CONDITION_PARAM_TICKS, 10 * 60 * 1000)
bullseye:setParameter(CONDITION_PARAM_SUBID, JeanPierreDistance)
bullseye:setParameter(CONDITION_PARAM_SKILL_DISTANCE, 5)
bullseye:setParameter(CONDITION_PARAM_SKILL_SHIELD, -10)
bullseye:setParameter(CONDITION_PARAM_BUFF_SPELL, true)

local antidote = Combat()
antidote:setParameter(COMBAT_PARAM_TYPE, COMBAT_HEALING)
antidote:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_MAGIC_BLUE)
antidote:setParameter(COMBAT_PARAM_DISPEL, CONDITION_POISON)
antidote:setParameter(COMBAT_PARAM_AGGRESSIVE, false)
antidote:setParameter(COMBAT_PARAM_TARGETCASTERORTOPMOST, true)
local transcendence = Condition(CONDITION_ATTRIBUTES)
transcendence:setParameter(CONDITION_PARAM_TICKS, 10 * 60 * 1000)
transcendence:setParameter(CONDITION_PARAM_SUBID, JeanPierreMelee)
transcendence:setParameter(CONDITION_PARAM_SKILL_FIST, 4)
transcendence:setParameter(CONDITION_PARAM_BUFF_SPELL, true)

local exhaust = Condition(CONDITION_EXHAUST_HEAL)
exhaust:setParameter(CONDITION_PARAM_TICKS, (configManager.getNumber(configKeys.EX_ACTIONS_DELAY_INTERVAL) - 1000))

local function magicshield(player)
	local condition = Condition(CONDITION_MANASHIELD)
	condition:setParameter(CONDITION_PARAM_TICKS, 60000)
	condition:setParameter(CONDITION_PARAM_MANASHIELD, math.min(player:getMaxMana(), 300 + 7.6 * player:getLevel() + 7 * player:getMagicLevel()))
	exhaust:setParameter(CONDITION_PARAM_TICKS, 500)
	player:addCondition(condition)
end

local potions = {
	[236] = { health = { 800, 1120 }, vocations = { VOCATION.BASE_ID.PALADIN, VOCATION.BASE_ID.KNIGHT }, level = 50, flask = 283, description = "Only knights, paladins of level 50 or above may drink this fluid." },
	[237] = { mana = { 368, 592 }, level = 50, flask = 283, description = "Only players of level 50 or above may drink this fluid." },
	[238] = { mana = { 480, 800 }, vocations = { VOCATION.BASE_ID.SORCERER, VOCATION.BASE_ID.DRUID, VOCATION.BASE_ID.PALADIN }, level = 80, flask = 284, description = "Only sorcerers, druids, paladins of level 80 or above may drink this fluid." },
	[239] = { health = { 1360, 1840 }, vocations = { VOCATION.BASE_ID.KNIGHT }, level = 80, flask = 284, description = "Only knights of level 80 or above may drink this fluid." },
	[266] = { health = { 400, 560 }, flask = 285 },
	[268] = { mana = { 240, 400 }, flask = 285 },
	[6558] = { transform = { id = { 236, 237 } }, effect = CONST_ME_DRAWBLOOD },
	[7439] = { vocations = { VOCATION.BASE_ID.KNIGHT }, condition = berserk, effect = CONST_ME_MAGIC_RED, description = "Only knights may drink this potion.", text = "You feel stronger.", achievement = "Berserker" },
	[7440] = { vocations = { VOCATION.BASE_ID.SORCERER, VOCATION.BASE_ID.DRUID }, condition = mastermind, effect = CONST_ME_MAGIC_BLUE, description = "Only sorcerers and druids may drink this potion.", text = "You feel smarter.", achievement = "Mastermind" },
	[7443] = { vocations = { VOCATION.BASE_ID.PALADIN }, condition = bullseye, effect = CONST_ME_MAGIC_GREEN, description = "Only paladins may drink this potion.", text = "You feel more accurate.", achievement = "Sharpshooter" },
	[7642] = { health = { 800, 1120 }, mana = { 320, 640 }, vocations = { VOCATION.BASE_ID.PALADIN }, level = 80, flask = 284, description = "Only paladins of level 80 or above may drink this fluid." },
	[7643] = { health = { 2080, 2720 }, vocations = { VOCATION.BASE_ID.KNIGHT }, level = 130, flask = 284, description = "Only knights of level 130 or above may drink this fluid." },
	[7644] = { combat = antidote, flask = 285 },
	[7876] = { health = { 192, 288 }, flask = 285 },
	[23373] = { mana = { 425, 575 }, vocations = { VOCATION.BASE_ID.SORCERER, VOCATION.BASE_ID.DRUID }, level = 130, flask = 284, description = "Only druids and sorcerers of level 130 or above may drink this fluid." },
	[23374] = { health = { 420, 580 }, mana = { 250, 350 }, vocations = { VOCATION.BASE_ID.PALADIN }, level = 130, flask = 284, description = "Only paladins and monks of level 130 or above may drink this fluid." },
	[23375] = { health = { 875, 1125 }, vocations = { VOCATION.BASE_ID.KNIGHT }, level = 200, flask = 284, description = "Only knights of level 200 or above may drink this fluid." },
	[60258] = { mana = { 1275, 1725 }, vocations = { VOCATION.BASE_ID.SORCERER, VOCATION.BASE_ID.DRUID }, level = 130, flask = 284, description = "Only druids and sorcerers of level 130 or above may drink this fluid." },
	[60259] = { health = { 2625, 3375 }, vocations = { VOCATION.BASE_ID.KNIGHT }, level = 200, flask = 284, description = "Only knights of level 200 or above may drink this fluid." },
	[60260] = { health = { 1260, 1740 }, mana = { 750, 1050 }, vocations = { VOCATION.BASE_ID.PALADIN }, level = 130, flask = 284, description = "Only paladins of level 130 or above may drink this fluid." },
	[35563] = { vocations = { VOCATION.BASE_ID.SORCERER, VOCATION.BASE_ID.DRUID }, level = 14, func = magicshield, effect = CONST_ME_ENERGYAREA, description = "Only sorcerers and druids of level 14 or above may drink this potion." },
}

local flaskPotion = Action()

local function getPotionBadgeMultiplier(player)
	if not player or not BadgeBag then
		return 1
	end

	local potionBadgeTier = BadgeBag.getPlayerBadgeTier(player, "POTION")
	if not potionBadgeTier or potionBadgeTier <= 0 then
		return 1
	end

	local bonus
	if potionBadgeTier <= 5 then
		bonus = potionBadgeTier * 0.02
	else
		bonus = 0.10 + ((potionBadgeTier - 5) * 0.04)
	end
	return 1 + bonus
end

function flaskPotion.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if not target or type(target) == "userdata" and not target:isPlayer() then
		return false
	end

	local potion = potions[item:getId()]
	if not player:getGroup():getAccess() and (potion.level and player:getLevel() < potion.level or potion.vocations and not table.contains(potion.vocations, player:getVocation():getBaseId())) then
		player:say(potion.description, MESSAGE_POTION)
		return true
	end

	if potion.health or potion.mana or potion.combat then
		local potionMultiplier = getPotionBadgeMultiplier(player)
		local badgeBonusPercent = 0
		if potionMultiplier > 1 then
			badgeBonusPercent = math.floor((potionMultiplier - 1) * 100 + 0.5)
		end

		if potion.health then
			local baseMinHealth = potion.health[1]
			local baseMaxHealth = potion.health[2]
			local minHealth = math.floor(baseMinHealth * potionMultiplier)
			local maxHealth = math.floor(baseMaxHealth * potionMultiplier)

			-- Relic: Potion healing bonus
			local relicBonus = player:getStorageValue(920030)
			if relicBonus and relicBonus > 0 then
				local extraMin = math.floor(minHealth * relicBonus / 10000)
				local extraMax = math.floor(maxHealth * relicBonus / 10000)
				minHealth = minHealth + extraMin
				maxHealth = maxHealth + extraMax
			end

			local hpBefore = target:getHealth()
			doTargetCombatHealth(player, target, COMBAT_HEALING, minHealth, maxHealth, CONST_ME_MAGIC_BLUE)
			local realHeal = target:getHealth() - hpBefore

			if badgeBonusPercent > 0 and realHeal > 0 then
				local badgeBonusValue = math.floor(realHeal * badgeBonusPercent / (100 + badgeBonusPercent) + 0.5)
				if badgeBonusValue > 0 then
					target:sendTextMessage(MESSAGE_HEALED, string.format("(badge +%d (%d%%))", badgeBonusValue, badgeBonusPercent))
				end
			end
		end

		if potion.mana then
			local minMana = math.floor(potion.mana[1] * potionMultiplier)
			local maxMana = math.floor(potion.mana[2] * potionMultiplier)

			local manaBefore = target:getMana()
			doTargetCombatMana(0, target, minMana, maxMana, CONST_ME_MAGIC_BLUE)
			local realMana = target:getMana() - manaBefore

			if badgeBonusPercent > 0 and realMana > 0 then
				local badgeBonusValue = math.floor(realMana * badgeBonusPercent / (100 + badgeBonusPercent) + 0.5)
				if badgeBonusValue > 0 then
					target:sendTextMessage(MESSAGE_HEALED, string.format("(badge +%d mana (%d%%))", badgeBonusValue, badgeBonusPercent))
				end
			end
		end

		if potion.combat then
			potion.combat:execute(target, Variant(target:getId()))
		end

		if not potion.effect and target:getPosition() ~= nil then
			target:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
		end

		player:addAchievementProgress("Potion Addict", 100000)
		target:say("Aaaah...", MESSAGE_POTION)

		local deactivatedFlasks = player:kv():get("talkaction.potions.flask") or false
		if not deactivatedFlasks and configManager.getBoolean(configKeys.REMOVE_POTION_CHARGES) then
			if fromPosition.x == CONTAINER_POSITION then
				player:addItem(potion.flask, 1)
			else
				Game.createItem(potion.flask, 1, fromPosition)
			end
		end
	end

	player:getPosition():sendSingleSoundEffect(SOUND_EFFECT_TYPE_ITEM_USE_POTION, player:isInGhostMode() and nil or player)

	if potion.func then
		potion.func(player)
		player:say("Aaaah...", MESSAGE_POTION)
		player:getPosition():sendMagicEffect(potion.effect)

		if potion.achievement then
			player:addAchievementProgress(potion.achievement, 100)
		end
	end

	if potion.condition then
		player:addCondition(potion.condition)
		player:say(potion.text, MESSAGE_POTION)
		player:getPosition():sendMagicEffect(potion.effect)
	end

	if potion.transform then
		if item:getCount() >= 1 then
			item:remove(1)
			player:addItem(potion.transform.id[math.random(#potion.transform.id)], 1)
			item:getPosition():sendMagicEffect(potion.effect)
			player:addAchievementProgress("Demonic Barkeeper", 250)
			return true
		end
	end

	if not configManager.getBoolean(configKeys.REMOVE_POTION_CHARGES) then
		return true
	end

	player:updateSupplyTracker(item)
	item:remove(1)
	return true
end

for index, value in pairs(potions) do
	flaskPotion:id(index)
end

flaskPotion:register()
