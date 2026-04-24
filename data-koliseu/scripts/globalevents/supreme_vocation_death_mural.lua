-- Sets the death chamber mural text on server startup: picks a random order
-- of ghost releases and writes it into the sign item at the configured
-- position. The order stays fixed until the next server restart.

local startup = GlobalEvent("SupremeVocationDeathMuralStartup")

function startup.onStartup()
	SupremeVocation.deathTerraceBegin()

	local cfg = SupremeVocation.DeathChamber
	local tile = Tile(cfg.muralPosition)
	local signItem = tile and tile:getItemById(cfg.muralItemId)

	if not signItem then
		logger.warn(string.format(
			"[SupremeVocationDeathMural] Sign item %d not found at (%d,%d,%d).",
			cfg.muralItemId, cfg.muralPosition.x, cfg.muralPosition.y, cfg.muralPosition.z))
		return true
	end

	local names = SupremeVocation.deathTerraceGetExpectedOrderNames()
	local lines = { "The mural reads:", "" }
	for i, name in ipairs(names) do
		lines[#lines + 1] = string.format("%d. %s", i, name)
	end

	signItem:setAttribute(ITEM_ATTRIBUTE_TEXT, table.concat(lines, "\n"))
	logger.info(string.format("[SupremeVocationDeathMural] Wrote order: %s", table.concat(names, ", ")))
	return true
end

startup:register()
