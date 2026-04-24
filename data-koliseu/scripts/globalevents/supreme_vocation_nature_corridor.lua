-- Drives the Nature Defender corridor: cycles between frames every tick,
-- transforming the marked sqms into hot ground, dealing earth damage to any
-- player standing on them, and reverting the previous tick's tiles.

local tick = GlobalEvent("SupremeVocationNatureCorridor")

function tick.onThink(interval)
	local frameIndex = SupremeVocation.advanceNatureFrame()
	SupremeVocation.activateNatureFrame(frameIndex)
	return true
end

tick:interval(SupremeVocation.NatureDefender.tickInterval)
tick:register()
