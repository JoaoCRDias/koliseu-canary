--[[
	Linked Task System - Core Library
	Separate from the daily task system. Sequential, non-repeatable tasks
	organized in 5 rooms (tiers). Player must complete all tasks in a room
	before unlocking the next room.

	Storage Layout (192000-192999):
	  192000 = Quest log marker
	  192001 = Currently active room (1-5, 0 = not started)
	  192002 = Currently active task index within room (1-N, 0 = none)
	  192003 = Kill counter for active task
	  192004 = Task status (0=none, 1=active, 2=kills complete, 3=reward claimed)
	  192010 = Permanent XP bonus (stored as percentage, e.g. 5 = 5%)
	  192011 = Permanent Loot bonus (stored as percentage)
	  192012 = Permanent Forge bonus (stored as flat % added to success rate)
	  192100-192104 = Room completion flags (1 = completed, per room)
	  192200-192499 = Individual task completion flags (per task global index)

	Action IDs for totems: 57001-57250 (57000 + global task index)
]]

-- =============================================================================
-- CONFIGURATION
-- =============================================================================

LinkedTask = {}

LinkedTask.Storages = {
	QUEST_LOG = 192000,
	ACTIVE_ROOM = 192001,
	ACTIVE_TASK_INDEX = 192002,
	KILL_COUNT = 192003,
	TASK_STATUS = 192004,
	-- Permanent bonuses
	BONUS_XP = 192010,
	BONUS_LOOT = 192011,
	BONUS_FORGE = 192012,
	-- Room completion base (+ roomIndex - 1)
	ROOM_COMPLETE_BASE = 192100,
	-- Individual task completion base (+ global task index)
	TASK_COMPLETE_BASE = 192200,
}

LinkedTask.Status = {
	NONE = 0,
	ACTIVE = 1,
	KILLS_COMPLETE = 2,
	REWARD_CLAIMED = 3,
}

-- Action ID base: totem actionId = ACTION_ID_BASE + globalTaskIndex
LinkedTask.ACTION_ID_BASE = 57000

-- =============================================================================
-- ITEM ID TABLE (use these constants in rewards for readability)
-- =============================================================================

LinkedTask.Items = {
	-- Coins & Currency
	CRYSTAL_COIN = 3043,
	TASK_TOKEN = 60129,
	COSMIC_TOKEN = 60535,
	BOSS_TOKEN = 60083,
	ROULETTE_COIN = 60104,

	-- Experience Potions
	LESSER_EXP_POTION = 60303,
	EXP_POTION = 60301,
	GREATER_EXP_POTION = 60302,

	-- Exercise & Training
	BOOSTED_EXERCISE_TOKEN = 60648,
	EXERCISE_SPEED_IMPROVEMENT = 60647,
	COMMON_TRAINING_CHEST = 60614,

	-- Upgrade Stones
	BASIC_UPGRADE_STONE = 60429,
	MEDIUM_UPGRADE_STONE = 60428,
	EPIC_UPGRADE_STONE = 60427,
	TIER_UPGRADER = 60022,

	-- Bags & Containers
	BAG_YOU_DESIRE = 34109,
	BAG_YOU_COVET = 43895,
	PRIMAL_BAG = 39546,
	BAG_OF_COSMIC_WISHES = 60626,
	BAG_OF_YOUR_DREAMS = 60628,
	MYSTERY_BAG = 60077,

	-- Dolls (Store Inbox)
	ADDON_DOLL = 8778,
	MOUNT_DOLL = 21948,

	-- Potions & Consumables
	PREY_WILDCARD = 60101,
	REFLECT_POTION = 49272,
	MITIGATION_POTION = 11372,

	-- Protectors (elemental)
	EARTH_PROTECTOR = 60110,
	HOLY_PROTECTOR = 60109,
	ICE_PROTECTOR = 60108,
	DEATH_PROTECTOR = 60107,
	FIRE_PROTECTOR = 60106,
	ENERGY_PROTECTOR = 60105,

	-- Gem Bags
	SURPRISE_GEM_BAG = 60316,

	-- Forge Materials
	TAINTED_HEART = 43854,
	DARKLIGHT_HEART = 43855,

	-- Boss Essences
	ESSENCE_OF_MURCION = 43501,
	ESSENCE_OF_ICHGAHAL = 43502,
	ESSENCE_OF_VEMIATH = 43503,
	ESSENCE_OF_CHAGORZ = 43504,
	BAKRAGORE_AMALGAMATION = 43968,

	-- Craft Plans
	SILVER_PLAN_OF_CRAFT = 60156,
	GOLDEN_PLAN_OF_CRAFT = 60155,

	-- Relics
	UNREVEALED_RELIC = 60522,

	-- Premium
	PREMIUM_SCROLL = 14758,

	-- Special
	STARLIGHT_POWER = 60148,
}

-- Shortcut alias
local I = LinkedTask.Items

-- =============================================================================
-- ROOM & TASK DEFINITIONS
-- =============================================================================
-- Each room has:
--   name: display name
--   killsRequired: DEFAULT kills needed per task in this room (can be overridden per task)
--   tasks: ordered list of tasks (must be completed sequentially)
--     each task has: name, races (monster names), rewards (individual task reward)
--     optional: killsRequired (overrides room default for this specific task)
--   roomReward: special reward for completing ALL tasks in the room
--
-- Reward types:
--   { type = "item", id = itemId, count = amount }
--   { type = "storeitem", id = itemId, count = amount }  -- delivered to store inbox, non-movable
--   { type = "vocgem", count = amount }                  -- skill gem matching player vocation
--   { type = "wheelgreatergem", count = amount }         -- greater wheel gem matching player vocation
--   { type = "gold", amount = number }                   -- gold added directly to bank
--   { type = "experience", amount = number }
--   { type = "level", amount = number }
--   { type = "addon", looktype = number, addon = number (1,2,3) }
--   { type = "mount", id = mountId }
--   { type = "bonus_xp", amount = percent }        -- permanent
--   { type = "bonus_loot", amount = percent }       -- permanent
--   { type = "bonus_forge", amount = percent }      -- permanent
-- =============================================================================

