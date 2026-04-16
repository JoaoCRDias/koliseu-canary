SoulPit.zone:blockFamiliars()

local zoneEvent = ZoneEvent(SoulPit.zone)
function zoneEvent.afterLeave(zone, creature)
	local player = creature:getPlayer()
	if not player then
		return false
	end

	if table.empty(zone:getPlayers()) then
		if SoulPit.encounter then
			SoulPit.encounter:reset()
			SoulPit.encounter = nil
		end
		if SoulPit.kickEvent then
			stopEvent(SoulPit.kickEvent)
			SoulPit.obeliskPosition:transformItem(SoulPit.obeliskActive, SoulPit.obeliskInactive)
		end
	end
end
zoneEvent:register()

local soulPitAction = Action()
function soulPitAction.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if SoulPit.onFuseSoulCores(player, item, target) then
		return true
	end

	if not target or target:getId() ~= SoulPit.obeliskInactive then
		return false
	end

	local monsterName = string.gsub(item:getName(), " soul core", "")
	local monsterVariationName = SoulPit.getMonsterVariationNameBySoulCore(item:getName())
	monsterName = monsterVariationName and monsterVariationName or monsterName

	if not SoulPit.startFight(player, monsterName) then
		return true
	end

	item:remove(1)
	return true
end

for _, itemType in pairs(SoulPit.soulCores) do
	if itemType:getId() ~= 49164 then -- Exclude soul prism
		soulPitAction:id(itemType:getId())
	end
end
soulPitAction:register()
