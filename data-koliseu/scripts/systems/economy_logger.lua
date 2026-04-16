-- Economy Logger: sumariza gold gerado por drops de monstros
-- Arquivo: logs/economy_YYYY-MM-DD_summary.txt
-- Flush para disco a cada FLUSH_INTERVAL ms, não a cada morte
-- State é persistido em .dat para sobreviver a restarts do servidor

local LOG_DIR = CORE_DIRECTORY .. "/logs/"
local FLUSH_INTERVAL = 60 * 1000 -- 60 segundos

local function getItemSellPrice(itemId)
	if sellingTable and sellingTable[itemId] then
		return sellingTable[itemId].sell or 0
	end
	if LootShopConfigTable then
		for _, category in pairs(LootShopConfigTable) do
			for _, entry in ipairs(category) do
				if entry.clientId == itemId then
					return entry.sell or 0
				end
			end
		end
	end
	return 0
end

-- Serialização simples do state para persistência
local function serializeState(st)
	local lines = {}
	lines[#lines + 1] = "date=" .. st.date
	lines[#lines + 1] = "total=" .. st.total
	lines[#lines + 1] = "kills=" .. st.kills

	for h = 0, 23 do
		if st.hours[h] and st.hours[h] > 0 then
			lines[#lines + 1] = "hour|" .. h .. "=" .. st.hours[h]
		end
	end

	for name, data in pairs(st.monsters) do
		lines[#lines + 1] = "monster|" .. name .. "=" .. data.gold .. "," .. data.kills
		for itemName, itemGold in pairs(data.items) do
			lines[#lines + 1] = "item|" .. name .. "|" .. itemName .. "=" .. itemGold
		end
	end

	return table.concat(lines, "\n")
end

local function deserializeState(content)
	local st = { date = "", total = 0, kills = 0, monsters = {}, hours = {}, dirty = false }

	for line in content:gmatch("[^\n]+") do
		local key, value = line:match("^(.-)=(.+)$")
		if key and value then
			if key == "date" then
				st.date = value
			elseif key == "total" then
				st.total = tonumber(value) or 0
			elseif key == "kills" then
				st.kills = tonumber(value) or 0
			else
				local hourIdx = key:match("^hour|(%d+)$")
				if hourIdx then
					st.hours[tonumber(hourIdx)] = tonumber(value) or 0
				else
					local monsterName = key:match("^monster|(.+)$")
					if monsterName then
						local gold, kills = value:match("^(%d+),(%d+)$")
						if not st.monsters[monsterName] then
							st.monsters[monsterName] = { gold = 0, kills = 0, items = {} }
						end
						st.monsters[monsterName].gold = tonumber(gold) or 0
						st.monsters[monsterName].kills = tonumber(kills) or 0
					else
						local mName, itemName = key:match("^item|(.+)|([^|]+)$")
						if mName and itemName then
							if not st.monsters[mName] then
								st.monsters[mName] = { gold = 0, kills = 0, items = {} }
							end
							st.monsters[mName].items[itemName] = tonumber(value) or 0
						end
					end
				end
			end
		end
	end

	return st
end

local function getStatePath()
	return LOG_DIR .. "economy_state.dat"
end

local function loadState()
	local f = io.open(getStatePath(), "r")
	if not f then
		return { date = "", total = 0, kills = 0, monsters = {}, hours = {}, dirty = false }
	end
	local content = f:read("*a")
	f:close()
	if not content or content == "" then
		return { date = "", total = 0, kills = 0, monsters = {}, hours = {}, dirty = false }
	end
	local st = deserializeState(content)
	print("[EconomyLogger] State restored from disk (date=" .. st.date .. ", kills=" .. st.kills .. ")")
	return st
end

local function saveState(st)
	local path = getStatePath()
	local f = io.open(path, "w")
	if not f then
		os.execute("mkdir -p " .. LOG_DIR)
		f = io.open(path, "w")
		if not f then
			print("[EconomyLogger] ERROR: cannot save state to " .. path)
			return
		end
	end
	f:write(serializeState(st))
	f:close()
end

-- Estado em memória, restaurado do disco no startup
-- monsters[name] = { gold, kills, items = { [itemName] = gold } }
-- hours[0..23] = gold
local state = loadState()

local function resetIfNewDay()
	local today = os.date("%Y-%m-%d")
	if state.date ~= today then
		state.date = today
		state.total = 0
		state.kills = 0
		state.monsters = {}
		state.hours = {}
		state.dirty = false
		saveState(state)
	end
end

local function writeSummary()
	if not state.dirty then return end

	local path = LOG_DIR .. string.format("economy_%s_summary.txt", state.date)
	local f = io.open(path, "w")
	if not f then
		os.execute("mkdir -p " .. LOG_DIR)
		f = io.open(path, "w")
		if not f then
			print("[EconomyLogger] ERROR: cannot open " .. path)
			return
		end
	end

	-- Header
	local avgPerKill = state.kills > 0 and math.floor(state.total / state.kills) or 0
	f:write(string.format("Date: %s\n", state.date))
	f:write(string.format("Total Gold Generated: %d\n", state.total))
	f:write(string.format("Total Kills Tracked:  %d\n", state.kills))
	f:write(string.format("Avg Gold per Kill:    %d\n", avgPerKill))

	-- Peak hours
	f:write("\n[Gold by Hour]\n")
	for h = 0, 23 do
		local gold = state.hours[h] or 0
		if gold > 0 then
			f:write(string.format("  %02d:00  %d\n", h, gold))
		end
	end

	-- Monster contributions sorted by gold desc
	local sorted = {}
	for name, data in pairs(state.monsters) do
		sorted[#sorted + 1] = { name = name, gold = data.gold, kills = data.kills, items = data.items }
	end
	table.sort(sorted, function(a, b) return a.gold > b.gold end)

	f:write("\n[Monster Contributions]\n")
	f:write(string.format("%-40s %12s %8s %12s\n", "Monster", "Gold", "Kills", "Gold/Kill"))
	f:write(string.rep("-", 76) .. "\n")

	for _, entry in ipairs(sorted) do
		local gk = entry.kills > 0 and math.floor(entry.gold / entry.kills) or 0
		f:write(string.format("%-40s %12d %8d %12d\n", entry.name, entry.gold, entry.kills, gk))

		-- Top items for this monster
		local itemsSorted = {}
		for itemName, itemGold in pairs(entry.items) do
			itemsSorted[#itemsSorted + 1] = { name = itemName, gold = itemGold }
		end
		table.sort(itemsSorted, function(a, b) return a.gold > b.gold end)
		for i = 1, math.min(5, #itemsSorted) do
			local it = itemsSorted[i]
			local pct = entry.gold > 0 and math.floor(it.gold * 100 / entry.gold) or 0
			f:write(string.format("  %-38s %12d (%d%%)\n", "  " .. it.name, it.gold, pct))
		end
	end

	f:close()
	state.dirty = false
	saveState(state)
end

-- Timer de flush periódico
local flushEvent = GlobalEvent("EconomyLoggerFlush")

function flushEvent.onThink(_)
	resetIfNewDay()
	writeSummary()
	return true
end

flushEvent:interval(FLUSH_INTERVAL)
flushEvent:register()

-- Callback de loot: só acumula em memória, sem I/O
local callback = EventCallback("EconomyLogger")

function callback.monsterPostDropLoot(monster, corpse)
	if not corpse then return end

	resetIfNewDay()

	local monsterName = monster:getName()
	local monsterTotal = 0
	local itemTotals = {}

	for i = corpse:getSize() - 1, 0, -1 do
		local item = corpse:getItem(i)
		if item then
			local price = getItemSellPrice(item:getId())
			if price > 0 then
				local value = price * item:getCount()
				monsterTotal = monsterTotal + value
				local itemName = item:getName()
				itemTotals[itemName] = (itemTotals[itemName] or 0) + value
			end
		end
	end

	-- Always count the kill, even if no valuable loot dropped
	state.kills = state.kills + 1
	local hour = tonumber(os.date("%H")) or 0
	state.hours[hour] = (state.hours[hour] or 0) + monsterTotal

	local m = state.monsters[monsterName]
	if not m then
		state.monsters[monsterName] = { gold = 0, kills = 0, items = {} }
		m = state.monsters[monsterName]
	end
	m.kills = m.kills + 1
	m.gold = m.gold + monsterTotal
	for itemName, value in pairs(itemTotals) do
		m.items[itemName] = (m.items[itemName] or 0) + value
	end

	state.total = state.total + monsterTotal
	state.dirty = true
end

callback:register()
