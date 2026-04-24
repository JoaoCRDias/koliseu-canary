local combat = Combat()
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_MAGIC_GREEN)
combat:setParameter(COMBAT_PARAM_AGGRESSIVE, false)

local spell = Spell("instant")

function spell.onCastSpell(creature, variant)
	if creature:getCondition(CONDITION_ATTRIBUTES, CONDITIONID_COMBAT, AttrSubId_BloodRageProtector) then
		creature:removeCondition(CONDITION_ATTRIBUTES, CONDITIONID_COMBAT, AttrSubId_BloodRageProtector)
	end

	local damageReceived = 90
	local relicBonus = creature:getStorageValue(920036)
	if relicBonus and relicBonus > 0 then
		local extra = relicBonus / 100
		damageReceived = damageReceived - extra
		creature:sendTextMessage(MESSAGE_EVENT_ADVANCE, "[Relic] Protector +" .. extra .. "% extra damage reduction (total " .. (100 - damageReceived) .. "%)")
	end

	local skill = Condition(CONDITION_ATTRIBUTES)
	skill:setParameter(CONDITION_PARAM_SUBID, AttrSubId_BloodRageProtector)
	skill:setParameter(CONDITION_PARAM_TICKS, 13000)
	skill:setParameter(CONDITION_PARAM_SKILL_SHIELDPERCENT, 170)
	skill:setParameter(CONDITION_PARAM_BUFF_DAMAGEDEALT, 60)
	skill:setParameter(CONDITION_PARAM_BUFF_DAMAGERECEIVED, damageReceived)
	skill:setParameter(CONDITION_PARAM_BUFF_SPELL, true)
	creature:addCondition(skill)
	creature:getPosition():sendMagicEffect(CONST_ME_MAGIC_GREEN)
	return true
end

spell:name("Protector")
spell:words("utamo tempo")
spell:group("support", "focus")
spell:vocation("knight;true", "elite knight;true", "titan knight;true")
spell:castSound(SOUND_EFFECT_TYPE_SPELL_PROTECTOR)
spell:id(132)
spell:cooldown(2 * 1000)
spell:groupCooldown(2 * 1000, 2 * 1000)
spell:level(55)
spell:mana(200)
spell:isSelfTarget(true)
spell:isAggressive(false)
spell:isPremium(true)
spell:needLearn(false)
spell:register()
