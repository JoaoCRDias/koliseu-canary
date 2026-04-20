local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_EARTHDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_CARNIPHILA)
combat:setParameter(COMBAT_PARAM_DISTANCEEFFECT, CONST_ANI_SMALLEARTH)

function onGetFormulaValues(player, skill, attack, factor)
	local level = player:getLevel()
	local maglevel = player:getMagicLevel()
	local min = (level / 4) + (maglevel * 1.403) + 8
	local max = (level / 4) + (maglevel * 2.203) + 13
	local weaponBonus = 1 + (attack * 0.002)
	return -min * weaponBonus, -max * weaponBonus
end

combat:setCallback(CALLBACK_PARAM_SKILLVALUE, "onGetFormulaValues")

local spell = Spell("instant")

function spell.onCastSpell(creature, var)
	return combat:execute(creature, var)
end

spell:group("attack")
spell:id(113)
spell:name("Terra Strike")
spell:words("exori tera")
spell:castSound(SOUND_EFFECT_TYPE_SPELL_OR_RUNE)
spell:impactSound(SOUND_EFFECT_TYPE_SPELL_TERRA_STRIKE)
spell:level(13)
spell:mana(20)
spell:range(3)
spell:isPremium(false)
spell:needCasterTargetOrDirection(true)
spell:blockWalls(true)
spell:cooldown(2 * 1000)
spell:groupCooldown(2 * 1000)
spell:needLearn(false)
spell:vocation("druid;true", "elder druid;true", "sorcerer;true", "master sorcerer;true")
spell:register()
