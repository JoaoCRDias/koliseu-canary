GemBag = GemBag or {}

---@class GemBagConfig
GemBag.config = {
	ITEMID_GEM_BAG = 60165, -- Backpack of Holding (24 slots)
	PLACEHOLDER_SLOT_ID = 60325, -- Empty gem slot
	LOCK_ITEMID = 60327, -- Closed trap (visual lock)
	AID_INDICATOR_BASE = 910100, -- Produces 910101..910106
	STORAGE_GEM_EXTENDER = 910001,
	STORAGE_GEM_AMPLIFICATION = 910006,
	STORAGE_GEM_LIFE_LEECH_AMOUNT = 910030,
	STORAGE_GEM_LIFE_LEECH_CHANCE = 910031,
	STORAGE_GEM_MANA_LEECH_AMOUNT = 910032,
	STORAGE_GEM_MANA_LEECH_CHANCE = 910033,
	STORAGE_GEM_CRITICAL_CHANCE = 910034,
	STORAGE_GEM_CRITICAL_DAMAGE = 910035,
	COLUMN_COUNT = 4,
	ROW_COUNT = 6,
	DEFAULT_UNLOCKED_COLUMNS = 3, -- columns 1-3 usable without extender (col 4 needs extender)
	INDICATOR_ITEMIDS = {
		weapon = {
			[1] = 60336, -- Sorcerer
			[2] = 60332, -- Druid
			[3] = 60334, -- Paladin
			[4] = 60333, -- Knight
			[5] = 60336, -- Master Sorcerer (uses same as Sorcerer)
			[6] = 60332, -- Elder Druid (uses same as Druid)
			[7] = 60334, -- Royal Paladin (uses same as Paladin)
			[8] = 60333, -- Elite Knight (uses same as Knight)
		},
		helmet = 60328,
		armor = 60326,
		legs = 60329,
		boots = 60330,
		shield = {
			[1] = 60331, -- Sorcerer
			[2] = 60331, -- Druid
			[3] = 60318, -- Paladin
			[4] = 60337, -- Knight
			[5] = 60331, -- Master Sorcerer (uses same as Sorcerer)
			[6] = 60331, -- Elder Druid (uses same as Druid)
			[7] = 60318, -- Royal Paladin (uses same as Paladin)
			[8] = 60337, -- Elite Knight (uses same as Knight)
		},
	},
	EQUIP_ROWS = {
		[1] = "boots",
		[2] = "legs",
		[3] = "armor",
		[4] = "helmet",
		[5] = "shield",
		[6] = "weapon",
	},
	MESSAGES = {
		FIXED_SLOT = "Este slot é fixo.",
		RESERVED_INDICATOR = "Slot reservado ao indicador do equipamento.",
		REQUIRES_EXTENDER = "Compre o Gem Extender para desbloquear este slot.",
		ONLY_GEMS = "Apenas gemas podem ser colocadas aqui.",
		GEM_INCOMPATIBLE = "Esta gema não é compatível com %s.",
		INVALID_SLOT = "Slot inválido.",
		SCHEMA_REPAIRED = "Gem Bag com estrutura inválida foi corrigida automaticamente.",
		SCHEMA_PURGED = "Itens inválidos foram movidos para sua Store Inbox ao reparar a Gem Bag.",
		EXTENDER_GRANTED = "Seu Gem Extender foi ativado, a quarta coluna da Gem Bag está liberada.",
		EXTENDER_REVOKED = "Gem Extender removido. Slots finais foram bloqueados novamente.",
	},
}

GemBag.constants = {
	TOTAL_SLOTS = GemBag.config.ROW_COUNT * GemBag.config.COLUMN_COUNT,
	FIRST_GEM_COLUMN = 2,
	INDICATOR_COLUMN = 1,
	LOCK_COLUMN = 4,
}

GemBag.lookup = GemBag.lookup or {
	rowByEquip = {},
}

GemBag.config.ELEMENTS = GemBag.config.ELEMENTS or {
	fire = { label = "Fire", combatType = COMBAT_FIREDAMAGE, shieldStorage = 910010, weaponStorage = 910020 },
	energy = { label = "Energy", combatType = COMBAT_ENERGYDAMAGE, shieldStorage = 910011, weaponStorage = 910021 },
	earth = { label = "Earth", combatType = COMBAT_EARTHDAMAGE, shieldStorage = 910012, weaponStorage = 910022 },
	ice = { label = "Ice", combatType = COMBAT_ICEDAMAGE, shieldStorage = 910013, weaponStorage = 910023 },
	holy = { label = "Holy", combatType = COMBAT_HOLYDAMAGE, shieldStorage = 910014, weaponStorage = 910024 },
	death = { label = "Death", combatType = COMBAT_DEATHDAMAGE, shieldStorage = 910015, weaponStorage = 910025 },
	physical = { label = "Physical", combatType = COMBAT_PHYSICALDAMAGE, shieldStorage = 910016, weaponStorage = 910026 },
}

GemBag.elementsByLabel = GemBag.elementsByLabel or {}
GemBag.elementsByKey = GemBag.elementsByKey or {}

for key, info in pairs(GemBag.config.ELEMENTS) do
	GemBag.elementsByKey[key] = info
	if info.label then
		GemBag.elementsByLabel[info.label] = info
		GemBag.elementsByLabel[string.lower(info.label)] = info
	end
end

for row, equip in pairs(GemBag.config.EQUIP_ROWS) do
	GemBag.lookup.rowByEquip[equip] = row
end

GemBag._cache = GemBag._cache or {}

---@return integer row, integer col
function GemBag.bagRowCol(slotIndex)
	if slotIndex < 0 then
		return 0, 0
	end
	local row = math.floor(slotIndex / GemBag.config.COLUMN_COUNT) + 1
	local col = (slotIndex % GemBag.config.COLUMN_COUNT) + 1
	return row, col
end

---Get the equipment type for a visual row position in the game
---Container rows: [1]=boots, [2]=legs, [3]=armor, [4]=helmet, [5]=shield, [6]=weapon
---Visual (game): weapon(top row 1), shield(row 2), helmet(row 3), armor(row 4), legs(row 5), boots(row 6)
---When client renders, it shows container row 6 as visual row 1 (inverted)
---@param containerRow integer
---@return string equipment type for the visual position
function GemBag.getVisualEquipForContainerRow(containerRow)
	-- Client renders containers inverted:
	-- Container row 1 (boots) appears as visual row 6 (bottom)
	-- Container row 6 (weapon) appears as visual row 1 (top)
	-- So we need to invert to get the correct visual equipment
	local visualRow = (GemBag.config.ROW_COUNT - containerRow + 1)
	return GemBag.config.EQUIP_ROWS[visualRow]
end

---@param row integer
---@param col integer
---@return integer
function GemBag.colToIndex(row, col)
	return (row - 1) * GemBag.config.COLUMN_COUNT + (col - 1)
end

---@param player Player
---@return boolean
function GemBag.playerHasExtender(player)
	return player and player:getStorageValue(GemBag.config.STORAGE_GEM_EXTENDER) == 1 or false
end

---@param item Item|nil
---@return boolean
function GemBag.isGemBagItem(item)
	return item and item:getId() == GemBag.config.ITEMID_GEM_BAG
end

---@param item Item|nil
---@return boolean
function GemBag.isIndicator(item)
	if not item then
		return false
	end
	local aid = item:getActionId()
	return aid >= GemBag.config.AID_INDICATOR_BASE + 1 and aid <= GemBag.config.AID_INDICATOR_BASE + GemBag.config.ROW_COUNT
end

---@param item Item|nil
---@return boolean
function GemBag.isLock(item)
	return item and item:getId() == GemBag.config.LOCK_ITEMID
end

---@param item Item|nil
---@return boolean
function GemBag.isPlaceholder(item)
	return item and item:getId() == GemBag.config.PLACEHOLDER_SLOT_ID
end

---@param item Item|nil
---@return boolean
function GemBag.isFixedByAid(item)
	return GemBag.isIndicator(item) or GemBag.isLock(item)
end

---@param cylinder Cylinder|nil
---@return Container|nil
function GemBag.getBagContainer(cylinder)
	if not cylinder then
		return nil
	end

	-- Try to convert Cylinder to Container
	local container = nil
	if cylinder.getContainerItem then
		container = cylinder
	else
		local success, result = pcall(function() return Container(cylinder:getUniqueId()) end)
		if success and result then
			container = result
		else
			return nil
		end
	end

	if not container then
		return nil
	end

	-- Check if this container IS the gem bag
	-- Method 1: Try getContainerItem() if available
	if container.getContainerItem then
		local containerItem = container:getContainerItem()
		if containerItem and GemBag.isGemBagItem(containerItem) then
			return container
		end
	end

	-- Method 2: Check if the container itself is the gem bag
	if container.getID then
		local containerId = container:getID()
		if containerId == GemBag.config.ITEMID_GEM_BAG then
			return container
		end
	end

	-- Method 3: Try using the container's parent to get the gem bag item
	local parentItem = container:getParent()
	if parentItem and parentItem.getId then
		local parentId = parentItem:getId()
		if parentId == GemBag.config.ITEMID_GEM_BAG then
			return container
		end
	end

	return nil
