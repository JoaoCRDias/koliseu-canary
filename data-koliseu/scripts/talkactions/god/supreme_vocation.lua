-- /supremevoc [subcommand] [playerName]
-- Dev/test utility for the Supreme Vocation quest line.
--
-- Subcommands:
--   (none)           Show the caller's current quest state.
--   status [name]    Show quest state for <name> (or caller).
--   reset [name]     Clear all quest storages + KV so the target can start fresh.
--   grant [name]     Grant the trial-of-access mission as completed (mountain unlocked).
--   pattern          Show the currently active lever pattern (globally).
--   rotate           Force a rotation of the active lever pattern now.

local talk = TalkAction("/supremevoc")

local function resolveTarget(player, param)
	local name = param and param:trim() or ""
	if name == "" then
		return player
	end
	local target = Player(name)
	if not target then
		player:sendCancelMessage(string.format("Player '%s' is not online.", name))
		return nil
	end
	return target
end

local function showStatus(player, target)
	local kv = target:kv():scoped(SupremeVocation.KV_SCOPE)
	local lines = {
		string.format("Supreme Vocation status for %s:", target:getName()),
		string.format("  mountain-started (KV):      %s", tostring(kv:get("mountain-started"))),
		string.format("  mountain-access  (KV):      %s", tostring(kv:get("mountain-access"))),
		string.format("  nature-chest-claimed (KV):  %s", tostring(kv:get("nature-chest-claimed"))),
		string.format("  QuestLine storage:          %d", target:getStorageValue(Storage.SupremeVocation.QuestLine)),
		string.format("  MissionAccess storage:      %d", target:getStorageValue(Storage.SupremeVocation.MissionAccess)),
		string.format("  MissionReport storage:      %d", target:getStorageValue(Storage.SupremeVocation.MissionReport)),
		string.format("  MissionBasin  storage:      %d", target:getStorageValue(Storage.SupremeVocation.MissionBasinRitual)),
		string.format("  EnergyWallAccess stg:       %d", target:getStorageValue(Storage.SupremeVocation.EnergyWallAccess)),
		string.format("  NatureBossKilled stg:       %d", target:getStorageValue(Storage.SupremeVocation.NatureBossKilled)),
		string.format("  NatureStageComplete stg:    %d", target:getStorageValue(Storage.SupremeVocation.NatureStageComplete)),
		string.format("  PoisonStageAccess stg:      %d", target:getStorageValue(Storage.SupremeVocation.PoisonStageAccess)),
		string.format("  PoisonRoomCleared stg:      %d", target:getStorageValue(Storage.SupremeVocation.PoisonRoomCleared)),
		string.format("  MissionPoisonReport stg:    %d", target:getStorageValue(Storage.SupremeVocation.MissionPoisonReport)),
		string.format("  PoisonStageComplete stg:    %d", target:getStorageValue(Storage.SupremeVocation.PoisonStageComplete)),
		string.format("  DeathPuzzleSolved stg:      %d", target:getStorageValue(Storage.SupremeVocation.DeathPuzzleSolved)),
		string.format("  DeathLabyrinthKey stg:      %d", target:getStorageValue(Storage.SupremeVocation.DeathLabyrinthKeyTaken)),
		string.format("  DeathChamberCleared stg:    %d", target:getStorageValue(Storage.SupremeVocation.DeathChamberCleared)),
		string.format("  MissionDeathReport stg:     %d", target:getStorageValue(Storage.SupremeVocation.MissionDeathReport)),
		string.format("  DeathStageComplete stg:     %d", target:getStorageValue(Storage.SupremeVocation.DeathStageComplete)),
		string.format("  FireStageAccess stg:        %d", target:getStorageValue(Storage.SupremeVocation.FireStageAccess)),
		string.format("  FireChamberCleared stg:     %d", target:getStorageValue(Storage.SupremeVocation.FireChamberCleared)),
		string.format("  MissionFireReport stg:      %d", target:getStorageValue(Storage.SupremeVocation.MissionFireReport)),
		string.format("  FireStageComplete stg:      %d", target:getStorageValue(Storage.SupremeVocation.FireStageComplete)),
		string.format("  Fire phase:                 %s", tostring(SupremeVocation.fireChamberGetPhase())),
		string.format("  WealthStageAccess stg:      %d", target:getStorageValue(Storage.SupremeVocation.WealthStageAccess)),
		string.format("  WealthFeePaid stg:          %d", target:getStorageValue(Storage.SupremeVocation.WealthFeePaid)),
		string.format("  Wealth streak:              %s", tostring(SupremeVocation.getWealthStreak(target))),
		string.format("  WealthChamberCleared stg:   %d", target:getStorageValue(Storage.SupremeVocation.WealthChamberCleared)),
		string.format("  MissionWealthReport stg:    %d", target:getStorageValue(Storage.SupremeVocation.MissionWealthReport)),
		string.format("  WealthStageComplete stg:    %d", target:getStorageValue(Storage.SupremeVocation.WealthStageComplete)),
		string.format("  SummitAccess stg:           %d", target:getStorageValue(Storage.SupremeVocation.SummitAccess)),
		string.format("  MissionSummitReport stg:    %d", target:getStorageValue(Storage.SupremeVocation.MissionSummitReport)),
		string.format("  SupremeVocationGranted stg: %d", target:getStorageValue(Storage.SupremeVocation.SupremeVocationGranted)),
		string.format("  Poison room phase:          %s (deposits %d/%d)",
			tostring(SupremeVocation.poisonRoomGetPhase()),
			SupremeVocation.poisonRoomGetMechanismCount(),
			SupremeVocation.PoisonRoom.mechanismRequired),
		string.format("  Active pattern index:       %s", tostring(SupremeVocation.getActivePatternIndex())),
		string.format("  Boss alive / phase active:  %s / %s",
			tostring(not SupremeVocation.isBossAreaClear()),
			tostring(SupremeVocation.isBossPhaseActive())),
	}
	player:popupFYI(table.concat(lines, "\n"))
