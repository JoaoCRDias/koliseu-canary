-- Every 10s, if Sylvareth is alive but the arena is empty of players, remove
-- the boss and clean up the fight state. Keeps the area from being held
-- hostage by a summon + logout.

local guard = GlobalEvent("SylvarethBossGuard")

local function isArenaEmpty()
	local cfg = SupremeVocation.NatureBoss
	for _, creature in ipairs(Game.getSpectators(cfg.spawnPosition, false, true,
			cfg.spawnPosition.x - cfg.areaFrom.x,
			cfg.areaTo.x - cfg.spawnPosition.x,
			cfg.spawnPosition.y - cfg.areaFrom.y,
			cfg.areaTo.y - cfg.spawnPosition.y)) do
		if creature:isPlayer() then
			return false
		end
	end
	return true
end

function guard.onThink(interval)
	if not NatureBoss or not NatureBoss.bossId then
		return true
	end
	local boss = Creature(NatureBoss.bossId)
	if not boss then
		NatureBoss.bossId = nil
		return true
	end
	if isArenaEmpty() then
		boss:remove()
		NatureBoss.bossId = nil
		NatureBoss.phaseActive = false
		NatureBoss.phaseStepsLeft = 0
		NatureBoss.phaseSecondsLeft = 0
		NatureBoss.enrageUntil = 0
		if NatureBoss.tickEvent then
			stopEvent(NatureBoss.tickEvent)
			NatureBoss.tickEvent = nil
		end
		if NatureBoss.swapEvent then
			stopEvent(NatureBoss.swapEvent)
			NatureBoss.swapEvent = nil
		end
	end
	return true
end

guard:interval(10000)
guard:register()
