local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_ICEDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_ICEATTACK)
combat:setParameter(COMBAT_PARAM_DISTANCEEFFECT, CONST_ANI_SMALLICE)

function onGetFormulaValues(player, skill, attack, factor)
	local maglevel = player:getMagicLevel()
	local skillTotal = maglevel * attack
	local levelTotal = player:getLevel() / 4
	-- Multiplicative formula
	local minMult = ((skillTotal * 0.218) + 35) + levelTotal
	local maxMult = ((skillTotal * 0.328) + 55) + levelTotal
	-- Original formula as floor
	local minOrig = levelTotal + (maglevel * 4.5) + 35
	local maxOrig = levelTotal + (maglevel * 7.3) + 55
	return -math.max(minMult, minOrig), -math.max(maxMult, maxOrig)
end

combat:setCallback(CALLBACK_PARAM_SKILLVALUE, "onGetFormulaValues")

local spell = Spell("instant")

function spell.onCastSpell(creature, var)
	return combat:execute(creature, var)
end

spell:group("attack", "ultimatestrikes")
spell:id(156)
spell:name("Ultimate Ice Strike")
spell:words("exori max frigo")
spell:castSound(SOUND_EFFECT_TYPE_SPELL_OR_RUNE)
spell:impactSound(SOUND_EFFECT_TYPE_SPELL_ULTIMATE_ICE_STRIKE)
spell:level(100)
spell:mana(100)
spell:isPremium(true)
spell:range(3)
spell:needCasterTargetOrDirection(true)
spell:blockWalls(true)
spell:cooldown(16 * 1000)
spell:groupCooldown(2 * 1000)
spell:needLearn(false)
spell:vocation("druid;true", "elder druid;true")
spell:register()
