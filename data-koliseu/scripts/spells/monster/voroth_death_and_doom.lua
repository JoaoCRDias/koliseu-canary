-- Voroth's Death and Doom: warns, channels, then detonates a large AoE

local combatWarn = Combat()
combatWarn:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_TUTORIALSQUARE)

local area = {
	{ 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0 },
	{ 0, 0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0, 0 },
	{ 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0 },
	{ 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0 },
	{ 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0 },
	{ 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0 },
	{ 1, 1, 1, 1, 1, 1, 3, 1, 1, 1, 1, 1, 1 },
	{ 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0 },
	{ 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0 },
	{ 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0 },
	{ 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0 },
	{ 0, 0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0, 0 },
	{ 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0 },
}

local createArea = createCombatArea(area)

local combat = Combat()
combat:setArea(createArea)
combatWarn:setArea(createArea)

function onTargetTile(creature, pos)
	local min = 500000
	local max = 600000
	local tile = Tile(pos)
	if tile then
		local top = tile:getTopCreature()
		if top then
			if top:isPlayer() or top:isMonster() then
				doTargetCombatHealth(creature, top, COMBAT_DEATHDAMAGE, -min, -max, CONST_ME_NONE)
			end
		end
	end
	pos:sendMagicEffect(CONST_ME_PURPLEENERGY)
	return true
end

combat:setCallback(CALLBACK_PARAM_TARGETTILE, "onTargetTile")

local function delayedCastSpell(cid, var)
	local creature = Creature(cid)
	if not creature then return end
	creature:say("DEATH AND DOOM!", TALKTYPE_MONSTER_YELL)
	return combat:execute(creature, positionToVariant(creature:getPosition()))
end

local spell = Spell("instant")

function spell.onCastSpell(creature, var)
	creature:say("Voroth channels DEATH AND DOOM! FLEE!", TALKTYPE_MONSTER_YELL)
	combatWarn:execute(creature, var)
	addEvent(delayedCastSpell, 5000, creature:getId(), var)
	return true
end

spell:name("voroth death and doom")
spell:words("###vdoom")
spell:isAggressive(true)
spell:blockWalls(true)
spell:needTarget(false)
spell:needLearn(true)
spell:register()
