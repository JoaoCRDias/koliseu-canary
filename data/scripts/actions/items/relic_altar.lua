local relicAltar = Action()

-- Ensure the altar container has all tool items inside
local function ensureAltarPopulated(altarContainer)
	if altarContainer:getSize() >= 4 then
		return
	end

	-- Clear any existing items
	while altarContainer:getSize() > 0 do
		local existingItem = altarContainer:getItem(0)
		if existingItem then
			existingItem:remove()
		end
	end

	-- Add the 4 items
	altarContainer:addItem(RelicSystem.ALTAR_PARCHMENT, 1)
	altarContainer:addItem(RelicSystem.ALTAR_SACRIFICER, 1)
	altarContainer:addItem(RelicSystem.ALTAR_UPGRADER, 1)
	altarContainer:addItem(RelicSystem.ALTAR_TRADER, 1)
end

function relicAltar.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if not player then
		return false
	end

	local container = Container(item:getUniqueId())
	if container then
		ensureAltarPopulated(container)
	end

	-- Return false so the engine handles the container open/close natively
	-- This properly registers it in openContainers and auto-closes on distance
	return false
end

-- Register for Relic Altar item
relicAltar:id(RelicSystem.RELIC_ALTAR)
relicAltar:register()
