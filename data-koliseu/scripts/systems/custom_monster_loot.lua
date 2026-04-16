-- Drops custom loot for all monsters (chance values are the BASE for a monster with BASE_EXP experience)
-- Actual chance is scaled by monster difficulty: chance * getChanceMultiplier(exp)
local allLootConfig = {
	{ id = 8778, chance = 60, minCount = 1, maxCount = 1 },
	{ id = 60537, chance = 60, minCount = 1, maxCount = 1 },
	{ id = 60536, chance = 60, minCount = 1, maxCount = 1 },
	{ id = 60528, chance = 60, minCount = 1, maxCount = 1 },
	{ id = 12517, chance = 60, minCount = 1, maxCount = 1 },
	{ id = 19371, chance = 60, minCount = 1, maxCount = 1 },
	{ id = 21948, chance = 60, minCount = 1, maxCount = 1 },
}

-- Scaling config: monsters within BASE_EXP_MIN..BASE_EXP_MAX get exactly the configured chance (1.0x multiplier)
-- Stronger monsters get higher chance, weaker monsters get lower chance
-- Formula: below range uses BASE_EXP_MIN, above range uses BASE_EXP_MAX
local BASE_EXP_MIN = 24000 -- monsters with exp >= this get at least 1x drop
local BASE_EXP_MAX = 35000 -- monsters with exp <= this get at most 1x drop
local EXPONENT = 0.35 -- lower = smoother curve (0.35 keeps endgame at ~5-6x)
local MAX_MULTIPLIER = 3.0 -- cap to prevent extreme values on ultra-high XP monsters
local MIN_MULTIPLIER = 0.01 -- floor so even trash mobs have a tiny chance

local function getChanceMultiplier(mtype)
	local exp = mtype:experience()
	if not exp or exp <= 0 then
		return MIN_MULTIPLIER
	end
	-- Within the base range, multiplier is exactly 1.0
	if exp >= BASE_EXP_MIN and exp <= BASE_EXP_MAX then
		return 1.0
	end
	local multiplier
	if exp < BASE_EXP_MIN then
		multiplier = (exp / BASE_EXP_MIN) ^ EXPONENT
	else
		multiplier = (exp / BASE_EXP_MAX) ^ EXPONENT
	end
	return math.max(MIN_MULTIPLIER, math.min(MAX_MULTIPLIER, multiplier))
end

-- Bosses in this list will NOT receive the custom boss loot (bossLootConfig)
local bossLootBlacklist = {
	["Plunder Patriarch"] = true,
}

-- Custom loot for bosses only (monsters with rewardBoss = true)
-- This loot will be automatically added to each player's reward chest when a boss dies
-- Examples: Orshabaal, Morgaroth, Ahau, Fahim the Wise, etc.
-- Format: { id = itemId, chance = percentage (1-100), minCount = min, maxCount = max }
local bossLootConfig = {
	{ id = 60338, chance = 250, minCount = 1, maxCount = 1 }, -- Momentum Gem Tier 1
	{ id = 60348, chance = 250, minCount = 1, maxCount = 1 }, -- Onslaught Gem Tier 1
	{ id = 60358, chance = 250, minCount = 1, maxCount = 1 }, -- Transcendence Gem Tier 1
	{ id = 60368, chance = 250, minCount = 1, maxCount = 1 }, -- Ruse Gem Tier 1
	{ id = 60167, chance = 250, minCount = 1, maxCount = 1 }, -- Death Gem Tier 1
	{ id = 60177, chance = 250, minCount = 1, maxCount = 1 }, -- Energy Gem Tier 1
	{ id = 60187, chance = 250, minCount = 1, maxCount = 1 }, -- Fire Gem Tier 1
	{ id = 60197, chance = 250, minCount = 1, maxCount = 1 }, -- Holy Gem Tier 1
	{ id = 60207, chance = 250, minCount = 1, maxCount = 1 }, -- Ice Gem Tier 1
	{ id = 60217, chance = 250, minCount = 1, maxCount = 1 }, -- Physical Gem Tier 1
	{ id = 60227, chance = 250, minCount = 1, maxCount = 1 }, -- Earth Gem Tier 1
	{ id = 60083, chance = 1700, minCount = 1, maxCount = 1 },
	{ id = 22516, chance = 1000, minCount = 1, maxCount = 3 },
	{ id = 22721, chance = 1000, minCount = 1, maxCount = 3 },
}

