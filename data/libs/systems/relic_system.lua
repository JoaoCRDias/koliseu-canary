RelicSystem = {
	-- Item IDs
	UNREVEALED_RELIC = 60522,
	RELIC_REVEALER = 60521,
	RELIC_REVEAL_ENHANCEMENT = 60520,
	RELIC_ALTAR = 60538,

	-- Altar tool IDs (multiuse items inside the altar container)
	ALTAR_PARCHMENT = 60794,
	ALTAR_SACRIFICER = 60795,
	ALTAR_TRADER = 60796,
	ALTAR_UPGRADER = 60797,
	ALTAR_TOOL_IDS = { 60794, 60795, 60796, 60797 },

	-- Relic item IDs: [rarity][type] = itemId
	RELIC_IDS = {
		common = {
			defense = 60478,
			support = 60479,
			attack = 60481,
		},
		rare = {
			defense = 60485,
			support = 60486,
			attack = 60488,
		},
		legendary = {
			defense = 60492,
			support = 60493,
			attack = 60495,
		},
	},

	-- Reverse lookup: itemId -> {rarity, type}
	RELIC_ID_LOOKUP = {},

	-- (Reliquary check uses C++ ItemType:isReliquary() - no Lua table needed)

	-- Rarities
	RARITIES = { "common", "rare", "legendary" },

	-- Types
	TYPES = { "attack", "support", "defense" },

	-- Condition subId for relic bonuses
	CONDITION_SUBID = 53010,

	-- Sacrifice requirements for trade-up
	SACRIFICE_REQUIRED = {
		common = 5, -- 5 common sacrificed -> can trade-up to 1 rare
		rare = 5, -- 5 rare sacrificed -> can trade-up to 1 legendary
	},

	-- KV keys
	KV_SACRIFICE_COMMON = "relic_sacrifice_common",
	KV_SACRIFICE_RARE = "relic_sacrifice_rare",

	-- Bonus definitions per type
	-- Each bonus has: id, name, description, storageId, spellName (if spell-specific)
	BONUSES = {
		attack = {
			{ id = "executioners_throw_dmg", name = "Executioner's Throw Damage", spellName = "Executioner's Throw", storageId = 920001 },
			{ id = "fierce_berserk_dmg", name = "Fierce Berserk Damage", spellName = "Fierce Berserk", storageId = 920002 },
			{ id = "annihilation_dmg", name = "Annihilation Damage", spellName = "Annihilation", storageId = 920003 },
			{ id = "divine_grenade_dmg", name = "Divine Grenade Damage", spellName = "Divine Grenade", storageId = 920004 },
			{ id = "divine_caldera_dmg", name = "Divine Caldera Damage", spellName = "Divine Caldera", storageId = 920047 },
			{ id = "strong_ethereal_spear_dmg", name = "Strong Ethereal Spear Damage", spellName = "Strong Ethereal Spear", storageId = 920005 },
			{ id = "great_death_beam_dmg", name = "Great Death Beam Damage", spellName = "Great Death Beam", storageId = 920006 },
			{ id = "rage_of_the_skies_dmg", name = "Rage of the Skies Damage", spellName = "Rage of the Skies", storageId = 920007 },
			{ id = "hells_core_dmg", name = "Hell's Core Damage", spellName = "Hell's Core", storageId = 920008 },
			{ id = "terra_burst_dmg", name = "Terra Burst Damage", spellName = "Terra Burst", storageId = 920009 },
			{ id = "ice_burst_dmg", name = "Ice Burst Damage", spellName = "Ice Burst", storageId = 920010 },
			{ id = "eternal_winter_dmg", name = "Eternal Winter Damage", spellName = "Eternal Winter", storageId = 920011 },
			{ id = "wrath_of_nature_dmg", name = "Wrath of Nature Damage", spellName = "Wrath of Nature", storageId = 920012 },
			{ id = "crit_chance", name = "Critical Hit Chance", storageId = 920015 },
			{ id = "crit_damage", name = "Critical Hit Damage", storageId = 920016 },
			{ id = "onslaught_buff", name = "Onslaught Chance", storageId = 920017 },
		},
		support = {
			{ id = "fair_wound_cleansing_heal", name = "Fair Wound Cleansing Healing", spellName = "Fair Wound Cleansing", storageId = 920018 },
			{ id = "salvation_heal", name = "Salvation Healing", spellName = "Salvation", storageId = 920019 },
			{ id = "ultimate_healing_heal", name = "Ultimate Healing", spellName = "Ultimate Healing", storageId = 920020 },
			{ id = "divine_empowerment_buff", name = "Divine Empowerment Buff", spellName = "Divine Empowerment", storageId = 920021 },
			{ id = "avatar_steel_buff", name = "Avatar of Steel Duration", spellName = "Avatar of Steel", storageId = 920022 },
			{ id = "avatar_storm_buff", name = "Avatar of Storm Duration", spellName = "Avatar of Storm", storageId = 920023 },
			{ id = "avatar_nature_buff", name = "Avatar of Nature Duration", spellName = "Avatar of Nature", storageId = 920024 },
			{ id = "avatar_light_buff", name = "Avatar of Light Duration", spellName = "Avatar of Light", storageId = 920025 },
			{ id = "expose_weakness_buff", name = "Expose Weakness Debuff", spellName = "Expose Weakness", storageId = 920028 },
			{ id = "sap_strength_buff", name = "Sap Strength Debuff", spellName = "Sap Strength", storageId = 920029 },
			{ id = "blood_rage_buff", name = "Blood Rage Skill Boost", spellName = "Blood Rage", storageId = 920035 },
			{ id = "protector_buff", name = "Protector Damage Reduction", spellName = "Protector", storageId = 920036 },
			{ id = "avatar_damage_buff", name = "Avatar Damage Boost", storageId = 920037 },
			{ id = "divine_empowerment_dmg_buff", name = "Divine Empowerment Damage", spellName = "Divine Empowerment", storageId = 920038 },
			{ id = "potion_heal_buff", name = "Potion Healing", storageId = 920030 },
			{ id = "max_hp", name = "Maximum Health", storageId = 920032 },
			{ id = "max_mana", name = "Maximum Mana", storageId = 920033 },
			{ id = "magic_shield", name = "Magic Shield Capacity", storageId = 920034 },
		},
		defense = {
			{ id = "fire_resist", name = "Fire Resistance", storageId = 920040 },
			{ id = "ice_resist", name = "Ice Resistance", storageId = 920041 },
			{ id = "earth_resist", name = "Earth Resistance", storageId = 920042 },
			{ id = "energy_resist", name = "Energy Resistance", storageId = 920043 },
			{ id = "holy_resist", name = "Holy Resistance", storageId = 920044 },
			{ id = "death_resist", name = "Death Resistance", storageId = 920045 },
			{ id = "physical_resist", name = "Physical Resistance", storageId = 920046 },
		},
	},

	-- Quick lookup: bonusId -> bonus definition
	BONUS_LOOKUP = {},

	-- All storage IDs used by relics (populated in init)
	ALL_STORAGE_IDS = {},

	-- Bonus value scaling per rarity
	-- Values are percentages (e.g., 1 means 1%)
	-- Formula: base + (tier - 1) * step
	RARITY_SCALING = {
		common = { base = 0.5, step = 0.5 }, -- T1=0.5%, T10=5%
		rare = { base = 1.0, step = 1.0 }, -- T1=1%, T10=10%
		legendary = { base = 1.5, step = 1.5 }, -- T1=1.5%, T10=15%
	},

	-- Upgrade costs (tier -> next tier)
	UPGRADE_COSTS = {
		[1] = { gold = 150000000, chance = 40 }, -- 150kk
		[2] = { gold = 300000000, chance = 35 }, -- 300kk
		[3] = { gold = 500000000, chance = 30 }, -- 500kk
		[4] = { gold = 750000000, chance = 25 }, -- 750kk
		[5] = { gold = 1000000000, chance = 20 }, -- 1kkk
		[6] = { gold = 1500000000, chance = 15 }, -- 1.5kkk
		[7] = { gold = 2000000000, chance = 10 }, -- 2kkk
		[8] = { gold = 3000000000, chance = 5 }, -- 3kkk
		[9] = { gold = 5000000000, chance = 3 }, -- 5kkk
	},

	MAX_TIER = 10,
	PITY_BONUS = 1,
}