LinkedTask.Rooms = {
	-- =========================================================================
	-- ROOM 1: EASY (5000 kills per task)
	-- =========================================================================
	{
		name = "Easy",
		killsRequired = 5000,
		tasks = {
			{
				name = "Minotaurs",
				races = { "Minotaur", "Minotaur Archer", "Minotaur Guard", "Minotaur Mage" },
				killsRequired = 500,
				rewards = {
					{ type = "experience", amount = 500000 },
				},
			},
			{
				name = "Dwarves",
				races = { "Dwarf", "Dwarf Guard", "Dwarf Soldier", "Dwarf Geomancer" },
				killsRequired = 600,
				rewards = {
					{ type = "experience", amount = 750000 },
				},
			},
			{
				name = "Cyclops",
				races = { "Cyclops", "Cyclops Drone", "Cyclops Smith" },
				killsRequired = 800,
				rewards = {
					{ type = "experience", amount = 1000000 },
					{ type = "gold", amount = 1000000 },
				},
			},
			{
				name = "Apes",
				races = { "Sibang", "Kongra", "Merlkin" },
				killsRequired = 800,
				rewards = {
					{ type = "experience", amount = 1250000 },
				},
			},
			{
				name = "Vampires",
				races = { "Vampire", "Vampire Bride", "Vampire Viscount" },
				killsRequired = 1000,
				rewards = {
					{ type = "experience", amount = 1500000 },
					{ type = "gold", amount = 2000000 },
				},
			},
			{
				name = "Ancient Scarab",
				races = { "Ancient Scarab" },
				killsRequired = 1200,
				rewards = {
					{ type = "experience", amount = 1750000 },
					{ type = "item", id = I.BOOSTED_EXERCISE_TOKEN, count = 1 },
				},
			},
			{
				name = "Cults",
				races = { "Cult Enforcer", "Cult Believer", "Cult Scholar" },
				killsRequired = 1400,
				rewards = {
					{ type = "experience", amount = 2000000 },
				},
			},
			{
				name = "Undead",
				races = { "Putrid Mummy", "Bonebeast" },
				killsRequired = 1600,
				rewards = {
					{ type = "experience", amount = 2250000 },
					{ type = "item", id = I.EXERCISE_SPEED_IMPROVEMENT, count = 1 },
				},
			},
			{
				name = "Knights",
				races = { "Hero", "Vicious Squire", "Renegade Knight" },
				killsRequired = 1800,
				rewards = {
					{ type = "experience", amount = 2500000 },
					{ type = "item", id = I.ROULETTE_COIN, count = 3 },
				},
			},
			{
				name = "Dragons",
				races = { "Dragon", "Dragon Lord", "Dragon Lord Hatchling", "Dragon Hatchling" },
				killsRequired = 2000,
				rewards = {
					{ type = "experience", amount = 2750000 },
					{ type = "storeitem", id = I.ADDON_DOLL, count = 50 },
				},
			},
			{
				name = "Werecreatures",
				races = { "Werefox", "Wereboar", "Werebear", "Werebadger" },
				killsRequired = 2200,
				rewards = {
					{ type = "experience", amount = 3000000 },
					{ type = "storeitem", id = I.MOUNT_DOLL, count = 50 },
				},
			},
			{
				name = "Spiders",
				races = { "Giant Spider", "Tarantula" },
				killsRequired = 2400,
				rewards = {
					{ type = "experience", amount = 3250000 },
					{ type = "item", id = I.SURPRISE_GEM_BAG, count = 3 },
				},
			},
			{
				name = "Golems",
				races = { "Worker Golem", "War Golem" },
				killsRequired = 2600,
				rewards = {
					{ type = "experience", amount = 3500000 },
					{ type = "item", id = I.BAG_YOU_DESIRE, count = 1 },
				},
			},
			{
				name = "Banshees",
				races = { "Banshee", "Nightstalker" },
				killsRequired = 2600,
				rewards = {
					{ type = "experience", amount = 3750000 },
					{ type = "item", id = I.PRIMAL_BAG, count = 1 },
				},
			},
		},
		roomReward = {
			{ type = "bonus_xp", amount = 1 },
			{ type = "level", amount = 10 },
			{ type = "item", id = I.BAG_YOU_COVET, count = 1 },
		},
	},

	-- =========================================================================
	-- ROOM 2: MEDIUM (10000 kills per task)
	-- =========================================================================
	{
		name = "Medium",
		killsRequired = 10000,
		tasks = {
			{
				name = "Desert Warriors",
				races = { "Burning Gladiator", "Priestess Of The Wild Sun", "Black Sphinx Acolyte" },
				killsRequired = 3000,
				rewards = {
					{ type = "experience", amount = 3750000 },
					{ type = "gold", amount = 10000000 },
				},
			},
			{
				name = "Carnivors",
				races = { "Spiky Carnivor", "Lumbering Carnivor", "Menacing Carnivor" },
				killsRequired = 3000,
				rewards = {
					{ type = "experience", amount = 4000000 },
				},
			},
			{
				name = "Summer Court",
				races = { "Crazed Summer Rearguard", "Crazed Summer Vanguard", "Insane Siren" },
				killsRequired = 3000,
				rewards = {
					{ type = "experience", amount = 4250000 },
				},
			},
			{
				name = "Winter Court",
				races = { "Crazed Winter Rearguard", "Crazed Winter Vanguard", "Soul-Broken Harbinger" },
				killsRequired = 3000,
				rewards = {
					{ type = "experience", amount = 4500000 },
					{ type = "item", id = I.EPIC_UPGRADE_STONE, count = 2 },
					{ type = "item", id = I.MEDIUM_UPGRADE_STONE, count = 2 },
					{ type = "item", id = I.BASIC_UPGRADE_STONE, count = 2 },
				},
			},
			{
				name = "Nightmares",
				races = { "Frazzlemaw", "Guzzlemaw", "Silencer" },
				killsRequired = 3500,
				rewards = {
					{ type = "experience", amount = 4750000 },
				},
			},
			{
				name = "Horrors",
				races = { "Choking Fear", "Retching Horror" },
				killsRequired = 3500,
				rewards = {
					{ type = "experience", amount = 5000000 },
					{ type = "gold", amount = 50000000 },
				},
			},
			{
				name = "Gazer Spectres",
				races = { "Gazer Spectre", "Thanatursus" },
				killsRequired = 3500,
				rewards = {
					{ type = "experience", amount = 5250000 },
				},
			},
			{
				name = "Ripper Spectres",
				races = { "Arachnophobica", "Ripper Spectre" },
				killsRequired = 3500,
				rewards = {
					{ type = "experience", amount = 5500000 },
					{ type = "item", id = I.COMMON_TRAINING_CHEST, count = 2 },
				},
			},
			{
				name = "Grimeleech",
				races = { "Grimeleech", "Plaguesmith" },
				killsRequired = 4000,
				rewards = {
					{ type = "experience", amount = 5750000 },
				},
			},
			{
				name = "Vexclaw",
				races = { "Vexclaw", "Hellhound" },
				killsRequired = 4000,
				rewards = {
					{ type = "experience", amount = 6000000 },
					{ type = "item", id = I.TAINTED_HEART, count = 100 },
					{ type = "item", id = I.DARKLIGHT_HEART, count = 100 },
				},
			},
			{
				name = "Hellflayer",
				races = { "Hellflayer", "Juggernaut" },
				killsRequired = 4000,
				rewards = {
					{ type = "experience", amount = 6250000 },
				},
			},
			{
				name = "Falcons",
				races = { "Falcon Paladin", "Falcon Knight" },
				killsRequired = 4000,
				rewards = {
					{ type = "experience", amount = 6500000 },
				},
			},
			{
				name = "Deathlings",
				races = { "Deathling Spellsinger", "Deathling Scout" },
				killsRequired = 4500,
				rewards = {
					{ type = "experience", amount = 6750000 },
					{ type = "item", id = I.PREY_WILDCARD, count = 5 },
				},
			},
			{
				name = "Asuras",
				races = { "Midnight Asura", "Frost Flower Asura", "Dawnfire Asura" },
				killsRequired = 4500,
				rewards = {
					{ type = "experience", amount = 7000000 },
				},
			},
			{
				name = "Undead Warriors",
				races = { "Undead Elite Gladiator", "Skeleton Elite Warrior" },
				killsRequired = 4500,
				rewards = {
					{ type = "experience", amount = 7250000 },
					{ type = "item", id = I.ESSENCE_OF_MURCION, count = 2 },
					{ type = "item", id = I.ESSENCE_OF_ICHGAHAL, count = 2 },
					{ type = "item", id = I.ESSENCE_OF_VEMIATH, count = 2 },
					{ type = "item", id = I.ESSENCE_OF_CHAGORZ, count = 2 },
					{ type = "item", id = I.BAKRAGORE_AMALGAMATION, count = 2 },
				},
			},
			{
				name = "True Asuras",
				races = { "True Midnight Asura", "True Frost Flower Asura", "True Dawnfire Asura" },
				killsRequired = 4500,
				rewards = {
					{ type = "experience", amount = 7500000 },
				},
			},
			{
				name = "Lost Souls",
				races = { "Flimsy Lost Soul", "Freakish Lost Soul", "Mean Lost Soul" },
				killsRequired = 5000,
				rewards = {
					{ type = "experience", amount = 7750000 },
				},
			},
			{
				name = "Devourers",
				races = { "Streaked Devourer", "Lavaworm", "Lavafungus" },
				killsRequired = 5000,
				rewards = {
					{ type = "experience", amount = 8000000 },
					{ type = "item", id = I.MYSTERY_BAG, count = 5 },
				},
			},
			{
				name = "Girtablilu",
				races = { "Venerable Girtablilu", "Girtablilu Warrior" },
				killsRequired = 5000,
				rewards = {
					{ type = "experience", amount = 8250000 },
				},
			},
			{
				name = "Icecold Books",
				races = { "Icecold Book", "Animated Feather", "Squid Warden" },
				killsRequired = 5000,
				rewards = {
					{ type = "experience", amount = 8500000 },
				},
			},
			{
				name = "Burning Books",
				races = { "Burning Book", "Rage Squid", "Guardian Of Tales" },
				killsRequired = 5500,
				rewards = {
					{ type = "experience", amount = 8750000 },
					{ type = "storeitem", id = I.ADDON_DOLL, count = 200 },
					{ type = "storeitem", id = I.MOUNT_DOLL, count = 200 },
				},
			},
			{
				name = "Cursed Books",
				races = { "Cursed Book" },
				killsRequired = 5500,
				rewards = {
					{ type = "experience", amount = 9000000 },
				},
			},
			{
				name = "Energetic Books",
				races = { "Energetic Book", "Energuardian Of Tales", "Knowledge Elemental" },
				killsRequired = 5500,
				rewards = {
					{ type = "experience", amount = 9250000 },
					{ type = "item", id = I.PREMIUM_SCROLL, count = 1 },
				},
			},
			{
				name = "Bulltaurs",
				races = { "Bulltaur Alchemist", "Bulltaur Forgepriest", "Bulltaur Brute" },
				killsRequired = 5500,
				rewards = {
					{ type = "experience", amount = 9500000 },
				},
			},
			{
				name = "Goannas",
				races = { "Adult Goanna", "Young Goanna" },
				killsRequired = 6000,
				rewards = {
					{ type = "experience", amount = 9750000 },
					{ type = "item", id = I.TIER_UPGRADER, count = 2 },
				},
			},
			{
				name = "Underground Beasts",
				races = { "Cave Chimera", "Varnished Diremaw", "Tremendous Tyrant" },
				killsRequired = 6000,
				rewards = {
					{ type = "experience", amount = 10000000 },
					{ type = "item", id = I.EARTH_PROTECTOR, count = 1 },
					{ type = "item", id = I.HOLY_PROTECTOR, count = 1 },
				},
			},
			{
				name = "Wildlands",
				races = { "Carnivostrich", "Liodile", "Harpy" },
				killsRequired = 6000,
				rewards = {
					{ type = "experience", amount = 10250000 },
					{ type = "item", id = I.ICE_PROTECTOR, count = 1 },
					{ type = "item", id = I.DEATH_PROTECTOR, count = 1 },
				},
			},
			{
				name = "Cobras",
				races = { "Cobra Vizier", "Cobra Scout", "Cobra Assassin" },
				killsRequired = 6000,
				rewards = {
					{ type = "experience", amount = 10500000 },
					{ type = "item", id = I.FIRE_PROTECTOR, count = 1 },
					{ type = "item", id = I.ENERGY_PROTECTOR, count = 1 },
				},
			},
		},
		roomReward = {
			{ type = "bonus_xp", amount = 2 },
			{ type = "bonus_forge", amount = 1 },
			{ type = "level", amount = 20 },
			{ type = "item", id = I.STARLIGHT_POWER, count = 1 },
		},
	},

	-- =========================================================================
	-- ROOM 3: HARD (15000 kills per task)
	-- =========================================================================
	{
		name = "Hard",
		killsRequired = 15000,
		tasks = {
			{
				name = "Infernal",
				races = { "Infernal Phantom", "Infernal Demon", "Brachiodemon" },
				killsRequired = 7000,
				rewards = {
					{ type = "experience", amount = 8500000 },
					{ type = "item", id = I.ROULETTE_COIN, count = 10 },
				},
			},
			{
				name = "Rotting",
				races = { "Mould Phantom", "Branchy Crawler", "Rotten Golem" },
				killsRequired = 7000,
				rewards = {
					{ type = "experience", amount = 8750000 },

				},
			},
			{
				name = "Apparitions",
				races = { "Many Faces", "Distorted Phantom", "Paladin's Apparition", "Knight's Apparition", "Druid's Apparition", "Sorcerer's Apparition" },
				killsRequired = 8000,
				rewards = {
					{ type = "experience", amount = 9000000 },
					{ type = "item", id = I.BASIC_UPGRADE_STONE, count = 5 },
					{ type = "item", id = I.MEDIUM_UPGRADE_STONE, count = 5 },
					{ type = "item", id = I.EPIC_UPGRADE_STONE, count = 5 },
				},
			},
			{
				name = "Sea Devils",
				races = { "Capricious Phantom", "Bony Sea Devil", "Turbulent Elemental" },
				killsRequired = 8000,
				rewards = {
					{ type = "experience", amount = 9250000 },

				},
			},
			{
				name = "Vibrant Phantoms",
				races = { "Vibrant Phantom", "Cloak Of Terror", "Courage Leech" },
				killsRequired = 9000,
				rewards = {
					{ type = "experience", amount = 9500000 },
					{ type = "gold" , amount = 100000000 },
				},
			},
			{
				name = "Prehistoric I",
				races = { "Mercurial Menace", "Noxious Ripptor", "Headpecker" },
				killsRequired = 9000,
				rewards = {
					{ type = "experience", amount = 9750000 },
				},
			},
			{
				name = "Prehistoric II",
				races = { "Gorerilla", "Hulking Prehemoth", "Emerald Tortoise", "Sabretooth" },
				killsRequired = 10000,
				rewards = {
					{ type = "experience", amount = 10000000 },
					{ type = "item", id = I.COMMON_TRAINING_CHEST, count = 2 },
				},
			},
			{
				name = "Night Hunters",
				races = { "Sulphur Spouter", "Sulphider", "Nighthunter", "Undertaker" },
				killsRequired = 10000,
				rewards = {
					{ type = "experience", amount = 10250000 },
				},
			},
			{
				name = "Carcasses",
				races = { "Oozing Carcass", "Sopping Carcass", "Rotten Man-Maggot", "Meandering Mushroom" },
				killsRequired = 11000,
				rewards = {
					{ type = "experience", amount = 10500000 },
					{ type = "item", id = I.LESSER_EXP_POTION, count = 3 },
					{ type = "item", id = I.EXP_POTION, count = 3 },
					{ type = "item", id = I.GREATER_EXP_POTION, count = 3 },
				},
			},
			{
				name = "Darklight",
				races = { "Darklight Matter", "Walking Pillar", "Darklight Source", "Darklight Striker" },
				killsRequired = 11000,
				rewards = {
					{ type = "experience", amount = 10750000 },
				},
			},
			{
				name = "Corpses",
				races = { "Sopping Corpus", "Oozing Corpus", "Bloated Man-Maggot", "Mycobiontic Beetle" },
				killsRequired = 12000,
				rewards = {
					{ type = "experience", amount = 11000000 },
					{ type = "gold" , amount = 150000000 },
				},
			},
			{
				name = "Pillars",
				races = { "Wandering Pillar", "Darklight Construct", "Darklight Emitter", "Converter" },
				killsRequired = 12000,
				rewards = {
					{ type = "experience", amount = 11250000 },
				},
			},
			{
				name = "Cosmic I",
				races = { "Void Crawler", "Rift Stalker", "Astral Leech" },
				killsRequired = 13000,
				rewards = {
					{ type = "experience", amount = 11500000 },
					{ type = "item", id = I.PREY_WILDCARD, count = 3 },
				},
			},
			{
				name = "Cosmic II",
				races = { "Starfall Sentinel", "Dimensional Shade", "Nebula Weaver" },
				killsRequired = 13000,
				rewards = {
					{ type = "experience", amount = 11750000 },
				},
			},
			{
				name = "Cosmic III",
				races = { "Cosmic Warden", "Entropy Devourer", "Singularity Spawn" },
				killsRequired = 14000,
				rewards = {
					{ type = "experience", amount = 12000000 },
				},
			},
			{
				name = "Cosmic IV",
				races = { "Reality Fracture", "Oblivion Herald", "Event Horizon" },
				killsRequired = 14000,
				rewards = {
					{ type = "experience", amount = 12250000 },
					{ type = "item", id = I.COSMIC_TOKEN, count = 100 },

				},
			},
		},
		roomReward = {
			{ type = "bonus_xp", amount = 3 },
			{ type = "bonus_loot", amount = 3 },
			{ type = "bonus_forge", amount = 2 },
			{ type = "level", amount = 40 },
			{ type = "item", id = I.BAG_OF_COSMIC_WISHES, count = 1 },
		},
	},

	-- =========================================================================
	-- ROOM 4: EPIC (20000 kills per task)
	-- =========================================================================
	{
		name = "Epic",
		killsRequired = 20000,
		tasks = {
			{
				name = "Anomalies",
				races = { "Anomaly Man", "Flaming Bastard", "Remains of Chemical" },
				killsRequired = 15000,
				rewards = {
					{ type = "experience", amount = 11250000 },
				},
			},
			{
				name = "Executioners",
				races = { "Crushing Executioner", "Bloodthirsty Executioner", "Dark Executioner" },
				killsRequired = 15000,
				rewards = {
					{ type = "experience", amount = 11500000 },
				},
			},
			{
				name = "Necrotic",
				races = { "Bonecrusher Wight", "Graveshroud Revenant", "Necrotic Overlord" },
				killsRequired = 15000,
				rewards = {
					{ type = "experience", amount = 11750000 },
					{ type = "gold", amount = 200000000 },
				},
			},
			{
				name = "Thunder",
				races = { "Voltspawn Herald", "Arcsurge Conduit", "Thundercore Titan" },
				killsRequired = 15000,
				rewards = {
					{ type = "experience", amount = 12000000 },
				},
			},
			{
				name = "Dragons",
				races = { "Bluehide Dragon", "Stonehide Dragon", "Darkhide Dragon" },
				killsRequired = 15000,
				rewards = {
					{ type = "experience", amount = 12250000 },
					{ type = "item", id = I.SILVER_PLAN_OF_CRAFT, count = 1 },
				},
			},
			{
				name = "Bone Fiends",
				races = { "Bonegrinder", "Ancient Gozzler", "Soulleecher" },
				killsRequired = 17000,
				rewards = {
					{ type = "experience", amount = 12500000 },
				},
			},
			{
				name = "Ancients",
				races = { "Shellbreaker Ancient", "Ironshell Guardian", "Mosscrag Colossus" },
				killsRequired = 17000,
				rewards = {
					{ type = "experience", amount = 12750000 },
					{ type = "item", id = I.TIER_UPGRADER, count = 2 },
				},
			},
			{
				name = "Infernal Punishers",
				races = { "Infernal Punisher", "Wrathborn Fury", "Blazefury Ravager" },
				killsRequired = 17000,
				rewards = {
					{ type = "experience", amount = 13000000 },
				},
			},
			{
				name = "Storm Dragons",
				races = { "Tempest Wing", "Atrophied Wings", "Shadowflame Dragon" },
				killsRequired = 17000,
				rewards = {
					{ type = "experience", amount = 13250000 },
				},
			},
			{
				name = "Dark Monarchs",
				races = { "Carrion Monarch", "Demonic Soul", "Demonic Beholder" },
				killsRequired = 17000,
				rewards = {
					{ type = "experience", amount = 13500000 },
					{ type = "item", id = I.EPIC_UPGRADE_STONE, count = 5 },
					{ type = "item", id = I.MEDIUM_UPGRADE_STONE, count = 5 },
					{ type = "item", id = I.BASIC_UPGRADE_STONE, count = 5 },
				},
			},
			{
				name = "Void Casters",
				races = { "Voidcaller Archon", "Runeweaver Adept", "Hexbound Sorcerer" },
				killsRequired = 20000,
				rewards = {
					{ type = "experience", amount = 13750000 },
				},
			},
			{
				name = "Pumpkins",
				races = { "Wailing Jack", "Grim Gourd", "Twisted Pumpkinling" },
				killsRequired = 20000,
				rewards = {
					{ type = "experience", amount = 14000000 },
				},
			},
			{
				name = "Sentinels",
				races = { "Prismatic Sentinel", "Gemheart Warden", "Shardborn Golem" },
				killsRequired = 20000,
				rewards = {
					{ type = "experience", amount = 14250000 },
					{ type = "item", id = I.COSMIC_TOKEN, count = 100 },
				},
			},
			{
				name = "Volcanic",
				races = { "Volcanic Destroyer", "Cinder Behemoth", "Magma Stalker" },
				killsRequired = 20000,
				rewards = {
					{ type = "experience", amount = 14500000 },
				},
			},
			{
				name = "Abyssal",
				races = { "Rattling Abyssal", "Infernal Bonefiend", "Bonefiend" },
				killsRequired = 20000,
				rewards = {
					{ type = "experience", amount = 14750000 },
					{ type = "gold" , amount = 300000000 },

				},
			},
			{
				name = "Sinspawn",
				races = { "Sinspawn", "Shiny Dog", "Reaper Apparition" },
				killsRequired = 25000,
				rewards = {
					{ type = "experience", amount = 15000000 },
				},
			},
			{
				name = "Gloomcasters",
				races = { "Lier", "Gloomcaster Minister", "Shiny Bald" },
				killsRequired = 25000,
				rewards = {
					{ type = "experience", amount = 15250000 },
					{ type = "item", id = I.GOLDEN_PLAN_OF_CRAFT, count = 1 },
				},
			},
			{
				name = "Deep Sea",
				races = { "Deepfang Predator", "Abyssal Mauler", "Tidalwrath Leviathan" },
				killsRequired = 25000,
				rewards = {
					{ type = "experience", amount = 15500000 },
				},
			},
			{
				name = "Assassins",
				races = { "Venomblade Assassin", "Shadowstep Cutthroat", "Nightfall Executioner" },
				killsRequired = 25000,
				rewards = {
					{ type = "experience", amount = 15750000 },
				},
			},
			{
				name = "Serpents",
				races = { "Serpentcrown Mystic", "Nagascale Guardian", "Coilfang Matriarch" },
				killsRequired = 25000,
				rewards = {
					{ type = "experience", amount = 16000000 },
					{ type = "item", id = I.COMMON_TRAINING_CHEST, count = 3 },
				},
			},
		},
		roomReward = {
			{ type = "bonus_xp", amount = 4 },
			{ type = "bonus_loot", amount = 5 },
			{ type = "bonus_forge", amount = 3 },
			{ type = "level", amount = 40 },
			{ type = "item", id = I.BAG_OF_YOUR_DREAMS, count = 1 },
		},
	},

	-- =========================================================================
	-- ROOM 5: RAMPAGE (25000 kills per task)
	-- =========================================================================
	{
		name = "Rampage",
		killsRequired = 25000,
		tasks = {
			{
				name = "Ogres I",
				races = { "Riftburn Ogre", "Servant Of The Ogres", "Doomcurrent Ogre" },
				killsRequired = 30000,
				rewards = {
					{ type = "experience", amount = 14750000 },
					{ type = "gold" , amount = 500000000 },
				},
			},
			{
				name = "Ogres II",
				races = { "Rotmaw Ogre", "Baby Ogre", "Stoneflesh Ogre" },
				killsRequired = 30000,
				rewards = {
					{ type = "experience", amount = 15000000 },
				},
			},
			{
				name = "Plague I",
				races = { "Venomrot Wraith", "Pest Disperser", "Blightbone Revenant" },
				killsRequired = 30000,
				rewards = {
					{ type = "experience", amount = 15250000 },
					{ type = "gold" , amount = 300000000 },
				},
			},
			{
				name = "Plague II",
				races = { "Plaguefiend Behemoth", "Plaguefiend Bonelord", "Dreadmaw Corruptor" },
				killsRequired = 30000,
				rewards = {
					{ type = "experience", amount = 15500000 },
				},
			},
			{
				name = "Pirates",
				races = { "Powder Gunner", "Saltwater Corsair", "Plunderer Captain" },
				killsRequired = 30000,
				rewards = {
					{ type = "experience", amount = 15750000 },
					{ type = "gold" , amount = 300000000 },
				},
			},
			{
				name = "Buccaneers",
				races = { "Crimson Buccaneer", "Storm Conjurer", "Frostpelt Marauder" },
				killsRequired = 30000,
				rewards = {
					{ type = "experience", amount = 16000000 },
				},
			},
			{
				name = "Mining Camp",
				races = { "Stonepick Digger", "Runeshot Artillerist", "Molten Forgemaster", "Spelunker Sharpshooter", "Ember Bombadier", "Crossbow Rifleman" },
				killsRequired = 30000,
				rewards = {
					{ type = "experience", amount = 16250000 },
					{ type = "gold" , amount = 300000000 },
				},
			},
			{
				name = "Vault Keepers",
				races = { "Deeprock Berserker", "Ironforge Grunt", "Vault Guardian", "Grudge Keeper" },
				killsRequired = 30000,
				rewards = {
					{ type = "experience", amount = 16500000 },
				},
			},
			{
				name = "Gloomcaster Elite",
				races = { "Gloomcaster President Spouse", "Gloomcaster President", "Alcohol Bottle" },
				killsRequired = 30000,
				rewards = {
					{ type = "experience", amount = 16750000 },
				},
			},
		},
		roomReward = {
			{ type = "bonus_xp", amount = 5 },
			{ type = "bonus_loot", amount = 5 },
			{ type = "bonus_forge", amount = 4 },
			{ type = "level", amount = 50 },
			{ type = "item", id = I.BAG_OF_YOUR_DREAMS, count = 1 },
		},
	},
}

