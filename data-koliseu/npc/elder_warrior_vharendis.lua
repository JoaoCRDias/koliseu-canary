local internalNpcName = "Elder Warrior Vharen"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 0
npcConfig.walkRadius = 0

npcConfig.outfit = {
	lookType = 131,
	lookHead = 95,
	lookBody = 116,
	lookLegs = 114,
	lookFeet = 114,
	lookAddons = 0,
}

npcConfig.flags = {
	floorchange = false,
}

npcConfig.voices = {
	interval = 25000,
	chance = 30,
	{ text = "The mountain still claims its due. It always will." },
	{ text = "I am the last who came back. The rest sleep where they fell." },
}

local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)

npcType.onThink = function(npc, interval)
	npcHandler:onThink(npc, interval)
end

npcType.onAppear = function(npc, creature)
	npcHandler:onAppear(npc, creature)
end

npcType.onDisappear = function(npc, creature)
	npcHandler:onDisappear(npc, creature)
end

npcType.onMove = function(npc, creature, fromPosition, toPosition)
	npcHandler:onMove(npc, creature, fromPosition, toPosition)
end

npcType.onSay = function(npc, creature, type, message)
	npcHandler:onSay(npc, creature, type, message)
end

npcType.onCloseChannel = function(npc, creature)
	npcHandler:onCloseChannel(npc, creature)
end

