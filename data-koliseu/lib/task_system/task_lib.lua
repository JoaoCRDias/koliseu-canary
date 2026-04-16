taskOptions = {
	bonusReward = 65001, -- storage bonus reward
	bonusRate = 2, -- rate bonus reward
	taskBoardPositions = {
	},
	selectLanguage = 2, -- options: 1 = pt_br or 2 = english
	uniqueTask = true, -- limit simultaneous tasks
	uniqueTaskStorage = 65002,
	maxSimultaneousTasks = 2 -- max tasks at same time (must be different categories)
}

task_pt_br = {
	exitButton = "Fechar",
	confirmButton = "OK",
	cancelButton = "Anular",
	returnButton = "Voltar",
	title = "Quadro De Missoes",
	missionError = "Missao esta em andamento ou ela ja foi concluida.",
	uniqueMissionError = "Voce ja esta com o maximo de missoes ativas.",
	sameCategoryError = "Voce ja tem uma missao ativa dessa categoria.",
	missionErrorTwo = "Voce concluiu a missao",
	missionErrorTwoo = "\nAqui estao suas recompensas:",
	choiceText = "- Experiencia: ",
	messageAcceptedText = "Voce aceitou essa missao!",
	messageDetailsText = "Detalhes da missao:",
	choiceMonsterName = "Missao: ",
	choiceMonsterRace = "Racas: ",
	choiceMonsterKill = "Abates: ",
	choiceEveryDay = "Repeticao: Todos os dias",
	choiceRepeatable = "Repeticao: Sempre",
	choiceOnce = "Repeticao: Apenas uma vez",
	choiceReward = "Recompensas:",
	messageAlreadyCompleteTask = "Voce ja concluiu essa missao.",
	choiceCancelTask = "Voce cancelou essa missao",
	choiceCancelTaskError = "Voce nao pode cancelar essa missao, porque ela ja foi concluida ou nao foi iniciada.",
	choiceBoardText = "Escolha uma missao e use os botoes abaixo:",
	choiceRewardOnHold = "Resgatar Premio",
	choiceDailyConclued = "Diaria Concluida",
	choiceConclued = "Concluida",
	messageTaskBoardError = "O quadro de missoes esta muito longe ou esse nao e o quadro de missoes correto.",
	messageCompleteTask = "Voce terminou essa missao! \nRetorne para o quadro de missoes e pegue sua recompensa.",
}