-- =============================================================================
-- LOOKUP TABLES (built on load)
-- =============================================================================

-- Maps monster name (lowercase) -> { roomIndex, taskIndex, globalIndex }
LinkedTask._monsterLookup = {}

-- Maps globalTaskIndex -> { roomIndex, taskIndex }
LinkedTask._taskByGlobalIndex = {}

-- Maps actionId -> globalTaskIndex
LinkedTask._actionIdLookup = {}

-- Total tasks count
LinkedTask._totalTasks = 0

function LinkedTask.buildLookupTables()
	LinkedTask._monsterLookup = {}
	LinkedTask._taskByGlobalIndex = {}
	LinkedTask._actionIdLookup = {}

	local globalIndex = 0
	for roomIndex, room in ipairs(LinkedTask.Rooms) do
		for taskIndex, task in ipairs(room.tasks) do
			globalIndex = globalIndex + 1
			LinkedTask._taskByGlobalIndex[globalIndex] = {
				roomIndex = roomIndex,
				taskIndex = taskIndex,
			}
			local actionId = LinkedTask.ACTION_ID_BASE + globalIndex
			LinkedTask._actionIdLookup[actionId] = globalIndex

			for _, raceName in ipairs(task.races) do
				LinkedTask._monsterLookup[raceName:lower()] = {
					roomIndex = roomIndex,
					taskIndex = taskIndex,
					globalIndex = globalIndex,
				}
			end
		end
	end
	LinkedTask._totalTasks = globalIndex
