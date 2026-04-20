-- Unified cooldown check.
-- Presents a modal listing all per-character cooldowns for the caller.
local SIEGE_LEVELS = { 500, 1000, 1500 }
local SIEGE_BOSS_NAMES = {
	[500] = "Nebular Warlord",
	[1000] = "Eclipse Sovereign",
	[1500] = "Astral Tyrant",
}

local DUNGEON_COOLDOWN_STORAGE = 54001
local TRINKET_COOLDOWN_SECONDS = 3 * 24 * 60 * 60

local function formatRemaining(seconds)
	if seconds <= 0 then
		return "Ready"
	end
	return Game.getTimeInWords(seconds)
end

local function gatherTrinketCd(player, now)
	local last = player:kv():scoped("elemental-trinkets"):get("last-reward-time")
	if not last then
		return "Trinket reward: Ready"
	end
	local elapsed = now - last
	if elapsed >= TRINKET_COOLDOWN_SECONDS then
		return "Trinket reward: Ready"
	end
	return "Trinket reward: " .. formatRemaining(TRINKET_COOLDOWN_SECONDS - elapsed)
end

local function gatherCosmicSiegeCds(player, now)
	local lines = {}
	for _, level in ipairs(SIEGE_LEVELS) do
		local cooldownEnd = player:kv():get("cosmic_siege.cooldown." .. level) or 0
		local bossName = SIEGE_BOSS_NAMES[level]
		local remaining = cooldownEnd - now
		local status = remaining > 0 and formatRemaining(remaining) or "Ready"
		table.insert(lines, string.format("Cosmic Siege L%d (%s): %s", level, bossName, status))
	end
	return lines
end

local function gatherDungeonCd(player, now)
	local cooldownEnd = player:getStorageValue(DUNGEON_COOLDOWN_STORAGE)
	if cooldownEnd <= 0 or cooldownEnd <= now then
		return "Solo Dungeon: Ready"
	end
	return "Solo Dungeon: " .. formatRemaining(cooldownEnd - now)
end

local function gatherGnomeArenaCd(player, now)
	local res = db.storeQuery(("SELECT `last_play_ready_at` FROM `gnome_arena_stats` WHERE `player_id` = %d"):format(player:getGuid()))
	if not res then
		return "Gnome Arena: Ready"
	end
	local readyAt = Result.getNumber(res, "last_play_ready_at")
	Result.free(res)
	if readyAt <= now then
		return "Gnome Arena: Ready"
	end
	return "Gnome Arena: " .. formatRemaining(readyAt - now)
end

local function gatherBossCds(player, now)
	local lines = {}
	for _, bossLever in pairs(BossLever) do
		if type(bossLever) == "table" and bossLever.name then
			local cooldown = player:getBossCooldown(bossLever.name)
			if cooldown and cooldown > now then
				table.insert(lines, string.format("%s: %s", bossLever.name, formatRemaining(cooldown - now)))
			end
		end
	end
	table.sort(lines)
	return lines
end

local cd = TalkAction("!cd")

function cd.onSay(player, words, param)
	local now = os.time()
	local lines = {}

	table.insert(lines, gatherTrinketCd(player, now))
	table.insert(lines, gatherDungeonCd(player, now))
	table.insert(lines, gatherGnomeArenaCd(player, now))

	for _, line in ipairs(gatherCosmicSiegeCds(player, now)) do
		table.insert(lines, line)
	end

	local bossCds = gatherBossCds(player, now)
	if #bossCds > 0 then
		table.insert(lines, "")
		table.insert(lines, "-- Boss cooldowns --")
		for _, line in ipairs(bossCds) do
			table.insert(lines, line)
		end
	end

	local modal = ModalWindow({
		title = "Cooldowns",
		message = table.concat(lines, "\n"),
	})
	modal:addButton("Close")
	modal:setDefaultEnterButton(0)
	modal:setDefaultEscapeButton(0)
	modal:sendToPlayer(player)
	return true
end

cd:groupType("normal")
cd:register()
