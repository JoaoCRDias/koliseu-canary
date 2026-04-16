local bossesGraveDanger = CreatureEvent("GraveDangerBossDeath")
function bossesGraveDanger.onDeath(creature)
	local bossName = creature:getName():lower()
	if not table.contains({ "count vlarkorth", "lord azaram", "earl osam", "sir baeloc", "duke krule" }, bossName) then
		return false
	end

	onDeathForDamagingPlayers(creature, function(creature, player)
		local kv = player:kv():scoped("grave-danger-quest")
		local killed = kv:scoped(bossName):get("killed") or 0
		if killed == 0 then
			kv:scoped(bossName):set("killed", 1)
		end

	end)

	return true
end

bossesGraveDanger:register()
