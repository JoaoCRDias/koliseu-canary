local IDLE_SECONDS = 180
local CHECK_INTERVAL_MS = 1000

local areaFrom = Position(999, 999, 7)
local areaTo = Position(1001, 1001, 7)
local teleportTo = Position(1006, 1005, 6)

local idleTracker = {}

local idleTempleTeleport = GlobalEvent("idleTempleTeleport.onThink")

function idleTempleTeleport.onThink(interval, lastExecution)
	local now = os.time()
	local seen = {}

	for _, player in ipairs(Game.getPlayers()) do
		local pos = player:getPosition()
		local id = player:getId()
		seen[id] = true

		if pos:isInRange(areaFrom, areaTo) then
			local entry = idleTracker[id]
			if not entry or entry.x ~= pos.x or entry.y ~= pos.y or entry.z ~= pos.z then
				idleTracker[id] = { x = pos.x, y = pos.y, z = pos.z, since = now }
			elseif now - entry.since >= IDLE_SECONDS then
				player:teleportTo(teleportTo)
				player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
				idleTracker[id] = nil
			end
		else
			idleTracker[id] = nil
		end
	end

	for id in pairs(idleTracker) do
		if not seen[id] then
			idleTracker[id] = nil
		end
	end

	return true
end

idleTempleTeleport:interval(CHECK_INTERVAL_MS)
idleTempleTeleport:register()
