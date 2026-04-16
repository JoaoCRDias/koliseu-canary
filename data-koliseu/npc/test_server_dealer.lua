local internalNpcName = "Test Server Dealer"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = "a test server dealer"

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 0
npcConfig.walkRadius = 0

npcConfig.outfit = {
	lookType = 3025,
	lookHead = 114,
	lookBody = 94,
	lookLegs = 78,
	lookFeet = 79,
	lookAddons = 3,
}

npcConfig.flags = {
	floorchange = false,
}

npcConfig.voices = {
	interval = 15000,
	chance = 50,
	{ text = "Need some help testing? I can give you exp, money, items, skills, mounts, or addons!" },
	{ text = "Say trade to buy test items!" },
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

-- Callback for handling conversation
local function creatureSayCallback(npc, creature, type, message)
	local player = Player(creature)
	local playerId = player:getId()

	if not npcHandler:checkInteraction(npc, creature) then
		return false
	end

	-- Topic IDs:
	-- 1 = waiting for exp confirmation
	-- 2 = waiting for money confirmation
	-- 3 = waiting for mounts confirmation
	-- 4 = waiting for addons confirmation
	-- 5 = waiting for skills confirmation
	-- 6 = waiting for htp confirmation
	-- 7 = waiting for coins confirmation

	-- Experience
	if MsgContains(message, "exp") or MsgContains(message, "experience") then
		local targetLevel = player:getLevel() + 100
		local expNeeded = Game.getExperienceForLevel(targetLevel) - player:getExperience()
		if expNeeded < 1 then
			expNeeded = 1
		end
		npcHandler:say("Do you want to receive enough experience to reach level " .. targetLevel .. "? Say {yes} to confirm.", npc, creature)
		npcHandler:setTopic(playerId, 1)
		return true
	end

	-- Money
	if MsgContains(message, "money") or MsgContains(message, "gold") then
		npcHandler:say("Do you want to receive 10kk gold coins in your bank account? Say {yes} to confirm.", npc, creature)
		npcHandler:setTopic(playerId, 2)
		return true
	end

	-- Mounts
	if MsgContains(message, "mounts") or MsgContains(message, "mount") then
		npcHandler:say("Do you want to receive all available mounts? Say {yes} to confirm.", npc, creature)
		npcHandler:setTopic(playerId, 3)
		return true
	end

	-- Addons
	if MsgContains(message, "addons") or MsgContains(message, "addon") then
		npcHandler:say("Do you want to receive all available outfit addons? Say {yes} to confirm.", npc, creature)
		npcHandler:setTopic(playerId, 4)
		return true
	end

	-- Skills
	if MsgContains(message, "skills") or MsgContains(message, "skill") then
		npcHandler:say("Do you want to max your skills? (Fist: 500, Main skills: 130, Magic Level: based on vocation) Say {yes} to confirm.", npc, creature)
		npcHandler:setTopic(playerId, 5)
		return true
	end

	-- Coins
	if MsgContains(message, "coins") or MsgContains(message, "coin") then
		npcHandler:say("Do you want to receive 100,000 coins and 100,000 transferable coins? Say {yes} to confirm.", npc, creature)
		npcHandler:setTopic(playerId, 7)
		return true
	end

	-- HTP (Hunting Task Points)
	if MsgContains(message, "htp") or MsgContains(message, "hunting task points") then
		npcHandler:say("Do you want to receive 1kk (1,000,000) Hunting Task Points? Say {yes} to confirm.", npc, creature)
		npcHandler:setTopic(playerId, 6)
		return true
	end

	-- Items info
	if MsgContains(message, "items") or MsgContains(message, "item") then
		npcHandler:say("Say {trade} to browse all available test items including gems, sanguine equipment, divinity items, and more!", npc, creature)
		return true
	end

	-- Yes confirmation
	if MsgContains(message, "yes") then
		local topic = npcHandler:getTopic(playerId)

		-- Confirm EXP
		if topic == 1 then
			local targetLevel = player:getLevel() + 100
			local expAmount = Game.getExperienceForLevel(targetLevel) - player:getExperience()
			if expAmount < 1 then
				expAmount = 1
			end
			player:addExperience(expAmount, true)
			npcHandler:say("You are now level " .. player:getLevel() .. "! Enjoy!", npc, creature)
			player:getPosition():sendMagicEffect(CONST_ME_FIREWORK_YELLOW)
			npcHandler:setTopic(playerId, 0)
			return true
		end

		-- Confirm Money
		if topic == 2 then
			local moneyAmount = 100000000000 -- 10kk
			player:setBankBalance(player:getBankBalance() + moneyAmount)
			npcHandler:say("I've added " .. moneyAmount .. " gold coins to your bank account!", npc, creature)
			player:getPosition():sendMagicEffect(CONST_ME_FIREWORK_RED)
			npcHandler:setTopic(playerId, 0)
			return true
		end

		-- Confirm Mounts
		if topic == 3 then
			local mountCount = 0
			-- Loop through all valid mount IDs from mounts.xml (1 to 2651)
			for mountId = 1, 2651 do
				local mount = Mount(mountId)
				if mount and not player:hasMount(mountId) then
					player:addMount(mountId)
					mountCount = mountCount + 1
				end
			end

			if mountCount > 0 then
				npcHandler:say("You've received " .. mountCount .. " mounts! Check your store inbox or mount list!", npc, creature)
				player:getPosition():sendMagicEffect(CONST_ME_FIREWORK_BLUE)
			else
				npcHandler:say("You already have all available mounts!", npc, creature)
			end
			npcHandler:setTopic(playerId, 0)
			return true
		end

		-- Confirm Addons
		if topic == 4 then
			-- Valid outfit looktypes from outfits.xml
			local validLookTypes = {
				128, 129, 130, 131, 132, 133, 134, 136, 137, 138, 139, 140, 141, 142, 143, 144, 145, 146, 147, 148, 149, 150, 151, 152, 153, 154, 155, 156, 157, 158,
				251, 252, 268, 269, 270, 273, 278, 279, 288, 289, 324, 325, 328, 329, 335, 336, 366, 367, 430, 431, 432, 433, 463, 464, 465, 466, 471, 472, 512, 513, 514, 516, 541, 542, 574, 575, 577, 578, 610, 618, 619, 620, 632, 633, 634, 635, 636, 637, 664, 665, 666, 667, 683, 684, 694, 695, 696, 697, 698, 699, 724, 725, 732, 733, 745, 746, 749, 750, 759, 760,
				819, 820, 827, 828, 830, 831, 833, 834, 836, 837, 845, 846, 852, 853, 873, 874, 884, 885, 899, 900, 908, 909, 929, 931, 955, 956, 957, 958, 962, 963, 964, 965, 966, 967, 968, 969, 970, 971, 972, 973, 974, 975,
				1020, 1021, 1023, 1024, 1042, 1043, 1050, 1051, 1056, 1057, 1069, 1070, 1094, 1095, 1102, 1103, 1127, 1128, 1146, 1147, 1161, 1162, 1173, 1174, 1186, 1187, 1202, 1203, 1204, 1205, 1206, 1207, 1210, 1211, 1243, 1244, 1245, 1246, 1251, 1252, 1270, 1271, 1279, 1280, 1282, 1283, 1288, 1289, 1292, 1293, 1322, 1323, 1331, 1332, 1338, 1339, 1371, 1372, 1382, 1383, 1384, 1385, 1386, 1387, 1415, 1416, 1436, 1437, 1444, 1445, 1449, 1450, 1456, 1457, 1460, 1461, 1489, 1490, 1500, 1501, 1568, 1569, 1575, 1576, 1581, 1582, 1597, 1598, 1612, 1613, 1618, 1619, 1662, 1663, 1675, 1676, 1680, 1681, 1713, 1714, 1722, 1723, 1725, 1726, 1745, 1746, 1774, 1775, 1776, 1777, 1808, 1809, 1813, 1814, 1850, 1856, 1877, 1878, 1879, 1880, 1881, 1882, 1887, 1888, 1891, 1892, 1910, 1911, 1912, 1913, 1916, 1918, 1919, 1920, 1921, 1922, 1923, 1924, 1925, 1926,
				2604, 2605, 2611, 2615, 2626, 2627, 2639, 2640, 2658, 2659
			}

			local outfitCount = 0
			-- Add all addons for valid outfits from outfits.xml
			for _, lookType in ipairs(validLookTypes) do
				if not player:hasOutfit(lookType, 3) then
					player:addOutfitAddon(lookType, 3)
					outfitCount = outfitCount + 1
				end
			end

			if outfitCount > 0 then
				npcHandler:say("You've received all addons! Check your outfit window!", npc, creature)
				player:getPosition():sendMagicEffect(CONST_ME_FIREWORK_BLUE)
			else
				npcHandler:say("You already have all available addons!", npc, creature)
			end
			npcHandler:setTopic(playerId, 0)
			return true
		end

		-- Confirm Coins
		if topic == 7 then
			local coinsAmount = 100000
			player:addCoinsBalance(coinsAmount)
			player:addTransferableCoins(coinsAmount)
			npcHandler:say("I've added 100,000 coins and 100,000 transferable coins to your account!", npc, creature)
			player:getPosition():sendMagicEffect(CONST_ME_FIREWORK_YELLOW)
			npcHandler:setTopic(playerId, 0)
			return true
		end

		-- Confirm HTP
		if topic == 6 then
			local htpAmount = 1000000 -- 1kk
			player:addTaskHuntingPoints(htpAmount)
			npcHandler:say("I've added 1,000,000 Hunting Task Points to your account!", npc, creature)
			player:getPosition():sendMagicEffect(CONST_ME_FIREWORK_YELLOW)
			npcHandler:setTopic(playerId, 0)
			return true
		end

		-- Confirm Skills
		if topic == 5 then
			local vocationId = player:getVocation():getId()

			-- Skill IDs
			local SKILL_FIST = 0
			local SKILL_CLUB = 1
			local SKILL_SWORD = 2
			local SKILL_AXE = 3
			local SKILL_DISTANCE = 4
			local SKILL_SHIELD = 5
			local SKILL_MAGLEVEL = 7

			-- Set Fist to 500 for all vocations
			player:addSkillTries(SKILL_FIST, player:getVocation():getRequiredSkillTries(SKILL_FIST, 130) - player:getSkillTries(SKILL_FIST))

			-- Set Shield to 130 for all vocations
			player:addSkillTries(SKILL_SHIELD, player:getVocation():getRequiredSkillTries(SKILL_SHIELD, 130) - player:getSkillTries(SKILL_SHIELD))

			-- Vocation-specific skills
			if vocationId == 4 or vocationId == 8 then
				-- Knight (4) or Elite Knight (8)
				-- Set melee skills to 130
				player:addSkillTries(SKILL_CLUB, player:getVocation():getRequiredSkillTries(SKILL_CLUB, 130) - player:getSkillTries(SKILL_CLUB))
				player:addSkillTries(SKILL_SWORD, player:getVocation():getRequiredSkillTries(SKILL_SWORD, 130) - player:getSkillTries(SKILL_SWORD))
				player:addSkillTries(SKILL_AXE, player:getVocation():getRequiredSkillTries(SKILL_AXE, 130) - player:getSkillTries(SKILL_AXE))
				-- Set magic level to 13
				player:addManaSpent(player:getVocation():getRequiredManaSpent(13) - player:getManaSpent())
				-- Set distance to 130
				player:addSkillTries(SKILL_DISTANCE, player:getVocation():getRequiredSkillTries(SKILL_DISTANCE, 130) - player:getSkillTries(SKILL_DISTANCE))
				npcHandler:say("Your skills have been set! (Melee: 130, Distance: 130, Magic Level: 13, Shield: 130, Fist: 500)", npc, creature)
			elseif vocationId == 1 or vocationId == 2 or vocationId == 5 or vocationId == 6 then
				-- Sorcerer (1), Druid (2), Master Sorcerer (5), Elder Druid (6)
				-- Set magic level to 130
				player:addManaSpent(player:getVocation():getRequiredManaSpent(130) - player:getManaSpent())
				-- Set other skills to 130
				player:addSkillTries(SKILL_CLUB, player:getVocation():getRequiredSkillTries(SKILL_CLUB, 130) - player:getSkillTries(SKILL_CLUB))
				player:addSkillTries(SKILL_SWORD, player:getVocation():getRequiredSkillTries(SKILL_SWORD, 130) - player:getSkillTries(SKILL_SWORD))
				player:addSkillTries(SKILL_AXE, player:getVocation():getRequiredSkillTries(SKILL_AXE, 130) - player:getSkillTries(SKILL_AXE))
				player:addSkillTries(SKILL_DISTANCE, player:getVocation():getRequiredSkillTries(SKILL_DISTANCE, 130) - player:getSkillTries(SKILL_DISTANCE))
				npcHandler:say("Your skills have been set! (Magic Level: 130, All other skills: 130, Fist: 500)", npc, creature)
			elseif vocationId == 3 or vocationId == 7 then
				-- Paladin (3) or Royal Paladin (7)
				-- Set distance to 130
				player:addSkillTries(SKILL_DISTANCE, player:getVocation():getRequiredSkillTries(SKILL_DISTANCE, 130) - player:getSkillTries(SKILL_DISTANCE))
				-- Set magic level to 40
				player:addManaSpent(player:getVocation():getRequiredManaSpent(40) - player:getManaSpent())
				-- Set other skills to 130
				player:addSkillTries(SKILL_CLUB, player:getVocation():getRequiredSkillTries(SKILL_CLUB, 130) - player:getSkillTries(SKILL_CLUB))
				player:addSkillTries(SKILL_SWORD, player:getVocation():getRequiredSkillTries(SKILL_SWORD, 130) - player:getSkillTries(SKILL_SWORD))
				player:addSkillTries(SKILL_AXE, player:getVocation():getRequiredSkillTries(SKILL_AXE, 130) - player:getSkillTries(SKILL_AXE))
				npcHandler:say("Your skills have been set! (Distance: 130, Magic Level: 40, All other skills: 130, Fist: 500)", npc, creature)
			else
				-- No vocation or other vocations - set all to 130
				player:addSkillTries(SKILL_CLUB, player:getVocation():getRequiredSkillTries(SKILL_CLUB, 130) - player:getSkillTries(SKILL_CLUB))
				player:addSkillTries(SKILL_SWORD, player:getVocation():getRequiredSkillTries(SKILL_SWORD, 130) - player:getSkillTries(SKILL_SWORD))
				player:addSkillTries(SKILL_AXE, player:getVocation():getRequiredSkillTries(SKILL_AXE, 130) - player:getSkillTries(SKILL_AXE))
				player:addSkillTries(SKILL_DISTANCE, player:getVocation():getRequiredSkillTries(SKILL_DISTANCE, 130) - player:getSkillTries(SKILL_DISTANCE))
				player:addManaSpent(player:getVocation():getRequiredManaSpent(130) - player:getManaSpent())
				npcHandler:say("Your skills have been set! (All skills: 130, Fist: 500)", npc, creature)
			end

			player:getPosition():sendMagicEffect(CONST_ME_FIREWORK_YELLOW)
			npcHandler:setTopic(playerId, 0)
			return true
		end
	end

	-- No confirmation
	if MsgContains(message, "no") then
		npcHandler:say("Alright, let me know if you need anything else!", npc, creature)
		npcHandler:setTopic(playerId, 0)
		return true
	end

	return true
end

-- Greet keyword
keywordHandler:addGreetKeyword({ "hi" }, { npcHandler = npcHandler, text = "Welcome to the Test Server, |PLAYERNAME|! I can help you with {exp}, {money}, {coins}, {items}, {mounts}, {addons}, {skills}, {htp}, or say {trade} for equipment!" })
keywordHandler:addAliasKeyword({ "hello" })

npcHandler:setMessage(MESSAGE_FAREWELL, "Good luck testing!")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Come back when you need more!")
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- Shop configuration
npcConfig.shop = {
	-- Utility Items
	{ itemName = "dust potion", clientId = 60146, buy = 1 },
	{ itemName = "tier upgrader", clientId = 60022, buy = 1 },

	-- Cosmic Gear
	{ itemName = "scroll of cosmic transformation", clientId = 60540, buy = 1 },
	{ itemName = "cosmic helmet", clientId = 60541, buy = 1 },
	{ itemName = "cosmic armor", clientId = 60542, buy = 1 },
	{ itemName = "cosmic legs", clientId = 60543, buy = 1 },
	{ itemName = "pair of cosmic boots", clientId = 60544, buy = 1 },
	{ itemName = "cosmic sword", clientId = 60545, buy = 1 },
	{ itemName = "cosmic club", clientId = 60546, buy = 1 },
	{ itemName = "cosmic axe", clientId = 60547, buy = 1 },
	{ itemName = "cosmic mask", clientId = 60548, buy = 1 },
	{ itemName = "cosmic mantle", clientId = 60549, buy = 1 },
	{ itemName = "cosmic pants", clientId = 60550, buy = 1 },
	{ itemName = "cosmic shoes", clientId = 60551, buy = 1 },
	{ itemName = "cosmic folio", clientId = 60552, buy = 1 },
	{ itemName = "cosmic wand", clientId = 60553, buy = 1 },
	{ itemName = "cosmic crown", clientId = 60554, buy = 1 },
	{ itemName = "cosmic robe", clientId = 60555, buy = 1 },
	{ itemName = "cosmic skirt", clientId = 60556, buy = 1 },
	{ itemName = "cosmic galoshes", clientId = 60557, buy = 1 },
	{ itemName = "cosmic tome", clientId = 60558, buy = 1 },
	{ itemName = "cosmic rod", clientId = 60559, buy = 1 },
	{ itemName = "cosmic headguard", clientId = 60560, buy = 1 },
	{ itemName = "cosmic plate", clientId = 60561, buy = 1 },
	{ itemName = "cosmic greaves", clientId = 60562, buy = 1 },
	{ itemName = "pair of cosmic stalkers", clientId = 60563, buy = 1 },
	{ itemName = "cosmic quiver", clientId = 60564, buy = 1 },
	{ itemName = "cosmic bow", clientId = 60565, buy = 1 },
	{ itemName = "cosmic crossbow", clientId = 60566, buy = 1 },

	-- Bloodrage Gear - Knight
	{ itemName = "bloodrage helmet", clientId = 60593, buy = 1 },
	{ itemName = "bloodrage armor", clientId = 60600, buy = 1 },
	{ itemName = "bloodrage legs", clientId = 60594, buy = 1 },
	{ itemName = "pair of bloodrage boots", clientId = 60590, buy = 1 },
	{ itemName = "bloodrage sword", clientId = 60598, buy = 1 },
	{ itemName = "bloodrage axe", clientId = 60589, buy = 1 },
	{ itemName = "bloodrage club", clientId = 60591, buy = 1 },

	-- Void Pulse Gear - Sorcerer
	{ itemName = "void pulse mask", clientId = 60577, buy = 1 },
	{ itemName = "void pulse mantle", clientId = 60574, buy = 1 },
	{ itemName = "void pulse pants", clientId = 60578, buy = 1 },
	{ itemName = "void pulse shoes", clientId = 60576, buy = 1 },
	{ itemName = "void pulse folio", clientId = 60575, buy = 1 },
	{ itemName = "void pulse wand", clientId = 60572, buy = 1 },

	-- Mystic Nature Gear - Druid
	{ itemName = "mystic nature mask", clientId = 60608, buy = 1 },
	{ itemName = "mystic nature robe", clientId = 60608, buy = 1 },
	{ itemName = "mystic nature skirt", clientId = 60605, buy = 1 },
	{ itemName = "mystic nature galoshes", clientId = 60604, buy = 1 },
	{ itemName = "mystic nature tome", clientId = 60603, buy = 1 },
	{ itemName = "mystic nature rod", clientId = 60960, buy = 1 },

	-- Sacred Gear - Paladin
	{ itemName = "sacred headguard", clientId = 60587, buy = 1 },
	{ itemName = "sacred plate", clientId = 60583, buy = 1 },
	{ itemName = "sacred greaves", clientId = 60588, buy = 1 },
	{ itemName = "pair of sacred stalkers", clientId = 60584, buy = 1 },
	{ itemName = "sacred quiver", clientId = 60580, buy = 1 },
	{ itemName = "sacred bow", clientId = 60585, buy = 1 },
	{ itemName = "sacred crossbow", clientId = 60586, buy = 1 },

	-- Astral Gear - Knight
	{ itemName = "astral helmet", clientId = 60923, buy = 1 },
	{ itemName = "astral armor", clientId = 60924, buy = 1 },
	{ itemName = "astral legs", clientId = 60925, buy = 1 },
	{ itemName = "pair of astral boots", clientId = 60926, buy = 1 },
	{ itemName = "astral sword", clientId = 60918, buy = 1 },
	{ itemName = "astral axe", clientId = 60920, buy = 1 },
	{ itemName = "astral club", clientId = 60921, buy = 1 },

	-- Astral Gear - Sorcerer
	{ itemName = "astral mask", clientId = 60935, buy = 1 },
	{ itemName = "astral mantle", clientId = 60936, buy = 1 },
	{ itemName = "astral pants", clientId = 60937, buy = 1 },
	{ itemName = "astral shoes", clientId = 60938, buy = 1 },
	{ itemName = "astral folio", clientId = 60939, buy = 1 },
	{ itemName = "astral wand", clientId = 60934, buy = 1 },

	-- Astral Gear - Druid
	{ itemName = "astral crown", clientId = 60929, buy = 1 },
	{ itemName = "astral robe", clientId = 60930, buy = 1 },
	{ itemName = "astral skirt", clientId = 60931, buy = 1 },
	{ itemName = "astral galoshes", clientId = 60932, buy = 1 },
	{ itemName = "astral tome", clientId = 60933, buy = 1 },
	{ itemName = "astral rod", clientId = 60928, buy = 1 },

	-- Astral Gear - Paladin
	{ itemName = "astral headguard", clientId = 60912, buy = 1 },
	{ itemName = "astral plate", clientId = 60913, buy = 1 },
	{ itemName = "astral greaves", clientId = 60914, buy = 1 },
	{ itemName = "pair of astral stalkers", clientId = 60915, buy = 1 },
	{ itemName = "astral quiver", clientId = 60916, buy = 1 },
	{ itemName = "astral bow", clientId = 60910, buy = 1 },
	{ itemName = "astral crossbow", clientId = 60911, buy = 1 },

	-- Exercise Tokens
	{ itemName = "exercise weapon token", clientId = 60141, buy = 1 },

	-- Exercise Weapons
	{ itemName = "exercise sword", clientId = 28552, buy = 1 },
	{ itemName = "exercise axe", clientId = 28553, buy = 1 },
	{ itemName = "exercise club", clientId = 28554, buy = 1 },
	{ itemName = "exercise bow", clientId = 28555, buy = 1 },
	{ itemName = "exercise rod", clientId = 28556, buy = 1 },
	{ itemName = "exercise wand", clientId = 28557, buy = 1 },
	{ itemName = "durable exercise sword", clientId = 35279, buy = 1 },
	{ itemName = "durable exercise axe", clientId = 35280, buy = 1 },
	{ itemName = "durable exercise club", clientId = 35281, buy = 1 },
	{ itemName = "durable exercise bow", clientId = 35282, buy = 1 },
	{ itemName = "durable exercise rod", clientId = 35283, buy = 1 },
	{ itemName = "durable exercise wand", clientId = 35284, buy = 1 },
	{ itemName = "lasting exercise sword", clientId = 35285, buy = 1 },
	{ itemName = "lasting exercise axe", clientId = 35286, buy = 1 },
	{ itemName = "lasting exercise club", clientId = 35287, buy = 1 },
	{ itemName = "lasting exercise bow", clientId = 35288, buy = 1 },
	{ itemName = "lasting exercise rod", clientId = 35289, buy = 1 },
	{ itemName = "lasting exercise wand", clientId = 35290, buy = 1 },
	{ itemName = "exercise shield", clientId = 44065, buy = 1 },
	{ itemName = "durable exercise shield", clientId = 44066, buy = 1 },
	{ itemName = "lasting exercise shield", clientId = 44067, buy = 1 },
	{ itemName = "common exercise wraps", clientId = 50292, buy = 1 },
	{ itemName = "exercise wraps", clientId = 50293, buy = 1 },
	{ itemName = "durable exercise wraps", clientId = 50294, buy = 1 },
	{ itemName = "lasting exercise wraps", clientId = 50295, buy = 1 },

	-- Momentum Gems (Tier 1-10)
	{ itemName = "momentum gem tier 1", clientId = 60338, buy = 1 },
	{ itemName = "momentum gem tier 2", clientId = 60339, buy = 1 },
	{ itemName = "momentum gem tier 3", clientId = 60340, buy = 1 },
	{ itemName = "momentum gem tier 4", clientId = 60341, buy = 1 },
	{ itemName = "momentum gem tier 5", clientId = 60342, buy = 1 },
	{ itemName = "momentum gem tier 6", clientId = 60343, buy = 1 },
	{ itemName = "momentum gem tier 7", clientId = 60344, buy = 1 },
	{ itemName = "momentum gem tier 8", clientId = 60345, buy = 1 },
	{ itemName = "momentum gem tier 9", clientId = 60346, buy = 1 },
	{ itemName = "momentum gem tier 10", clientId = 60347, buy = 1 },

	-- Onslaught Gems (Tier 1-10)
	{ itemName = "onslaught gem tier 1", clientId = 60348, buy = 1 },
	{ itemName = "onslaught gem tier 2", clientId = 60349, buy = 1 },
	{ itemName = "onslaught gem tier 3", clientId = 60350, buy = 1 },
	{ itemName = "onslaught gem tier 4", clientId = 60351, buy = 1 },
	{ itemName = "onslaught gem tier 5", clientId = 60352, buy = 1 },
	{ itemName = "onslaught gem tier 6", clientId = 60353, buy = 1 },
	{ itemName = "onslaught gem tier 7", clientId = 60354, buy = 1 },
	{ itemName = "onslaught gem tier 8", clientId = 60355, buy = 1 },
	{ itemName = "onslaught gem tier 9", clientId = 60356, buy = 1 },
	{ itemName = "onslaught gem tier 10", clientId = 60357, buy = 1 },

	-- Transcendence Gems (Tier 1-10)
	{ itemName = "transcendence gem tier 1", clientId = 60358, buy = 1 },
	{ itemName = "transcendence gem tier 2", clientId = 60359, buy = 1 },
	{ itemName = "transcendence gem tier 3", clientId = 60360, buy = 1 },
	{ itemName = "transcendence gem tier 4", clientId = 60361, buy = 1 },
	{ itemName = "transcendence gem tier 5", clientId = 60362, buy = 1 },
	{ itemName = "transcendence gem tier 6", clientId = 60363, buy = 1 },
	{ itemName = "transcendence gem tier 7", clientId = 60364, buy = 1 },
	{ itemName = "transcendence gem tier 8", clientId = 60365, buy = 1 },
	{ itemName = "transcendence gem tier 9", clientId = 60366, buy = 1 },
	{ itemName = "transcendence gem tier 10", clientId = 60367, buy = 1 },

	-- Ruse Gems (Tier 1-10)
	{ itemName = "ruse gem tier 1", clientId = 60368, buy = 1 },
	{ itemName = "ruse gem tier 2", clientId = 60369, buy = 1 },
	{ itemName = "ruse gem tier 3", clientId = 60370, buy = 1 },
	{ itemName = "ruse gem tier 4", clientId = 60371, buy = 1 },
	{ itemName = "ruse gem tier 5", clientId = 60372, buy = 1 },
	{ itemName = "ruse gem tier 6", clientId = 60373, buy = 1 },
	{ itemName = "ruse gem tier 7", clientId = 60374, buy = 1 },
	{ itemName = "ruse gem tier 8", clientId = 60375, buy = 1 },
	{ itemName = "ruse gem tier 9", clientId = 60376, buy = 1 },
	{ itemName = "ruse gem tier 10", clientId = 60377, buy = 1 },

	-- Death Gems (Tier 1-10)
	{ itemName = "death gem tier 1", clientId = 60167, buy = 1 },
	{ itemName = "death gem tier 2", clientId = 60168, buy = 1 },
	{ itemName = "death gem tier 3", clientId = 60169, buy = 1 },
	{ itemName = "death gem tier 4", clientId = 60170, buy = 1 },
	{ itemName = "death gem tier 5", clientId = 60171, buy = 1 },
	{ itemName = "death gem tier 6", clientId = 60172, buy = 1 },
	{ itemName = "death gem tier 7", clientId = 60173, buy = 1 },
	{ itemName = "death gem tier 8", clientId = 60174, buy = 1 },
	{ itemName = "death gem tier 9", clientId = 60175, buy = 1 },
	{ itemName = "death gem tier 10", clientId = 60176, buy = 1 },

	-- Energy Gems (Tier 1-10)
	{ itemName = "energy gem tier 1", clientId = 60177, buy = 1 },
	{ itemName = "energy gem tier 2", clientId = 60178, buy = 1 },
	{ itemName = "energy gem tier 3", clientId = 60179, buy = 1 },
	{ itemName = "energy gem tier 4", clientId = 60180, buy = 1 },
	{ itemName = "energy gem tier 5", clientId = 60181, buy = 1 },
	{ itemName = "energy gem tier 6", clientId = 60182, buy = 1 },
	{ itemName = "energy gem tier 7", clientId = 60183, buy = 1 },
	{ itemName = "energy gem tier 8", clientId = 60184, buy = 1 },
	{ itemName = "energy gem tier 9", clientId = 60185, buy = 1 },
	{ itemName = "energy gem tier 10", clientId = 60186, buy = 1 },

	-- Fire Gems (Tier 1-10)
	{ itemName = "fire gem tier 1", clientId = 60187, buy = 1 },
	{ itemName = "fire gem tier 2", clientId = 60188, buy = 1 },
	{ itemName = "fire gem tier 3", clientId = 60189, buy = 1 },
	{ itemName = "fire gem tier 4", clientId = 60190, buy = 1 },
	{ itemName = "fire gem tier 5", clientId = 60191, buy = 1 },
	{ itemName = "fire gem tier 6", clientId = 60192, buy = 1 },
	{ itemName = "fire gem tier 7", clientId = 60193, buy = 1 },
	{ itemName = "fire gem tier 8", clientId = 60194, buy = 1 },
	{ itemName = "fire gem tier 9", clientId = 60195, buy = 1 },
	{ itemName = "fire gem tier 10", clientId = 60196, buy = 1 },

	-- Holy Gems (Tier 1-10)
	{ itemName = "holy gem tier 1", clientId = 60197, buy = 1 },
	{ itemName = "holy gem tier 2", clientId = 60198, buy = 1 },
	{ itemName = "holy gem tier 3", clientId = 60199, buy = 1 },
	{ itemName = "holy gem tier 4", clientId = 60200, buy = 1 },
	{ itemName = "holy gem tier 5", clientId = 60201, buy = 1 },
	{ itemName = "holy gem tier 6", clientId = 60202, buy = 1 },
	{ itemName = "holy gem tier 7", clientId = 60203, buy = 1 },
	{ itemName = "holy gem tier 8", clientId = 60204, buy = 1 },
	{ itemName = "holy gem tier 9", clientId = 60205, buy = 1 },
	{ itemName = "holy gem tier 10", clientId = 60206, buy = 1 },

	-- Ice Gems (Tier 1-10)
	{ itemName = "ice gem tier 1", clientId = 60207, buy = 1 },
	{ itemName = "ice gem tier 2", clientId = 60208, buy = 1 },
	{ itemName = "ice gem tier 3", clientId = 60209, buy = 1 },
	{ itemName = "ice gem tier 4", clientId = 60210, buy = 1 },
	{ itemName = "ice gem tier 5", clientId = 60211, buy = 1 },
	{ itemName = "ice gem tier 6", clientId = 60212, buy = 1 },
	{ itemName = "ice gem tier 7", clientId = 60213, buy = 1 },
	{ itemName = "ice gem tier 8", clientId = 60214, buy = 1 },
	{ itemName = "ice gem tier 9", clientId = 60215, buy = 1 },
	{ itemName = "ice gem tier 10", clientId = 60216, buy = 1 },

	-- Physical Gems (Tier 1-10)
	{ itemName = "physical gem tier 1", clientId = 60217, buy = 1 },
	{ itemName = "physical gem tier 2", clientId = 60218, buy = 1 },
	{ itemName = "physical gem tier 3", clientId = 60219, buy = 1 },
	{ itemName = "physical gem tier 4", clientId = 60220, buy = 1 },
	{ itemName = "physical gem tier 5", clientId = 60221, buy = 1 },
	{ itemName = "physical gem tier 6", clientId = 60222, buy = 1 },
	{ itemName = "physical gem tier 7", clientId = 60223, buy = 1 },
	{ itemName = "physical gem tier 8", clientId = 60224, buy = 1 },
	{ itemName = "physical gem tier 9", clientId = 60225, buy = 1 },
	{ itemName = "physical gem tier 10", clientId = 60226, buy = 1 },

	-- Earth Gems (Tier 1-10)
	{ itemName = "earth gem tier 1", clientId = 60227, buy = 1 },
	{ itemName = "earth gem tier 2", clientId = 60228, buy = 1 },
	{ itemName = "earth gem tier 3", clientId = 60229, buy = 1 },
	{ itemName = "earth gem tier 4", clientId = 60230, buy = 1 },
	{ itemName = "earth gem tier 5", clientId = 60231, buy = 1 },
	{ itemName = "earth gem tier 6", clientId = 60232, buy = 1 },
	{ itemName = "earth gem tier 7", clientId = 60233, buy = 1 },
	{ itemName = "earth gem tier 8", clientId = 60234, buy = 1 },
	{ itemName = "earth gem tier 9", clientId = 60235, buy = 1 },
	{ itemName = "earth gem tier 10", clientId = 60166, buy = 1 },

	-- Skill Gems
	{ itemName = "paladin skill gem", clientId = 58051, buy = 1 },
	{ itemName = "mage skill gem", clientId = 58052, buy = 1 },
	{ itemName = "knight skill gem", clientId = 58054, buy = 1 },

	-- Upgrade Stones
	{ itemName = "basic upgrade stone", clientId = 60429, buy = 1 },
	{ itemName = "medium upgrade stone", clientId = 60428, buy = 1 },
	{ itemName = "epic upgrade stone", clientId = 60427, buy = 1 },

	-- Sanguine Weapons
	{ itemName = "sanguine blade", clientId = 43864, buy = 10 },
	{ itemName = "grand sanguine blade", clientId = 43865, buy = 10 },
	{ itemName = "sanguine cudgel", clientId = 43866, buy = 10 },
	{ itemName = "grand sanguine cudgel", clientId = 43867, buy = 10 },
	{ itemName = "sanguine hatchet", clientId = 43868, buy = 10 },
	{ itemName = "grand sanguine hatchet", clientId = 43869, buy = 10 },
	{ itemName = "sanguine razor", clientId = 43870, buy = 10 },
	{ itemName = "grand sanguine razor", clientId = 43871, buy = 10 },
	{ itemName = "sanguine bludgeon", clientId = 43872, buy = 10 },
	{ itemName = "grand sanguine bludgeon", clientId = 43873, buy = 10 },
	{ itemName = "sanguine battleaxe", clientId = 43874, buy = 10 },
	{ itemName = "grand sanguine battleaxe", clientId = 43875, buy = 10 },
	{ itemName = "sanguine bow", clientId = 43877, buy = 10 },
	{ itemName = "grand sanguine bow", clientId = 43878, buy = 10 },
	{ itemName = "sanguine crossbow", clientId = 43879, buy = 10 },
	{ itemName = "grand sanguine crossbow", clientId = 43880, buy = 10 },
	{ itemName = "sanguine coil", clientId = 43882, buy = 10 },
	{ itemName = "grand sanguine coil", clientId = 43883, buy = 10 },
	{ itemName = "sanguine rod", clientId = 43885, buy = 10 },
	{ itemName = "grand sanguine rod", clientId = 43886, buy = 10 },

	-- Sanguine Armor
	{ itemName = "sanguine legs", clientId = 43876, buy = 10 },
	{ itemName = "sanguine greaves", clientId = 43881, buy = 10 },
	{ itemName = "sanguine boots", clientId = 43884, buy = 10 },
	{ itemName = "sanguine galoshes", clientId = 43887, buy = 10 },
	-- Falcon Equipment (Endgame)
	{ itemName = "falcon circlet", clientId = 28714, buy = 10 },
	{ itemName = "falcon coif", clientId = 28715, buy = 10 },
	{ itemName = "falcon rod", clientId = 28716, buy = 10 },
	{ itemName = "falcon wand", clientId = 28717, buy = 10 },
	{ itemName = "falcon bow", clientId = 28718, buy = 10 },
	{ itemName = "falcon plate", clientId = 28719, buy = 10 },
	{ itemName = "falcon greaves", clientId = 28720, buy = 10 },
	{ itemName = "falcon escutcheon", clientId = 28722, buy = 10 },
	{ itemName = "falcon longsword", clientId = 28723, buy = 10 },
	{ itemName = "falcon battleaxe", clientId = 28724, buy = 10 },
	{ itemName = "falcon mace", clientId = 28725, buy = 10 },

	-- Level 200+ Equipment
	{ itemName = "ring of ending", clientId = 20182, buy = 10 },
	{ itemName = "fireheart cuirass", clientId = 22518, buy = 10 },
	{ itemName = "fireheart hauberk", clientId = 22519, buy = 10 },
	{ itemName = "fireheart platemail", clientId = 22520, buy = 10 },
	{ itemName = "earthheart cuirass", clientId = 22521, buy = 10 },
	{ itemName = "earthheart hauberk", clientId = 22522, buy = 10 },
	{ itemName = "earthheart platemail", clientId = 22523, buy = 10 },
	{ itemName = "thunderheart cuirass", clientId = 22524, buy = 10 },
	{ itemName = "thunderheart hauberk", clientId = 22525, buy = 10 },
	{ itemName = "thunderheart platemail", clientId = 22526, buy = 10 },
	{ itemName = "frostheart cuirass", clientId = 22527, buy = 10 },
	{ itemName = "frostheart hauberk", clientId = 22528, buy = 10 },
	{ itemName = "frostheart platemail", clientId = 22529, buy = 10 },
	{ itemName = "firesoul tabard", clientId = 22530, buy = 10 },
	{ itemName = "earthsoul tabard", clientId = 22531, buy = 10 },
	{ itemName = "thundersoul tabard", clientId = 22532, buy = 10 },
	{ itemName = "frostsoul tabard", clientId = 22533, buy = 10 },
	{ itemName = "firemind raiment", clientId = 22534, buy = 10 },
	{ itemName = "earthmind raiment", clientId = 22535, buy = 10 },
	{ itemName = "thundermind raiment", clientId = 22536, buy = 10 },
	{ itemName = "frostmind raiment", clientId = 22537, buy = 10 },
	{ itemName = "gnome legs", clientId = 27649, buy = 10 },
	{ itemName = "rainbow necklace", clientId = 30323, buy = 10 },
	{ itemName = "cobra boots", clientId = 30394, buy = 10 },
	{ itemName = "amulet of theurgy", clientId = 30401, buy = 10 },
	{ itemName = "enchanted theurgic amulet", clientId = 30403, buy = 10 },
	{ itemName = "rainbow amulet", clientId = 31556, buy = 10 },
	{ itemName = "enchanted blister ring", clientId = 31557, buy = 10 },
	{ itemName = "blister ring", clientId = 31621, buy = 10 },
	{ itemName = "cobra amulet", clientId = 31631, buy = 10 },
	{ itemName = "enchanted ring of souls", clientId = 32621, buy = 10 },
	{ itemName = "reflect potion", clientId = 49272, buy = 10 },
	{ itemName = "ring of souls", clientId = 32636, buy = 10 },
	{ itemName = "soulshanks", clientId = 34092, buy = 10 },
	{ itemName = "soulstrider", clientId = 34093, buy = 10 },
	{ itemName = "lion amulet", clientId = 34158, buy = 10 },
	{ itemName = "eldritch quiver", clientId = 36666, buy = 10 },
	{ itemName = "eldritch breeches", clientId = 36667, buy = 10 },
	{ itemName = "alicorn quiver", clientId = 39150, buy = 10 },
	{ itemName = "frostflower boots", clientId = 39158, buy = 10 },
	{ itemName = "naga quiver", clientId = 39160, buy = 10 },
	{ itemName = "dawnfire pantaloons", clientId = 39166, buy = 10 },
	{ itemName = "midnight sarong", clientId = 39167, buy = 10 },
	{ itemName = "charged spiritthorn ring", clientId = 39177, buy = 10 },
	{ itemName = "spiritthorn ring", clientId = 39179, buy = 10 },
	{ itemName = "charged alicorn ring", clientId = 39180, buy = 10 },
	{ itemName = "alicorn ring", clientId = 39182, buy = 10 },
	{ itemName = "charged arcanomancer sigil", clientId = 39183, buy = 10 },
	{ itemName = "charged arboreal ring", clientId = 39186, buy = 10 },
	{ itemName = "arboreal ring", clientId = 39188, buy = 10 },
	{ itemName = "enchanted turtle amulet", clientId = 39233, buy = 10 },
	{ itemName = "turtle amulet", clientId = 39235, buy = 10 },
	{ itemName = "stitched mutant hide legs", clientId = 40589, buy = 10 },
	{ itemName = "mutated skin legs", clientId = 40590, buy = 10 },
	{ itemName = "alchemist's boots", clientId = 40592, buy = 10 },
	{ itemName = "mutant bone boots", clientId = 40593, buy = 10 },
	{ itemName = "mutant bone kilt", clientId = 40595, buy = 10 },
	{ itemName = "candy necklace", clientId = 45641, buy = 10 },
	{ itemName = "candy-coated quiver", clientId = 45644, buy = 10 },
	-- Soulwar Equipment
	{ itemName = "soulcutter", clientId = 34082, buy = 10 },
	{ itemName = "soulshredder", clientId = 34083, buy = 10 },
	{ itemName = "soulbiter", clientId = 34084, buy = 10 },
	{ itemName = "souleater", clientId = 34085, buy = 10 },
	{ itemName = "soulcrusher", clientId = 34086, buy = 10 },
	{ itemName = "soulmaimer", clientId = 34087, buy = 10 },
	{ itemName = "soulbleeder", clientId = 34088, buy = 10 },
	{ itemName = "soulpiercer", clientId = 34089, buy = 10 },
	{ itemName = "soultainter", clientId = 34090, buy = 10 },
	{ itemName = "soulhexer", clientId = 34091, buy = 10 },
	{ itemName = "soulshanks", clientId = 34092, buy = 10 },
	{ itemName = "soulstrider", clientId = 34093, buy = 10 },
	{ itemName = "soulshell", clientId = 34094, buy = 10 },
	{ itemName = "soulmantle", clientId = 34095, buy = 10 },
	{ itemName = "soulshroud", clientId = 34096, buy = 10 },
	{ itemName = "arcanomancer regalia", clientId = 39151, buy = 10 },

	-- Relic System
	{ itemName = "unrevealed relic", clientId = 60522, buy = 1 },
	{ itemName = "relic revealer", clientId = 60521, buy = 1 },
	{ itemName = "relic reveal enhancement", clientId = 60520, buy = 1 },

	-- Accessories
	{ itemName = "sight of truth", clientId = 60160, buy = 1 },
	{ itemName = "supreme sigil", clientId = 60158, buy = 1 },
	{ itemName = "supreme pendulet", clientId = 60159, buy = 1 },

	-- Badge Upgrade System
	{ itemName = "damage token", clientId = 60537, buy = 1 },
	{ itemName = "exp token", clientId = 60528, buy = 1 },
	{ itemName = "fortune token", clientId = 60536, buy = 1 },
	{ itemName = "potion badge ingredient", clientId = 19371, buy = 1 },
	{ itemName = "medicine badge ingredient", clientId = 12517, buy = 1 },
}

-- On buy npc shop message
npcType.onBuyItem = function(npc, player, itemId, subType, amount, ignore, inBackpacks, totalCost)
	npc:sellItem(player, itemId, amount, subType, 0, ignore, inBackpacks)
end

-- On sell npc shop message
npcType.onSellItem = function(npc, player, itemId, subtype, amount, ignore, name, totalCost)
	player:sendTextMessage(MESSAGE_TRADE, string.format("Sold %ix %s for %i gold.", amount, name, totalCost))
end

-- On check npc shop message (look item)
npcType.onCheckItem = function(npc, player, clientId, subType) end

npcType:register(npcConfig)