end

local GEM_IDS = {
	60338, 60339, 60340, 60341, 60342, 60343, 60344, 60345, 60346, 60347, -- upgrade momentum
	60348, 60349, 60350, 60351, 60352, 60353, 60354, 60355, 60356, 60357, -- upgrade onslaught
	60358, 60359, 60360, 60361, 60362, 60363, 60364, 60365, 60366, 60367, -- upgrade transcendence
	60368, 60369, 60370, 60371, 60372, 60373, 60374, 60375, 60376, 60377, -- upgrade ruse
	60167, 60168, 60169, 60170, 60171, 60172, 60173, 60174, 60175, 60176, -- death gem
	60177, 60178, 60179, 60180, 60181, 60182, 60183, 60184, 60185, 60186, -- energy gem
	60187, 60188, 60189, 60190, 60191, 60192, 60193, 60194, 60195, 60196, -- fire gem
	60197, 60198, 60199, 60200, 60201, 60202, 60203, 60204, 60205, 60206, -- holy gem
	60207, 60208, 60209, 60210, 60211, 60212, 60213, 60214, 60215, 60216, -- ice gem
	60217, 60218, 60219, 60220, 60221, 60222, 60223, 60224, 60225, 60226, -- physical gem
	60227, 60228, 60229, 60230, 60231, 60232, 60233, 60234, 60235, 60166, -- earth gem
}

GemBag.gemLookup = GemBag.gemLookup or {}
for _, id in ipairs(GEM_IDS) do
	GemBag.gemLookup[id] = true
end

---@param item Item|nil
---@return boolean
function GemBag.isGem(item)
	return item and GemBag.gemLookup[item:getId()] or false
end

