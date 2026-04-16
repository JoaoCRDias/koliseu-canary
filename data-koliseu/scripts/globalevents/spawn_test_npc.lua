local spawnTestNpc = GlobalEvent("SpawnTestNpc")

function spawnTestNpc.onStartup()
	local env = serverEnvironment
	local envType = type(env)
	logger.info("[SpawnTestNpc] serverEnvironment value: '{}', type: {}", tostring(env), envType)

	if env ~= "DEV" and env ~= "QAS" then
		logger.warn("[SpawnTestNpc] Skipping spawn: serverEnvironment='{}' is not DEV or QAS", tostring(env))
		return true
	end

	local position = Position(1000, 998, 7)
	logger.info("[SpawnTestNpc] Attempting to create NPC 'Test Server Dealer' at pos ({}, {}, {})", position.x, position.y, position.z)

	local npc = Game.createNpc("Test Server Dealer", position)
	if npc then
		npc:setMasterPos(position)
		logger.info("[SpawnTestNpc] Test Server Dealer spawned successfully (env: {})", env)
	else
		logger.warn("[SpawnTestNpc] Game.createNpc returned nil - NPC file may not exist or position is invalid")
	end

	return true
end

spawnTestNpc:register()
