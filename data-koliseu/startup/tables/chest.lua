--[[
	Look README.md for see the reserved action/unique numbers
	From range 5000 to 6000 is reserved for keys chest
	From range 6001 to 472 is reserved for script reward
	Path: data\scripts\actions\system\quest_reward_common.lua

	From range 473 to 15000 is reserved for others scripts (varied rewards)

	There is no need to tamper with the chests scripts, just register a new table and configure correctly
	So the quest will work in-game

	Example:
	[xxxx] = {
		-- For use of the map
		itemId = xxxx,
		itemPos = {x = xxxxx, y = xxxxx, z = x},
		-- For use of the script
		container = xxxx (it's for use reward in a container, only put the id of the container here)
		keyAction = xxxx, (it's for use one key in the chest and is reward in container, only put the key in reward and action here)
		reward = {{xxxx, x}},
		storage = xxxxx
	},

		Example using KV:
		[xxxx] = {
			useKV = true,
			itemId = xxxx,
			itemPos = {x = xxxxx, y = xxxxx, z = x},
			container = xxxx, (it's for use reward in a container, only put the id of the container here)
			reward = {{xxxx, x}},
			questName = "testkv",
		}

		Example using Store Inbox delivery:
		[xxxx] = {
			itemId = xxxx,
			itemPos = {x = xxxxx, y = xxxxx, z = x},
			reward = {{xxxx, x}},
			storage = xxxxx,
			storeInbox = true,  -- Deliver item to player's Store Inbox instead of backpack
			movable = false,    -- If false, item cannot be removed from Store Inbox (optional, default: true)
		}

	Note:
	The "for use of the map" variables are only used to create the action or unique on the map during startup
	If the reward is an key, do not need to use "keyAction", only set the storage as same action id

	The "for use of the script" variables are used by the scripts
	To allow a single script to manage all rewards
]]

ChestAction = {}

ChestUnique = {
	-- Demon helmet quest
	-- Steel boots
	[6029] = {
		itemId = 2472,
		itemPos = Position(707, 1280, 9),
		reward = { { 3554, 1 } },
		storage = Storage.DemonHelmet.Rewards.SteelBoots,
	},
	-- Demon helmet
	[6030] = {
		itemId = 2472,
		itemPos = Position(707, 1281, 9),
		reward = { { 3387, 1 } },
		storage = Storage.DemonHelmet.Rewards.DemonHelmet,
	},
	-- Demon shield
	[6031] = {
		itemId = 2472,
		itemPos = Position(707, 1282, 9),
		reward = { { 3420, 1 } },
		storage = Storage.DemonHelmet.Rewards.DemonShield,
	},
	--Annihilator
	[6032] = {
		itemId = 2472,
		itemPos = Position(718, 1304, 9),
		reward = { { 8026, 1 } },
		storage = Storage.TheAnnihilator.Reward,
	},
	[6033] = {
		itemId = 2472,
		itemPos = Position(720, 1304, 9),
		reward = { { 3288, 1 } },
		storage = Storage.TheAnnihilator.Reward,
	},
	[6034] = {
		itemId = 2472,
		itemPos = Position(722, 1304, 9),
		reward = { { 3319, 1 } },
		storage = Storage.TheAnnihilator.Reward,
	},
	[6035] = {
		itemId = 2472,
		itemPos = Position(724, 1304, 9),
		reward = { { 3309, 1 } },
		storage = Storage.TheAnnihilator.Reward,
	},
	[6036] = {
		itemId = 2472,
		itemPos = Position(726, 1304, 9),
		reward = { { 25700, 1 } },
		storage = Storage.TheAnnihilator.Reward,
	},
	--POI
	[6037] = {
		itemId = 2481,
		itemPos = Position(958, 1178, 10),
		reward = { { 3253, 1 } },
		storage = Storage.ThePitsOfInferno.RewardChestBP,
	},
	[6038] = {
		itemId = 2481,
		itemPos = Position(958, 1179, 10),
		reward = { { 6529, 1 } },
		storage = Storage.ThePitsOfInferno.RewardChestSoftBoots,
	},
	--Canivetes
	[6039] = {
		itemId = 2472,
		itemPos = Position(707, 1225, 8),
		reward = { { 9598, 1 } },
		storage = Storage.Canivetes,
	},
	[6040] = {
		itemId = 2472,
		itemPos = Position(708, 1225, 8),
		reward = { { 9596, 1 } },
		storage = Storage.Canivetes,
	},
	[6041] = {
		itemId = 2472,
		itemPos = Position(709, 1225, 8),
		reward = { { 9594, 1 } },
		storage = Storage.Canivetes,
	},
	--Custom Inq
	[6042] = {
		itemId = 2472,
		itemPos = Position(238, 1558, 12),
		reward = { { 25779, 1 } },
		storage = Storage.CustomInqui,
	},
	[6043] = {
		itemId = 2472,
		itemPos = Position(240, 1558, 12),
		reward = { { 8090, 1 } },
		storage = Storage.CustomInqui,
	},
	[6044] = {
		itemId = 2472,
		itemPos = Position(242, 1558, 12),
		reward = { { 8060, 1 } },
		storage = Storage.CustomInqui,
	},
	[6045] = {
		itemId = 2472,
		itemPos = Position(244, 1558, 12),
		reward = { { 8062, 1 } },
		storage = Storage.CustomInqui,
	},
	[6046] = {
		itemId = 2472,
		itemPos = Position(246, 1558, 12),
		reward = { { 8054, 1 } },
		storage = Storage.CustomInqui,
	},
	[6047] = {
		itemId = 2472,
		itemPos = Position(248, 1558, 12),
		reward = { { 8053, 1 } },
		storage = Storage.CustomInqui,
	},
	[6048] = {
		itemId = 2472,
		itemPos = Position(250, 1558, 12),
		reward = { { 8055, 1 } },
		storage = Storage.CustomInqui,
	},
	--Custom Wote
	[6049] = {
		itemId = 2472,
		itemPos = Position(755, 1496, 11),
		reward = { { 11687, 1 } },
		storage = Storage.CustomWote,
	},
	[6050] = {
		itemId = 2472,
		itemPos = Position(757, 1496, 11),
		reward = { { 11686, 1 } },
		storage = Storage.CustomWote,
	},
	[6051] = {
		itemId = 2472,
		itemPos = Position(759, 1496, 11),
		reward = { { 11689, 1 } },
		storage = Storage.CustomWote,
	},
	-- Destruction quest
	[6052] = {
		itemId = 2472,
		itemPos = Position(268, 1358, 8),
		reward = { { 27458, 1 } },
		storage = Storage.DestructionQuest,
	},
	[6053] = {
		itemId = 2472,
		itemPos = Position(269, 1358, 8),
		reward = { { 27457, 1 } },
		storage = Storage.DestructionQuest,
	},
	[6054] = {
		itemId = 2472,
		itemPos = Position(270, 1358, 8),
		reward = { { 27449, 1 }, { 27450, 1 } },
		storage = Storage.DestructionQuest,
	},
	[6055] = {
		itemId = 2472,
		itemPos = Position(271, 1358, 8),
		reward = { { 27453, 1 }, { 27454, 1 } },
		storage = Storage.DestructionQuest,
	},
	[6056] = {
		itemId = 2472,
		itemPos = Position(272, 1358, 8),
		reward = { { 27451, 1 }, { 27452, 1 } },
		storage = Storage.DestructionQuest,
	},
	[6057] = {
		itemId = 2472,
		itemPos = Position(273, 1358, 8),
		reward = { { 27455, 1 }, { 27456, 1 } },
		storage = Storage.DestructionQuest,
	},
	-- prismatic
	[6058] = {
		itemId = 2480,
		itemPos = Position(447, 1340, 15),
		reward = { { 16109, 1 }, { 16110, 1 }, { 16111, 1 } },
		storage = Storage.PrismaticQuest,
	},
	-- trinkets elements
	[6061] = {
		itemId = 2472,
		itemPos = Position(460, 1107, 8),
		reward = { { 25975, 1 } },
		storage = Storage.TrinketsElementsQuest1,
	},
	[6062] = {
		itemId = 2472,
		itemPos = Position(461, 1107, 8),
		reward = { { 25976, 1 } },
		storage = Storage.TrinketsElementsQuest2,
	},
	[6063] = {
		itemId = 2472,
		itemPos = Position(462, 1107, 8),
		reward = { { 25977, 1 } },
		storage = Storage.TrinketsElementsQuest3,
	},
	[6064] = {
		itemId = 2472,
		itemPos = Position(463, 1107, 8),
		reward = { { 28493, 1 } },
		storage = Storage.TrinketsElementsQuest4,
	},
	[6065] = {
		itemId = 2472,
		itemPos = Position(457, 1107, 8),
		reward = { { 43863, 1 } },
		storage = Storage.TrinketsElementsQuest5,
	},
	[6066] = {
		itemId = 2472,
		itemPos = Position(458, 1107, 8),
		reward = { { 34016, 1 } },
		storage = Storage.TrinketsElementsQuest6,
	},
	[6067] = {
		itemId = 2472,
		itemPos = Position(459, 1107, 8),
		reward = { { 43740, 1 } },
		storage = Storage.TrinketsElementsQuest7,
	},
	-- Per voc armors
	[6068] = {
		itemId = 2472,
		itemPos = Position(1648, 1861, 8),
		reward = { { 22534, 1 }, { 22535, 1 }, { 22536, 1 }, { 22537, 1 }, },
		storage = Storage.ArmorsMage,
	},
	[6069] = {
		itemId = 2472,
		itemPos = Position(1670, 1592, 8),
		reward = { { 22530, 1 }, { 22531, 1 }, { 22532, 1 }, { 22533, 1 } },
		storage = Storage.ArmorsPally,
	},
	[6070] = {
		itemId = 2472,
		itemPos = Position(1574, 1736, 8),
		reward = { { 22518, 1 }, { 22519, 1 }, { 22520, 1 }, { 22521, 1 }, { 22522, 1 }, { 22523, 1 }, { 22524, 1 }, { 22525, 1 }, { 22526, 1 }, { 22527, 1 }, { 22528, 1 }, { 22529, 1 }, },
		storage = Storage.ArmorsKina,
	},
	-- Dwarven Items
	[6071] = {
		itemId = 2472,
		itemPos = Position(69, 1656, 8),
		reward = { { 3396, 1 }, { 3397, 1 }, { 3398, 1 }, },
		storage = Storage.DwarvenQuestItems,
	},
	-- Demon Oak Items
	[6072] = {
		itemId = 2480,
		itemPos = Position(593, 1243, 8),
		reward = { { 3389, 1 }, { 8077, 1 }, { 14768, 1 }, { 14769, 1 }, },
		storage = Storage.DemonOakItems,
	},
	-- Dream matter
	[6073] = {
		itemId = 2480,
		itemPos = Position(427, 927, 8),
		reward = { { 20063, 5 }, },
		storage = Storage.DreamMatterQuest,
	},
	-- Grasshopper legends
	[6074] = {
		itemId = 2472,
		itemPos = Position(1224, 781, 7),
		reward = { { 16104, 1 }, { 16105, 1 }, { 16106, 1 }, { 14087, 1 } },
		storage = Storage.GrasshopperQuest,
	},
	-- second floor mounts and addrons
	[6075] = {
		itemId = 24863,
		itemPos = Position(1140, 287, 9),
		reward = { { 60237, 1 }, { 60137, 1 }, { 60138, 1 }, },
		storage = Storage.SecondFloorAddonsMount,
		extra = function(player, item, fromPosition, itemEx, toPosition)
			SecondFloorQuests.removeAccess(player)
		end
	},
	-- daily exercise token
	[6076] = {
		questName = "Daily Exercise Token",
		itemId = 2472,
		itemPos = Position(766, 1303, 9),
		reward = { { 60141, 1 }, },
		storeInbox = true,
		movable = false,
		useKV = true,
		timerStorage = Storage.DailyExerciseToken,
		time = 20, -- hour
	},
	-- aneis 2 andar
	[6077] = {
		itemId = 2480,
		itemPos = Position(846, 139, 12),
		reward = { { 60151, 1 } },
		storage = Storage.SecondFloorRings,
		extra = function(player, item, fromPosition, itemEx, toPosition)
			SecondFloorQuests.removeAccess(player)
		end
	},
	[6078] = {
		itemId = 2480,
		itemPos = Position(844, 139, 12),
		reward = { { 60150, 1 } },
		storage = Storage.SecondFloorRings,
		extra = function(player, item, fromPosition, itemEx, toPosition)
			SecondFloorQuests.removeAccess(player)
		end
	},
	[6079] = {
		itemId = 2480,
		itemPos = Position(842, 139, 12),
		reward = { { 60149, 1 } },
		storage = Storage.SecondFloorRings,
		extra = function(player, item, fromPosition, itemEx, toPosition)
			SecondFloorQuests.removeAccess(player)
		end
	},
	-- skull backpack
	[6080] = {
		itemId = 23740,
		itemPos = Position(754, 1114, 8),
		reward = { { 60028, 1 } },
		storage = Storage.SkullBackpack,
		extra = function(player, item, fromPosition, itemEx, toPosition)
			SecondFloorQuests.removeAccess(player)
		end
	},
	-- Boos of blessings
	[6081] = {
		itemId = 2480,
		itemPos = Position(1161, 822, 8),
		reward = { { 60143, 1 } },
		storage = Storage.BlessingsBook,
		extra = function(player, item, fromPosition, itemEx, toPosition)
			SecondFloorQuests.removeAccess(player)
		end
	},
	-- reflect potions
	[6082] = {
		itemId = 2472,
		itemPos = Position(1263, 549, 9),
		reward = { { 49272, 1 } },
		storage = Storage.ReflectPotion1,
		extra = function(player, item, fromPosition, itemEx, toPosition)
			local currentCount = player:getStorageValue(Storage.ReflectPotionCount)
			if currentCount < 0 then
				currentCount = 0
			end
			-- Incrementa o contador
			player:setStorageValue(Storage.ReflectPotionCount, currentCount + 1)
			-- Verifica se completou
			if currentCount + 1 >= 10 then
				SecondFloorQuests.removeAccess(player)
			end
		end
	},
	[6083] = {
		itemId = 2472,
		itemPos = Position(1297, 548, 9),
		reward = { { 49272, 1 } },
		storage = Storage.ReflectPotion2,
		extra = function(player, item, fromPosition, itemEx, toPosition)
			local currentCount = player:getStorageValue(Storage.ReflectPotionCount)
			if currentCount < 0 then
				currentCount = 0
			end
			-- Incrementa o contador
			player:setStorageValue(Storage.ReflectPotionCount, currentCount + 1)
			-- Verifica se completou
			if currentCount + 1 >= 10 then
				SecondFloorQuests.removeAccess(player)
			end
		end
	},
	[6084] = {
		itemId = 2472,
		itemPos = Position(1314, 563, 9),
		reward = { { 49272, 1 } },
		storage = Storage.ReflectPotion3,
		extra = function(player, item, fromPosition, itemEx, toPosition)
			local currentCount = player:getStorageValue(Storage.ReflectPotionCount)
			if currentCount < 0 then
				currentCount = 0
			end
			-- Incrementa o contador
			player:setStorageValue(Storage.ReflectPotionCount, currentCount + 1)
			-- Verifica se completou
			if currentCount + 1 >= 10 then
				SecondFloorQuests.removeAccess(player)
			end
		end
	},
	[6085] = {
		itemId = 2472,
		itemPos = Position(1336, 601, 9),
		reward = { { 49272, 1 } },
		storage = Storage.ReflectPotion4,
		extra = function(player, item, fromPosition, itemEx, toPosition)
			local currentCount = player:getStorageValue(Storage.ReflectPotionCount)
			if currentCount < 0 then
				currentCount = 0
			end
			-- Incrementa o contador
			player:setStorageValue(Storage.ReflectPotionCount, currentCount + 1)
			-- Verifica se completou
			if currentCount + 1 >= 10 then
				SecondFloorQuests.removeAccess(player)
			end
		end
	},
	[6086] = {
		itemId = 2472,
		itemPos = Position(1344, 623, 9),
		reward = { { 49272, 1 } },
		storage = Storage.ReflectPotion5,
		extra = function(player, item, fromPosition, itemEx, toPosition)
			local currentCount = player:getStorageValue(Storage.ReflectPotionCount)
			if currentCount < 0 then
				currentCount = 0
			end
			-- Incrementa o contador
			player:setStorageValue(Storage.ReflectPotionCount, currentCount + 1)
			-- Verifica se completou
			if currentCount + 1 >= 10 then
				SecondFloorQuests.removeAccess(player)
			end
		end
	},
	[6087] = {
		itemId = 2472,
		itemPos = Position(1327, 644, 9),
		reward = { { 49272, 1 } },
		storage = Storage.ReflectPotion6,
		extra = function(player, item, fromPosition, itemEx, toPosition)
			local currentCount = player:getStorageValue(Storage.ReflectPotionCount)
			if currentCount < 0 then
				currentCount = 0
			end
			-- Incrementa o contador
			player:setStorageValue(Storage.ReflectPotionCount, currentCount + 1)
			-- Verifica se completou
			if currentCount + 1 >= 10 then
				SecondFloorQuests.removeAccess(player)
			end
		end
	},
	[6088] = {
		itemId = 2472,
		itemPos = Position(1305, 646, 9),
		reward = { { 49272, 1 } },
		storage = Storage.ReflectPotion7,
		extra = function(player, item, fromPosition, itemEx, toPosition)
			local currentCount = player:getStorageValue(Storage.ReflectPotionCount)
			if currentCount < 0 then
				currentCount = 0
			end
			-- Incrementa o contador
			player:setStorageValue(Storage.ReflectPotionCount, currentCount + 1)
			-- Verifica se completou
			if currentCount + 1 >= 10 then
				SecondFloorQuests.removeAccess(player)
			end
		end
	},
	[6089] = {
		itemId = 2472,
		itemPos = Position(1260, 636, 9),
		reward = { { 49272, 1 } },
		storage = Storage.ReflectPotion8,
		extra = function(player, item, fromPosition, itemEx, toPosition)
			local currentCount = player:getStorageValue(Storage.ReflectPotionCount)
			if currentCount < 0 then
				currentCount = 0
			end
			-- Incrementa o contador
			player:setStorageValue(Storage.ReflectPotionCount, currentCount + 1)
			-- Verifica se completou
			if currentCount + 1 >= 10 then
				SecondFloorQuests.removeAccess(player)
			end
		end
	},
	[6090] = {
		itemId = 2472,
		itemPos = Position(1254, 600, 9),
		reward = { { 49272, 1 } },
		storage = Storage.ReflectPotion9,
		extra = function(player, item, fromPosition, itemEx, toPosition)
			local currentCount = player:getStorageValue(Storage.ReflectPotionCount)
			if currentCount < 0 then
				currentCount = 0
			end
			-- Incrementa o contador
			player:setStorageValue(Storage.ReflectPotionCount, currentCount + 1)
			-- Verifica se completou
			if currentCount + 1 >= 10 then
				SecondFloorQuests.removeAccess(player)
			end
		end
	},
	[6091] = {
		itemId = 2472,
		itemPos = Position(1253, 578, 9),
		reward = { { 49272, 1 } },
		storage = Storage.ReflectPotion10,
		extra = function(player, item, fromPosition, itemEx, toPosition)
			local currentCount = player:getStorageValue(Storage.ReflectPotionCount)
			if currentCount < 0 then
				currentCount = 0
			end
			-- Incrementa o contador
			player:setStorageValue(Storage.ReflectPotionCount, currentCount + 1)
			-- Verifica se completou
			if currentCount + 1 >= 10 then
				SecondFloorQuests.removeAccess(player)
			end
		end
	},
	[6093] = {
		itemId = 2472,
		itemPos = Position(968, 1112, 15),
		reward = { { 49520, 1 } },
		storage = Storage.ArbazilothItems,
	},
	[6094] = {
		itemId = 2472,
		itemPos = Position(970, 1112, 15),
		reward = { { 49522, 1 } },
		storage = Storage.ArbazilothItems,
	},
	[6095] = {
		itemId = 2472,
		itemPos = Position(972, 1112, 15),
		reward = { { 49523, 1 } },
		storage = Storage.ArbazilothItems,
	},
	[6096] = {
		itemId = 2472,
		itemPos = Position(974, 1112, 15),
		reward = { { 49524, 1 } },
		storage = Storage.ArbazilothItems,
	},
	[6097] = {
		itemId = 2472,
		itemPos = Position(976, 1112, 15),
		reward = { { 49525, 1 } },
		storage = Storage.ArbazilothItems,
	},
	[6098] = {
		itemId = 2472,
		itemPos = Position(978, 1112, 15),
		reward = { { 49526, 1 } },
		storage = Storage.ArbazilothItems,
	},
	[6099] = {
		itemId = 2472,
		itemPos = Position(980, 1112, 15),
		reward = { { 49527, 1 } },
		storage = Storage.ArbazilothItems,
	},
	[6100] = {
		itemId = 2472,
		itemPos = Position(982, 1112, 15),
		reward = { { 49530, 1 } },
		storage = Storage.ArbazilothItems,
	},
	[6101] = {
		itemId = 2472,
		itemPos = Position(984, 1112, 15),
		reward = { { 49528, 1 } },
		storage = Storage.ArbazilothItems,
	},
	[6102] = {
		itemId = 2472,
		itemPos = Position(986, 1112, 15),
		reward = { { 49529, 1 } },
		storage = Storage.ArbazilothItems,
	},
	[6103] = {
		itemId = 2480,
		itemPos = Position(612, 1803, 8),
		reward = { { 63367, 1 } },
		storage = Storage.PitsOfInfernoV2.RewardChest,
		extra = function(player, item, fromPosition, itemEx, toPosition)
			SecondFloorQuests.removeAccess(player)
		end
	},
	[6104] = {
		itemId = 2480,
		itemPos = Position(614, 1803, 8),
		reward = { { 63372, 1 } },
		storage = Storage.PitsOfInfernoV2.RewardChest,
		extra = function(player, item, fromPosition, itemEx, toPosition)
			SecondFloorQuests.removeAccess(player)
		end
	},
	[6105] = {
		itemId = 2480,
		itemPos = Position(616, 1803, 8),
		reward = { { 63369, 1 } },
		storage = Storage.PitsOfInfernoV2.RewardChest,
		extra = function(player, item, fromPosition, itemEx, toPosition)
			SecondFloorQuests.removeAccess(player)
		end
	},
	[6106] = {
		itemId = 2480,
		itemPos = Position(618, 1803, 8),
		reward = { { 63370, 1 } },
		storage = Storage.PitsOfInfernoV2.RewardChest,
		extra = function(player, item, fromPosition, itemEx, toPosition)
			SecondFloorQuests.removeAccess(player)
		end
	},
	[6107] = {
		itemId = 2480,
		itemPos = Position(620, 1803, 8),
		reward = { { 63368, 1 } },
		storage = Storage.PitsOfInfernoV2.RewardChest,
		extra = function(player, item, fromPosition, itemEx, toPosition)
			SecondFloorQuests.removeAccess(player)
		end
	},
	[6108] = {
		itemId = 2480,
		itemPos = Position(622, 1803, 8),
		reward = { { 63371, 1 } },
		storage = Storage.PitsOfInfernoV2.RewardChest,
		extra = function(player, item, fromPosition, itemEx, toPosition)
			SecondFloorQuests.removeAccess(player)
		end
	},
	[6109] = {
		itemId = 2480,
		itemPos = Position(624, 1803, 8),
		reward = { { 63373, 1 } },
		storage = Storage.PitsOfInfernoV2.RewardChest,
		extra = function(player, item, fromPosition, itemEx, toPosition)
			SecondFloorQuests.removeAccess(player)
		end
	},
	[6110] = {
		itemId = 23740,
		itemPos = Position(848, 1668, 8),
		reward = { { 60055, 1 } },
		storage = Storage.Jacquin,
		extra = function(player, item, fromPosition, itemEx, toPosition)
			SecondFloorQuests.removeAccess(player)
		end
	},
}