GemBag.gemDefinitions = GemBag.gemDefinitions or {
	-- Upgrade Momentum Gems (41693-41703)
	[60338] = { name = "momentum gem tier 1", allowedRows = { "helmet", "armor", "legs", "boots" }, bonuses = { rows = { helmet = { momentum = 1.0 }, armor = { criticalDamagePercent = 0.70 }, legs = { criticalChancePercent = 0.50 }, boots = { xpPercent = 1 } } } },
	[60339] = { name = "momentum gem tier 2", allowedRows = { "helmet", "armor", "legs", "boots" }, bonuses = { rows = { helmet = { momentum = 2.02 }, armor = { criticalDamagePercent = 1.40 }, legs = { criticalChancePercent = 1.00 }, boots = { xpPercent = 2 } } } },
	[60340] = { name = "momentum gem tier 3", allowedRows = { "helmet", "armor", "legs", "boots" }, bonuses = { rows = { helmet = { momentum = 3.10 }, armor = { criticalDamagePercent = 2.10 }, legs = { criticalChancePercent = 1.50 }, boots = { xpPercent = 3 } } } },
	[60341] = { name = "momentum gem tier 4", allowedRows = { "helmet", "armor", "legs", "boots" }, bonuses = { rows = { helmet = { momentum = 4.22 }, armor = { criticalDamagePercent = 2.80 }, legs = { criticalChancePercent = 2.00 }, boots = { xpPercent = 4 } } } },
	[60342] = { name = "momentum gem tier 5", allowedRows = { "helmet", "armor", "legs", "boots" }, bonuses = { rows = { helmet = { momentum = 5.40 }, armor = { criticalDamagePercent = 3.50 }, legs = { criticalChancePercent = 2.50 }, boots = { xpPercent = 5 } } } },
	[60343] = { name = "momentum gem tier 6", allowedRows = { "helmet", "armor", "legs", "boots" }, bonuses = { rows = { helmet = { momentum = 6.62 }, armor = { criticalDamagePercent = 4.20 }, legs = { criticalChancePercent = 3.00 }, boots = { xpPercent = 6 } } } },
	[60344] = { name = "momentum gem tier 7", allowedRows = { "helmet", "armor", "legs", "boots" }, bonuses = { rows = { helmet = { momentum = 7.90 }, armor = { criticalDamagePercent = 4.90 }, legs = { criticalChancePercent = 3.50 }, boots = { xpPercent = 7 } } } },
	[60345] = { name = "momentum gem tier 8", allowedRows = { "helmet", "armor", "legs", "boots" }, bonuses = { rows = { helmet = { momentum = 9.22 }, armor = { criticalDamagePercent = 5.60 }, legs = { criticalChancePercent = 4.00 }, boots = { xpPercent = 8 } } } },
	[60346] = { name = "momentum gem tier 9", allowedRows = { "helmet", "armor", "legs", "boots" }, bonuses = { rows = { helmet = { momentum = 10.60 }, armor = { criticalDamagePercent = 6.30 }, legs = { criticalChancePercent = 4.50 }, boots = { xpPercent = 9 } } } },
	[60347] = { name = "momentum gem tier 10", allowedRows = { "helmet", "armor", "legs", "boots" }, bonuses = { rows = { helmet = { momentum = 12.02 }, armor = { criticalDamagePercent = 7.00 }, legs = { criticalChancePercent = 5.00 }, boots = { xpPercent = 10 } } } },

	-- Upgrade Onslaught Gems (41704-41713)

	[60348] = { name = "onslaught gem tier 1", allowedRows = { "helmet", "armor", "legs", "boots" }, bonuses = { rows = { helmet = { onslaught = 0.25 }, armor = { lifeLeechPercent = 0.70 }, legs = { lifeLeechPercent = 0.70 }, boots = { healthPercent = 1 } } } },
	[60349] = { name = "onslaught gem tier 2", allowedRows = { "helmet", "armor", "legs", "boots" }, bonuses = { rows = { helmet = { onslaught = 0.52 }, armor = { lifeLeechPercent = 1.40 }, legs = { lifeLeechPercent = 1.40 }, boots = { healthPercent = 2 } } } },
	[60350] = { name = "onslaught gem tier 3", allowedRows = { "helmet", "armor", "legs", "boots" }, bonuses = { rows = { helmet = { onslaught = 0.85 }, armor = { lifeLeechPercent = 2.10 }, legs = { lifeLeechPercent = 2.10 }, boots = { healthPercent = 3 } } } },
	[60351] = { name = "onslaught gem tier 4", allowedRows = { "helmet", "armor", "legs", "boots" }, bonuses = { rows = { helmet = { onslaught = 1.22 }, armor = { lifeLeechPercent = 2.80 }, legs = { lifeLeechPercent = 2.80 }, boots = { healthPercent = 4 } } } },
	[60352] = { name = "onslaught gem tier 5", allowedRows = { "helmet", "armor", "legs", "boots" }, bonuses = { rows = { helmet = { onslaught = 1.65 }, armor = { lifeLeechPercent = 3.50 }, legs = { lifeLeechPercent = 3.50 }, boots = { healthPercent = 5 } } } },
	[60353] = { name = "onslaught gem tier 6", allowedRows = { "helmet", "armor", "legs", "boots" }, bonuses = { rows = { helmet = { onslaught = 2.12 }, armor = { lifeLeechPercent = 4.20 }, legs = { lifeLeechPercent = 4.20 }, boots = { healthPercent = 6 } } } },
	[60354] = { name = "onslaught gem tier 7", allowedRows = { "helmet", "armor", "legs", "boots" }, bonuses = { rows = { helmet = { onslaught = 2.65 }, armor = { lifeLeechPercent = 4.90 }, legs = { lifeLeechPercent = 4.90 }, boots = { healthPercent = 7 } } } },
	[60355] = { name = "onslaught gem tier 8", allowedRows = { "helmet", "armor", "legs", "boots" }, bonuses = { rows = { helmet = { onslaught = 3.22 }, armor = { lifeLeechPercent = 5.60 }, legs = { lifeLeechPercent = 5.60 }, boots = { healthPercent = 8 } } } },
	[60356] = { name = "onslaught gem tier 9", allowedRows = { "helmet", "armor", "legs", "boots" }, bonuses = { rows = { helmet = { onslaught = 3.85 }, armor = { lifeLeechPercent = 6.30 }, legs = { lifeLeechPercent = 6.30 }, boots = { healthPercent = 9 } } } },
	[60357] = { name = "onslaught gem tier 10", allowedRows = { "helmet", "armor", "legs", "boots" }, bonuses = { rows = { helmet = { onslaught = 4.52 }, armor = { lifeLeechPercent = 7.00 }, legs = { lifeLeechPercent = 7.00 }, boots = { healthPercent = 10 } } } },

	-- Upgrade Transcendence Gems (41714-41723)

	[60358] = { name = "transcendence gem tier 1", allowedRows = { "helmet", "armor", "legs", "boots" }, bonuses = { rows = { helmet = { transcendence = 0.06 }, armor = { manaLeechPercent = 0.35 }, legs = { manaLeechPercent = 0.35 }, boots = { manaPercent = 1 } } } },
	[60359] = { name = "transcendence gem tier 2", allowedRows = { "helmet", "armor", "legs", "boots" }, bonuses = { rows = { helmet = { transcendence = 0.13 }, armor = { manaLeechPercent = 0.70 }, legs = { manaLeechPercent = 0.70 }, boots = { manaPercent = 2 } } } },
	[60360] = { name = "transcendence gem tier 3", allowedRows = { "helmet", "armor", "legs", "boots" }, bonuses = { rows = { helmet = { transcendence = 0.22 }, armor = { manaLeechPercent = 1.05 }, legs = { manaLeechPercent = 1.05 }, boots = { manaPercent = 3 } } } },
	[60361] = { name = "transcendence gem tier 4", allowedRows = { "helmet", "armor", "legs", "boots" }, bonuses = { rows = { helmet = { transcendence = 0.32 }, armor = { manaLeechPercent = 1.40 }, legs = { manaLeechPercent = 1.40 }, boots = { manaPercent = 4 } } } },
	[60362] = { name = "transcendence gem tier 5", allowedRows = { "helmet", "armor", "legs", "boots" }, bonuses = { rows = { helmet = { transcendence = 0.43 }, armor = { manaLeechPercent = 1.75 }, legs = { manaLeechPercent = 1.75 }, boots = { manaPercent = 5 } } } },
	[60363] = { name = "transcendence gem tier 6", allowedRows = { "helmet", "armor", "legs", "boots" }, bonuses = { rows = { helmet = { transcendence = 0.55 }, armor = { manaLeechPercent = 2.10 }, legs = { manaLeechPercent = 2.10 }, boots = { manaPercent = 6 } } } },
	[60364] = { name = "transcendence gem tier 7", allowedRows = { "helmet", "armor", "legs", "boots" }, bonuses = { rows = { helmet = { transcendence = 0.69 }, armor = { manaLeechPercent = 2.45 }, legs = { manaLeechPercent = 2.45 }, boots = { manaPercent = 7 } } } },
	[60365] = { name = "transcendence gem tier 8", allowedRows = { "helmet", "armor", "legs", "boots" }, bonuses = { rows = { helmet = { transcendence = 0.84 }, armor = { manaLeechPercent = 2.80 }, legs = { manaLeechPercent = 2.80 }, boots = { manaPercent = 8 } } } },
	[60366] = { name = "transcendence gem tier 9", allowedRows = { "helmet", "armor", "legs", "boots" }, bonuses = { rows = { helmet = { transcendence = 1.00 }, armor = { manaLeechPercent = 3.15 }, legs = { manaLeechPercent = 3.15 }, boots = { manaPercent = 9 } } } },
	[60367] = { name = "transcendence gem tier 10", allowedRows = { "helmet", "armor", "legs", "boots" }, bonuses = { rows = { helmet = { transcendence = 1.17 }, armor = { manaLeechPercent = 3.50 }, legs = { manaLeechPercent = 3.50 }, boots = { manaPercent = 10 } } } },

	-- Upgrade Ruse Gems (41724-41733)

	-- Skill Bonus: Knights = club/sword/axe, Paladin = distance, Sorcerer/Druid = magic level
	[60368] = { name = "ruse gem tier 1", allowedRows = { "helmet", "armor", "legs", "boots" }, bonuses = { rows = { helmet = { ruse = 0.25 }, armor = { lootPercent = 1.25 }, legs = { skillBonus = 1 }, boots = { amplificationPercent = 1.25 } } } },
	[60369] = { name = "ruse gem tier 2", allowedRows = { "helmet", "armor", "legs", "boots" }, bonuses = { rows = { helmet = { ruse = 0.51 }, armor = { lootPercent = 2.50 }, legs = { skillBonus = 2 }, boots = { amplificationPercent = 2.70 } } } },
	[60370] = { name = "ruse gem tier 3", allowedRows = { "helmet", "armor", "legs", "boots" }, bonuses = { rows = { helmet = { ruse = 0.81 }, armor = { lootPercent = 3.75 }, legs = { skillBonus = 3 }, boots = { amplificationPercent = 4.55 } } } },
	[60371] = { name = "ruse gem tier 4", allowedRows = { "helmet", "armor", "legs", "boots" }, bonuses = { rows = { helmet = { ruse = 1.14 }, armor = { lootPercent = 5.00 }, legs = { skillBonus = 4 }, boots = { amplificationPercent = 6.80 } } } },
	[60372] = { name = "ruse gem tier 5", allowedRows = { "helmet", "armor", "legs", "boots" }, bonuses = { rows = { helmet = { ruse = 1.50 }, armor = { lootPercent = 6.25 }, legs = { skillBonus = 5 }, boots = { amplificationPercent = 9.45 } } } },
	[60373] = { name = "ruse gem tier 6", allowedRows = { "helmet", "armor", "legs", "boots" }, bonuses = { rows = { helmet = { ruse = 1.89 }, armor = { lootPercent = 7.50 }, legs = { skillBonus = 6 }, boots = { amplificationPercent = 12.50 } } } },
	[60374] = { name = "ruse gem tier 7", allowedRows = { "helmet", "armor", "legs", "boots" }, bonuses = { rows = { helmet = { ruse = 2.31 }, armor = { lootPercent = 8.75 }, legs = { skillBonus = 7 }, boots = { amplificationPercent = 15.95 } } } },
	[60375] = { name = "ruse gem tier 8", allowedRows = { "helmet", "armor", "legs", "boots" }, bonuses = { rows = { helmet = { ruse = 2.76 }, armor = { lootPercent = 10.00 }, legs = { skillBonus = 8 }, boots = { amplificationPercent = 19.80 } } } },
	[60376] = { name = "ruse gem tier 9", allowedRows = { "helmet", "armor", "legs", "boots" }, bonuses = { rows = { helmet = { ruse = 3.24 }, armor = { lootPercent = 11.25 }, legs = { skillBonus = 9 }, boots = { amplificationPercent = 24.05 } } } },
	[60377] = { name = "ruse gem tier 10", allowedRows = { "helmet", "armor", "legs", "boots" }, bonuses = { rows = { helmet = { ruse = 3.75 }, armor = { lootPercent = 12.50 }, legs = { skillBonus = 10 }, boots = { amplificationPercent = 28.70 } } } },

	-- Death Gems (61004-61013)
	[60167] = { name = "death gem tier 1", allowedRows = { "weapon", "shield" }, bonuses = { rows = { weapon = { attackPercent = 1 }, shield = { defensePercent = 1 } } } },
	[60168] = { name = "death gem tier 2", allowedRows = { "weapon", "shield" }, bonuses = { rows = { weapon = { attackPercent = 2 }, shield = { defensePercent = 2 } } } },
	[60169] = { name = "death gem tier 3", allowedRows = { "weapon", "shield" }, bonuses = { rows = { weapon = { attackPercent = 3 }, shield = { defensePercent = 3 } } } },
	[60170] = { name = "death gem tier 4", allowedRows = { "weapon", "shield" }, bonuses = { rows = { weapon = { attackPercent = 4 }, shield = { defensePercent = 4 } } } },
	[60171] = { name = "death gem tier 5", allowedRows = { "weapon", "shield" }, bonuses = { rows = { weapon = { attackPercent = 5 }, shield = { defensePercent = 5 } } } },
	[60172] = { name = "death gem tier 6", allowedRows = { "weapon", "shield" }, bonuses = { rows = { weapon = { attackPercent = 6 }, shield = { defensePercent = 6 } } } },
	[60173] = { name = "death gem tier 7", allowedRows = { "weapon", "shield" }, bonuses = { rows = { weapon = { attackPercent = 7 }, shield = { defensePercent = 7 } } } },
	[60174] = { name = "death gem tier 8", allowedRows = { "weapon", "shield" }, bonuses = { rows = { weapon = { attackPercent = 8 }, shield = { defensePercent = 8 } } } },
	[60175] = { name = "death gem tier 9", allowedRows = { "weapon", "shield" }, bonuses = { rows = { weapon = { attackPercent = 9 }, shield = { defensePercent = 9 } } } },
	[60176] = { name = "death gem tier 10", allowedRows = { "weapon", "shield" }, bonuses = { rows = { weapon = { attackPercent = 10 }, shield = { defensePercent = 10 } } } },

	-- Energy Gems (61014-61023)
	[60177] = { name = "energy gem tier 1", allowedRows = { "weapon", "shield" }, bonuses = { rows = { weapon = { attackPercent = 1 }, shield = { defensePercent = 1 } } } },
	[60178] = { name = "energy gem tier 2", allowedRows = { "weapon", "shield" }, bonuses = { rows = { weapon = { attackPercent = 2 }, shield = { defensePercent = 2 } } } },
	[60179] = { name = "energy gem tier 3", allowedRows = { "weapon", "shield" }, bonuses = { rows = { weapon = { attackPercent = 3 }, shield = { defensePercent = 3 } } } },
	[60180] = { name = "energy gem tier 4", allowedRows = { "weapon", "shield" }, bonuses = { rows = { weapon = { attackPercent = 4 }, shield = { defensePercent = 4 } } } },
	[60181] = { name = "energy gem tier 5", allowedRows = { "weapon", "shield" }, bonuses = { rows = { weapon = { attackPercent = 5 }, shield = { defensePercent = 5 } } } },
	[60182] = { name = "energy gem tier 6", allowedRows = { "weapon", "shield" }, bonuses = { rows = { weapon = { attackPercent = 6 }, shield = { defensePercent = 6 } } } },
	[60183] = { name = "energy gem tier 7", allowedRows = { "weapon", "shield" }, bonuses = { rows = { weapon = { attackPercent = 7 }, shield = { defensePercent = 7 } } } },
	[60184] = { name = "energy gem tier 8", allowedRows = { "weapon", "shield" }, bonuses = { rows = { weapon = { attackPercent = 8 }, shield = { defensePercent = 8 } } } },
	[60185] = { name = "energy gem tier 9", allowedRows = { "weapon", "shield" }, bonuses = { rows = { weapon = { attackPercent = 9 }, shield = { defensePercent = 9 } } } },
	[60186] = { name = "energy gem tier 10", allowedRows = { "weapon", "shield" }, bonuses = { rows = { weapon = { attackPercent = 10 }, shield = { defensePercent = 10 } } } },

	-- Fire Gems (61024-61033)
	[60187] = { name = "fire gem tier 1", allowedRows = { "weapon", "shield" }, bonuses = { rows = { weapon = { attackPercent = 1 }, shield = { defensePercent = 1 } } } },
	[60188] = { name = "fire gem tier 2", allowedRows = { "weapon", "shield" }, bonuses = { rows = { weapon = { attackPercent = 2 }, shield = { defensePercent = 2 } } } },
	[60189] = { name = "fire gem tier 3", allowedRows = { "weapon", "shield" }, bonuses = { rows = { weapon = { attackPercent = 3 }, shield = { defensePercent = 3 } } } },
	[60190] = { name = "fire gem tier 4", allowedRows = { "weapon", "shield" }, bonuses = { rows = { weapon = { attackPercent = 4 }, shield = { defensePercent = 4 } } } },
	[60191] = { name = "fire gem tier 5", allowedRows = { "weapon", "shield" }, bonuses = { rows = { weapon = { attackPercent = 5 }, shield = { defensePercent = 5 } } } },
	[60192] = { name = "fire gem tier 6", allowedRows = { "weapon", "shield" }, bonuses = { rows = { weapon = { attackPercent = 6 }, shield = { defensePercent = 6 } } } },
	[60193] = { name = "fire gem tier 7", allowedRows = { "weapon", "shield" }, bonuses = { rows = { weapon = { attackPercent = 7 }, shield = { defensePercent = 7 } } } },
	[60194] = { name = "fire gem tier 8", allowedRows = { "weapon", "shield" }, bonuses = { rows = { weapon = { attackPercent = 8 }, shield = { defensePercent = 8 } } } },
	[60195] = { name = "fire gem tier 9", allowedRows = { "weapon", "shield" }, bonuses = { rows = { weapon = { attackPercent = 9 }, shield = { defensePercent = 9 } } } },
	[60196] = { name = "fire gem tier 10", allowedRows = { "weapon", "shield" }, bonuses = { rows = { weapon = { attackPercent = 10 }, shield = { defensePercent = 10 } } } },

	-- Holy Gems (61034-61043)
	[60197] = { name = "holy gem tier 1", allowedRows = { "weapon", "shield" }, bonuses = { rows = { weapon = { attackPercent = 1 }, shield = { defensePercent = 1 } } } },
	[60198] = { name = "holy gem tier 2", allowedRows = { "weapon", "shield" }, bonuses = { rows = { weapon = { attackPercent = 2 }, shield = { defensePercent = 2 } } } },
	[60199] = { name = "holy gem tier 3", allowedRows = { "weapon", "shield" }, bonuses = { rows = { weapon = { attackPercent = 3 }, shield = { defensePercent = 3 } } } },
	[60200] = { name = "holy gem tier 4", allowedRows = { "weapon", "shield" }, bonuses = { rows = { weapon = { attackPercent = 4 }, shield = { defensePercent = 4 } } } },
	[60201] = { name = "holy gem tier 5", allowedRows = { "weapon", "shield" }, bonuses = { rows = { weapon = { attackPercent = 5 }, shield = { defensePercent = 5 } } } },
	[60202] = { name = "holy gem tier 6", allowedRows = { "weapon", "shield" }, bonuses = { rows = { weapon = { attackPercent = 6 }, shield = { defensePercent = 6 } } } },
	[60203] = { name = "holy gem tier 7", allowedRows = { "weapon", "shield" }, bonuses = { rows = { weapon = { attackPercent = 7 }, shield = { defensePercent = 7 } } } },
	[60204] = { name = "holy gem tier 8", allowedRows = { "weapon", "shield" }, bonuses = { rows = { weapon = { attackPercent = 8 }, shield = { defensePercent = 8 } } } },
	[60205] = { name = "holy gem tier 9", allowedRows = { "weapon", "shield" }, bonuses = { rows = { weapon = { attackPercent = 9 }, shield = { defensePercent = 9 } } } },
	[60206] = { name = "holy gem tier 10", allowedRows = { "weapon", "shield" }, bonuses = { rows = { weapon = { attackPercent = 10 }, shield = { defensePercent = 10 } } } },

	-- Ice Gems (61044-61053)
	[60207] = { name = "ice gem tier 1", allowedRows = { "weapon", "shield" }, bonuses = { rows = { weapon = { attackPercent = 1 }, shield = { defensePercent = 1 } } } },
	[60208] = { name = "ice gem tier 2", allowedRows = { "weapon", "shield" }, bonuses = { rows = { weapon = { attackPercent = 2 }, shield = { defensePercent = 2 } } } },
	[60209] = { name = "ice gem tier 3", allowedRows = { "weapon", "shield" }, bonuses = { rows = { weapon = { attackPercent = 3 }, shield = { defensePercent = 3 } } } },
	[60210] = { name = "ice gem tier 4", allowedRows = { "weapon", "shield" }, bonuses = { rows = { weapon = { attackPercent = 4 }, shield = { defensePercent = 4 } } } },
	[60211] = { name = "ice gem tier 5", allowedRows = { "weapon", "shield" }, bonuses = { rows = { weapon = { attackPercent = 5 }, shield = { defensePercent = 5 } } } },
	[60212] = { name = "ice gem tier 6", allowedRows = { "weapon", "shield" }, bonuses = { rows = { weapon = { attackPercent = 6 }, shield = { defensePercent = 6 } } } },
	[60213] = { name = "ice gem tier 7", allowedRows = { "weapon", "shield" }, bonuses = { rows = { weapon = { attackPercent = 7 }, shield = { defensePercent = 7 } } } },
	[60214] = { name = "ice gem tier 8", allowedRows = { "weapon", "shield" }, bonuses = { rows = { weapon = { attackPercent = 8 }, shield = { defensePercent = 8 } } } },
	[60215] = { name = "ice gem tier 9", allowedRows = { "weapon", "shield" }, bonuses = { rows = { weapon = { attackPercent = 9 }, shield = { defensePercent = 9 } } } },
	[60216] = { name = "ice gem tier 10", allowedRows = { "weapon", "shield" }, bonuses = { rows = { weapon = { attackPercent = 10 }, shield = { defensePercent = 10 } } } },

	-- Physical Gems (61054-61063)
	[60217] = { name = "physical gem tier 1", allowedRows = { "weapon", "shield" }, bonuses = { rows = { weapon = { attackPercent = 1 }, shield = { defensePercent = 1 } } } },
	[60218] = { name = "physical gem tier 2", allowedRows = { "weapon", "shield" }, bonuses = { rows = { weapon = { attackPercent = 2 }, shield = { defensePercent = 2 } } } },
	[60219] = { name = "physical gem tier 3", allowedRows = { "weapon", "shield" }, bonuses = { rows = { weapon = { attackPercent = 3 }, shield = { defensePercent = 3 } } } },
	[60220] = { name = "physical gem tier 4", allowedRows = { "weapon", "shield" }, bonuses = { rows = { weapon = { attackPercent = 4 }, shield = { defensePercent = 4 } } } },
	[60221] = { name = "physical gem tier 5", allowedRows = { "weapon", "shield" }, bonuses = { rows = { weapon = { attackPercent = 5 }, shield = { defensePercent = 5 } } } },
	[60222] = { name = "physical gem tier 6", allowedRows = { "weapon", "shield" }, bonuses = { rows = { weapon = { attackPercent = 6 }, shield = { defensePercent = 6 } } } },
	[60223] = { name = "physical gem tier 7", allowedRows = { "weapon", "shield" }, bonuses = { rows = { weapon = { attackPercent = 7 }, shield = { defensePercent = 7 } } } },
	[60224] = { name = "physical gem tier 8", allowedRows = { "weapon", "shield" }, bonuses = { rows = { weapon = { attackPercent = 8 }, shield = { defensePercent = 8 } } } },
	[60225] = { name = "physical gem tier 9", allowedRows = { "weapon", "shield" }, bonuses = { rows = { weapon = { attackPercent = 9 }, shield = { defensePercent = 9 } } } },
	[60226] = { name = "physical gem tier 10", allowedRows = { "weapon", "shield" }, bonuses = { rows = { weapon = { attackPercent = 10 }, shield = { defensePercent = 10 } } } },

	-- Earth Gems (61064-61073)
	[60227] = { name = "earth gem tier 1", allowedRows = { "weapon", "shield" }, bonuses = { rows = { weapon = { attackPercent = 1 }, shield = { defensePercent = 1 } } } },
	[60228] = { name = "earth gem tier 2", allowedRows = { "weapon", "shield" }, bonuses = { rows = { weapon = { attackPercent = 2 }, shield = { defensePercent = 2 } } } },
	[60229] = { name = "earth gem tier 3", allowedRows = { "weapon", "shield" }, bonuses = { rows = { weapon = { attackPercent = 3 }, shield = { defensePercent = 3 } } } },
	[60230] = { name = "earth gem tier 4", allowedRows = { "weapon", "shield" }, bonuses = { rows = { weapon = { attackPercent = 4 }, shield = { defensePercent = 4 } } } },
	[60231] = { name = "earth gem tier 5", allowedRows = { "weapon", "shield" }, bonuses = { rows = { weapon = { attackPercent = 5 }, shield = { defensePercent = 5 } } } },
	[60232] = { name = "earth gem tier 6", allowedRows = { "weapon", "shield" }, bonuses = { rows = { weapon = { attackPercent = 6 }, shield = { defensePercent = 6 } } } },
	[60233] = { name = "earth gem tier 7", allowedRows = { "weapon", "shield" }, bonuses = { rows = { weapon = { attackPercent = 7 }, shield = { defensePercent = 7 } } } },
	[60234] = { name = "earth gem tier 8", allowedRows = { "weapon", "shield" }, bonuses = { rows = { weapon = { attackPercent = 8 }, shield = { defensePercent = 8 } } } },
	[60235] = { name = "earth gem tier 9", allowedRows = { "weapon", "shield" }, bonuses = { rows = { weapon = { attackPercent = 9 }, shield = { defensePercent = 9 } } } },
	[60166] = { name = "earth gem tier 10", allowedRows = { "weapon", "shield" }, bonuses = { rows = { weapon = { attackPercent = 10 }, shield = { defensePercent = 10 } } } },
}