taskConfiguration = {
	{
		name = "easy",
		total = 1000,
		type = "daily",
		storage = 190000,
		storagecount = 190001,
		rewards = {
			{ 60129, 10 },
		},
		races = {
			"Minotaur",
			"Minotaur Guard",
			"Minotaur Archer",
			"Minotaur Mage",
			"Cyclops",
			"Cyclops Drone",
			"Cyclops Smith",
			"Vampire",
			"Vampire Viscount",
			"Vampire Bride",
			"Cult Believer",
			"Cult Scholar",
			"Cult Enforcer",
			"Hero",
			"Vicious Squire",
			"Renegade Knight",
			"Vile Grandmaster",
			"Werebear",
			"Werebadger",
			"Werefox",
			"Werewolf",
			"War Golem",
			"Worker Golem",
			"Banshee",
			"Nightstalker",
			"Giant Spider",
			"Exotic Cave Spider",
			"Exotic Bat",
			"Dragon",
			"Dragon Lord",
			"Dragon Hatchling",
			"Dragon Lord Hatchling",
			"Putrid Mummy",
			"Bonebeast",
			"Ancient Scarab",
			"Scarab",
			"Kongra",
			"Merlkin",
			"Sibang",
			"Dwarf Geomancer",
			"Dwarf Soldier",
			"Dwarf Guard",
			"Dwarf",
		},
	},
	{
		name = "medium",
		total = 2000,
		type = "daily",
		storage = 190002,
		storagecount = 190003,
		rewards = {
			{ 60129, 20 },
		},
		races = {
			"Lumbering Carnivor",
			"Spiky Carnivor",
			"Menacing Carnivor",
			"Crazed Summer Rearguard",
			"Insane Siren",
			"Crazed Summer Vanguard",
			"Crazed Winter Rearguard",
			"Soul-Broken Harbinger",
			"Crazed Winter Vanguard",
			"Silencer",
			"Guzzlemaw",
			"Frazzlemaw",
			"Retching Horror",
			"Choking Fear",
			"Juggernaut",
			"Demon Outcast",
			"Dark Torturer",
			"Skeleton Elite Warrior",
			"Undead Elite Gladiator",
			"Cave Chimera",
			"Varnished Diremaw",
			"Tremendous Tyrant",
			"Diremaw",
			"Deepworm",
			"Lavaworm",
			"Mean Lost Soul",
			"Freakish Lost Soul",
			"Flimsy Lost Soul",
			"Streaked Devourer",
			"Lavafungus",
			"Gazer Spectre",
			"Burster Spectre",
			"Ripper Spectre",
			"Harpy",
			"Crape Man",
			"Carnivostrich",
			"Rhindeer",
			"Spectre",
			"Grimeleech",
			"Hellflayer",
			"Vexclaw",
			"Hellhound",
			"Hellfire Fighter",
			"Ink Blob",
			"Cursed Book",
			"Adult Goanna",
			"Young Goanna",
			"Biting Book",
			"Energuardian Of Tales",
			"Knowledge Elemental",
			"Energetic Book",
			"Brain Squid",
			"Venerable Girtablilu",
			"Priestess Of The Wild Sun",
			"Black Sphinx Acolyte",
			"Burning Gladiator",
			"Girtablilu Warrior",
			"Animated Feather",
			"Icecold Book",
			"Squid Warden",
			"Rage Squid",
			"Burning Book",
			"Energuardian Of Tales",
			"Bulltaur Brute",
			"Bulltaur Alchemist",
			"Bulltaur Forgepriest",
			"Foam Stalker",
			"Two-Headed Turtle",
			"Falcon Paladin",
			"Falcon Knight",
			"Deathling Spellsinger",
			"Deathling Scout",
			"Cobra Vizier",
			"Cobra Assassin",
			"Cobra Scout",
			"True Midnight Asura",
			"True Dawnfire Asura",
			"True Frost Flower Asura",
			"Frost Flower Asura",
			"Midnight Asura",
			"Dawnfire Asura",
		},
	},
	{
		name = "hard",
		total = 3000,
		type = "daily",
		storage = 190004,
		storagecount = 190005,
		rewards = {
			{ 60129, 30 },
		},
		races = {
			"Knight's Apparition",
			"Druid's Apparition",
			"Many Faces",
			"Paladin's Apparition",
			"Sorcerer's Apparition",
			"Bony Sea Devil",
			"Turbulent Elemental",
			"Capricious Phantom",
			"Mould Phantom",
			"Rotten Golem",
			"Branchy Crawler",
			"Sulphur Spouter",
			"Nighthunter",
			"Undertaker",
			"Sulphider",
			"Sopping Carcass",
			"Oozing Carcass",
			"Meandering Mushroom",
			"Rotten Man-Maggot",
			"Darklight Matter",
			"Darklight Source",
			"Darklight Striker",
			"Walking Pillar",
			"Wandering Pillar",
			"Darklight Emitter",
			"Converter",
			"Darklight Construct",
			"Oozing Corpus",
			"Bloated Man-Maggot",
			"Mycobiontic Beetle",
			"Sopping Corpus",
			"Emerald Tortoise",
			"Gore Horn",
			"Hulking Prehemoth",
			"Sabretooth",
			"Noxious Ripptor",
			"Mercurial Menace",
			"Mantosaurus",
			"Headpecker",
			"Infernal Demon",
			"Brachiodemon",
			"Infernal Phantom",
			"Courage Leech",
			"Cloak Of Terror",
			"Vibrant Phantom",
			"Astral Leech",
			"Rift Stalker",
			"Void Crawler",
			"Dimensional Shade",
			"Nebula Weaver",
			"Starfall Sentinel",
			"Cosmic Warden",
			"Entropy Devourer",
			"Singularity Spawn",
			"Event Horizon",
			"Oblivion Herald",
			"Reality Fracture",
		},
	},
	{
		name = "epic",
		total = 4000,
		type = "daily",
		storage = 190006,
		storagecount = 190007,
		rewards = {
			{ 60129, 40 },
		},
		races = {
			"Anomaly Man",
			"Infernal Bonefiend",
			"Soulleecher",
			"Grim Gourd",
			"Twisted Pumpkinling",
			"Wailing Jack",
			"Bonefiend",
			"Rattling Abyssal",
			"Ancient Gozzler",
			"Bonegrinder",
			"Carrion Monarch",
			"Demonic Beholder",
			"Dark Executioner",
			"Bloodthirsty Executioner",
			"Crushing Executioner",
			"Sinspawn",
			"Shadowflame Dragon",
			"Stonehide Dragon",
			"Tempest Wing",
			"Gloomcaster Minister",
			-- New epics
			"Abyssal Mauler",
			"Arcsurge Conduit",
			"Blazefury Ravager",
			"Bonecrusher Wight",
			"Cinder Behemoth",
			"Coilfang Matriarch",
			"Deepfang Predator",
			"Gemheart Warden",
			"Graveshroud Revenant",
			"Hexbound Sorcerer",
			"Infernal Punisher",
			"Ironshell Guardian",
			"Magma Stalker",
			"Mosscrag Colossus",
			"Nagascale Guardian",
			"Necrotic Overlord",
			"Nightfall Executioner",
			"Prismatic Sentinel",
			"Runeweaver Adept",
			"Serpentcrown Mystic",
			"Shadowstep Cutthroat",
			"Shardborn Golem",
			"Shellbreaker Ancient",
			"Thundercore Titan",
			"Tidalwrath Leviathan",
			"Venomblade Assassin",
			"Voidcaller Archon",
			"Volcanic Destroyer",
			"Voltspawn Herald",
			"Wrathborn Fury",
			"Atrophied Wings",
			"Bluehide Dragon",
			"Darkness Warlock",
			"Darkhide Dragon",
			"Demonic Soul",
			"Flaming Bastard",
			"Lier",
			"Reaper Apparition",
			"Remains of Chemical",
			"Shiny Bald",
			"Shiny Dog",
		},
	},
	{
		name = "rampage",
		total = 5000,
		type = "daily",
		storage = 190008,
		storagecount = 190009,
		rewards = {
			{ 60129, 60 },
		},
		races = {
			"Rotmaw Ogre",
			"Riftburn Ogre",
			"Doomcurrent Ogre",
			"Stoneflesh Ogre",
			"Blightbone Revenant",
			"Venomrot Wraith",
			"Plaguefiend Behemoth",
			"Dreadmaw Corruptor",
			"Alcohol Bottle",
			"Ashrock Warden",
			"Baby Ogre",
			"Crimson Buccaneer",
			"Crossbow Rifleman",
			"Deeprock Berserker",
			"Ember Bombadier",
			"Frostpelt Marauder",
			"Gloomcaster President",
			"Gloomcaster President Spouse",
			"Grudge Keeper",
			"Ironforge Grunt",
			"Molten Forgemaster",
			"Pest Disperser",
			"Plaguefiend Bonelord",
			"Plunderer Captain",
			"Powder Gunner",
			"Runeshot Artillerist",
			"Saltwater Corsair",
			"Servant Of The Ogres",
			"Spelunker Sharpshooter",
			"Stonepick Digger",
			"Storm Conjurer",
			"Vault Guardian",
		},
	},

}

