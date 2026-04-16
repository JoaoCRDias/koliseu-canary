-- Nebular Warlord - Death Event
-- Teleports all players out of the siege area and rewards participants

local nebularWarlordDeath = CreatureEvent("NebularWarlordDeath")

-- Exit position after defeating Nebular Warlord
local EXIT_POSITION = Position(825, 766, 7) -- Cosmic Siege entry room
local SIEGE_LEVEL = 500

function nebularWarlordDeath.onDeath(creature)
	print("[Cosmic Siege] NebularWarlordDeath event triggered!")

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
			print(string.format("[Cosmic Siege] Participant: %s (damage: %d)", player:getName(), damageInfo.total or 0))
		end
	end

	-- Get all players in the entire siege zone using CosmicSiege helper
	local arenaZone = CosmicSiege.getArenaZone(SIEGE_LEVEL)
	arenaZone:refresh()
	local playersInZone = arenaZone:getPlayers()

	print(string.format("[Cosmic Siege] Players in zone: %d, Participants: %d", #playersInZone, participantCount))

	-- Teleport all players out
	for _, player in ipairs(playersInZone) do
		-- Only reward participants who dealt damage
		if participants[player:getId()] then
			local inbox = player:getStoreInbox()
			if inbox then
				local tokens = inbox:addItem(60535, 10)
				if tokens then
					player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You received 10 Siege Tokens!")
				end
			end
		end

		player:teleportTo(EXIT_POSITION, true)
		EXIT_POSITION:sendMagicEffect(CONST_ME_TELEPORT)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The siege has been completed! You have been teleported to safety.")
	end

	return true
end

nebularWarlordDeath:register()
