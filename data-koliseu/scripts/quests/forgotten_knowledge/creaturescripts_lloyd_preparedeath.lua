local monsters = {
	{ cosmicNormal = "cosmic energy prism a", cosmicInvu = "cosmic energy prism a invu", pos = Position(1375, 1039, 15) },
	{ cosmicNormal = "cosmic energy prism b", cosmicInvu = "cosmic energy prism b invu", pos = Position(1377, 1040, 15) },
	{ cosmicNormal = "cosmic energy prism c", cosmicInvu = "cosmic energy prism c invu", pos = Position(1380, 1040, 15) },
	{ cosmicNormal = "cosmic energy prism d", cosmicInvu = "cosmic energy prism d invu", pos = Position(1382, 1039, 15) },
}

local function revertLloyd(prismId)
	local lloydTile = Tile(Position(1378, 1038, 15))
	if lloydTile then
		local lloyd = lloydTile:getTopCreature()
		if lloyd then
			lloyd:teleportTo(Position(1378, 1041, 15))
			lloyd:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		end
	end

	local tile = Tile(monsters[prismId].pos)
	if tile then
		local creatures = tile:getCreatures()
		for _, creature in ipairs(creatures) do
			if creature:isMonster() then
				creature:remove()
			end
		end
		Game.createMonster(monsters[prismId].cosmicInvu, Position(monsters[prismId].pos), true, true)
	end
end

local lloydPrepareDeath = CreatureEvent("LloydPrepareDeath")
function lloydPrepareDeath.onPrepareDeath(creature, lastHitKiller, mostDamageKiller)
	local prismCount = 1
	for m = 1, #monsters do
		local cosmic = Tile(Position(monsters[m].pos)):getTopCreature()
		if not cosmic then
			prismCount = prismCount + 1
		end
	end

	local reborn = false
	if prismCount <= 4 then
		Tile(monsters[prismCount].pos):getTopCreature():remove()
		Game.createMonster(monsters[prismCount].cosmicNormal, Position(monsters[prismCount].pos), true, true)
		reborn = true
	end

	if reborn then
		creature:teleportTo(Position(1378, 1038, 15))
		creature:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		creature:addHealth(300000, true)
		creature:say("The cosmic energies in the chamber refocus on Lloyd.", TALKTYPE_MONSTER_SAY)
		Storage.ForgottenKnowledge.LloydEvent = addEvent(revertLloyd, 10 * 1000, prismCount)
	end
	return true
end

lloydPrepareDeath:register()