for _, definition in pairs(GemBag.gemDefinitions) do
	if definition and not definition.element then
		local elementName = definition.name and definition.name:match("^([%a]+)")
		if elementName then
			definition.element = elementName:lower()
			definition.elementLabel = elementName:sub(1, 1):upper() .. elementName:sub(2)
		end
	end
end

local function collectElementalBonuses(bonuses, rowName, statKey)
	local result = {}
	local total = 0

	if not bonuses or not bonuses.rows then
		return result, total
	end

	local rowData = bonuses.rows[rowName]
	if not rowData then
		return result, total
	end

	if rowData.elements and next(rowData.elements) then
		if rowData.elementTotal then
			return rowData.elements, rowData.elementTotal, rowData.elementList
		end

		local list = {}
		for label, value in pairs(rowData.elements) do
			if type(value) == "number" and value ~= 0 then
				result[label] = value
				total = total + value
				list[#list+1] = { label = label, value = value }
			end
		end
		if next(result) then
			table.sort(list, function(a, b) return a.label < b.label end)
			rowData.elementTotal = total
			rowData.elementList = list
			return rowData.elements, total, list
		end
	end

	if not rowData.gems then
		return result, total
	end

	for _, gemId in ipairs(rowData.gems) do
		local definition = GemBag.gemDefinitions[gemId]
		local rowBonuses = definition and definition.bonuses and definition.bonuses.rows and definition.bonuses.rows[rowName]
		local value = rowBonuses and rowBonuses[statKey]
		if value and value ~= 0 then
			local label = (definition and definition.elementLabel) or "Gem"
			result[label] = (result[label] or 0) + value
			total = total + value
		end
	end

	return result, total
end

GemBag.collectElementalBonuses = collectElementalBonuses

local function isPlayerGemBagSlot(player, position)
	if not player or not position or position.x ~= CONTAINER_POSITION then
		return false
	end

	if not player.getContainerById then
		return false
	end

	local container = player:getContainerById(position.y)
	if not container then
		return false
	end

	-- Check if getContainerItem method exists (may not be available in all container types)
	if container.getContainerItem then
		local parentItem = container:getContainerItem()
		if parentItem and GemBag.isGemBagItem(parentItem) then
			return true
		end
	end

	return false
end

local function sendCyclopediaUpdates(player)
	if not player then
		return
	end

	local ok, _ = pcall(function()
		if player.sendCyclopediaCharacterGeneralStats then
			player:sendCyclopediaCharacterGeneralStats()
		end
		if player.sendCyclopediaCharacterOffenceStats then
			player:sendCyclopediaCharacterOffenceStats()
		end
		if player.sendCyclopediaCharacterDefenceStats then
			player:sendCyclopediaCharacterDefenceStats()
		end
		if player.sendCyclopediaCharacterMiscStats then
			player:sendCyclopediaCharacterMiscStats()
		end
		if player.sendCyclopediaCharacterCombatStats then
			player:sendCyclopediaCharacterCombatStats()
		end
	end)

	return ok
end

local function scheduleApplyBonuses(player)
	if not player then
		return
	end
	local playerId = player:getId()
	if not playerId then
		return
	end
	addEvent(function(targetId)
		local target = Player(targetId)
		if not target then
			return
		end
		GemBag.invalidateCache(target)
		GemBag.applyStatBonuses(target)
	end, 0, playerId)
end

---@param definition table|nil
---@param rowName string
---@return boolean
local function definitionAllowsRow(definition, rowName)
	if not definition then
		return false
	end
	local allowed = definition.allowedRows
	if not allowed or #allowed == 0 then
		return true
	end
	for _, value in ipairs(allowed) do
		if value == rowName then
			return true
		end
	end
	return false
end

---@param item Item
---@return boolean
function GemBag.isGemCompatibleWithEquip(item, equip)
	local def = GemBag.gemDefinitions[item:getId()]
	return definitionAllowsRow(def, equip)
end

---@param row integer
---@param vocationId integer
---@return integer
local function getIndicatorItemId(row, vocationId)
	local equipType = GemBag.config.EQUIP_ROWS[row]
	if not equipType then
		return 0
	end

	local indicatorConfig = GemBag.config.INDICATOR_ITEMIDS[equipType]
	if type(indicatorConfig) == "table" then
		return indicatorConfig[vocationId] or indicatorConfig[1] -- fallback to Sorcerer
	else
		return indicatorConfig
	end
end

local function markIndicator(indicator, row)
	if not indicator then
		return
	end
	indicator:setActionId(GemBag.config.AID_INDICATOR_BASE + row)
	local equip = GemBag.config.EQUIP_ROWS[row] or "equip"
	indicator:setAttribute(ITEM_ATTRIBUTE_DESCRIPTION, string.format("%s row indicator (fixo).", equip))
end

local function markLock(lockItem)
	if not lockItem then
		return
	end
	lockItem:setAttribute(ITEM_ATTRIBUTE_DESCRIPTION, "Slot bloqueado. Compre o Gem Extender para desbloquear.")
end

---@param container Container
---@return Player|nil
local function getContainerOwner(container)
	if not container or not container.getContainerItem then
		return nil
	end
	local item = container:getContainerItem()
	if not item then
		return nil
	end
	local owner = item:getTopParent()
	if owner and owner:isPlayer() then
		return owner
	end
	return nil
end

---@param container Container
---@param index integer
---@param reason? string
local function ejectItem(container, index, reason)
	local item = container:getItem(index)
	if not item then
		return
	end
	local owner = getContainerOwner(container)
	if owner then
		local inbox = owner:getInbox()
		if inbox and item:moveTo(inbox) then
			if reason then
				owner:sendTextMessage(MESSAGE_EVENT_ADVANCE, reason)
			end
			return
		end
		item:moveTo(owner:getPosition())
		owner:sendTextMessage(MESSAGE_EVENT_ADVANCE, reason or GemBag.config.MESSAGES.SCHEMA_PURGED)
	else
		item:remove()
	end
end

---Updates only the lock items when extender status changes
---@param container Container
---@param hasExt boolean
---@param player Player|nil
local function updateExtenderColumn(container, hasExt, player)
	if not container or not container.getItem then
		return
	end

	local containerSize = container:getSize()

	if hasExt then
		-- Grant extender: transform all locks to placeholders
		for i = 0, containerSize - 1 do
			local item = container:getItem(i)
			if item and GemBag.isLock(item) then
				item:transform(GemBag.config.PLACEHOLDER_SLOT_ID)
				item:setActionId(0)
			end
		end
	else
		-- Revoke extender: eject gems from column 4 and add locks back
		for row = 1, GemBag.config.ROW_COUNT do
			local lockColIndex = GemBag.colToIndex(row, GemBag.constants.LOCK_COLUMN)
			local lockItem = container:getItem(lockColIndex)
			-- If there's a gem in the lock column, eject it
			if lockItem and GemBag.isGem(lockItem) then
				ejectItem(container, lockColIndex, "Gem movida para inbox pois o Gem Extender foi removido.")
				lockItem = nil
			end

			-- Transform placeholder to lock or create new lock
			lockItem = container:getItem(lockColIndex)
			if lockItem and GemBag.isPlaceholder(lockItem) then
				lockItem:transform(GemBag.config.LOCK_ITEMID)
				lockItem = container:getItem(lockColIndex)
				if lockItem then
					markLock(lockItem)
				end
			elseif not lockItem then
				local createdLock = Game.createItem(GemBag.config.LOCK_ITEMID, 1)
				if createdLock then
					markLock(createdLock)
					container:addItemEx(createdLock, lockColIndex, FLAG_NOLIMIT)
				end
			end
		end
	end
end

---@param container Container
---@param hasExt boolean
---@param opts? table
function GemBag.ensureGemBagScaffold(container, hasExt, opts)
	if not container or not container.getItem then
		return
	end
	opts = opts or {}
	local owner = opts.player or getContainerOwner(container)
	local movedInvalid = false

	-- Get vocation ID for indicator selection
	local vocationId = owner and owner:getVocation():getId() or 1 -- default to Sorcerer

	for row = 1, GemBag.config.ROW_COUNT do
		local col4Index = GemBag.colToIndex(row, 1)
		local col4Item = container:getItem(col4Index)

		if hasExt then
			-- Should have placeholder or gem, not lock
			if col4Item and GemBag.isLock(col4Item) then
				col4Item:remove()
				col4Item = nil
			end

			if not col4Item then
				local placeholder = Game.createItem(GemBag.config.PLACEHOLDER_SLOT_ID, 1)
				if placeholder then
					container:addItemEx(placeholder, col4Index, FLAG_NOLIMIT)
				end
			elseif not GemBag.isPlaceholder(col4Item) and not GemBag.isGem(col4Item) then
				ejectItem(container, col4Index, GemBag.config.MESSAGES.SCHEMA_PURGED)
				movedInvalid = true
				local placeholder = Game.createItem(GemBag.config.PLACEHOLDER_SLOT_ID, 1)
				if placeholder then
					container:addItemEx(placeholder, col4Index, FLAG_NOLIMIT)
				end
			end
		else
			-- Should have lock
			if col4Item then
				if not GemBag.isLock(col4Item) then
					ejectItem(container, col4Index, GemBag.config.MESSAGES.SCHEMA_PURGED)
					movedInvalid = true
					col4Item = nil
				else
					markLock(col4Item)
				end
			end
			if not col4Item then
				local createdLock = Game.createItem(GemBag.config.LOCK_ITEMID, 1)
				if createdLock then
					markLock(createdLock)
					local ret = container:addItemEx(createdLock, col4Index, FLAG_NOLIMIT)
					if ret ~= RETURNVALUE_NOERROR then
						createdLock:remove()
					end
				end
			end
		end

		-- Columns 2-3: Free gem slots (placeholders) - Always available
		for col = 2, 3 do
			local slotIndex = GemBag.colToIndex(row, col)
			local slotItem = container:getItem(slotIndex)

			-- If slot is empty, add placeholder
			if not slotItem then
				local placeholder = Game.createItem(GemBag.config.PLACEHOLDER_SLOT_ID, 1)
				if placeholder then
					container:addItemEx(placeholder, slotIndex, FLAG_NOLIMIT)
				end
				-- If slot has placeholder, keep it; if slot has gem, keep it; otherwise it's invalid
			elseif not GemBag.isPlaceholder(slotItem) and not GemBag.isGem(slotItem) then
				ejectItem(container, slotIndex, GemBag.config.MESSAGES.SCHEMA_PURGED)
				movedInvalid = true
				-- Add placeholder after ejecting
				local placeholder = Game.createItem(GemBag.config.PLACEHOLDER_SLOT_ID, 1)
				if placeholder then
					container:addItemEx(placeholder, slotIndex, FLAG_NOLIMIT)
				end
			end
		end

		-- Column 1: Indicator (based on vocation) - FIXED, cannot be moved
		local indicatorIndex = GemBag.colToIndex(row, 4)
		local indicator = container:getItem(indicatorIndex)
		local expectedIndicatorId = getIndicatorItemId(row, vocationId)

		if indicator then
			if indicator:getId() ~= expectedIndicatorId then
				ejectItem(container, indicatorIndex, GemBag.config.MESSAGES.SCHEMA_PURGED)
				movedInvalid = true
				indicator = nil
			else
				markIndicator(indicator, row)
			end
		end
		if not indicator then
			local created = Game.createItem(expectedIndicatorId, 1)
			if created then
				markIndicator(created, row)
				local ret = container:addItemEx(created, indicatorIndex, FLAG_NOLIMIT)
				if ret ~= RETURNVALUE_NOERROR then
					created:remove()
				end
			end
		end
	end

	if movedInvalid and owner and not opts.silent then
		owner:sendTextMessage(MESSAGE_EVENT_ADVANCE, GemBag.config.MESSAGES.SCHEMA_REPAIRED)
	end
end

local function applyBonusRow(target, source)
	if not source then
		return
	end

	for key, value in pairs(source) do
		if type(value) == "number" then
			target[key] = (target[key] or 0) + value
		end
	end
end

---@param player Player
---@param container Container
---@return table
function GemBag.computeGemBagBonuses(player, container)
	local bonuses = {
		rows = {},
		totals = {
			xpPercent = 0,
			lootPercent = 0,
			attackPercent = 0,
			distancePercent = 0,
			defensePercent = 0,
			magicDamagePercent = 0,
			supportDamagePercent = 0,
			healingPercent = 0,
			manaPercent = 0,
			custom = {},
		},
	}

	if not container then
		return bonuses
	end

	local hasExt = GemBag.playerHasExtender(player)
	for containerRowIndex = 1, GemBag.config.ROW_COUNT do
		-- Get visual equipment type (client renders container inverted)
		local visualEquip = GemBag.getVisualEquipForContainerRow(containerRowIndex)

		local rowData = {
			gems = {},
			count = 0,
			stats = {},
			elements = {},
		}
		bonuses.rows[visualEquip] = rowData

		local maxCol = hasExt and GemBag.config.COLUMN_COUNT or GemBag.config.DEFAULT_UNLOCKED_COLUMNS
		for col = GemBag.constants.FIRST_GEM_COLUMN, maxCol do
			local slotIndex = GemBag.colToIndex(containerRowIndex, col)
			local gemItem = container:getItem(slotIndex)
			if gemItem and GemBag.isGem(gemItem) then
				local gemId = gemItem:getId()
				local definition = GemBag.gemDefinitions[gemId]
				if definition and definitionAllowsRow(definition, visualEquip) then
					rowData.count = rowData.count + 1
					table.insert(rowData.gems, gemId)

					local rowBonuses = definition.bonuses and definition.bonuses.rows and definition.bonuses.rows[visualEquip]
					if rowBonuses then
						applyBonusRow(rowData.stats, rowBonuses)
						applyBonusRow(bonuses.totals, rowBonuses)
					end

					if definition.bonuses then
						if definition.bonuses.totals then
							applyBonusRow(bonuses.totals, definition.bonuses.totals)
						end
						if definition.bonuses.custom then
							for key, value in pairs(definition.bonuses.custom) do
								if type(value) == "number" then
									bonuses.totals.custom[key] = (bonuses.totals.custom[key] or 0) + value
								end
							end
						end
					end

					if definition.elementLabel then
						if visualEquip == "weapon" and rowBonuses and rowBonuses.attackPercent then
							rowData.elements[definition.elementLabel] = (rowData.elements[definition.elementLabel] or 0) + rowBonuses.attackPercent
						elseif visualEquip == "shield" and rowBonuses and rowBonuses.defensePercent then
							rowData.elements[definition.elementLabel] = (rowData.elements[definition.elementLabel] or 0) + rowBonuses.defensePercent
						end
					end
				end
			end
		end

		if rowData.elements and next(rowData.elements) then
			local total = 0
			local list = {}
			for label, value in pairs(rowData.elements) do
				if type(value) == "number" and value ~= 0 then
					total = total + value
					list[#list+1] = { label = label, value = value }
				end
			end
			if #list > 0 then
				table.sort(list, function(a, b) return a.label < b.label end)
				rowData.elementTotal = total
				rowData.elementList = list
			end
		end
	end

	return bonuses
end

---@param player Player
function GemBag.invalidateCache(player)
	local playerId = type(player) == "number" and player or (player and player:getId())
	if not playerId then
		return
	end
	GemBag._cache[playerId] = nil
end

---@param player Player
---@return table
function GemBag.getCachedBonuses(player)
	local playerId = player:getId()
	if not GemBag._cache[playerId] then
		local container = nil
		GemBag.scanPlayerGemBags(player, function(_, bagContainer)
			container = bagContainer
			return true
		end)
		GemBag._cache[playerId] = GemBag.computeGemBagBonuses(player, container)
	end
	return GemBag._cache[playerId]
end

---Applies stat bonuses from gems to the player using Conditions
---@param player Player
function GemBag.applyStatBonuses(player)
	if not player then
		return
	end

	if player:getCondition(CONDITION_ATTRIBUTES, CONDITIONID_COMBAT, 98) then
		player:removeCondition(CONDITION_ATTRIBUTES, CONDITIONID_COMBAT, 98)
	end

	local bonuses = GemBag.getCachedBonuses(player)
	local totals = bonuses and bonuses.totals

	local function setWheelStorage(offset, value)
		local storageId = GemBag.config.STORAGE_GEM_EXTENDER + offset
		if value and value > 0 then
			player:setStorageValue(storageId, math.floor((value * 100) + 0.5))
		else
			player:setStorageValue(storageId, -1)
		end
	end

	setWheelStorage(1, totals and totals.momentum)
	setWheelStorage(2, totals and totals.onslaught)
	setWheelStorage(3, totals and totals.transcendence)
	setWheelStorage(4, totals and totals.ruse)
	setWheelStorage(5, totals and totals.amplificationPercent)

	local function setElementStorage(storageId, percent)
		if not storageId then
			return
		end
		if percent and percent > 0 then
			player:setStorageValue(storageId, math.floor((percent * 100) + 0.5))
		else
			player:setStorageValue(storageId, -1)
		end
	end

	local function setSpecialStatStorage(storageId, percent)
		if not storageId then
			return
		end
		if percent and percent > 0 then
			player:setStorageValue(storageId, math.floor((percent * 100) + 0.5))
		else
			player:setStorageValue(storageId, -1)
		end
	end

	for _, info in pairs(GemBag.config.ELEMENTS) do
		setElementStorage(info.weaponStorage, nil)
		setElementStorage(info.shieldStorage, nil)
	end

	local weaponElements = {}
	local shieldElements = {}
	if bonuses and bonuses.rows then
		local weaponRow = bonuses.rows.weapon
		if weaponRow and weaponRow.elements then
			for label, value in pairs(weaponRow.elements) do
				if value and value ~= 0 then
					weaponElements[label] = value
				end
			end
		end

		local shieldRow = bonuses.rows.shield
		if shieldRow and shieldRow.elements then
			for label, value in pairs(shieldRow.elements) do
				if value and value ~= 0 then
					shieldElements[label] = value
				end
			end
		end
	end

	for label, value in pairs(weaponElements) do
		local info = GemBag.elementsByLabel[label]
		if info then
			setElementStorage(info.weaponStorage, value)
		end
	end

	for label, value in pairs(shieldElements) do
		local info = GemBag.elementsByLabel[label]
		if info then
			setElementStorage(info.shieldStorage, value)
		end
	end

	setSpecialStatStorage(GemBag.config.STORAGE_GEM_LIFE_LEECH_AMOUNT, totals and totals.lifeLeechPercent)
	setSpecialStatStorage(GemBag.config.STORAGE_GEM_LIFE_LEECH_CHANCE, totals and totals.lifeLeechChancePercent)
	setSpecialStatStorage(GemBag.config.STORAGE_GEM_MANA_LEECH_AMOUNT, totals and totals.manaLeechPercent)
	setSpecialStatStorage(GemBag.config.STORAGE_GEM_MANA_LEECH_CHANCE, totals and totals.manaLeechChancePercent)
	setSpecialStatStorage(GemBag.config.STORAGE_GEM_CRITICAL_CHANCE, totals and totals.criticalChancePercent)
	setSpecialStatStorage(GemBag.config.STORAGE_GEM_CRITICAL_DAMAGE, totals and totals.criticalDamagePercent)

	if not totals then
		player:sendStats()
		player:sendSkills()
		sendCyclopediaUpdates(player)
		return
	end

	local gemCondition = Condition(CONDITION_ATTRIBUTES)
	gemCondition:setParameter(CONDITION_PARAM_TICKS, -1)
	gemCondition:setParameter(CONDITION_PARAM_SUBID, 98)

	local hasAnyBonus = false
	local healthBonus = 0
	local manaBonus = 0

	local healthPercent = totals.healthPercent or 0
	if healthPercent > 0 then
		local baseHealth = player:getMaxHealth()
		healthBonus = math.floor(baseHealth * (healthPercent / 100))
		if healthBonus > 0 then
			gemCondition:setParameter(CONDITION_PARAM_STAT_MAXHITPOINTS, healthBonus)
			hasAnyBonus = true
		end
	end

	local manaPercent = totals.manaPercent or 0
	if manaPercent > 0 then
		local baseMana = player:getMaxMana()
		manaBonus = math.floor(baseMana * (manaPercent / 100))
		if manaBonus > 0 then
			gemCondition:setParameter(CONDITION_PARAM_STAT_MAXMANAPOINTS, manaBonus)
			hasAnyBonus = true
		end
	end

	local skillBonus = totals.skillBonus or 0
	if skillBonus > 0 then
		local vocation = player:getVocation()
		if vocation then
			local baseVocationId = vocation:getBaseId()
			if baseVocationId == 1 or baseVocationId == 2 then
				gemCondition:setParameter(CONDITION_PARAM_STAT_MAGICPOINTS, skillBonus)
				hasAnyBonus = true
			elseif baseVocationId == 3 then
				gemCondition:setParameter(CONDITION_PARAM_SKILL_DISTANCE, skillBonus)
				hasAnyBonus = true
			elseif baseVocationId == 4 then
				gemCondition:setParameter(CONDITION_PARAM_SKILL_MELEE, skillBonus)
				hasAnyBonus = true
			elseif baseVocationId == 5 then
				gemCondition:setParameter(CONDITION_PARAM_SKILL_FIST, skillBonus)
				hasAnyBonus = true
			end
		end
	end

	local critChance = totals.criticalChancePercent or 0
	if critChance > 0 then
		gemCondition:setParameter(CONDITION_PARAM_SKILL_CRITICAL_HIT_CHANCE, math.floor((critChance * 100) + 0.5))
		hasAnyBonus = true
	end

	local critDamage = totals.criticalDamagePercent or 0
	if critDamage > 0 then
		gemCondition:setParameter(CONDITION_PARAM_SKILL_CRITICAL_HIT_DAMAGE, math.floor((critDamage * 100) + 0.5))
		hasAnyBonus = true
	end

	local lifeLeechChance = totals.lifeLeechChancePercent or 0
	if lifeLeechChance > 0 then
		gemCondition:setParameter(CONDITION_PARAM_SKILL_LIFE_LEECH_CHANCE, math.floor((lifeLeechChance * 100) + 0.5))
		hasAnyBonus = true
	end

	local lifeLeechAmount = totals.lifeLeechPercent or 0
	if lifeLeechAmount > 0 then
		gemCondition:setParameter(CONDITION_PARAM_SKILL_LIFE_LEECH_AMOUNT, math.floor((lifeLeechAmount * 100) + 0.5))
		hasAnyBonus = true
	end

	local manaLeechChance = totals.manaLeechChancePercent or 0
	if manaLeechChance > 0 then
		gemCondition:setParameter(CONDITION_PARAM_SKILL_MANA_LEECH_CHANCE, math.floor((manaLeechChance * 100) + 0.5))
		hasAnyBonus = true
	end

	local manaLeechAmount = totals.manaLeechPercent or 0
	if manaLeechAmount > 0 then
		gemCondition:setParameter(CONDITION_PARAM_SKILL_MANA_LEECH_AMOUNT, math.floor((manaLeechAmount * 100) + 0.5))
		hasAnyBonus = true
	end

	if hasAnyBonus then
		player:addCondition(gemCondition)
	end

	player:sendStats()
	player:sendSkills()
	sendCyclopediaUpdates(player)
end

---@param player Player
---@param callback fun(bagItem: Item, bagContainer: Container): boolean|nil
function GemBag.scanPlayerGemBags(player, callback)
	local visited = {}

	local function scanItem(item)
		if not item or visited[item] then
			return false
		end
		visited[item] = true

		if GemBag.isGemBagItem(item) then
			local bagContainer = Container(item:getUniqueId())
			if bagContainer then
				if callback(item, bagContainer) then
					return true
				end
			end
		end

		if item:isContainer() then
			local innerContainer = Container(item:getUniqueId())
			if innerContainer then
				local size = innerContainer:getSize()
				if size > 0 then
					for slot = 0, size - 1 do
						local child = innerContainer:getItem(slot)
						if child and scanItem(child) then
							return true
						end
					end
				end
			end
		end
		return false
	end

	for slot = CONST_SLOT_FIRST, CONST_SLOT_LAST do
		local slotItem = player:getSlotItem(slot)
		if slotItem and scanItem(slotItem) then
			return
		end
	end

	local inbox = player:getInbox()
	if inbox then
		local size = inbox:getSize()
		if size > 0 then
			for slot = 0, size - 1 do
				local child = inbox:getItem(slot)
				if child and scanItem(child) then
					return
				end
			end
		end
	end
end

---@param player Player
---@param opts? table
function GemBag.ensurePlayerBags(player, opts)
	opts = opts or {}
	local hasExt = GemBag.playerHasExtender(player)
	GemBag.scanPlayerGemBags(player, function(_, bagContainer)
		GemBag.ensureGemBagScaffold(bagContainer, hasExt, { player = player, silent = opts.silent })
	end)
	GemBag.invalidateCache(player)
end

---@param player Player
---@return boolean
function GemBag.grantGemExtender(player)
	if not player or GemBag.playerHasExtender(player) then
		return false
	end
	player:setStorageValue(GemBag.config.STORAGE_GEM_EXTENDER, 1)

	-- Only update column 1 (locks -> placeholders), don't touch other columns
	GemBag.scanPlayerGemBags(player, function(_, bagContainer)
		updateExtenderColumn(bagContainer, true, player)
	end)

	GemBag.invalidateCache(player)
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, GemBag.config.MESSAGES.EXTENDER_GRANTED)
	return true
end

---@param player Player
---@return boolean
function GemBag.revokeGemExtender(player)
	if not player or not GemBag.playerHasExtender(player) then
		return false
	end
	player:setStorageValue(GemBag.config.STORAGE_GEM_EXTENDER, 0)

	-- Only update column 1 (placeholders/gems -> locks), don't touch other columns
	GemBag.scanPlayerGemBags(player, function(_, bagContainer)
		updateExtenderColumn(bagContainer, false, player)
	end)

	GemBag.invalidateCache(player)
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, GemBag.config.MESSAGES.EXTENDER_REVOKED)
	return true
