local combatWarn = Combat()
combatWarn:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_TUTORIALSQUARE)

local combat = Combat()

arr = {
	{ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
	{ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
	{ 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0 },
	{ 0, 0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0, 0 },
	{ 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0 },
	{ 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0 },
	{ 0, 0, 1, 1, 1, 1, 3, 1, 1, 1, 1, 0, 0 },
	{ 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0 },
	{ 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0 },
	{ 0, 0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0, 0 },
	{ 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0 },
	{ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
	{ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
}


local area = createCombatArea(arr)
combat:setArea(area)
combatWarn:setArea(area)

function onTargetTile(creature, pos)
	local creatureTable = {}
	local n, i = Tile({ x = pos.x, y = pos.y, z = pos.z }).creatures, 1
	if n ~= 0 then
		local v = getThingfromPos({ x = pos.x, y = pos.y, z = pos.z, stackpos = i }).uid
		while v ~= 0 do
			local creatureFromPos = Creature(v)
			if creatureFromPos then
				table.insert(creatureTable, v)
				if n == #creatureTable then
					break
				end
			end
			i = i + 1
			v = getThingfromPos({ x = pos.x, y = pos.y, z = pos.z, stackpos = i }).uid
		end
	end
	if #creatureTable ~= nil and #creatureTable > 0 then
		for r = 1, #creatureTable do
			if creatureTable[r] ~= creature then
				local min = 6000
				local max = 10000
				local creatureTarget = Creature(creatureTable[r])
				if creatureTarget then
					if (creatureTarget:isPlayer() and table.contains({ vocation }, creatureTarget:getVocation():getBaseId())) or creatureTarget:isMonster() then
						doTargetCombatHealth(creature, creatureTarget, COMBAT_FIREDAMAGE, -min, -max, CONST_ME_NONE)
					end
				end
			end
		end
	end
	pos:sendMagicEffect(CONST_ME_FIREAREA)
	return true
end

combat:setCallback(CALLBACK_PARAM_TARGETTILE, "onTargetTile")

local spell = Spell("instant")

local function delayedCastSpell(cid, var)
	local creature = Creature(cid)
	if not creature then
		return
	end
	return combat:execute(creature, positionToVariant(creature:getPosition()))
end

function spell.onCastSpell(creature, var)
	combatWarn:execute(creature, var)
	addEvent(delayedCastSpell, 3000, creature:getId(), var)
	return true
end

spell:name("fire tentacle fire rain")
spell:words("###541")
spell:isAggressive(true)
spell:blockWalls(true)
spell:needTarget(false)
spell:needLearn(true)
spell:register()
