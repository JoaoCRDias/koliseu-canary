-- Lesser Mystic Repulse - Newhaven Update 15.12.c7d92c
-- A weaker version of Mystic Repulse for low level Monks

local combatPhysical = Combat()
combatPhysical:setParameter(COMBAT_PARAM_TYPE, COMBAT_PHYSICALDAMAGE)
combatPhysical:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_WHITE_ENERGYPULSE)

local combatEnergy = Combat()
combatEnergy:setParameter(COMBAT_PARAM_TYPE, COMBAT_ENERGYDAMAGE)
combatEnergy:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_PINK_ENERGYPULSE)

local combatEarth = Combat()
combatEarth:setParameter(COMBAT_PARAM_TYPE, COMBAT_EARTHDAMAGE)
combatEarth:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_GREEN_ENERGYPULSE)

function onGetFormulaValuesLesser(player, skill, weaponDamage, attackFactor)
	local basePower = 36 -- Half of regular Mystic Repulse (72)
	local attackValue = calculateAttackValue(player, skill, weaponDamage)
	local spellFactor = 0.35 -- Half of regular (0.7)
	local total = (basePower * attackValue) / 100 + (spellFactor * attackValue)
	return -total * 0.9, -total * 1.1
end

onGetFormulaValuesLesserEnergy = loadstring(string.dump(onGetFormulaValuesLesser))
onGetFormulaValuesLesserEarth = loadstring(string.dump(onGetFormulaValuesLesser))
onGetFormulaValuesLesserPhysical = loadstring(string.dump(onGetFormulaValuesLesser))

combatPhysical:setCallback(CALLBACK_PARAM_SKILLVALUE, "onGetFormulaValuesLesserPhysical")
combatEnergy:setCallback(CALLBACK_PARAM_SKILLVALUE, "onGetFormulaValuesLesserEnergy")
combatEarth:setCallback(CALLBACK_PARAM_SKILLVALUE, "onGetFormulaValuesLesserEarth")

local combatTypes = {
	["physical"] = combatPhysical,
	["energy"] = combatEnergy,
	["earth"] = combatEarth,
}

local spell = Spell("instant")

function spell.onCastSpell(creature, var)
	local combat = combatPhysical
	local weapon = creature:getSlotItem(CONST_SLOT_LEFT)
	if weapon then
		local itemType = weapon:getType()
		if itemType and itemType.getElementalBond then
			local elementalBondType = itemType:getElementalBond():lower()
			if elementalBondType then
				combat = combatTypes[elementalBondType] or combat
			end
		end
	end

	creature:addHarmony(1)

	return combat:execute(creature, var)
end

spell:group("attack")
spell:id(291)
spell:name("Lesser Mystic Repulse")
spell:words("exori infir amp pug")
spell:castSound(SOUND_EFFECT_TYPE_SPELL_MYSTIC_REPULSE)
spell:level(6)
spell:mana(30)
spell:isPremium(false)
spell:range(7)
spell:needTarget(true)
spell:blockWalls(true)
spell:needWeapon(false)
spell:cooldown(6 * 1000)
spell:groupCooldown(2 * 1000)
spell:needLearn(false)
spell:vocation("monk;true", "exalted monk;true")
spell:register()