-- Custom loot for specific monsters (this has the same usage options as normal monster loot)
local customLootConfig = {
	['Darklight Matter'] = {
		items = {

			{ id = 43855, chance = 100, minCount = 1, maxCount = 1 },
		}
	},
	['Darklight Source'] = {
		items = {

			{ id = 43855, chance = 100, minCount = 1, maxCount = 1 },
		}
	},
	['Darklight Striker'] = {
		items = {

			{ id = 43855, chance = 100, minCount = 1, maxCount = 1 },
		}
	},
	['Walking Pillar'] = {
		items = {

			{ id = 43855, chance = 100, minCount = 1, maxCount = 1 },
		}
	},
	['Darklight Emitter'] = {
		items = {

			{ id = 43855, chance = 100, minCount = 1, maxCount = 1 },
		}
	},
	['Wandering Pillar'] = {
		items = {

			{ id = 43855, chance = 100, minCount = 1, maxCount = 1 },
		}
	},
	['Darklight Construct'] = {
		items = {

			{ id = 43855, chance = 100, minCount = 1, maxCount = 1 },
		}
	},
	['Converter'] = {
		items = {
			{ id = 43855, chance = 100, minCount = 1, maxCount = 1 },
		}
	},
	['Sopping Corpus'] = {
		items = {
			{ id = 43854, chance = 100, minCount = 1, maxCount = 1 },
		}
	},
	['Oozing Corpus'] = {
		items = {
			{ id = 43854, chance = 100, minCount = 1, maxCount = 1 },
		}
	},
	['Mycobiontic Beetle'] = {
		items = {
			{ id = 43854, chance = 100, minCount = 1, maxCount = 1 },
		}
	},
	['Bloated Man-Maggot'] = {
		items = {
			{ id = 43854, chance = 100, minCount = 1, maxCount = 1 },
		}
	},
	['Sopping Carcass'] = {
		items = {
			{ id = 43854, chance = 100, minCount = 1, maxCount = 1 },
		}
	},
	['Oozing Carcass'] = {
		items = {
			{ id = 43854, chance = 100, minCount = 1, maxCount = 1 },
		}
	},
	['Meandering Mushroom'] = {
		items = {
			{ id = 43854, chance = 100, minCount = 1, maxCount = 1 },
		}
	},
	['Rotten Man-Maggot'] = {
		items = {
			{ id = 43854, chance = 100, minCount = 1, maxCount = 1 },
		}
	},
	['Astral Leech'] = {
		items = {
			{ id = 43854, chance = 100, minCount = 1, maxCount = 1 },
			{ id = 43855, chance = 100, minCount = 1, maxCount = 1 },
		}
	},
	['Rift Stalker'] = {
		items = {
			{ id = 43854, chance = 100, minCount = 1, maxCount = 1 },
			{ id = 43855, chance = 100, minCount = 1, maxCount = 1 },
		}
	},
	['Void Crawler'] = {
		items = {
			{ id = 43854, chance = 100, minCount = 1, maxCount = 1 },
			{ id = 43855, chance = 100, minCount = 1, maxCount = 1 },
		}
	},
	['Dimensional Shade'] = {
		items = {
			{ id = 43854, chance = 100, minCount = 1, maxCount = 1 },
			{ id = 43855, chance = 100, minCount = 1, maxCount = 1 },
		}
	},
	['Nebula Weaver'] = {
		items = {
			{ id = 43854, chance = 100, minCount = 1, maxCount = 1 },
			{ id = 43855, chance = 100, minCount = 1, maxCount = 1 },
		}
	},
	['Starfall Sentinel'] = {
		items = {
			{ id = 43854, chance = 100, minCount = 1, maxCount = 1 },
			{ id = 43855, chance = 100, minCount = 1, maxCount = 1 },
		}
	},
	['Cosmic Warden'] = {
		items = {
			{ id = 43854, chance = 100, minCount = 1, maxCount = 1 },
			{ id = 43855, chance = 100, minCount = 1, maxCount = 1 },
		}
	},
	['Entropy Devourer'] = {
		items = {
			{ id = 43854, chance = 100, minCount = 1, maxCount = 1 },
			{ id = 43855, chance = 100, minCount = 1, maxCount = 1 },
		}
	},
	['Singularity Spawn'] = {
		items = {
			{ id = 43854, chance = 100, minCount = 1, maxCount = 1 },
			{ id = 43855, chance = 100, minCount = 1, maxCount = 1 },
		}
	},
	['Event Horizon'] = {
		items = {
			{ id = 43854, chance = 100, minCount = 1, maxCount = 1 },
			{ id = 43855, chance = 100, minCount = 1, maxCount = 1 },
		}
	},
	['Oblivion Herald'] = {
		items = {
			{ id = 43854, chance = 100, minCount = 1, maxCount = 1 },
			{ id = 43855, chance = 100, minCount = 1, maxCount = 1 },
		}
	},
	['Reality Fracture'] = {
		items = {
			{ id = 43854, chance = 100, minCount = 1, maxCount = 1 },
			{ id = 43855, chance = 100, minCount = 1, maxCount = 1 },
		}
	},

}



