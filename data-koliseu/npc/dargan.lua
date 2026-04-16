local internalNpcName = "Dargan The Clothemaster"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 130,
	lookHead = 115,
	lookBody = 39,
	lookLegs = 96,
	lookFeet = 118,
	lookAddons = 3
}

npcConfig.flags = {
	floorchange = false
}

npcConfig.voices = {
	interval = 15000,
	chance = 50,
	{
		text = 'Come see my Addons bro!'
	}
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

local addoninfo = {
	['citizen addons'] = {
		cost = 0,
		items = { { 8778, 50 } },
		outfit_female = 136,
		outfit_male = 128
	},
	['hunter addons'] = {
		cost = 0,
		items = { { 8778, 50 } },
		outfit_female = 137,
		outfit_male = 129
	},
	['knight addons'] = {
		cost = 0,
		items = { { 8778, 50 } },
		outfit_female = 139,
		outfit_male = 131
	},
	['male mage addons'] = {
		cost = 0,
		items = { { 8778, 50 }, { 5903, 1 } },
		outfit_male = 130
	},
	['female mage addons'] = {
		cost = 0,
		items = { { 8778, 50 } },
		outfit_female = 138
	},
	['male summoner addons'] = {
		cost = 0,
		items = { { 8778, 50 } },
		outfit_male = 133
	},
	['female summoner addons'] = {
		cost = 0,
		items = { { 8778, 50 }, { 5903, 1 } },
		outfit_female = 141
	},
	['barbarian addons'] = {
		cost = 0,
		items = { { 8778, 50 } },
		outfit_female = 147,
		outfit_male = 143
	},
	['druid addons'] = {
		cost = 0,
		items = { { 8778, 50 } },
		outfit_female = 148,
		outfit_male = 144
	},
	['nobleman addons'] = {
		cost = 0,
		items = { { 8778, 50 } },
		outfit_female = 140,
		outfit_male = 132
	},
	['oriental addons'] = {
		cost = 0,
		items = { { 8778, 50 } },
		outfit_female = 150,
		outfit_male = 146
	},
	['warrior addons'] = {
		cost = 0,
		items = { { 8778, 50 } },
		outfit_female = 142,
		outfit_male = 134
	},
	['wizard addons'] = {
		cost = 0,
		items = { { 8778, 50 } },
		outfit_female = 149,
		outfit_male = 145
	},
	['assassin addons'] = {
		cost = 0,
		items = { { 8778, 50 } },
		outfit_female = 156,
		outfit_male = 152
	},
	['beggar addons'] = {
		cost = 0,
		items = { { 8778, 50 } },
		outfit_female = 157,
		outfit_male = 153
	},
	['pirate addons'] = {
		cost = 0,
		items = { { 8778, 50 } },
		outfit_female = 155,
		outfit_male = 151
	},
	['shaman addons'] = {
		cost = 0,
		items = { { 8778, 50 } },
		outfit_female = 158,
		outfit_male = 154
	},
	['norseman addons'] = {
		cost = 0,
		items = { { 8778, 50 } },
		outfit_female = 252,
		outfit_male = 251
	},
	['nightmare addons'] = {
		cost = 0,
		items = { { 8778, 50 } },
		outfit_female = 269,
		outfit_male = 268
	},
	['jester addons'] = {
		cost = 0,
		items = { { 8778, 50 } },
		outfit_female = 270,
		outfit_male = 273
	},
	['brotherhood addons'] = {
		cost = 0,
		items = { { 8778, 50 } },
		outfit_female = 279,
		outfit_male = 278
	},
	['demon hunter addons'] = {
		cost = 0,
		items = { { 8778, 50 } },
		outfit_female = 288,
		outfit_male = 289
	},
	['yalaharian addons'] = {
		cost = 0,
		items = { { 8778, 50 } },
		outfit_female = 324,
		outfit_male = 325
	},
	['warmaster addons'] = {
		cost = 0,
		items = { { 8778, 50 } },
		outfit_female = 336,
		outfit_male = 335
	},
	['wayfarer addons'] = {
		cost = 0,
		items = { { 8778, 50 } },
		outfit_female = 366,
		outfit_male = 367
	},
	['afflicted addons'] = {
		cost = 0,
		items = { { 8778, 50 } },
		outfit_female = 431,
		outfit_male = 430
	},
	['elementalist addons'] = {
		cost = 0,
		items = { { 8778, 50 } },
		outfit_female = 433,
		outfit_male = 432
	},
	['deepling addons'] = {
		cost = 0,
		items = { { 8778, 50 } },
		outfit_female = 464,
		outfit_male = 463
	},
	['insectoid addons'] = {
		cost = 0,
		items = { { 8778, 50 } },
		outfit_female = 466,
		outfit_male = 465
	},
	['crystal warlord addons'] = {
		cost = 0,
		items = { { 8778, 50 } },
		outfit_female = 513,
		outfit_male = 512
	},
	['soil guardian addons'] = {
		cost = 0,
		items = { { 8778, 50 } },
		outfit_female = 514,
		outfit_male = 516
	},
	['demon addons'] = {
		cost = 0,
		items = { { 8778, 50 } },
		outfit_female = 542,
		outfit_male = 541
	},
	['cave explorer addons'] = {
		cost = 0,
		items = { { 8778, 50 } },
		outfit_female = 575,
		outfit_male = 574
	},
	['dream warden addons'] = {
		cost = 0,
		items = { { 8778, 50 } },
		outfit_female = 578,
		outfit_male = 577
	},
	['glooth engineer addons'] = {
		cost = 0,
		items = { { 8778, 50 } },
		outfit_female = 618,
		outfit_male = 610
	},
	['jersey addons'] = {
		cost = 0,
		items = { { 8778, 50 } },
		outfit_female = 620,
		outfit_male = 619
	},
	['recruiter addons'] = {
		cost = 0,
		items = { { 8778, 50 } },
		outfit_female = 745,
		outfit_male = 746
	},
	['rift warrior addons'] = {
		cost = 0,
		items = { { 8778, 50 } },
		outfit_female = 845,
		outfit_male = 846
	},
	['festive addons'] = {
		cost = 0,
		items = { { 8778, 50 } },
		outfit_female = 929,
		outfit_male = 931
	},
	['makeshift warrior addons'] = {
		cost = 0,
		items = { { 8778, 50 } },
		outfit_female = 1043,
		outfit_male = 1042
	},
	['battle mage addons'] = {
		cost = 0,
		items = { { 8778, 50 } },
		outfit_female = 1070,
		outfit_male = 1069
	},
	['discoverer addons'] = {
		cost = 0,
		items = { { 8778, 50 } },
		outfit_female = 1095,
		outfit_male = 1094
	},
	['dream warrior addons'] = {
		cost = 0,
		items = { { 8778, 50 } },
		outfit_female = 1147,
		outfit_male = 1146
	},
	['percht raider addons'] = {
		cost = 0,
		items = { { 8778, 50 } },
		outfit_female = 1162,
		outfit_male = 1161
	},
	['hand of the inquisition addons'] = {
		cost = 0,
		items = { { 8778, 50 } },
		outfit_female = 1244,
		outfit_male = 1243
	},
	['orcsoberfest garb addons'] = {
		cost = 0,
		items = { { 8778, 50 } },
		outfit_female = 1252,
		outfit_male = 1251
	},
	['poltergeist addons'] = {
		cost = 0,
		items = { { 8778, 50 } },
		outfit_female = 1271,
		outfit_male = 1270
	},
	['falconer addons'] = {
		cost = 0,
		items = { { 8778, 50 } },
		outfit_female = 1283,
		outfit_male = 1282
	},
	['revenant addons'] = {
		cost = 0,
		items = { { 8778, 50 } },
		outfit_female = 1323,
		outfit_male = 1322
	},
	['rascoohan addons'] = {
		cost = 0,
		items = { { 8778, 50 } },
		outfit_female = 1372,
		outfit_male = 1371
	},
	['citizen of issavi addons'] = {
		cost = 0,
		items = { { 8778, 50 } },
		outfit_female = 1387,
		outfit_male = 1386
	},
	['royal bounacean advisor addons'] = {
		cost = 0,
		items = { { 8778, 50 } },
		outfit_female = 1437,
		outfit_male = 1436
	},
	['fire-fighter addons'] = {
		cost = 0,
		items = { { 8778, 50 } },
		outfit_female = 1569,
		outfit_male = 1568
	},
	['ancient aucar addons'] = {
		cost = 0,
		items = { { 8778, 50 } },
		outfit_female = 1598,
		outfit_male = 1597
	},
	['decaying defender addons'] = {
		cost = 0,
		items = { { 8778, 50 } },
		outfit_female = 1663,
		outfit_male = 1662
	},
	['draccoon herald addons'] = {
		cost = 0,
		items = { { 8778, 50 } },
		outfit_female = 1723,
		outfit_male = 1722
	},
	['rootwalker addons'] = {
		cost = 0,
		items = { { 8778, 50 } },
		outfit_female = 1775,
		outfit_male = 1774
	},
	['golden addons'] = {
		cost = 10000000000,
		items = {},
		outfit_female = 1211,
		outfit_male = 1210
	},
	['royal costume addons'] = {
		cost = 0,
		items = { { 22721, 20000 }, { 22516, 20000 } },
		outfit_female = 1456,
		outfit_male = 1457
	},
	['arbalester addons'] = {
		cost = 0,
		outfit_female = 1450,
		outfit_male = 1449,
		items = { { 8778, 50 } }
	},
	['arena champion addons'] = {
		cost = 0,
		outfit_female = 885,
		outfit_male = 884,
		items = { { 8778, 50 } }
	},
	['armoured archer addons'] = {
		cost = 0,
		outfit_female = 1619,
		outfit_male = 1618,
		items = { { 8778, 50 } }
	},
	['beastmaster addons'] = {
		cost = 0,
		outfit_female = 636,
		outfit_male = 637,
		items = { { 8778, 50 } }
	},
	['breezy garb addons'] = {
		cost = 0,
		outfit_female = 1246,
		outfit_male = 1245,
		items = { { 8778, 50 } }
	},
	['ceremonial garb addons'] = {
		cost = 0,
		outfit_female = 694,
		outfit_male = 695,
		items = { { 8778, 50 } }
	},
	['champion addons'] = {
		cost = 0,
		outfit_female = 632,
		outfit_male = 633,
		items = { { 8778, 50 } }
	},
	['chaos acolyte addons'] = {
		cost = 0,
		outfit_female = 664,
		outfit_male = 665,
		items = { { 8778, 50 } }
	},
	['conjurer addons'] = {
		cost = 0,
		outfit_female = 635,
		outfit_male = 634,
		items = { { 8778, 50 } }
	},
	['death herald addons'] = {
		cost = 0,
		outfit_female = 666,
		outfit_male = 667,
		items = { { 8778, 50 } }
	},
	['dragon knight addons'] = {
		cost = 0,
		outfit_female = 1445,
		outfit_male = 1444,
		items = { { 8778, 50 } }
	},
	['entrepreneur addons'] = {
		cost = 0,
		outfit_female = 471,
		outfit_male = 472,
		items = { { 8778, 50 } }
	},
	['evoker addons'] = {
		cost = 0,
		outfit_female = 724,
		outfit_male = 725,
		items = { { 8778, 50 } }
	},
	['fencer addons'] = {
		cost = 0,
		outfit_female = 1576,
		outfit_male = 1575,
		items = { { 8778, 50 } }
	},
	['flamefury mage addons'] = {
		cost = 0,
		outfit_female = 1681,
		outfit_male = 1680,
		items = { { 8778, 50 } }
	},
	['forest warden addons'] = {
		cost = 0,
		outfit_female = 1416,
		outfit_male = 1415,
		items = { { 8778, 50 } }
	},
	['frost tracer addons'] = {
		cost = 0,
		outfit_female = 1613,
		outfit_male = 1612,
		items = { { 8778, 50 } }
	},
	['ghost blade addons'] = {
		cost = 0,
		outfit_female = 1490,
		outfit_male = 1489,
		items = { { 8778, 50 } }
	},
	['grove keeper addons'] = {
		cost = 0,
		outfit_female = 909,
		outfit_male = 908,
		items = { { 8778, 50 } }
	},
	['guidon bearer addons'] = {
		cost = 0,
		outfit_female = 1187,
		outfit_male = 1186,
		items = { { 8778, 50 } }
	},
	['herbalist addons'] = {
		cost = 0,
		outfit_female = 1020,
		outfit_male = 1021,
		items = { { 8778, 50 } }
	},
	['herder addons'] = {
		cost = 0,
		outfit_female = 1280,
		outfit_male = 1279,
		items = { { 8778, 50 } }
	},
	['jouster addons'] = {
		cost = 0,
		outfit_female = 1332,
		outfit_male = 1331,
		items = { { 8778, 50 } }
	},
	['lupine warden addons'] = {
		cost = 0,
		outfit_female = 900,
		outfit_male = 899,
		items = { { 8778, 50 } }
	},
	['mercenary addons'] = {
		cost = 0,
		outfit_female = 1057,
		outfit_male = 1056,
		items = { { 8778, 50 } }
	},
	['merry garb addons'] = {
		cost = 0,
		outfit_female = 1383,
		outfit_male = 1382,
		items = { { 8778, 50 } }
	},
	['moth cape addons'] = {
		cost = 0,
		outfit_female = 1339,
		outfit_male = 1338,
		items = { { 8778, 50 } }
	},
	['nordic chieftain addons'] = {
		cost = 0,
		outfit_female = 1501,
		outfit_male = 1500,
		items = { { 8778, 50 } }
	},
	['owl keeper addons'] = {
		cost = 0,
		outfit_female = 1174,
		outfit_male = 1173,
		items = { { 8778, 50 } }
	},
	['pharaoh addons'] = {
		cost = 0,
		outfit_female = 956,
		outfit_male = 955,
		items = { { 8778, 50 } }
	},
	['philosopher addons'] = {
		cost = 0,
		outfit_female = 874,
		outfit_male = 873,
		items = { { 8778, 50 } }
	},
	['pumpkin mummy addons'] = {
		cost = 0,
		outfit_female = 1128,
		outfit_male = 1127,
		items = { { 8778, 50 } }
	},
	['puppeteer addons'] = {
		cost = 0,
		outfit_female = 696,
		outfit_male = 697,
		items = { { 8778, 50 } }
	},
	['ranger addons'] = {
		cost = 0,
		outfit_female = 683,
		outfit_male = 684,
		items = { { 8778, 50 } }
	},
	['royal pumpkin addons'] = {
		cost = 0,
		outfit_female = 759,
		outfit_male = 760,
		items = { { 8778, 50 } }
	}, -- corrigido (não 1385/1384)
	['sea dog addons'] = {
		cost = 0,
		outfit_female = 749,
		outfit_male = 750,
		items = { { 8778, 50 } }
	},
	['seaweaver addons'] = {
		cost = 0,
		outfit_female = 732,
		outfit_male = 733,
		items = { { 8778, 50 } }
	},
	['shadowlotus disciple addons'] = {
		cost = 0,
		outfit_female = 1582,
		outfit_male = 1581,
		items = { { 8778, 50 } }
	},
	['siege master addons'] = {
		cost = 0,
		outfit_female = 1050,
		outfit_male = 1051,
		items = { { 8778, 50 } }
	},
	['sinister archer addons'] = {
		cost = 0,
		outfit_female = 1103,
		outfit_male = 1102,
		items = { { 8778, 50 } }
	},
	['spirit caller addons'] = {
		cost = 0,
		outfit_female = 698,
		outfit_male = 699,
		items = { { 8778, 50 } }
	},
	['sun priest addons'] = {
		cost = 0,
		outfit_female = 1024,
		outfit_male = 1023,
		items = { { 8778, 50 } }
	},
	['trailblazer addons'] = {
		cost = 0,
		outfit_female = 1293,
		outfit_male = 1292,
		items = { { 8778, 50 } }
	},
	['trophy hunter addons'] = {
		cost = 0,
		outfit_female = 958,
		outfit_male = 957,
		items = { { 8778, 50 } }
	}, -- corrigido (não 900/899)
	['veteran paladin addons'] = {
		cost = 0,
		outfit_female = 1205,
		outfit_male = 1204,
		items = { { 8778, 50 } }
	},
	['void master addons'] = {
		cost = 0,
		outfit_female = 1203,
		outfit_male = 1202,
		items = { { 8778, 50 } }
	},
	['winter warden addons'] = {
		cost = 0,
		outfit_female = 852,
		outfit_male = 853,
		items = { { 8778, 50 } }
	},
	['retro citizen addons'] = {
		cost = 0,
		outfit_female = 975,
		outfit_male = 974,
		items = { { 8778, 50 } }
	},
	['retro hunter addons'] = {
		cost = 0,
		outfit_female = 973,
		outfit_male = 972,
		items = { { 8778, 50 } }
	},
	['retro knight addons'] = {
		cost = 0,
		outfit_female = 971,
		outfit_male = 970,
		items = { { 8778, 50 } }
	},
	['retro mage addons'] = {
		cost = 0,
		outfit_female = 969,
		outfit_male = 968,
		items = { { 8778, 50 } }
	},
	['retro nobleman addons'] = {
		cost = 0,
		outfit_female = 967,
		outfit_male = 966,
		items = { { 8778, 50 } }
	},
	['retro summoner addons'] = {
		cost = 0,
		outfit_female = 965,
		outfit_male = 964,
		items = { { 8778, 50 } }
	},
	['retro warrior addons'] = {
		cost = 0,
		items = { { 8778, 50 } },
		outfit_female = 963,
		outfit_male = 962
	},
	['noblewoman addons'] = {
		cost = 0,
		items = { { 8778, 50 } },
		outfit_female = 140
	},
	['norsewoman addons'] = {
		cost = 0,
		items = { { 8778, 50 } },
		outfit_female = 252
	},
	['newly wed addons'] = {
		cost = 0,
		items = { { 8778, 50 } },
		outfit_female = 329,
		outfit_male = 328
	},
	['monk addons'] = {
		cost = 0,
		items = { { 8778, 50 } },
		outfit_female = 1825,
		outfit_male = 1824
	},
	['fiend slayer addons'] = {
		cost = 0,
		items = { { 8778, 50 } },
		outfit_female = 1808,
		outfit_male = 1809
	},
	['field surgeon addons'] = {
		cost = 0,
		items = { { 8778, 50 } },
		outfit_female = 1815,
		outfit_male = 1814
	},
	['illuminator addons'] = {
		cost = 0,
		items = { { 8778, 50 } },
		outfit_female = 1861,
		outfit_male = 1860
	}
}
local function buildAddonNamesList()
	local names = {}
	for key, _ in pairs(addoninfo) do
		-- remove the trailing word "addons" and surrounding spaces
		local name = key:gsub("%s*[Aa][Dd][Dd][Oo][Nn][Ss]%s*$", "")
		table.insert(names, name)
	end
	table.sort(names)
	return names
end
local pendingAddon = {}
local function creatureSayCallback(npc, creature, type, message)
	local talkUser = creature
	local player = Player(creature)
	local playerId = player:getId()
	local messageLower = message:lower()
	local addonInfo = addoninfo[messageLower]
	local talkState = {}
	if not npcHandler:checkInteraction(npc, creature) then
		return false
	end

	if addonInfo ~= nil then
		local itemsTable = addonInfo.items
		local items_list = ''
		if (player:hasOutfit(addonInfo.outfit_female, 3) or player:hasOutfit(addonInfo.outfit_male, 3)) then
			npcHandler:say('You already have this addon!', npc, creature)
			npcHandler:resetNpc(creature)
			return true
		elseif table.maxn(itemsTable) > 0 then
			for i = 1, table.maxn(itemsTable) do
				local item = itemsTable[i]
				items_list = items_list .. item[2] .. ' ' .. ItemType(item[1]):getName()
				if i ~= table.maxn(itemsTable) then
					items_list = items_list .. ', '
				end
			end
		end
		local text = ''
		if (addonInfo.cost > 0) and (table.maxn(addonInfo.items) > 0) then
			text = items_list .. ' and ' .. addonInfo.cost .. ' gp'
		elseif (addonInfo.cost > 0) then
			text = addonInfo.cost .. ' gp'
		elseif table.maxn(addonInfo.items) > 0 then
			text = items_list
		end
		npcHandler:say('For ' .. message .. ' you will need ' .. text .. '. Do you have it all with you?', npc, creature)
		pendingAddon[playerId] = messageLower
		npcHandler:setTopic(playerId, 2)
		return true
	elseif npcHandler:getTopic(playerId) == 2 then
		if MsgContains(message, "yes") then
			local selectedAddon = pendingAddon[playerId]
			if not selectedAddon or not addoninfo[selectedAddon] then
				npcHandler:say('Sorry, I did not catch which addon you want. Please say the addon name again.', npc, creature)
				pendingAddon[playerId] = nil
				npcHandler:setTopic(playerId, 0)
				npcHandler:resetNpc(creature)
				return true
			end
			local items_number = 0
			if table.maxn(addoninfo[selectedAddon].items) > 0 then
				for i = 1, table.maxn(addoninfo[selectedAddon].items) do
					local item = addoninfo[selectedAddon].items[i]
					if (getPlayerItemCount(creature, item[1]) >= item[2]) then
						items_number = items_number + 1
					end
				end
			end
			if (getPlayerMoney(creature) >= addoninfo[selectedAddon].cost) and
					(items_number == table.maxn(addoninfo[selectedAddon].items)) then
				doPlayerRemoveMoney(creature, addoninfo[selectedAddon].cost)
				if table.maxn(addoninfo[selectedAddon].items) > 0 then
					for i = 1, table.maxn(addoninfo[selectedAddon].items) do
						local item = addoninfo[selectedAddon].items[i]
						doPlayerRemoveItem(creature, item[1], item[2])
					end
				end
				if addoninfo[selectedAddon].outfit_male ~= nil then
					doPlayerAddOutfit(creature, addoninfo[selectedAddon].outfit_male, 3)
				end
				if addoninfo[selectedAddon].outfit_female ~= nil then
					doPlayerAddOutfit(creature, addoninfo[selectedAddon].outfit_female, 3)
				end
				npcHandler:say('Here you are.', npc, creature)
			else
				npcHandler:say('You do not have needed items!', npc, creature)
			end
			pendingAddon[playerId] = nil
			npcHandler:setTopic(playerId, 0)
			talkState[talkUser] = 0
			npcHandler:resetNpc(creature)
			return true
		end
	elseif MsgContains(message, "addons") then
		local names = buildAddonNamesList()
		npcHandler:say('I can give you full addons for the following outfits:', npc, creature)
		
		local function sendBatch(npcId, cid, index)
			local n = Npc(npcId)
			local p = Player(cid)
			if not n or not p then return end
			
			if index > #names then
				npcHandler:resetNpc(p)
				return
			end
			
			local batch = {}
			local limit = math.min(index + 19, #names)
			for i = index, limit do
				table.insert(batch, names[i])
			end
			
			npcHandler:say('{' .. table.concat(batch, '}, {') .. '}', n, p)
			addEvent(sendBatch, 1000, npcId, cid, index + 20)
		end
		
		addEvent(sendBatch, 500, npc:getId(), playerId, 1)

		pendingAddon[playerId] = nil
		npcHandler:setTopic(playerId, 0)
		talkState[talkUser] = 0
		return true
	elseif MsgContains(message, "help") then
		npcHandler:say('You must say \'NAME addons\', for the full addon', npc, creature)
		pendingAddon[playerId] = nil
		npcHandler:setTopic(playerId, 0)
		talkState[talkUser] = 0
		npcHandler:resetNpc(creature)
		return true
	else
		if talkState[talkUser] ~= nil then
			if talkState[talkUser] > 0 then
				npcHandler:say('Come back when you get these items.', npc, creature)
				pendingAddon[playerId] = nil
				npcHandler:setTopic(playerId, 0)
				talkState[talkUser] = 0
				npcHandler:resetNpc(creature)
				return true
			end
		end
	end
	return true
end

npcHandler:setMessage(MESSAGE_GREET,
	'Welcome |PLAYERNAME|! If you want some addons, just ask me! Do you want to see my {addons}, or are you decided? If you are decided, just ask me like this: {citizen addons}')
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)
npcType:register(npcConfig)
