-- Astral Tyrant - Death Event
-- Teleports all players out of the siege area and rewards participants

local astralTyrantDeath = CreatureEvent("AstralTyrantDeath")

-- Exit position after defeating Astral Tyrant
local EXIT_POSITION = Position(825, 766, 7) -- Cosmic Siege entry room
local SIEGE_LEVEL = 1500

function astralTyrantDeath.onDeath(creature)
	-- Get damage map to identify participants
	local damageMap = creature:getDamageMap()
	local participants = {}
	local participantCount = 0

	-- Collect all players who dealt damage (key is playerId in damageMap)
	for playerId, damageInfo in pairs(damageMap) do
		local player = Player(playerId)
		if player then
			participants[player:getId()] = player
			participantCount = participantCount + 1
		end
	end

	-- Get all players in the entire siege zone using CosmicSiege helper
	local arenaZone = CosmicSiege.getArenaZone(SIEGE_LEVEL)
	arenaZone:refresh()
	local playersInZone = arenaZone:getPlayers()

	-- Teleport all players out
	for _, player in ipairs(playersInZone) do
		-- Only reward participants who dealt damage
		if participants[player:getId()] then
			local inbox = player:getStoreInbox()
			if inbox then
				local tokens = inbox:addItem(60535, 30)
				if tokens then
					player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You received 30 Siege Tokens!")
				end
			end
		end

		player:teleportTo(EXIT_POSITION, true)
		EXIT_POSITION:sendMagicEffect(CONST_ME_TELEPORT)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The siege has been completed! You have been teleported to safety.")
	end

	return true
end

astralTyrantDeath:register()
