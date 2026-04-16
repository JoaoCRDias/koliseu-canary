local interval = 120 -- interval (in minutes)
local positions = { -- position in map
	Position(780, 1123, 3),
	Position(783, 1123, 3),
	Position(786, 1123, 3)
}

local npcNames = { "Top one", "Top two", "Top three" }
local cachedTopPlayers = {}

local function parseTopPlayers(queryResult)
	cachedTopPlayers = {}
	if not queryResult then
		return false
	end

	repeat
		cachedTopPlayers[#cachedTopPlayers+1] = {
			name = result.getDataString(queryResult, "name"),
			level = result.getDataInt(queryResult, "level"),
			outfit = {
				lookType = result.getDataInt(queryResult, "looktype"),
				lookHead = result.getDataInt(queryResult, "lookhead"),
				lookBody = result.getDataInt(queryResult, "lookbody"),
				lookLegs = result.getDataInt(queryResult, "looklegs"),
				lookFeet = result.getDataInt(queryResult, "lookfeet"),
				lookAddons = result.getDataInt(queryResult, "lookaddons")
			}
		}
	until not result.next(queryResult)
	result.free(queryResult)
end

local function removeOldNpcs()
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

local function spawnNpcsFromCache()
	removeOldNpcs()
	for i, data in ipairs(cachedTopPlayers) do
		if positions[i] then
			local npc = Game.createNpc(npcNames[i], positions[i])
			if npc then
				npc:setMasterPos(positions[i])
				npc:setName(string.format("%s [%d]", data.name, data.level))
				npc:setOutfit(data.outfit)
			end
		end
	end
end

local function refreshPodiumAsync()
	db.asyncStoreQuery(
		"SELECT `name`, `level`, `lookbody`, `lookfeet`, `lookhead`, `looklegs`, `looktype`, `lookaddons` FROM `players` WHERE `group_id` != 6 ORDER BY `level` DESC LIMIT 3",
		function(queryResult)
			parseTopPlayers(queryResult)
			spawnNpcsFromCache()
		end
	)
end

-- On startup, use sync query (server not serving players yet)
local initializePodium = GlobalEvent("initializePodium")
function initializePodium.onStartup()
	local queryResult = db.storeQuery("SELECT `name`, `level`, `lookbody`, `lookfeet`, `lookhead`, `looklegs`, `looktype`, `lookaddons` FROM `players` WHERE `group_id` != 6 ORDER BY `level` DESC LIMIT 3")
	parseTopPlayers(queryResult)
	spawnNpcsFromCache()
end

initializePodium:register()

-- Periodic update uses async query
local podium = GlobalEvent("podium")
function podium.onThink(interval)
	refreshPodiumAsync()
	return true
end

podium:interval(interval * 60000)
podium:register()