taskQuestLog = 65000 -- A storage so you get the quest log

-- Task daily completion count (shared across all tiers)
taskDailyCountStorage = 191000

-- Max daily task completions (shared across all tiers)
taskMaxDailyCompletionsFree = 1
taskMaxDailyCompletionsVip = 3
taskMaxDailyCompletionsEnhanced = 4

local function isTaskVip(player)
	if player:isVip() then
		return true
	end
	local vipDays = player:getVipDays()
	if vipDays and vipDays > 0 then
		return true
	end
	local vipUntil = player:getVipTime()
	return vipUntil and vipUntil > os.time() or false
end

local TASK_ENHANCEMENT_STORAGE = 58100

local function hasTaskEnhancement(player)
	return isTaskVip(player) and player:getStorageValue(TASK_ENHANCEMENT_STORAGE) == 1
end

function getTaskLevelReward(playerLevel)
	if playerLevel < 1000 then return 5 end
	if playerLevel < 2000 then return 4 end
	if playerLevel < 3000 then return 3 end
	if playerLevel < 4000 then return 2 end
	return 1
end

function Player.getActiveTaskCount(self)
	local count = 0
	for _, data in pairs(taskConfiguration) do
		if self:getStorageValue(data.storagecount) ~= -1 then
			count = count + 1
		end
	end
	return count
