-- Rotates the active supreme vocation lever pattern at a fixed cadence and
-- resets all levers so the room starts clean for every window.

local rotation = GlobalEvent("SupremeVocationPatternRotation")

function rotation.onThink(interval)
	SupremeVocation.rotateActivePattern()
	return true
end

rotation:interval(SupremeVocation.PATTERN_ROTATION_SECONDS * 1000)
rotation:register()

-- Seed an initial pattern on server startup so the first rotation window is valid.
local startup = GlobalEvent("SupremeVocationPatternStartup")

function startup.onStartup()
	if not SupremeVocation.getActivePatternIndex() then
		SupremeVocation.rotateActivePattern()
	end
	return true
end

startup:register()
