function onGetFormulaValues(player, skill, attack, factor)
	local maglevel = player:getMagicLevel()
	local skillTotal = maglevel * attack
	local levelTotal = player:getLevel() / 4
	-- Multiplicative formula
	local minMult = ((skillTotal * 0.178) + 10) + levelTotal
	local maxMult = ((skillTotal * 0.328) + 15) + levelTotal
	-- Original formula as floor
	local minOrig = levelTotal + (maglevel * 5.5)
	local maxOrig = levelTotal + (maglevel * 9)
	return -math.max(minMult, minOrig), -math.max(maxMult, maxOrig)
end

local initCombat = Combat()
initCombat:setCallback(CALLBACK_PARAM_SKILLVALUE, "onGetFormulaValues")

local function createCombat(combat, area)
	combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_DEATHDAMAGE)
	combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_MORTAREA)
	combat:setArea(createCombatArea(area))
	return combat
end

local combat1 = createCombat(initCombat, AREA_BEAM6)
local combat2 = createCombat(initCombat, AREA_BEAM7)
local combat3 = createCombat(initCombat, AREA_BEAM8)
local combat = { combat1, combat2, combat3 }

local spell = Spell("instant")

local exhaust = {}
function spell.onCastSpell(creature, var)
	if not creature or not creature:isPlayer() then
		return false
	end

	local grade = creature:upgradeSpellsWOD("Great Death Beam")
	if grade == WHEEL_GRADE_NONE then
		creature:sendCancelMessage("You need to learn this spell first")
		creature:getPosition():sendMagicEffect(CONST_ME_POFF)
		return false
	end

	return combat[grade]:execute(creature, var)
end

spell:group("attack", "greatbeams")
spell:id(260)
spell:name("Great Death Beam")
spell:words("exevo max mort")
spell:level(300)
spell:mana(140)
spell:isPremium(false)
spell:needDirection(true)
spell:blockWalls(true)
spell:cooldown(10 * 1000)
spell:groupCooldown(2 * 1000, 6 * 1000)
spell:needLearn(true)
spell:vocation("sorcerer;true", "master sorcerer;true")
spell:register()
