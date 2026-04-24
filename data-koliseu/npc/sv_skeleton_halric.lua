local internalNpcName = "Halric"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName
npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 0
npcConfig.walkRadius = 0

npcConfig.outfit = {
	lookType = 298,
}

npcConfig.flags = { floorchange = false }

local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)

npcType.onThink = function(npc, interval) npcHandler:onThink(npc, interval) end
npcType.onAppear = function(npc, creature) npcHandler:onAppear(npc, creature) end
npcType.onDisappear = function(npc, creature) npcHandler:onDisappear(npc, creature) end
npcType.onMove = function(npc, creature, fromPosition, toPosition) npcHandler:onMove(npc, creature, fromPosition, toPosition) end
npcType.onSay = function(npc, creature, type, message) npcHandler:onSay(npc, creature, type, message) end
npcType.onCloseChannel = function(npc, creature) npcHandler:onCloseChannel(npc, creature) end

-- Per-player puzzle state (answer step). Indexed by player id.
local answerProgress = {}

local function expectedName(step)
	return SupremeVocation.DeathPuzzleOrder[step]
end

local function normalizeName(s)
	return (s:gsub("^%s+", ""):gsub("%s+$", "")):lower()
end

local function creatureSayCallback(npc, creature, type, message)
	local player = Player(creature)
	if not player then
		return false
	end

	local interaction = npcHandler:checkInteraction(npc, creature)
	local playerId = player:getId()
	local text = message:lower()
	logger.info(string.format("[Halric] player=%s interaction=%s message=%q progress=%s",
		player:getName(), tostring(interaction), message, tostring(answerProgress[playerId])))

	if not interaction then
		return false
	end

	-- Player already solved; the master just acknowledges.
	if SupremeVocation.hasSolvedDeathPuzzle(player) then
		if MsgContains(text, "answer") or MsgContains(text, "order") then
			npcHandler:say("The rite is already done. The stair beyond is open to you.", npc, creature)
		end
		return true
	end

	if MsgContains(text, "answer") or MsgContains(text, "order") then
		answerProgress[playerId] = 1
		logger.info("[Halric] answer mode started")
		npcHandler:say(string.format(
			"Then speak the names in order. Begin with the first to fall. (%d of %d).",
			1, #SupremeVocation.DeathPuzzleOrder), npc, creature)
		return true
	end

	-- If the player is inside an ongoing answer, try to match the current step.
	local step = answerProgress[playerId]
	if step then
		local expected = expectedName(step)
		local normalized = normalizeName(message)
		logger.info(string.format("[Halric] step=%d expected=%q normalized=%q match=%s",
			step, tostring(expected), normalized, tostring(expected and normalized == expected:lower())))
		if expected and normalized == expected:lower() then
			step = step + 1
			if step > #SupremeVocation.DeathPuzzleOrder then
				answerProgress[playerId] = nil
				SupremeVocation.markDeathPuzzleSolved(player)
				npcHandler:say("The rite is sealed. Climb, seeker. The stair yields to you.", npc, creature)
				player:getPosition():sendMagicEffect(CONST_ME_HOLYAREA)
			else
				answerProgress[playerId] = step
				npcHandler:say(string.format(
					"Yes. (%d of %d).", step, #SupremeVocation.DeathPuzzleOrder), npc, creature)
			end
			return true
		else
			-- Any name spoken that isn't the expected one (and isn't a command)
			-- breaks the sequence.
			local looksLikeName = message:match("^[A-Za-z]+$")
			if looksLikeName then
				answerProgress[playerId] = nil
				npcHandler:say("No. The order is broken. Begin again with {answer}.", npc, creature)
				return true
			end
		end
	end

	return false
end

npcHandler:setMessage(MESSAGE_GREET, "Aldric fell after me, and Fyodor lies. Say {answer} to recite the rite.")
npcHandler:setMessage(MESSAGE_FAREWELL, "...")
npcHandler:setMessage(MESSAGE_WALKAWAY, "...")
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

npcType:register(npcConfig)