end

-- =============================================================================
-- HELPER FUNCTIONS
-- =============================================================================

--- Get the global task index for a given room and task
function LinkedTask.getGlobalIndex(roomIndex, taskIndex)
	local offset = 0
	for i = 1, roomIndex - 1 do
		offset = offset + #LinkedTask.Rooms[i].tasks
	end
	return offset + taskIndex
end

--- Get room and task data from global index
function LinkedTask.getTaskByGlobalIndex(globalIndex)
	local info = LinkedTask._taskByGlobalIndex[globalIndex]
	if not info then
		return nil, nil, nil
	end
	local room = LinkedTask.Rooms[info.roomIndex]
	local task = room.tasks[info.taskIndex]
	return room, task, info
end

--- Get task data from monster name
function LinkedTask.getTaskByMonster(monsterName)
	return LinkedTask._monsterLookup[monsterName:lower()]
end

--- Check if player has completed a specific task (by global index)
function LinkedTask.isTaskCompleted(player, globalIndex)
	return player:getStorageValue(LinkedTask.Storages.TASK_COMPLETE_BASE + globalIndex) == 1
end

--- Check if player has completed a room
function LinkedTask.isRoomCompleted(player, roomIndex)
	return player:getStorageValue(LinkedTask.Storages.ROOM_COMPLETE_BASE + roomIndex - 1) == 1
