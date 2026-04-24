local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_ICEDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_ICETORNADO)
combat:setArea(createCombatArea(AREA_CIRCLE5X5))

function onGetFormulaValues(player, level, maglevel)
	-- UE: 30% stronger than SD (SD = 1.95)
	local min = ((level / 1.15) + (maglevel * 12.0) + 50) * 2.535
	local max = ((level / 1.15) + (maglevel * 17.0) + 80) * 2.535
	return -min, -max
end

combat:setCallback(CALLBACK_PARAM_LEVELMAGICVALUE, "onGetFormulaValues")

local spell = Spell("instant")

function spell.onCastSpell(creature, var)
	return combat:execute(creature, var)
end

spell:group("attack", "focus")
spell:id(118)
spell:name("Eternal Winter")
spell:words("exevo gran mas frigo")
spell:castSound(SOUND_EFFECT_TYPE_SPELL_ETERNAL_WINTER)
spell:level(60)
spell:mana(1050)
spell:isPremium(true)
spell:range(5)
spell:isSelfTarget(true)
spell:cooldown(20 * 1000)
spell:groupCooldown(2 * 1000)
spell:needLearn(false)
spell:vocation("druid;true", "elder druid;true", "primal druid;true")
spell:register()
