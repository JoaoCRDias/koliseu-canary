-- One-time migration: reset fallen raid cooldown for all players
-- Storage 57080 stores a future timestamp; setting to 0 clears the cooldown

local MIGRATION_KV = "fallen_cd_reset_v1"
local FALLEN_COOLDOWN_STORAGE = 57080

local migration = CreatureEvent("FallenCdReset")

function migration.onLogin(player)
	if player:kv():get(MIGRATION_KV) then
		return true
	end

	local cd = player:getStorageValue(FALLEN_COOLDOWN_STORAGE)
	if type(cd) == "number" and cd > 0 then
		player:setStorageValue(FALLEN_COOLDOWN_STORAGE, 0)
	end

	player:kv():set(MIGRATION_KV, true)
	return true
end

migration:register()