end

--- Get player's current active room (the one they are working on)
function LinkedTask.getActiveRoom(player)
	local val = player:getStorageValue(LinkedTask.Storages.ACTIVE_ROOM)
	if val < 1 then
		return 1 -- starts at room 1
	end
	return val
end

--- Check if player can access a room
function LinkedTask.canAccessRoom(player, roomIndex)
	if roomIndex == 1 then
		return true
	end
	return LinkedTask.isRoomCompleted(player, roomIndex - 1)
end

--- Get the next available task in a room for this player
function LinkedTask.getNextTaskInRoom(player, roomIndex)
	local room = LinkedTask.Rooms[roomIndex]
	if not room then
		return nil
	end
	for taskIndex, _ in ipairs(room.tasks) do
		local globalIndex = LinkedTask.getGlobalIndex(roomIndex, taskIndex)
		if not LinkedTask.isTaskCompleted(player, globalIndex) then
			return taskIndex, globalIndex
		end
	end
	return nil -- all tasks completed
end

--- Check if all tasks in a room are completed
function LinkedTask.areAllTasksCompleted(player, roomIndex)
	local room = LinkedTask.Rooms[roomIndex]
	if not room then
		return false
	end
	for taskIndex, _ in ipairs(room.tasks) do
		local globalIndex = LinkedTask.getGlobalIndex(roomIndex, taskIndex)
		if not LinkedTask.isTaskCompleted(player, globalIndex) then
			return false
		end
	end
	return true
