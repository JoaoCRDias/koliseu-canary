-- Event Pool System
-- Manages a pool of events that run at scheduled hours
-- Each hour (except excluded ones), one random event is picked and started

EventPool = {
	-- Config
	config = {
		-- Hours to SKIP (no events at these times)
		excludedHours = { 10, 22 },
	},

	-- Registered events: { name = string, canStart = function, start = function }
	events = {},

	-- Track last triggered hour to avoid double-triggering
	lastTriggeredHour = -1,
}

-- ============================================================
-- Event Registration
-- ============================================================

function EventPool:register(name, canStartFn, startFn)
	self.events[#self.events + 1] = {
		name = name,
		canStart = canStartFn,
		start = startFn,
	}
	print("[EventPool] Registered event: " .. name)
end

-- ============================================================
-- Event Selection
-- ============================================================

function EventPool:isExcludedHour(hour)
	for _, h in ipairs(self.config.excludedHours) do
		if h == hour then
			return true
		end
	end
	return false
end

function EventPool:getAvailableEvents()
	local available = {}
	for _, event in ipairs(self.events) do
		if event.canStart() then
			available[#available + 1] = event
		end
	end
	return available
end

function EventPool:pickAndStart()
	local available = self:getAvailableEvents()
	if #available == 0 then
		print("[EventPool] No events available to start.")
		return
	end

	local picked = available[math.random(#available)]
	print("[EventPool] Starting event: " .. picked.name)
	picked.start()
end

-- ============================================================
-- Tick (called every minute by globalevent)
-- ============================================================

function EventPool:onTick()
	local now = os.date("*t")
	local currentHour = now.hour
	local currentMin = now.min

	-- Only trigger at minute :00
	if currentMin ~= 0 then
		return
	end

	-- Avoid double-trigger in the same hour
	if currentHour == self.lastTriggeredHour then
		return
	end

	-- Skip excluded hours
	if self:isExcludedHour(currentHour) then
		return
	end

	self.lastTriggeredHour = currentHour
	self:pickAndStart()
end