local function creatureSayCallback(npc, creature, type, message)
	local player = Player(creature)
	if not player then
		return false
	end

	if not npcHandler:checkInteraction(npc, creature) then
		return false
	end

	local playerId = player:getId()
	message = message:lower()

	if MsgContains(message, "mountain") or MsgContains(message, "lore") or MsgContains(message, "story") then
		npcHandler:say({
			"This mountain is older than any kingdom that names it. It holds an ancient power within.",
			"Those who reach its heart are said to awaken a {supreme} form of their vocation. I have seen no one come back to prove it.",
			"The mountain does not open for the curious. It opens for the worthy. If you wish to try, ask me for the {task}.",
		}, npc, creature)
		return true
	end

	if MsgContains(message, "supreme") or MsgContains(message, "vocation") or MsgContains(message, "power") then
		npcHandler:say({
			"A power ancestral, sleeping in the stone. They say it reshapes those who earn it into something beyond their craft.",
			"I know little more than that. The mountain keeps its own counsel. Ask me for the {task} if you would begin.",
		}, npc, creature)
		return true
	end

	if MsgContains(message, "task") or MsgContains(message, "access") or MsgContains(message, "prove") or MsgContains(message, "trial") then
		if SupremeVocation.hasMountainAccess(player) then
			npcHandler:say("You have already earned your way onto the mountain. Climb, then.", npc, creature)
			return true
		end

		if SupremeVocation.hasStartedMountain(player) then
			npcHandler:say({
				"You already carry the mark of the trial. The sealed door on the second floor will yield to your step.",
				"The stones above shift with the mountain's humour. Only one arrangement is ever the true one, and it will not hold for long. Climb and search.",
			}, npc, creature)
			return true
		end

		npcHandler:setTopic(playerId, 1)
		npcHandler:say({
			"Then listen well. The second floor of this mountain hides twenty stone levers, laid in a grid of five rows by four columns.",
			"The shape that grants passage is not shown to anyone. The mountain itself decides it, and changes its mind often. You must discover it by your own hand.",
			"Align the levers and pull the central mechanism. Every pull consumes the attempt, and the stones fall back to rest. Speak {yes} if you accept the trial.",
		}, npc, creature)
		return true
	end

	if MsgContains(message, "yes") then
		if npcHandler:getTopic(playerId) == 1 then
			SupremeVocation.startMountain(player)
			npcHandler:say({
				"It is done. The sealed door on the second floor will now yield to your step.",
				"Climb. Pull. Fail. Pull again. The mountain does not care how many tries it costs you.",
			}, npc, creature)
			npcHandler:setTopic(playerId, 0)
			player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
			return true
		end

		return false
	end

	if MsgContains(message, "report") then
		-- Sixth report: after beating Goldmouth in the wealth chamber.
		if SupremeVocation.hasReportedWealthChamber(player) and not SupremeVocation.hasCompletedWealthStage(player) then
			SupremeVocation.completeWealthStage(player)
			npcHandler:say({
				"You broke the gambler. Few do. Gold bends to the worthy as stone did before it.",
				"Five trials behind you. The summit is open. Climb when you are ready.",
			}, npc, creature)
			player:getPosition():sendMagicEffect(CONST_ME_HOLYAREA)
			return true
		end

		if SupremeVocation.hasCompletedWealthStage(player) then
			npcHandler:say("The wealth chamber is behind you. The summit of the mountain awaits.", npc, creature)
			return true
		end

		-- Fifth report: after clearing the fire chamber.
		if SupremeVocation.hasReportedFireChamber(player) then
			SupremeVocation.completeFireStage(player)
			npcHandler:say({
				"The bonfire held. Beyond the ordinary paths lies the {wealth chamber} - a room that tests the grip of gold and the nerve of the wager.",
				"Go when you are ready.",
			}, npc, creature)
			player:getPosition():sendMagicEffect(CONST_ME_HOLYAREA)
			return true
		end

		if SupremeVocation.hasCompletedFireStage(player) and not SupremeVocation.hasClearedWealthChamber(player) then
			npcHandler:say("The fire chamber is behind you. Press into the {wealth chamber} when you are ready.", npc, creature)
			return true
		end

		-- Fourth report: after clearing the death chamber.
		if SupremeVocation.hasReportedDeathChamber(player) and not SupremeVocation.hasCompletedDeathStage(player) then
			SupremeVocation.completeDeathStage(player)
			npcHandler:say({
				"You walked through skeletons, stone, and spectre. Three biomes cleansed.",
				"The final path of the mountain is the {fire chamber} - its flames will answer to you now.",
				"Go when you are ready.",
			}, npc, creature)
			player:getPosition():sendMagicEffect(CONST_ME_HOLYAREA)
			return true
		end

		if SupremeVocation.hasCompletedDeathStage(player) and not SupremeVocation.hasClearedFireChamber(player) then
			npcHandler:say("The death chamber is behind you. Press into the {fire chamber} when you are ready.", npc, creature)
			return true
		end

		-- Third report: after surviving the poison chamber.
		if SupremeVocation.hasPoisonReportPending(player) and not SupremeVocation.hasCompletedPoisonStage(player) then
			SupremeVocation.completePoisonStage(player)
			npcHandler:say({
				"You walked into the poison chamber and walked out. That alone speaks louder than most warriors ever will.",
				"Two biomes cleansed. The next trial is a {death chamber} deeper in the mountain - the veil now parts for you.",
				"Go when you are ready.",
			}, npc, creature)
			player:getPosition():sendMagicEffect(CONST_ME_HOLYAREA)
			return true
		end

		if SupremeVocation.hasCompletedPoisonStage(player) and not SupremeVocation.hasClearedDeathChamber(player) then
			npcHandler:say("The poison chamber is behind you. Press into the {death chamber} when you are ready.", npc, creature)
			return true
		end

		-- Second report: after purifying the fountain.
		if SupremeVocation.hasPurifiedFountain(player) and not SupremeVocation.hasCompletedNatureStage(player) then
			SupremeVocation.completeNatureStage(player)
			npcHandler:say({
				"The fountain of nature runs clean again. I felt the grove breathe the moment you struck the water with the offering.",
				"One biome cleansed. Three still rot within this mountain. The next is a {swamp} of poison deeper within - its miasma now parts for you.",
				"Go when you are ready. I will wait for your word.",
			}, npc, creature)
			player:getPosition():sendMagicEffect(CONST_ME_HOLYAREA)
			return true
		end

		if SupremeVocation.hasCompletedNatureStage(player) and not SupremeVocation.hasClearedPoisonRoom(player) then
			npcHandler:say("The nature stage is behind you. Press into the {swamp} when you are ready.", npc, creature)
			return true
		end

		if SupremeVocation.hasReportedTrial(player) then
			npcHandler:say({
				"You have already reported the trial. Seek the {basins} inside the mountain, and gather the {extracts} from the plants of the continent.",
				"Once the {fountain} has been purified, return and report again.",
			}, npc, creature)
			return true
		end

		if not SupremeVocation.hasMountainAccess(player) then
			npcHandler:say("You have nothing to report yet. Climb the mountain and pass the trial first.", npc, creature)
			return true
		end

		-- First report: after the lever trial.
		SupremeVocation.completeReport(player)
		npcHandler:say({
			"So the stones yielded to you. Few have lived to stand here and say that.",
			"Listen now: beyond the trial's gate, a {wall of energies} blocks the inner paths. It will part for you from this moment on.",
			"Past it lies a sanctum of nature with four {basins}. To awaken it you must gather four {extracts} from rare plants hidden across the continent, \z
				place one on each basin, and pull the central mechanism. Do it right and a portal will open for a short breath.",
			"Beyond that portal waits the guardian of the fountain. Cleanse the fountain with what the grove hides for you, then return and report again.",
		}, npc, creature)
		player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
		return true
	end

	if MsgContains(message, "swamp") or MsgContains(message, "poison") or MsgContains(message, "miasma") then
		if SupremeVocation.hasCompletedNatureStage(player) then
			npcHandler:say("The swamp miasma will part for you. Past it you will find four caves, each hiding a purifier for its own fountain. That is all I can say - the rest is for you to see.", npc, creature)
		else
			npcHandler:say("The swamp lies beyond the nature stage. Cleanse the fountain first, then return to {report} to me.", npc, creature)
		end
		return true
	end

	if MsgContains(message, "death chamber") or MsgContains(message, "veil") or MsgContains(message, "skeletons") or MsgContains(message, "ghosts") then
		if SupremeVocation.hasCompletedPoisonStage(player) then
			npcHandler:say("Eight dead speak in the first hall. Past them, a labyrinth. Past that, the terrace where four spectres sleep. Find the order - the mural will tell it.", npc, creature)
		else
			npcHandler:say("The death chamber lies beyond the poison stage. Survive the chamber first, then return to {report} to me.", npc, creature)
		end
		return true
	end

	if MsgContains(message, "fire chamber") or MsgContains(message, "bonfire") or MsgContains(message, "flame") then
		if SupremeVocation.hasCompletedDeathStage(player) then
			npcHandler:say("A bonfire in a room of ice. Keep it burning for five minutes - the cold will try to put it out with tooth and claw. Logs fall; feed the flame.", npc, creature)
		else
			npcHandler:say("The fire chamber lies beyond the death chamber. Clear the death chamber first, then return to {report} to me.", npc, creature)
		end
		return true
	end

	if MsgContains(message, "wealth chamber") or MsgContains(message, "gambler") or MsgContains(message, "goldmouth") then
		if SupremeVocation.hasCompletedFireStage(player) then
			npcHandler:say("Gold in place of steel. A gambler called Goldmouth waits there - beat him at the dice and the door opens.", npc, creature)
		else
			npcHandler:say("The wealth chamber lies beyond the fire chamber. Clear the fire chamber first, then return to {report} to me.", npc, creature)
		end
		return true
	end

	if MsgContains(message, "fountain") or MsgContains(message, "purify") then
		if SupremeVocation.hasCompletedNatureStage(player) then
			npcHandler:say("The fountain of nature is pure. Your mark on it will not fade.", npc, creature)
		elseif SupremeVocation.hasPurifiedFountain(player) then
			npcHandler:say("You have already purified the fountain - now {report} to me so I may acknowledge it.", npc, creature)
		elseif SupremeVocation.hasReportedTrial(player) then
			npcHandler:say("Bring the offering from the grove's chest to the fountain. Use it on the water, and the poison will run out.", npc, creature)
		else
			npcHandler:say("First the trial. Then the {report}. Then we speak of fountains.", npc, creature)
		end
		return true
	end

	if MsgContains(message, "wall") or MsgContains(message, "energies") then
		if SupremeVocation.hasReportedTrial(player) then
			npcHandler:say("The wall of energies reads the mark I gave you. It will let you through.", npc, creature)
		else
			npcHandler:say("A wall of energies blocks the inner paths. You must prove the trial and {report} to me before it yields.", npc, creature)
		end
		return true
	end

	if MsgContains(message, "basin") or MsgContains(message, "extract") or MsgContains(message, "plant") then
		if SupremeVocation.hasReportedTrial(player) then
			npcHandler:say({
				"Four plants. Four extracts. Each plant yields its extract only once every four hours.",
				"Place one extract on each basin and use the central mechanism. A portal will open, but only briefly.",
			}, npc, creature)
		else
			npcHandler:say("First the trial. Then the {report}. Then we speak of basins.", npc, creature)
		end
		return true
	end

	return false
end

npcHandler:setMessage(MESSAGE_GREET, "Steady, |PLAYERNAME|. I am the last guardian of this isle. Ask me of the {mountain}, the {task} that gates it, or {report} if you have already passed it.")
npcHandler:setMessage(MESSAGE_FAREWELL, "Climb or leave. The mountain cares for neither.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Steady.")
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

npcType:register(npcConfig)
