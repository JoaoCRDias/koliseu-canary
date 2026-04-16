local interval = 120 -- interval (in minutes)

-- Positions for top PvP killer players
local playerPositions = {
	Position(767, 1131, 3),
	Position(767, 1133, 3),
	Position(767, 1135, 3),
}

-- Positions for top PvP killer guilds
local guildPositions = {
	Position(798, 1131, 3),
	Position(798, 1133, 3),
	Position(798, 1135, 3)

}

local playerNpcNames = { "PvP Top one", "PvP Top two", "PvP Top three" }
local guildNpcNames = { "Guild Top one", "Guild Top two", "Guild Top three" }

local cachedTopKillers = {}
local cachedTopGuilds = {}

-- Query: top 3 players with most PvP kills (using player_deaths where killer is a player)
local topKillersQuery = [[
	SELECT p.`name`, p.`level`, p.`looktype`, p.`lookhead`, p.`lookbody`,
		p.`looklegs`, p.`lookfeet`, p.`lookaddons`, COUNT(*) AS `kills`
	FROM `player_deaths` pd
	INNER JOIN `players` p ON p.`name` = pd.`killed_by`
	WHERE pd.`is_player` = 1 AND p.`group_id` < 4
	GROUP BY pd.`killed_by`
	ORDER BY `kills` DESC
	LIMIT 3
]]

-- Query: top 3 guilds with most PvP kills (sum of all members' kills)
local topGuildsQuery = [[
	SELECT g.`name` AS `guild_name`, COUNT(*) AS `kills`
	FROM `player_deaths` pd
	INNER JOIN `players` p ON p.`name` = pd.`killed_by`
	INNER JOIN `guild_membership` gm ON gm.`player_id` = p.`id`
	INNER JOIN `guilds` g ON g.`id` = gm.`guild_id`
	WHERE pd.`is_player` = 1 AND p.`group_id` < 4
	GROUP BY g.`id`
	ORDER BY `kills` DESC
	LIMIT 3
]]

local function parseTopKillers(queryResult)
	cachedTopKillers = {}
	if not queryResult then
		return
	end

	repeat
		cachedTopKillers[#cachedTopKillers+1] = {
			name = result.getDataString(queryResult, "name"),
			level = result.getDataInt(queryResult, "level"),
			kills = result.getDataInt(queryResult, "kills"),
			outfit = {
				lookType = result.getDataInt(queryResult, "looktype"),
				lookHead = result.getDataInt(queryResult, "lookhead"),
				lookBody = result.getDataInt(queryResult, "lookbody"),
				lookLegs = result.getDataInt(queryResult, "looklegs"),
				lookFeet = result.getDataInt(queryResult, "lookfeet"),
				lookAddons = result.getDataInt(queryResult, "lookaddons"),
			},
		}
	until not result.next(queryResult)
	result.free(queryResult)
end

local function parseTopGuilds(queryResult)
	cachedTopGuilds = {}
	if not queryResult then
		return
	end

	repeat
		cachedTopGuilds[#cachedTopGuilds+1] = {
			name = result.getDataString(queryResult, "guild_name"),
			kills = result.getDataInt(queryResult, "kills"),
		}
	until not result.next(queryResult)
	result.free(queryResult)
end

local function removeNpcsAt(positions)
	for _, pos in ipairs(positions) do
		local tile = Tile(pos)
		if tile then
			local creature = tile:getTopCreature()
			if creature and creature:isNpc() then
				creature:remove()
			end
		end
	end
end

local function spawnPlayerPodium()
	removeNpcsAt(playerPositions)
	for i, data in ipairs(cachedTopKillers) do
		if playerPositions[i] then
			local npc = Game.createNpc(playerNpcNames[i], playerPositions[i])
			if npc then
				npc:setMasterPos(playerPositions[i])
				npc:setName(string.format("%s [%d kills]", data.name, data.kills))
				npc:setOutfit(data.outfit)
			end
		end
	end
end

local function spawnGuildPodium()
	removeNpcsAt(guildPositions)
	for i, data in ipairs(cachedTopGuilds) do
		if guildPositions[i] then
			local npc = Game.createNpc(guildNpcNames[i], guildPositions[i])
			if npc then
				npc:setMasterPos(guildPositions[i])
				npc:setName(string.format("%s [%d kills]", data.name, data.kills))
			end
		end
	end
end

local function refreshPvPPodiumAsync()
	db.asyncStoreQuery(topKillersQuery, function(queryResult)
		parseTopKillers(queryResult)
		spawnPlayerPodium()
	end)
	db.asyncStoreQuery(topGuildsQuery, function(queryResult)
		parseTopGuilds(queryResult)
		spawnGuildPodium()
	end)
end

-- On startup, use sync query
local initializePvPPodium = GlobalEvent("initializePvPPodium")
function initializePvPPodium.onStartup()
	local killersResult = db.storeQuery(topKillersQuery)
	parseTopKillers(killersResult)
	spawnPlayerPodium()

	local guildsResult = db.storeQuery(topGuildsQuery)
	parseTopGuilds(guildsResult)
	spawnGuildPodium()
end

initializePvPPodium:register()

-- Periodic update uses async query
local pvpPodium = GlobalEvent("pvpPodium")
function pvpPodium.onThink(interval)
	refreshPvPPodiumAsync()
	return true
end

pvpPodium:interval(interval * 60000)
pvpPodium:register()