end

function Player.hasActiveTaskInCategory(self, storage)
	local targetData = getTaskByStorage(storage)
	if not targetData then
		return false
	end
	return self:getStorageValue(targetData.storagecount) ~= -1
end

function Player.getCustomActiveTasksName(self)
	local player = self
	if not player then
		return false
	end
	local tasks = {}
	for i, data in pairs(taskConfiguration) do
		if player:getStorageValue(data.storagecount) ~= -1 then
			tasks[#tasks+1] = data.name
		end
	end
	return #tasks > 0 and tasks or false
end

function getTaskByStorage(storage)
	for i, data in pairs(taskConfiguration) do
		if data.storage == tonumber(storage) then
			return data
		end
	end
	return false
end

function getTaskIndexByStorage(storage)
	for i, data in pairs(taskConfiguration) do
		if data.storage == tonumber(storage) then
			return i
		end
	end
	return false
end

-- Get how many tasks player completed today (shared across all tiers)
function Player.getTaskDailyCompletions(self)
	local count = self:getStorageValue(taskDailyCountStorage)
	return count > 0 and count or 0
end

-- Increment daily completion count (shared across all tiers)
function Player.addTaskDailyCompletion(self)
	local current = self:getTaskDailyCompletions()
	self:setStorageValue(taskDailyCountStorage, current + 1)
	return true
end

-- Get max daily completions based on VIP status and task enhancement
function Player.getMaxTaskDailyCompletions(self)
	local max
	if hasTaskEnhancement(self) then
		max = taskMaxDailyCompletionsEnhanced
	elseif isTaskVip(self) then
		max = taskMaxDailyCompletionsVip
	else
		max = taskMaxDailyCompletionsFree
	end
	if DOUBLE_TASK_EVENT then
		max = max * 2
	end
	return max
end

-- Check if player can do more tasks today (shared across all tiers)
function Player.canDoMoreTasksToday(self)
	local completions = self:getTaskDailyCompletions()
	local maxCompletions = self:getMaxTaskDailyCompletions()
	return completions < maxCompletions
end

function getTaskByMonsterName(name)
	for i, data in pairs(taskConfiguration) do
		for _, dataList in ipairs(data.races) do
			if dataList:lower() == name:lower() then
				return data
			end
		end
	end
	return false
end

function Player.startTask(self, storage)
	local player = self
	if not player then
		return false
	end
	local data = getTaskByStorage(storage)
	if data == false then
		return false
	end
	if player:getStorageValue(taskQuestLog) == -1 then
		player:setStorageValue(taskQuestLog, 1)
	end
	player:setStorageValue(storage, player:getStorageValue(storage) + 1)
	player:setStorageValue(data.storagecount, 0)
	return true
end

function Player.canStartCustomTask(self, storage)
	local player = self
	if not player then
		return false
	end
	local data = getTaskByStorage(storage)
	if data == false then
		return false
	end
	if data.type == "daily" then
		-- Check if player has remaining daily completions (VIP: 3x, Free: 1x)
		-- Task resets on server save, not with timer
		return player:canDoMoreTasksToday()
	elseif data.type == "once" then
		return player:getStorageValue(storage) == -1
	elseif data.type[1] == "repeatable" and data.type[2] ~= -1 then
		return player:getStorageValue(storage) < (data.type[2] - 1)
	else
		return true
	end
end

function Player.endTask(self, storage, prematurely)
	local player = self
	if not player then
		return false
	end
	local data = getTaskByStorage(storage)
	if data == false then
		return false
	end
	if prematurely then
		if data.type == "daily" then
			player:setStorageValue(storage, -1)
		else
			player:setStorageValue(storage, player:getStorageValue(storage) - 1)
		end
	else
		if data.type == "daily" then
			-- Increment daily completion counter (resets on server save)
			player:addTaskDailyCompletion()
		end
	end
	player:setStorageValue(data.storagecount, -1)
	return true
end

function Player.hasStartedTask(self, storage)
	local player = self
	if not player then
		return false
	end
	local data = getTaskByStorage(storage)
	if data == false then
		return false
	end
	return player:getStorageValue(data.storagecount) ~= -1
end

function Player.getTaskKills(self, storage)
	local player = self
	if not player then
		return false
	end
	return player:getStorageValue(storage)
end

function Player.addTaskKill(self, storage, count)
	local player = self
	if not player then
		return false
	end
	local data = getTaskByStorage(storage)
	if data == false then
		return false
	end
	local kills = player:getTaskKills(data.storagecount)
	if kills >= data.total then
		return false
	end
	if kills + count >= data.total then
		player:setStorageValue(data.storagecount, data.total)

		if hasTaskEnhancement(player) then
			-- LEVEL REWARD (auto-claim)
			local currentLevel = player:getLevel()
			local levelsToGain = getTaskLevelReward(currentLevel)
			local targetLevel = currentLevel + levelsToGain
			local expNeeded = Game.getExperienceForLevel(targetLevel) - player:getExperience()
			if expNeeded > 0 then
				player:addExperience(expNeeded, true)
			end

			-- AUTO-CLAIM: Give standard item rewards (respects bonus multiplier)
			local hasBonusReward = player:getStorageValue(taskOptions.bonusReward) >= 1
			local rewardRate = hasBonusReward and taskOptions.bonusRate or 1
			if data.rewards then
				for _, info in pairs(data.rewards) do
					if info[1] == "exp" then
						player:addExperience(info[2] * rewardRate)
					elseif tonumber(info[1]) then
						player:addItem(info[1], info[2] * rewardRate)
					end
				end
			end

			-- BONUS: 500 Hunting Task Points
			player:addTaskHuntingPoints(1000)

			-- Mark task complete (increments daily counter)
			player:endTask(storage, false)

			local completionMsg = string.format("[%s] Auto-completed! +%d levels, +1000 HTP",
				data.name or "Task", levelsToGain)
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, completionMsg)
			player:sendChannelMessage(player, completionMsg, TALKTYPE_CHANNEL_O, 9)
			player:getPosition():sendMagicEffect(CONST_ME_PRISMATIC_SPARK)
			player:getPosition():sendSingleSoundEffect(SOUND_EFFECT_TYPE_ACTION_LEVEL_ACHIEVEMENT,
				player:isInGhostMode() and nil or player)

			-- AUTO-RESTART: if daily limit not reached
			if player:canDoMoreTasksToday() then
				player:startTask(storage)
				player:sendTextMessage(MESSAGE_EVENT_ADVANCE,
					string.format("[%s] Task auto-restarted! (%d/%d daily)",
						data.name or "Task",
						player:getTaskDailyCompletions(),
						player:getMaxTaskDailyCompletions()))
			else
				player:sendTextMessage(MESSAGE_EVENT_ADVANCE,
					"[Task System] Daily limit reached. Task not restarted.")
			end
		else
			-- Normal behavior: tell player to claim rewards at board (exp given on report)
			local levelsToGain = getTaskLevelReward(player:getLevel())
			local completionMsg = string.format("[%s] Completed: %d/%d (+%d levels!)",
				data.name or "Task", data.total or 0, data.total or 0, levelsToGain)
			if taskOptions.selectLanguage == 1 then
				player:sendTextMessage(MESSAGE_EVENT_ADVANCE,
					task_pt_br.messageCompleteTask .. "\n" .. completionMsg)
			else
				player:sendTextMessage(MESSAGE_EVENT_ADVANCE,
					"[Task System] You have finished this task! To claim your rewards, return to the quest board.\n" .. completionMsg)
			end
			player:sendChannelMessage(player, completionMsg, TALKTYPE_CHANNEL_O, 9)
		end
		return true
	end
	-- Update quest tracker with progress
	local newKills = kills + count
	player:setStorageValue(data.storagecount, newKills)
	-- Show progress notification (orange text at top)
	local progressMsg = string.format("[%s] Progress: %d/%d", data.name or "Task", newKills or 0, data.total or 0)
	player:sendTextMessage(MESSAGE_STATUS, progressMsg)
	-- Send progress message to Tasks channel (ID 9)
	player:sendChannelMessage(player, progressMsg, TALKTYPE_CHANNEL_O, 9)
	return true
end