-- Initialize lookup tables
function RelicSystem.init()
	-- Build reverse lookup: itemId -> {rarity, type}
	for rarity, types in pairs(RelicSystem.RELIC_IDS) do
		for rtype, itemId in pairs(types) do
			RelicSystem.RELIC_ID_LOOKUP[itemId] = { rarity = rarity, type = rtype }
		end
	end

	-- Build bonus lookup and storage ID list
	for rtype, bonuses in pairs(RelicSystem.BONUSES) do
		for _, bonus in ipairs(bonuses) do
			bonus.bonusType = rtype
			RelicSystem.BONUS_LOOKUP[bonus.id] = bonus
			table.insert(RelicSystem.ALL_STORAGE_IDS, bonus.storageId)
		end
	end
end

-- Check if an item is a relic
function RelicSystem.isRelic(item)
	if not item or not item:isItem() then
		return false
	end
	return RelicSystem.RELIC_ID_LOOKUP[item:getId()] ~= nil
end

-- Check if an item is a reliquary (uses C++ isReliquary property from items.xml)
function RelicSystem.isReliquary(item)
	if not item or not item:isItem() then
		return false
	end
	return ItemType(item:getId()):isReliquary()
end

-- Get relic data from custom attributes
function RelicSystem.getRelicData(item)
	if not item then
		return nil
	end
	local rarity = item:getCustomAttribute("relic_rarity")
	local rtype = item:getCustomAttribute("relic_type")
	local bonusId = item:getCustomAttribute("relic_bonus_id")
	local tier = item:getCustomAttribute("relic_tier") or 1

	if not rarity or not rtype or not bonusId then
		return nil
	end

	return {
		rarity = rarity,
		type = rtype,
		bonusId = bonusId,
		tier = tier,
	}
end