end

local function resetTarget(player, target)
	local kv = target:kv():scoped(SupremeVocation.KV_SCOPE)
	kv:remove("mountain-started")
	kv:remove("mountain-access")
	kv:remove("nature-chest-claimed")
	kv:remove("lever-pattern") -- legacy key, ignored if absent
	for uid in pairs(SupremeVocation.Plants) do
		kv:remove("plant-cd-" .. uid)
	end
	target:setStorageValue(Storage.SupremeVocation.QuestLine, -1)
	target:setStorageValue(Storage.SupremeVocation.MissionAccess, -1)
	target:setStorageValue(Storage.SupremeVocation.MissionReport, -1)
	target:setStorageValue(Storage.SupremeVocation.MissionBasinRitual, -1)
	target:setStorageValue(Storage.SupremeVocation.EnergyWallAccess, -1)
	target:setStorageValue(Storage.SupremeVocation.NatureBossKilled, -1)
	target:setStorageValue(Storage.SupremeVocation.NatureStageComplete, -1)
	target:setStorageValue(Storage.SupremeVocation.PoisonStageAccess, -1)
	target:setStorageValue(Storage.SupremeVocation.PoisonRoomCleared, -1)
	target:setStorageValue(Storage.SupremeVocation.MissionPoisonReport, -1)
	target:setStorageValue(Storage.SupremeVocation.PoisonStageComplete, -1)
	target:setStorageValue(Storage.SupremeVocation.DeathPuzzleSolved, -1)
	target:setStorageValue(Storage.SupremeVocation.DeathLabyrinthKeyTaken, -1)
	target:setStorageValue(Storage.SupremeVocation.DeathChamberCleared, -1)
	target:setStorageValue(Storage.SupremeVocation.MissionDeathReport, -1)
	target:setStorageValue(Storage.SupremeVocation.DeathStageComplete, -1)
	target:setStorageValue(Storage.SupremeVocation.FireStageAccess, -1)
	target:setStorageValue(Storage.SupremeVocation.FireChamberCleared, -1)
	target:setStorageValue(Storage.SupremeVocation.MissionFireReport, -1)
	target:setStorageValue(Storage.SupremeVocation.FireStageComplete, -1)
	target:setStorageValue(Storage.SupremeVocation.WealthStageAccess, -1)
	target:setStorageValue(Storage.SupremeVocation.WealthFeePaid, -1)
	target:setStorageValue(Storage.SupremeVocation.WealthChamberCleared, -1)
	target:setStorageValue(Storage.SupremeVocation.MissionWealthReport, -1)
	target:setStorageValue(Storage.SupremeVocation.WealthStageComplete, -1)
	kv:remove("wealth-streak")
	target:setStorageValue(Storage.SupremeVocation.SummitAccess, -1)
	target:setStorageValue(Storage.SupremeVocation.MissionSummitReport, -1)
	target:setStorageValue(Storage.SupremeVocation.SupremeVocationGranted, -1)
	target:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Your Supreme Vocation progress has been reset.")
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("Reset Supreme Vocation for %s.", target:getName()))
end

local function grantTarget(player, target)
	SupremeVocation.startMountain(target)
	SupremeVocation.grantMountainAccess(target)
	SupremeVocation.startReport(target)
	SupremeVocation.completeReport(target)
	SupremeVocation.grantNatureBossReward(target:getId())
	SupremeVocation.markFountainPurified(target)
	SupremeVocation.completeNatureStage(target)
	target:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have been granted full access to the Supreme Vocation trial.")
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("Granted Supreme Vocation access to %s.", target:getName()))
end

local function showPattern(player)
	local index = SupremeVocation.getActivePatternIndex()
	if not index then
		player:sendCancelMessage("No active pattern is set.")
		return
	end
	local pattern = SupremeVocation.LeverPatterns[index]
	local lines = { string.format("Active pattern #%d (changes every %ds):", index, SupremeVocation.PATTERN_ROTATION_SECONDS) }
	for row = 1, SupremeVocation.GRID_ROWS do
		local rowText = ""
		for col = 1, SupremeVocation.GRID_COLS do
			rowText = rowText .. (pattern[row][col] == 1 and "[X] " or "[ ] ")
		end
		lines[#lines + 1] = rowText
	end
	lines[#lines + 1] = "[X] = lever active. [ ] = lever inactive."
	player:popupFYI(table.concat(lines, "\n"))
end

local function rotateNow(player)
	local newIndex = SupremeVocation.rotateActivePattern()
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("Rotated active pattern to #%d. Levers reset.", newIndex))
end

function talk.onSay(player, words, param)
	local trimmed = param and param:trim() or ""
	local sub, rest = trimmed:match("^(%S+)%s*(.-)$")
	sub = (sub or ""):lower()

	if sub == "" or sub == "status" then
		local target = resolveTarget(player, rest)
		if target then
			showStatus(player, target)
		end
		return true
	end

	if sub == "reset" then
		local target = resolveTarget(player, rest)
		if target then
			resetTarget(player, target)
		end
		return true
	end

	if sub == "grant" then
		local target = resolveTarget(player, rest)
		if target then
			grantTarget(player, target)
		end
		return true
	end

	if sub == "pattern" then
		showPattern(player)
		return true
	end

	if sub == "rotate" then
		rotateNow(player)
		return true
	end

	player:sendCancelMessage("Usage: /supremevoc [status|reset|grant|pattern|rotate] [playerName]")
	return true
end

talk:separator(" ")
talk:groupType("god")
talk:register()
