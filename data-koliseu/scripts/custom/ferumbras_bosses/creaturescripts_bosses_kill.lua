local bosses = {
	"tarbaz",
	"ragiaz",
	"plagirath",
	"razzagorn",
	"zamulosh",
	"mazoran",
	"shulgrax",
	"ferumbras mortal shell",
}

local ascendantBossesKill = CreatureEvent("AscendantBossesDeath")

function ascendantBossesKill.onDeath(creature)
	onDeathForDamagingPlayers(creature, function(creature, player)
		local bossName = creature:getName():lower()
		local kv = player:kv():scoped("ascending-ferumbras")
		local killed = kv:scoped(bossName):get("killed") or 0
		if killed == 0 then
			kv:scoped(bossName):set("killed", 1)
		end
	end)

	return true
end

ascendantBossesKill:register()