-- Set relic data as custom attributes
function RelicSystem.setRelicData(item, rarity, rtype, bonusId, tier)
	if not item then
		return false
	end
	item:setCustomAttribute("relic_rarity", rarity)
	item:setCustomAttribute("relic_type", rtype)
	item:setCustomAttribute("relic_bonus_id", bonusId)
	item:setCustomAttribute("relic_tier", tier or 1)
	return true
end

-- Get the item ID for a relic given rarity and type
function RelicSystem.getRelicItemId(rarity, rtype)
	local rarityTable = RelicSystem.RELIC_IDS[rarity]
	if not rarityTable then
		return nil
	end
	return rarityTable[rtype]
end

-- Calculate bonus value for a given rarity and tier
-- Returns the percentage value (e.g., 5.0 for 5%)
function RelicSystem.getBonusValue(rarity, tier)
	local scaling = RelicSystem.RARITY_SCALING[rarity]
	if not scaling then
		return 0
	end
	tier = tier or 1
	return scaling.base + (tier - 1) * scaling.step
end

-- Get bonus value as storage integer (value * 100)
-- e.g., 5% -> 500
function RelicSystem.getBonusStorageValue(rarity, tier)
	return RelicSystem.getBonusValue(rarity, tier) * 100
end

-- Update relic name and description based on attributes
function RelicSystem.updateRelicName(item)
	local data = RelicSystem.getRelicData(item)
	if not data then
		return
	end

	local bonus = RelicSystem.BONUS_LOOKUP[data.bonusId]
	if not bonus then
		return
	end

	local value = RelicSystem.getBonusValue(data.rarity, data.tier)
	local rarityName = data.rarity:sub(1, 1):upper() .. data.rarity:sub(2)

	local description = string.format(
		"Rarity: %s\nType: %s\nBonus: %s +%.1f%%\nTier: %d/%d",
		rarityName,
		data.type:sub(1, 1):upper() .. data.type:sub(2),
		bonus.name,
		value,
		data.tier,
		RelicSystem.MAX_TIER
	)

	item:setAttribute(ITEM_ATTRIBUTE_DESCRIPTION, description)
end

-- Get a relic's bonus definition
function RelicSystem.getBonusDefinition(bonusId)
	return RelicSystem.BONUS_LOOKUP[bonusId]
end

-- Format gold amount for display
function RelicSystem.formatGold(amount)
	if amount >= 1000000000 then
		local kkk = amount / 1000000000
		if kkk == math.floor(kkk) then
			return string.format("%dkkk", kkk)
		else
			return string.format("%.1fkkk", kkk)
		end
	elseif amount >= 1000000 then
		local kk = amount / 1000000
		if kk == math.floor(kk) then
			return string.format("%dkk", kk)
		else
			return string.format("%.0fkk", kk)
		end
	else
		return tostring(amount)
	end
end

-- Find all relics in a player's inventory (not inside reliquary)
function RelicSystem.findRelicsInInventory(player, filterRarity)
	local relics = {}
	for i = CONST_SLOT_HEAD, CONST_SLOT_AMMO do
		local slotItem = player:getSlotItem(i)
		if slotItem then
			if RelicSystem.isRelic(slotItem) then
				if not filterRarity or slotItem:getCustomAttribute("relic_rarity") == filterRarity then
					table.insert(relics, slotItem)
				end
			end
			-- Check inside containers (backpack)
			local container = Container(slotItem:getUniqueId())
			if container then
				RelicSystem._findRelicsInContainer(container, relics, filterRarity)
			end
		end
	end

	-- Also check store inbox
	local inbox = player:getStoreInbox()
	if inbox then
		RelicSystem._findRelicsInContainer(inbox, relics, filterRarity)
	end

	return relics
end

function RelicSystem._findRelicsInContainer(container, relics, filterRarity)
	for i = 0, container:getSize() - 1 do
		local item = container:getItem(i)
		if item then
			if RelicSystem.isRelic(item) then
				if not filterRarity or item:getCustomAttribute("relic_rarity") == filterRarity then
					table.insert(relics, item)
				end
			end
			-- Recurse into sub-containers
			local subContainer = Container(item:getUniqueId())
			if subContainer and not RelicSystem.isReliquary(item) then
				RelicSystem._findRelicsInContainer(subContainer, relics, filterRarity)
			end
		end
	end
end

-- Get player's equipped reliquary (item in ammo slot)
function RelicSystem.getEquippedReliquary(player)
	local ammoItem = player:getSlotItem(CONST_SLOT_AMMO)
	if ammoItem and RelicSystem.isReliquary(ammoItem) then
		return ammoItem
	end
	return nil
end

-- Get all relics inside an equipped reliquary
function RelicSystem.getRelicsInReliquary(reliquary)
	local relics = {}
	if not reliquary then
		return relics
	end

	local container = Container(reliquary:getUniqueId())
	if not container then
		return relics
	end

	for i = 0, container:getSize() - 1 do
		local item = container:getItem(i)
		if item and RelicSystem.isRelic(item) then
			table.insert(relics, item)
		end
	end

	return relics
end

-- Initialize on load
RelicSystem.init()

return RelicSystem
