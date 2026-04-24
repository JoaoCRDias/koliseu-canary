local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_ICEDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_ICEATTACK)
combat:setParameter(COMBAT_PARAM_DISTANCEEFFECT, CONST_ANI_SMALLICE)

function onGetFormulaValues(player, skill, attack, factor)
	local maglevel = player:getMagicLevel()
	local skillTotal = maglevel * attack
	local levelTotal = player:getLevel() / 4
	-- Multiplicative formula
	local minMult = ((skillTotal * 0.089) + 16) + levelTotal
	local maxMult = ((skillTotal * 0.178) + 28) + levelTotal
	-- Original formula as floor
	local minOrig = levelTotal + (maglevel * 2.8) + 16
	local maxOrig = levelTotal + (maglevel * 4.4) + 28
	return -math.max(minMult, minOrig), -math.max(maxMult, maxOrig)
end

combat:setCallback(CALLBACK_PARAM_SKILLVALUE, "onGetFormulaValues")

local spell = Spell("instant")

function spell.onCastSpell(creature, var)
	return combat:execute(creature, var)
end

spell:group("attack", "special")
spell:id(152)
spell:name("Strong Ice Strike")
spell:words("exori gran frigo")
spell:castSound(SOUND_EFFECT_TYPE_SPELL_OR_RUNE)
spell:impactSound(SOUND_EFFECT_TYPE_SPELL_STRONG_ICE_STRIKE)
spell:level(80)
spell:mana(60)
spell:isPremium(true)
spell:range(3)
spell:needCasterTargetOrDirection(true)
spell:blockWalls(true)
spell:cooldown(8 * 1000)
spell:groupCooldown(2 * 1000, 8 * 1000)
spell:needLearn(false)
spell:vocation("druid;true", "elder druid;true", "primal druid;true")
spell:register()
