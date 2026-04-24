local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_FIREDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_HITBYFIRE)
combat:setArea(createCombatArea(AREA_WAVE4, AREADIAGONAL_WAVE4))

function onGetFormulaValues(player, skill, attack, factor)
	local level = player:getLevel()
	local maglevel = player:getMagicLevel()
	local min = (level / 4) + (maglevel * 0.3) + 2
	local max = (level / 4) + (maglevel * 0.6) + 4
	local weaponBonus = 1 + (attack * 0.002)
	return -min * weaponBonus, -max * weaponBonus
end

combat:setCallback(CALLBACK_PARAM_SKILLVALUE, "onGetFormulaValues")

local spell = Spell("instant")

function spell.onCastSpell(creature, var)
	return combat:execute(creature, var)
end

spell:group("attack")
spell:id(178)
spell:name("Scorch")
spell:words("exevo infir flam hur")
spell:castSound(SOUND_EFFECT_TYPE_SPELL_SCORCH)
spell:level(1)
spell:mana(8)
spell:isAggressive(true)
spell:isPremium(false)
spell:needDirection(true)
spell:cooldown(4 * 1000)
spell:groupCooldown(2 * 1000)
spell:needLearn(false)
spell:vocation("sorcerer;true", "master sorcerer;true", "arcane sorcerer;true")
spell:register()