end

local function positionToSlot(position)
	if not position or position.x ~= CONTAINER_POSITION then
		return nil
	end
	return position.y
end

---@param player Player
---@param item Item
---@param fromPosition Position
---@param toPosition Position
---@param fromCylinder Cylinder
---@param toCylinder Cylinder
---@return boolean|nil
function GemBag.onMoveItem(player, item, fromPosition, toPosition, fromCylinder, toCylinder)
	if GemBag.isFixedByAid(item) then
		player:sendCancelMessage(GemBag.config.MESSAGES.FIXED_SLOT)
		return false
	end

	-- Prevent moving placeholders anywhere (but allow removing them from bag)
	if GemBag.isPlaceholder(item) then
		local originBag = GemBag.getBagContainer(fromCylinder)
		local destinationBag = GemBag.getBagContainer(toCylinder)

		-- Allow removing placeholder from bag (origin is bag, destination is not)
		if originBag and not destinationBag then
			return nil -- Allow removal - placeholder will be auto-replaced by ensureGemBagScaffold
		end

		-- Block all other placeholder movements
		player:sendCancelMessage("Este item não pode ser movido.")
		return false
	end

	local destinationBag = GemBag.getBagContainer(toCylinder)
	if destinationBag then
		local slotIndex = positionToSlot(toPosition)
		if not slotIndex or slotIndex < 0 or slotIndex >= GemBag.constants.TOTAL_SLOTS then
			player:sendCancelMessage(GemBag.config.MESSAGES.INVALID_SLOT)
			return false
		end
		local row, col = GemBag.bagRowCol(slotIndex)

		-- Column 1: Indicator (reserved, cannot place anything)
		if col == GemBag.constants.INDICATOR_COLUMN then
			player:sendCancelMessage(GemBag.config.MESSAGES.RESERVED_INDICATOR)
			return false
		end

		-- Column 4: Locked unless player has extender
		if col == GemBag.constants.LOCK_COLUMN and not GemBag.playerHasExtender(player) then
			player:sendCancelMessage(GemBag.config.MESSAGES.REQUIRES_EXTENDER)
			return false
		end

		local slotItem = destinationBag:getItem(slotIndex)
		if slotItem and GemBag.isLock(slotItem) then
			player:sendCancelMessage(GemBag.config.MESSAGES.REQUIRES_EXTENDER)
			return false
		end

		-- Allow placing gems or placeholders (placeholders will replace themselves)
		if not GemBag.isGem(item) and not GemBag.isPlaceholder(item) then
			player:sendCancelMessage(GemBag.config.MESSAGES.ONLY_GEMS)
			return false
		end

		-- Validate gem compatibility
		if GemBag.isGem(item) then
			-- Get visual equipment type (client renders inverted)
			local visualEquip = GemBag.getVisualEquipForContainerRow(row)
			local gemId = item:getId()
			local definition = GemBag.gemDefinitions[gemId]

			local compatible = GemBag.isGemCompatibleWithEquip(item, visualEquip)

			if not compatible then
				player:sendCancelMessage(string.format(GemBag.config.MESSAGES.GEM_INCOMPATIBLE, visualEquip))
				return false
			end

			-- NOTE: Placeholder removal is now handled in the C++ source (game.cpp)
			-- The source uses replaceThing() to swap placeholder with gem, preserving the exact index
		end
	end

	local originBag = GemBag.getBagContainer(fromCylinder)
	if originBag then
		local slotIndex = positionToSlot(fromPosition)
		if slotIndex then
			local slotItem = originBag:getItem(slotIndex)
			if slotItem and GemBag.isFixedByAid(slotItem) then
				player:sendCancelMessage(GemBag.config.MESSAGES.FIXED_SLOT)
				return false
			end
		end
	end

	return nil
