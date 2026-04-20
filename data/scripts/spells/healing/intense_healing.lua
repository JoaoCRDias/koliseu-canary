local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_HEALING)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_MAGIC_BLUE)
combat:setParameter(COMBAT_PARAM_DISPEL, CONDITION_PARALYZE)
combat:setParameter(COMBAT_PARAM_AGGRESSIVE, false)

function onGetFormulaValues(player, level, magicLevel) -- already compared to the official tibia | compared date: 05/07/19(m/d/y)
	local vocName = player:getVocation():getBase():getName()
	local isEKorRP = (vocName == "Knight" or vocName == "Paladin")
	local levelMult = isEKorRP and 1.0 or 0.2
	local min = (level * levelMult + magicLevel * 3.184) + 20
	local max = (level * levelMult + magicLevel * 5.59) + 35
	local bonus = 1
	if player:isMonk() then
		bonus = 1.5
	elseif vocName == "Sorcerer" or vocName == "Druid" then
		bonus = 0.5
	end
	return min * bonus, max * bonus
end

combat:setCallback(CALLBACK_PARAM_LEVELMAGICVALUE, "onGetFormulaValues")

local spell = Spell("instant")

function spell.onCastSpell(creature, variant)
	return combat:execute(creature, variant)
end

spell:name("Intense Healing")
spell:words("exura gran")
spell:group("healing")
spell:vocation("druid;true", "elder druid;true", "paladin;true", "royal paladin;true", "sorcerer;true", "master sorcerer;true", "monk;true", "exalted monk;true")
spell:castSound(SOUND_EFFECT_TYPE_SPELL_INTENSE_HEALING)
spell:id(2)
spell:cooldown(1000)
spell:groupCooldown(1000)
spell:level(20)
spell:mana(70)
spell:isSelfTarget(true)
spell:isAggressive(false)
spell:register()
