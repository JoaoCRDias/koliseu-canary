local wallLevers = {
	[14501] = {
		wallPos = Position(728, 1110, 8),
		wallIds = {2128, 2129}, -- Magic wall IDs (normal and decaying)
	},
	[14502] = {
		wallPos = Position(728, 1111, 8),
		wallIds = {2128, 2129},
	},
	[14503] = {
		wallPos = Position(728, 1112, 8),
		wallIds = {2128, 2129},
	},
	[14504] = {
		wallPos = Position(728, 1113, 8),
		wallIds = {2128, 2129},
	},
}

local REGEN_TIME = 10 * 60 * 1000

local function restoreWall(pos)
	local tile = Tile(pos)
	if tile then
		-- Verifica se já não existe uma magic wall
		local hasWall = tile:getItemById(2128) or tile:getItemById(2129)
		if not hasWall then
			Game.createItem(2128, 1, pos)
			pos:sendMagicEffect(CONST_ME_MAGIC_GREEN)
		end
	end
end

for aid, config in pairs(wallLevers) do
	local lever = Action()

	function lever.onUse(player, item, fromPosition, target, toPosition, isHotkey)
		if item.itemid == 2772 then
			local tile = Tile(config.wallPos)
			if not tile then
				return false
			end

			-- Tenta remover qualquer ID de magic wall
			local wallRemoved = false
			for _, wallId in ipairs(config.wallIds) do
				local wallItem = tile:getItemById(wallId)
				if wallItem then
					wallItem:remove()
					wallRemoved = true
					break
				end
			end

			-- Se removeu a wall, agenda a restauração
			if wallRemoved then
				config.wallPos:sendMagicEffect(CONST_ME_POFF)
				addEvent(restoreWall, REGEN_TIME, config.wallPos)

				local spectators = Game.getSpectators(fromPosition, false, true, 7, 7)
				for _, spectator in ipairs(spectators) do
					player:say("click", TALKTYPE_MONSTER_SAY, false, spectator, fromPosition)
				end
			end

			item:transform(2773)
		else
			item:transform(2772)
		end
		return true
	end

	lever:aid(aid)
	lever:register()
end
