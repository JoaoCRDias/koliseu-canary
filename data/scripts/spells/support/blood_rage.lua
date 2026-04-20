local combat = Combat()
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_MAGIC_GREEN)
combat:setParameter(COMBAT_PARAM_AGGRESSIVE, 0)

local spell = Spell("instant")

function spell.onCastSpell(creature, var)
	if creature:getCondition(CONDITION_ATTRIBUTES, CONDITIONID_COMBAT, AttrSubId_BloodRageProtector) then
		creature:removeCondition(CONDITION_ATTRIBUTES, CONDITIONID_COMBAT, AttrSubId_BloodRageProtector)
	end

	local skillPercent = 140
	local relicBonus = creature:getStorageValue(920035)
	if relicBonus and relicBonus > 0 then
		local extra = relicBonus / 100
		skillPercent = skillPercent + extra
		creature:sendTextMessage(MESSAGE_EVENT_ADVANCE, "[Relic] Blood Rage skill +" .. extra .. "% (total " .. (skillPercent - 100) .. "%)")
	end

	local condition = Condition(CONDITION_ATTRIBUTES)
	condition:setParameter(CONDITION_PARAM_SUBID, AttrSubId_BloodRageProtector)
	condition:setParameter(CONDITION_PARAM_TICKS, 10000)
	condition:setParameter(CONDITION_PARAM_SKILL_MELEEPERCENT, skillPercent)
	condition:setParameter(CONDITION_PARAM_BUFF_DAMAGERECEIVED, 115)
	condition:setParameter(CONDITION_PARAM_DISABLE_DEFENSE, true)
	condition:setParameter(CONDITION_PARAM_BUFF_SPELL, true)
	creature:addCondition(condition)
	creature:getPosition():sendMagicEffect(CONST_ME_MAGIC_GREEN)
	return true
end

spell:name("Blood Rage")
spell:words("utito tempo")
spell:group("support", "focus")
spell:vocation("knight;true", "elite knight;true")
spell:castSound(SOUND_EFFECT_TYPE_SPELL_BLOOD_RAGE)
spell:id(133)
spell:cooldown(2 * 1000)
spell:groupCooldown(2 * 1000, 2 * 1000)
spell:level(60)
spell:mana(290)
spell:isSelfTarget(true)
spell:isAggressive(false)
spell:isPremium(true)
spell:needLearn(false)
spell:register()