end

---@param player Player
---@param item Item
---@param fromPosition Position
---@param toPosition Position
---@param fromCylinder Cylinder
---@param toCylinder Cylinder
function GemBag.onItemMoved(player, item, fromPosition, toPosition, fromCylinder, toCylinder)
	-- NOTE: Placeholder creation when removing gems is now handled in the C++ source (game.cpp)
	-- The source automatically creates a placeholder at the exact same index where a gem was removed

	local touchedBag = GemBag.getBagContainer(fromCylinder) or GemBag.getBagContainer(toCylinder)

	if not touchedBag then
		if isPlayerGemBagSlot(player, fromPosition) or isPlayerGemBagSlot(player, toPosition) then
			touchedBag = true
		elseif GemBag.isGem(item) or GemBag.isPlaceholder(item) then
			touchedBag = true
		end
	end

	-- Invalidate cache if any bag was touched
	if touchedBag then
		GemBag.invalidateCache(player)
		-- Reapply stat bonuses after gem movement
		scheduleApplyBonuses(player)
	end
end

---@param player Player
function GemBag.onPlayerLogin(player)
	-- Only invalidate cache on login, do not modify bag structure
	-- The game already saves and loads items correctly
	GemBag.invalidateCache(player)
	-- Apply stat bonuses on login
	GemBag.applyStatBonuses(player)
