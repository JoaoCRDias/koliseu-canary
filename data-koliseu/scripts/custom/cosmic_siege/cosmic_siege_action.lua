-- Cosmic Siege - Central Mechanism Action
-- Handles party leader activation and modal display

local MECHANISM_AID = 34800

local mechanism = Action()

function mechanism.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	-- Ensure CosmicSiege module is loaded
	if not CosmicSiege then
		player:sendCancelMessage("Cosmic Siege system is not loaded.")
		return true
	end

	-- Check if player is in a party
	local party = player:getParty()
	if not party then
		player:sendCancelMessage("You must be in a party to use this mechanism.")
		return true
	end

	-- Check if player is party leader
	if party:getLeader() ~= player then
		player:sendCancelMessage("Only the party leader can activate this mechanism.")
		return true
	end

	-- Check if player is in entry room
	local zone = CosmicSiege.getEntryZone()
	zone:refresh()
	if not zone:isInZone(player:getPosition()) then
		player:sendCancelMessage("You must be in the entry room.")
		return true
	end

	-- Show level selection modal
	CosmicSiege.showLevelSelectionModal(player)

	return true
end

mechanism:aid(MECHANISM_AID)
mechanism:register()