end

--- Get the kills required for a task (task override > room default)
function LinkedTask.getKillsRequired(roomIndex, taskIndex)
	local room = LinkedTask.Rooms[roomIndex]
	if not room then
		return 0
	end
	local task = room.tasks[taskIndex]
	if not task then
		return room.killsRequired
	end
	return task.killsRequired or room.killsRequired
end

--- Get current kill count
function LinkedTask.getKillCount(player)
	local val = player:getStorageValue(LinkedTask.Storages.KILL_COUNT)
	return val > 0 and val or 0
end

--- Get task status
function LinkedTask.getTaskStatus(player)
	local val = player:getStorageValue(LinkedTask.Storages.TASK_STATUS)
	return val > 0 and val or 0
end

--- Get the active task global index
function LinkedTask.getActiveTaskGlobalIndex(player)
	local val = player:getStorageValue(LinkedTask.Storages.ACTIVE_TASK_INDEX)
	return val > 0 and val or 0
end

--- Apply a single reward to player
function LinkedTask.applyReward(player, reward)
	if reward.type == "item" then
		player:addItem(reward.id, reward.count or 1)
		local itemType = ItemType(reward.id)
		local name = itemType and itemType:getName() or ("item " .. reward.id)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE,
			string.format("[Linked Task] Received %dx %s.", reward.count or 1, name))

	elseif reward.type == "storeitem" then
		player:addItemStoreInbox(reward.id, reward.count or 1, false)
		local itemType = ItemType(reward.id)
		local name = itemType and itemType:getName() or ("item " .. reward.id)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE,
			string.format("[Linked Task] Received %dx %s (store inbox).", reward.count or 1, name))

	elseif reward.type == "vocgem" then
		local gemId = LinkedTask.getVocationGemId(player)
		if gemId then
			local count = reward.count or 1
			player:addItem(gemId, count)
			local itemType = ItemType(gemId)
			local name = itemType and itemType:getName() or ("skill gem")
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE,
				string.format("[Linked Task] Received %dx %s.", count, name))
		else
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE,
				"[Linked Task] Could not determine your vocation gem.")
		end

	elseif reward.type == "wheelgreatergem" then
		local gemId = LinkedTask.getWheelGreaterGemId(player)
		if gemId then
			local count = reward.count or 1
			player:addItem(gemId, count)
			local itemType = ItemType(gemId)
			local name = itemType and itemType:getName() or ("greater gem")
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE,
				string.format("[Linked Task] Received %dx %s.", count, name))
		else
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE,
				"[Linked Task] Could not determine your vocation wheel gem.")
		end

	elseif reward.type == "gold" then
		player:setBankBalance(player:getBankBalance() + reward.amount)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE,
			string.format("[Linked Task] Received %s gold (bank).", LinkedTask.formatNumber(reward.amount)))

	elseif reward.type == "experience" then
		player:addExperience(reward.amount, true)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE,
			string.format("[Linked Task] Received %s experience.", LinkedTask.formatNumber(reward.amount)))

	elseif reward.type == "level" then
		for _ = 1, reward.amount do
			local expNeeded = Game.getExperienceForLevel(player:getLevel() + 1) - player:getExperience()
			if expNeeded > 0 then
				player:addExperience(expNeeded, false)
			end
		end
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE,
			string.format("[Linked Task] Gained %d levels!", reward.amount))

	elseif reward.type == "addon" then
		player:addOutfitAddon(reward.looktype, reward.addon)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE,
			"[Linked Task] New addon unlocked!")

	elseif reward.type == "mount" then
		player:addMount(reward.id)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE,
			"[Linked Task] New mount unlocked!")

	elseif reward.type == "bonus_xp" then
		local current = player:getStorageValue(LinkedTask.Storages.BONUS_XP)
		current = current > 0 and current or 0
		player:setStorageValue(LinkedTask.Storages.BONUS_XP, current + reward.amount)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE,
			string.format("[Linked Task] Permanent XP bonus increased by %d%% (total: %d%%)!", reward.amount, current + reward.amount))

	elseif reward.type == "bonus_loot" then
		local current = player:getStorageValue(LinkedTask.Storages.BONUS_LOOT)
		current = current > 0 and current or 0
		player:setStorageValue(LinkedTask.Storages.BONUS_LOOT, current + reward.amount)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE,
			string.format("[Linked Task] Permanent Loot bonus increased by %d%% (total: %d%%)!", reward.amount, current + reward.amount))

	elseif reward.type == "bonus_forge" then
		local current = player:getStorageValue(LinkedTask.Storages.BONUS_FORGE)
		current = current > 0 and current or 0
		player:setStorageValue(LinkedTask.Storages.BONUS_FORGE, current + reward.amount)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE,
			string.format("[Linked Task] Permanent Forge success bonus increased by %d%% (total: %d%%)!", reward.amount, current + reward.amount))
	end