-- Global function to add custom boss loot to player's reward
-- This is called by the modified reward_chest.lua script
function addCustomBossLoot(monsterType, playerLoot)
	if not monsterType or not monsterType:isRewardBoss() then
		return playerLoot
	end

	-- Skip blacklisted bosses
	if bossLootBlacklist[monsterType:getName()] then
		return playerLoot
	end

	-- Skip bosses with empty loot table (no loot = no bonus loot)
	local baseLoot = monsterType:getLoot()
	if not baseLoot or #baseLoot == 0 then
		return playerLoot
	end

	if not playerLoot then
		playerLoot = {}
	end

	-- Add custom boss loot items based on chance
	for _, lootItem in ipairs(bossLootConfig) do
		local chance = lootItem.chance or 100
		-- Chance is in percentage (1-100), convert to per-thousand for precision
		if math.random(1, 10000) <= chance then
			local count = math.random(lootItem.minCount or 1, lootItem.maxCount or 1)
			local itemId = lootItem.id

			-- Add to loot table using itemId as key (format expected by addRewardBossItems)
			if playerLoot[itemId] then
				-- If item already exists, add to count
				playerLoot[itemId].count = playerLoot[itemId].count + count
			else
				-- Create new entry
				playerLoot[itemId] = { count = count }
			end

			logger.debug("[addCustomBossLoot] - Added custom loot {} (x{}) to boss {} reward", itemId, count, monsterType:getName())
		end
	end

	return playerLoot
end

local customMonsterLoot = GlobalEvent("CreateCustomMonsterLoot")

function customMonsterLoot.onStartup()
	-- Register custom loot for specific monsters by name
	for monsterName, lootTable in pairs(customLootConfig) do
		local mtype = Game.getMonsterTypeByName(monsterName)
		if mtype then
			if lootTable and lootTable.items and #lootTable.items > 0 then
				mtype:createLoot(lootTable.items)
			end
		else
			logger.error("[customMonsterLoot.onStartup] - Monster type not found: {}", monsterName)
		end
	end

	-- Register global loot for all non-boss monsters, scaled by monster difficulty
	if #allLootConfig > 0 then
		for monsterName, mtype in pairs(Game.getMonsterTypes()) do
			if mtype and not mtype:isRewardBoss() then
				local multiplier = getChanceMultiplier(mtype)
				local scaledLoot = {}
				for _, item in ipairs(allLootConfig) do
					table.insert(scaledLoot, {
						id = item.id,
						chance = math.max(1, math.floor(item.chance * multiplier)),
						minCount = item.minCount,
						maxCount = item.maxCount,
					})
				end
				mtype:createLoot(scaledLoot)
			end
		end
	end
end

customMonsterLoot:register()