end

---@param player Player
---@param item Item
function GemBag.onInventoryUpdate(player, item)
	if item and GemBag.isGemBagItem(item) then
		local container = Container(item:getUniqueId())
		if container then
			GemBag.ensureGemBagScaffold(container, GemBag.playerHasExtender(player), { player = player, silent = true })
		end
	end
end

---@param player Player
---@param item Item
---@return boolean|nil
function GemBag.onTradeRequest(player, item)
	if GemBag.isFixedByAid(item) then
		return false
	end
	return nil
end

---@param destination Cylinder|Player|Position|nil
---@param opts? table
---@return Item|nil
function GemBag.createGemBag(destination, opts)
	opts = opts or {}
	local bag = Game.createItem(GemBag.config.ITEMID_GEM_BAG, 1)
	if not bag then
		return nil
	end

	local container = Container(bag:getUniqueId())
	if container then
		GemBag.ensureGemBagScaffold(container, opts.hasExtender or false, { player = opts.player, silent = true })
	end

	if destination then
		if type(destination) == "userdata" and destination.isPlayer and destination:isPlayer() then
			-- Create Gem Bag in player's Store Inbox (immovable)
			local inbox = destination:getStoreInbox()
			if inbox then
				-- Add to store inbox
				local addedBag = inbox:addItem(GemBag.config.ITEMID_GEM_BAG, 1, INDEX_WHEREEVER, FLAG_NOLIMIT)
				if addedBag then
					-- Set ITEM_ATTRIBUTE_STORE to make it immovable
					addedBag:setAttribute(ITEM_ATTRIBUTE_STORE, os.time())

					-- Ensure scaffold is set up on the newly added bag
					local addedContainer = Container(addedBag:getUniqueId())
					if addedContainer then
						GemBag.ensureGemBagScaffold(addedContainer, opts.hasExtender or false, { player = destination, silent = true })
					end

					-- Remove the original bag since we created a new one in inbox
					bag:remove()
					return addedBag
				else
					bag:remove()
					return nil
				end
			else
				-- Fallback to old behavior if no store inbox
				if not destination:addItemEx(bag, true, INDEX_WHEREEVER, FLAG_NOLIMIT) then
					bag:remove()
					return nil
				end
			end
		else
			bag:moveTo(destination)
		end
	end

	return bag
end

---@param player Player
function GemBag.normalizePlayer(player)
	GemBag.ensurePlayerBags(player)
end

function GemBag.normalizeOnlinePlayers()
	for _, player in ipairs(Game.getPlayers()) do
		GemBag.normalizePlayer(player)
	end
end

return GemBag