end

--- Apply all rewards from a list
function LinkedTask.applyRewards(player, rewards)
	for _, reward in ipairs(rewards) do
		LinkedTask.applyReward(player, reward)
	end
end

--- Format number with dots (e.g. 1.000.000)
function LinkedTask.formatNumber(n)
	local formatted = tostring(n)
	local k
	while true do
		formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", "%1.%2")
		if k == 0 then
			break
		end
	end
	return formatted
end

--- Get the skill gem item ID for the player's vocation
function LinkedTask.getVocationGemId(player)
	if player:isKnight() then
		return SkillGems.KNIGHT_GEM
	elseif player:isPaladin() then
		return SkillGems.PALADIN_GEM
	elseif player:isMonk() then
		return SkillGems.MONK_GEM
	elseif player:isMage() then
		return SkillGems.MAGE_GEM
	end
	return nil
end

--- Get total permanent bonus for player
function LinkedTask.getPlayerBonusXP(player)
	local val = player:getStorageValue(LinkedTask.Storages.BONUS_XP)
	return val > 0 and val or 0
end

function LinkedTask.getPlayerBonusLoot(player)
	local val = player:getStorageValue(LinkedTask.Storages.BONUS_LOOT)
	return val > 0 and val or 0
end

function LinkedTask.getPlayerBonusForge(player)
	local val = player:getStorageValue(LinkedTask.Storages.BONUS_FORGE)
	return val > 0 and val or 0
end

-- Build lookup tables on load
LinkedTask.buildLookupTables()

print("[LinkedTask] Loaded " .. LinkedTask._totalTasks .. " tasks across " .. #LinkedTask.Rooms .. " rooms")
