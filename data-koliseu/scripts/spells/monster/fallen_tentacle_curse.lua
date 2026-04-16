local spell = Spell("instant")



function spell.onCastSpell(creature, var)
	local playerSpectators = {}
	local spectators = Game.getSpectators(creature:getPosition(), false, false)
	for _, spectator in pairs(spectators) do
		if spectator:isPlayer() and spectator:getGroup():getId() < GROUP_TYPE_GAMEMASTER then
			if not table.contains(FallenTentacleCurse.cursedPlayers, spectator:getId()) then
				spectator:getPosition():sendMagicEffect(CONST_ME_FIREATTACK)
				table.insert(playerSpectators, spectator)
			end
		end
	end
	if #playerSpectators > 0 then
		creature:say("HMMMMM, let me see who is the next soul i will consume...", TALKTYPE_MONSTER_SAY)
		local randomIndex = math.random(1, #playerSpectators)
		local randomPlayer = playerSpectators[randomIndex]
		addEvent(function(playerId, cid)
			local p = Creature(playerId)
			local c = Creature(cid)
			if not p or not c then
				return
			end
			table.insert(FallenTentacleCurse.cursedPlayers, playerId)
			p:getPosition():sendMagicEffect(264)
			c:say(p:getName() .. " your soul is MINE!!!!", TALKTYPE_MONSTER_SAY)
		end, 2000, randomPlayer:getId(), creature:getId())
	end
	return true
end

spell:name("fallen tentacle curse")
spell:words("###530")
spell:isAggressive(true)
spell:blockWalls(true)
spell:needTarget(false)
spell:needLearn(true)
spell:register()
