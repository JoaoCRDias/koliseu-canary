local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_ICEDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_ICEATTACK)
combat:setArea(createCombatArea(AREA_BURST3))

function onGetFormulaValues(player, skill, attack, factor)
	local maglevel = player:getMagicLevel()
	local skillTotal = maglevel * attack
	local levelTotal = player:getLevel() / 4
	-- Multiplicative formula
	local minMult = ((skillTotal * 0.260) + 15) + levelTotal
	local maxMult = ((skillTotal * 0.368) + 20) + levelTotal
	-- Original formula as floor
	local minOrig = levelTotal + (maglevel * 7)
	local maxOrig = levelTotal + (maglevel * 10.5)
	return -math.max(minMult, minOrig), -math.max(maxMult, maxOrig)
end

combat:setCallback(CALLBACK_PARAM_SKILLVALUE, "onGetFormulaValues")

local spell = Spell("instant")

function spell.onCastSpell(creature, var)
	local grade = creature:revelationStageWOD("Twin Burst")
	if grade == 0 then
		creature:sendCancelMessage("You need to learn this spell first")
		creature:getPosition():sendMagicEffect(CONST_ME_POFF)
		return false
	end

	return combat:execute(creature, var)
end

spell:group("attack", "burstsofnature")
spell:id(262)
spell:name("Ice Burst")
spell:words("exevo ulus frigo")
spell:castSound(SOUND_EFFECT_TYPE_SPELL_ETERNAL_WINTER)
spell:level(300)
spell:mana(230)
spell:isPremium(true)
spell:isSelfTarget(true)
spell:cooldown(22 * 1000)
spell:groupCooldown(2 * 1000, 22 * 1000)
spell:needLearn(true)
spell:vocation("druid;true", "elder druid;true")
spell:register()
