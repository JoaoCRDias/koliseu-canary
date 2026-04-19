-- Event Pool - Scheduler
-- Checks every minute if it's time to start a random event

local poolEvent = GlobalEvent("EventPoolScheduler")

function poolEvent.onThink(interval, lastExecution)
	EventPool:onTick()
	return true
end

poolEvent:interval(60 * 1000)
poolEvent:register()
