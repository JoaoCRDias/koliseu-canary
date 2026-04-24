local internalNpcName = "Goldmouth"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 0
npcConfig.walkRadius = 0

npcConfig.outfit = {
	lookType = 128,
	lookHead = 95,
	lookBody = 94,
	lookLegs = 77,
	lookFeet = 77,
	lookAddons = 3,
}

npcConfig.flags = { floorchange = false }

npcConfig.voices = {
	interval = 20000,
	chance = 30,
	{ text = "Gold speaks the only language I understand." },
	{ text = "A wager for the worthy. High or Low?" },
}

local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)

npcType.onThink = function(npc, interval) npcHandler:onThink(npc, interval) end
npcType.onAppear = function(npc, creature) npcHandler:onAppear(npc, creature) end
npcType.onDisappear = function(npc, creature) npcHandler:onDisappear(npc, creature) end
npcType.onMove = function(npc, creature, fromPosition, toPosition) npcHandler:onMove(npc, creature, fromPosition, toPosition) end
npcType.onSay = function(npc, creature, type, message) npcHandler:onSay(npc, creature, type, message) end
npcType.onCloseChannel = function(npc, creature) npcHandler:onCloseChannel(npc, creature) end

local function formatGold(coppers)
	local kk = math.floor(coppers / 1000000)
	return string.format("%d,000,000 gold", kk)
end

local function playerHasCoppers(player, amount)
	return (player:getMoney() + player:getBankBalance()) >= amount
end

local function takeCoppers(player, amount)
	player:removeMoney(amount)
end

local function creatureSayCallback(npc, creature, type, message)
	local player = Player(creature)
	if not player or not npcHandler:checkInteraction(npc, creature) then
		return false
	end

	local playerId = player:getId()
	local text = message:lower()
	local cfg = SupremeVocation.WealthChamber

	-- Already beat Goldmouth.
	if SupremeVocation.hasClearedWealthChamber(player) then
		if MsgContains(text, "play") or MsgContains(text, "high") or MsgContains(text, "low") or MsgContains(text, "bet") then
			npcHandler:say("You already broke me once, friend. The elder waits for your report.", npc, creature)
			return true
		end
	end

	-- Entry fee flow.
	if not SupremeVocation.hasPaidWealthFee(player) then
		if MsgContains(text, "enter") or MsgContains(text, "fee") or MsgContains(text, "play") or MsgContains(text, "game") then
			npcHandler:setTopic(playerId, 1)
			npcHandler:say({
				string.format("Welcome to my house, friend. The entry fee is %s.", formatGold(cfg.entryFeeCoppers)),
				"Pay once and the table is yours forever. Say {yes} to agree.",
			}, npc, creature)
			return true
		end

		if MsgContains(text, "yes") and npcHandler:getTopic(playerId) == 1 then
			if not playerHasCoppers(player, cfg.entryFeeCoppers) then
				npcHandler:say("You don't have the gold. Come back when you do.", npc, creature)
				npcHandler:setTopic(playerId, 0)
				return true
			end
			takeCoppers(player, cfg.entryFeeCoppers)
			SupremeVocation.markWealthFeePaid(player)
			SupremeVocation.resetWealthStreak(player)
			npcHandler:setTopic(playerId, 0)
			npcHandler:say({
				"Now you're welcome here. Every roll costs you " .. formatGold(cfg.rollFeeCoppers) .. ".",
				string.format("Beat me %d times in a row - {high} or {low} on the dice. Miss once and your streak resets.", cfg.requiredStreak),
			}, npc, creature)
			return true
		end

		npcHandler:say("The table is closed to you until you pay the {fee}.", npc, creature)
		return true
	end

	-- Paid players can bet.
	if MsgContains(text, "streak") or MsgContains(text, "score") then
		npcHandler:say(string.format("Your current streak: %d of %d.",
			SupremeVocation.getWealthStreak(player), cfg.requiredStreak), npc, creature)
		return true
	end

	if MsgContains(text, "play") or MsgContains(text, "game") or MsgContains(text, "bet") or MsgContains(text, "rule") then
		npcHandler:say({
			string.format("Say {high} or {low}. A roll costs %s. Beat me %d in a row to walk free.",
				formatGold(cfg.rollFeeCoppers), cfg.requiredStreak),
			"Low is 1-2-3. High is 4-5-6. Miss and your streak resets to zero.",
		}, npc, creature)
		return true
	end

	local isHigh = MsgContains(text, "high") or text == "h"
	local isLow = MsgContains(text, "low") or text == "l"
	if isHigh or isLow then
		if not playerHasCoppers(player, cfg.rollFeeCoppers) then
			npcHandler:say(string.format("You don't have the %s to roll.", formatGold(cfg.rollFeeCoppers)), npc, creature)
			return true
		end
		takeCoppers(player, cfg.rollFeeCoppers)

		local face = math.random(1, 6)
		local rolledHigh = face >= 4
		local won = (isHigh and rolledHigh) or (isLow and not rolledHigh)

		if won then
			local streak = SupremeVocation.getWealthStreak(player) + 1
			SupremeVocation.setWealthStreak(player, streak)
			if streak >= cfg.requiredStreak then
				SupremeVocation.markWealthChamberCleared(player)
				SupremeVocation.resetWealthStreak(player)
				npcHandler:say({
					string.format("%d - %s. I lose, friend. The door is yours.", face, rolledHigh and "high" or "low"),
					"Go. Tell the old warrior Goldmouth kept his word.",
				}, npc, creature)
				player:getPosition():sendMagicEffect(CONST_ME_GOLDEN_FIREWORKS)
			else
				npcHandler:say(string.format("%d - %s. You win. Streak: %d of %d.",
					face, rolledHigh and "high" or "low", streak, cfg.requiredStreak), npc, creature)
			end
		else
			SupremeVocation.resetWealthStreak(player)
			npcHandler:say(string.format("%d - %s. I win. Streak resets.",
				face, rolledHigh and "high" or "low"), npc, creature)
		end
		return true
	end

	return false
end

npcHandler:setMessage(MESSAGE_GREET, "I am Goldmouth, and I take bets. Say {fee} to pay the entry, or {play} if you already have.")
npcHandler:setMessage(MESSAGE_FAREWELL, "Your gold and my patience - both finite.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Hmph.")
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

npcType:register(npcConfig)
