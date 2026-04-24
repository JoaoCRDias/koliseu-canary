local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_ENERGYDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_ENERGYAREA)
combat:setParameter(COMBAT_PARAM_DISTANCEEFFECT, CONST_ANI_ENERGY)

function onGetFormulaValues(player, skill, attack, factor)
	local level = player:getLevel()
	local maglevel = player:getMagicLevel()
	local min = (level / 4) + (maglevel * 0.4) + 3
	local max = (level / 4) + (maglevel * 0.7) + 5
	local weaponBonus = 1 + (attack * 0.002)
	return -min * weaponBonus, -max * weaponBonus
end

combat:setCallback(CALLBACK_PARAM_SKILLVALUE, "onGetFormulaValues")

local spell = Spell("instant")

function spell.onCastSpell(creature, var)
	return combat:execute(creature, var)
end

spell:group("attack")
spell:id(177)
spell:name("Buzz")
spell:words("exori infir vis")
spell:castSound(SOUND_EFFECT_TYPE_SPELL_OR_RUNE)
spell:impactSound(SOUND_EFFECT_TYPE_SPELL_BUZZ)
spell:level(1)
spell:mana(6)
spell:isAggressive(true)
spell:isPremium(false)
spell:range(3)
spell:needCasterTargetOrDirection(true)
spell:blockWalls(true)
spell:cooldown(2 * 1000)
spell:groupCooldown(2 * 1000)
spell:needLearn(false)
spell:vocation("sorcerer;true", "master sorcerer;true", "arcane sorcerer;true")
spell:register()
