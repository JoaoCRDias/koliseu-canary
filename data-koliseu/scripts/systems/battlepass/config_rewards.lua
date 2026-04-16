local BattlePassConfig = {}

-- Season 1: "Relic Hunter"
BattlePassConfig.SEASON_1_ID = 1
BattlePassConfig.SEASON_1_NAME = "Relic Hunter - Season 1"

-- Season 2: "Cosmic Wolfes"
BattlePassConfig.SEASON_2_ID = 2
BattlePassConfig.SEASON_2_NAME = "Cosmic Wolfes - Season 2"

-- Item IDs
BattlePassConfig.ITEM_IDS = {
	REFLECT_POTION = 49272,
	LESSER_XP_POTION = 60303,
	XP_POTION = 60301,
	GREATER_XP_POTION = 60302,
	PREY_WILDCARD = 60101,
	EXERCISE_TOKEN = 60141,
	MYSTERY_BAG = 60077, -- surprise gem bag
	BADGE_PROTECTION_SCROLL = 60463,
	EXPEDITION_BACKPACK = 60416,
	ROULETTE_COIN = 60104,
	BASIC_UPGRADE_STONE = 60429,
	MEDIUM_UPGRADE_STONE = 60428,
	EPIC_UPGRADE_STONE = 60427,
	DUST_POTION = 60146,
	GRAND_SANGUINE_POTION = 60619,
	COSMIC_TRANSFORMATION_SCROLL = 60540,
	FLAME_REAPER_DUMMY = 60620,
	UNREVEALED_RELIC = 60522,
	IMPROVED_SURPRISE_GEM_BAG = 60673,
	RELIC_REVEAL_ENHANCEMENT = 60520,
}

-- Outfit IDs
BattlePassConfig.OUTFIT = {
	MALE_ID = 3096,
	FEMALE_ID = 3095,
	NAME = "Relic Hunter"
}

-- Mount ID (Season 1)
BattlePassConfig.MOUNT_ID = 255 -- Ancient Guardian Drake

-- Mount IDs (Season 2)
BattlePassConfig.SEASON_2_MOUNTS = {
	BROWN_COSMIC_WOLF = 284,
	PURPLE_COSMIC_WOLF = 285,
	BLACK_COSMIC_WOLF = 286,
}

-- Recompensas por dia (15 dias)
BattlePassConfig.REWARDS = {
	-- Dia 1: 10x Reflect Potion
	[1] = {
		description = "10x Reflect Potion",
		type = "items",
		items = {
			{ id = BattlePassConfig.ITEM_IDS.REFLECT_POTION, count = 10 }
		}
	},

	-- Dia 2: 2x de cada exp potion
	[2] = {
		description = "2x Lesser Exp Potion + 2x Exp Potion + 2x Greater Exp Potion",
		type = "items",
		items = {
			{ id = BattlePassConfig.ITEM_IDS.LESSER_XP_POTION, count = 2 },
			{ id = BattlePassConfig.ITEM_IDS.XP_POTION, count = 2 },
			{ id = BattlePassConfig.ITEM_IDS.GREATER_XP_POTION, count = 2 }
		}
	},

	-- Dia 3: 4x Prey Wildcard
	[3] = {
		description = "2x Prey Wildcard",
		type = "items",
		items = {
			{ id = BattlePassConfig.ITEM_IDS.PREY_WILDCARD, count = 2 }
		}
	},

	-- Dia 4: 10x Exercise Token
	[4] = {
		description = "10x Exercise Token",
		type = "items",
		items = {
			{ id = BattlePassConfig.ITEM_IDS.EXERCISE_TOKEN, count = 10 }
		}
	},

	-- Dia 5: 5x Mystery Bag
	[5] = {
		description = "5x Mystery Bag",
		type = "items",
		items = {
			{ id = BattlePassConfig.ITEM_IDS.MYSTERY_BAG, count = 5 }
		}
	},

	-- Dia 6: 3x Badge Protection Scroll
	[6] = {
		description = "3x Badge Protection Scroll",
		type = "items",
		items = {
			{ id = BattlePassConfig.ITEM_IDS.BADGE_PROTECTION_SCROLL, count = 3 }
		}
	},

	-- Dia 7: Expedition Backpack
	[7] = {
		description = "Expedition Backpack",
		type = "items",
		items = {
			{ id = BattlePassConfig.ITEM_IDS.EXPEDITION_BACKPACK, count = 1 }
		}
	},

	-- Dia 8: 10x Roulette Coin
	[8] = {
		description = "10x Roulette Coin",
		type = "items",
		items = {
			{ id = BattlePassConfig.ITEM_IDS.ROULETTE_COIN, count = 10 }
		}
	},

	-- Dia 9: 3x Basic + 3x Medium + 3x Epic Upgrade Stone
	[9] = {
		description = "3x Basic + 3x Medium + 3x Epic Upgrade Stone",
		type = "items",
		items = {
			{ id = BattlePassConfig.ITEM_IDS.BASIC_UPGRADE_STONE, count = 3 },
			{ id = BattlePassConfig.ITEM_IDS.MEDIUM_UPGRADE_STONE, count = 3 },
			{ id = BattlePassConfig.ITEM_IDS.EPIC_UPGRADE_STONE, count = 3 }
		}
	},

	-- Dia 10: 5x Dust Potion
	[10] = {
		description = "5x Dust Potion",
		type = "items",
		items = {
			{ id = BattlePassConfig.ITEM_IDS.DUST_POTION, count = 5 }
		}
	},

	-- Dia 11: Grand Sanguine Potion
	[11] = {
		description = "Grand Sanguine Potion",
		type = "items",
		items = {
			{ id = BattlePassConfig.ITEM_IDS.GRAND_SANGUINE_POTION, count = 1 }
		}
	},

	-- Dia 12: Scroll of Cosmic Transformation
	[12] = {
		description = "Scroll of Cosmic Transformation",
		type = "items",
		items = {
			{ id = BattlePassConfig.ITEM_IDS.COSMIC_TRANSFORMATION_SCROLL, count = 1 }
		}
	},

	-- Dia 13: Flame Reaper Exercise Dummy
	[13] = {
		description = "Flame Reaper Exercise Dummy",
		type = "items",
		items = {
			{ id = BattlePassConfig.ITEM_IDS.FLAME_REAPER_DUMMY, count = 1 }
		}
	},

	-- Dia 14: Mount Ancient Guardian Drake (EXCLUSIVE!)
	[14] = {
		description = "Mount: Ancient Guardian Drake (EXCLUSIVE!)",
		type = "mount",
		mount_id = BattlePassConfig.MOUNT_ID
	},

	-- Dia 15: Outfit Relic Hunter com todos os addons
	[15] = {
		description = "Outfit: Relic Hunter (Full with Addons)",
		type = "outfit_full",
		male_looktype = BattlePassConfig.OUTFIT.MALE_ID,
		female_looktype = BattlePassConfig.OUTFIT.FEMALE_ID
	}
}

-- Season 2 Rewards (15 dias)
BattlePassConfig.SEASON_2_REWARDS = {
	-- Dia 1: 10x Reflect Potion
	[1] = {
		description = "10x Reflect Potion",
		type = "items",
		items = {
			{ id = BattlePassConfig.ITEM_IDS.REFLECT_POTION, count = 10 }
		}
	},

	-- Dia 2: 2x de cada exp potion
	[2] = {
		description = "2x Lesser Exp Potion + 2x Exp Potion + 2x Greater Exp Potion",
		type = "items",
		items = {
			{ id = BattlePassConfig.ITEM_IDS.LESSER_XP_POTION, count = 2 },
			{ id = BattlePassConfig.ITEM_IDS.XP_POTION, count = 2 },
			{ id = BattlePassConfig.ITEM_IDS.GREATER_XP_POTION, count = 2 }
		}
	},

	-- Dia 3: 5x Roulette Coin
	[3] = {
		description = "5x Roulette Coin",
		type = "items",
		items = {
			{ id = BattlePassConfig.ITEM_IDS.ROULETTE_COIN, count = 5 }
		}
	},

	-- Dia 4: 3x Improved Surprise Gem Bag
	[4] = {
		description = "3x Improved Surprise Gem Bag",
		type = "items",
		items = {
			{ id = BattlePassConfig.ITEM_IDS.IMPROVED_SURPRISE_GEM_BAG, count = 3 }
		}
	},

	-- Dia 5: Mount Brown Cosmic Wolf (EXCLUSIVE!)
	[5] = {
		description = "Mount: Brown Cosmic Wolf (EXCLUSIVE!)",
		type = "mount",
		mount_id = BattlePassConfig.SEASON_2_MOUNTS.BROWN_COSMIC_WOLF
	},

	-- Dia 6: 5x Exercise Token
	[6] = {
		description = "5x Exercise Token",
		type = "items",
		items = {
			{ id = BattlePassConfig.ITEM_IDS.EXERCISE_TOKEN, count = 5 }
		}
	},

	-- Dia 7: 2x Unrevealed Relic
	[7] = {
		description = "2x Unrevealed Relic",
		type = "items",
		items = {
			{ id = BattlePassConfig.ITEM_IDS.UNREVEALED_RELIC, count = 2 }
		}
	},

	-- Dia 8: 5x Mystery Bag + 3x Dust Potion
	[8] = {
		description = "5x Mystery Bag + 3x Dust Potion",
		type = "items",
		items = {
			{ id = BattlePassConfig.ITEM_IDS.MYSTERY_BAG, count = 5 },
			{ id = BattlePassConfig.ITEM_IDS.DUST_POTION, count = 3 }
		}
	},

	-- Dia 9: 3x Basic + 3x Medium + 2x Epic Upgrade Stone
	[9] = {
		description = "3x Basic + 3x Medium + 2x Epic Upgrade Stone",
		type = "items",
		items = {
			{ id = BattlePassConfig.ITEM_IDS.BASIC_UPGRADE_STONE, count = 3 },
			{ id = BattlePassConfig.ITEM_IDS.MEDIUM_UPGRADE_STONE, count = 3 },
			{ id = BattlePassConfig.ITEM_IDS.EPIC_UPGRADE_STONE, count = 2 }
		}
	},

	-- Dia 10: Mount Purple Cosmic Wolf (EXCLUSIVE!)
	[10] = {
		description = "Mount: Purple Cosmic Wolf (EXCLUSIVE!)",
		type = "mount",
		mount_id = BattlePassConfig.SEASON_2_MOUNTS.PURPLE_COSMIC_WOLF
	},

	-- Dia 11: 2x Relic Reveal Enhancement + 2x Prey Wildcard
	[11] = {
		description = "2x Relic Reveal Enhancement + 2x Prey Wildcard",
		type = "items",
		items = {
			{ id = BattlePassConfig.ITEM_IDS.RELIC_REVEAL_ENHANCEMENT, count = 2 },
			{ id = BattlePassConfig.ITEM_IDS.PREY_WILDCARD, count = 2 }
		}
	},

	-- Dia 12: 1x Grand Sanguine Potion + 1x Scroll of Cosmic Transformation
	[12] = {
		description = "1x Grand Sanguine Potion + 1x Scroll of Cosmic Transformation",
		type = "items",
		items = {
			{ id = BattlePassConfig.ITEM_IDS.GRAND_SANGUINE_POTION, count = 1 },
			{ id = BattlePassConfig.ITEM_IDS.COSMIC_TRANSFORMATION_SCROLL, count = 1 }
		}
	},

	-- Dia 13: 10x Roulette Coin
	[13] = {
		description = "10x Roulette Coin",
		type = "items",
		items = {
			{ id = BattlePassConfig.ITEM_IDS.ROULETTE_COIN, count = 10 }
		}
	},

	-- Dia 14: 3x Badge Protection Scroll
	[14] = {
		description = "3x Badge Protection Scroll",
		type = "items",
		items = {
			{ id = BattlePassConfig.ITEM_IDS.BADGE_PROTECTION_SCROLL, count = 3 }
		}
	},

	-- Dia 15: Mount Black Cosmic Wolf (EXCLUSIVE!)
	[15] = {
		description = "Mount: Black Cosmic Wolf (EXCLUSIVE!)",
		type = "mount",
		mount_id = BattlePassConfig.SEASON_2_MOUNTS.BLACK_COSMIC_WOLF
	},
}

-- Helper: Get rewards for season
function BattlePassConfig.getSeasonRewards(seasonId)
	if seasonId == BattlePassConfig.SEASON_1_ID then
		return BattlePassConfig.REWARDS
	elseif seasonId == BattlePassConfig.SEASON_2_ID then
		return BattlePassConfig.SEASON_2_REWARDS
	end
	return nil
end

-- Helper: Get reward for specific day
function BattlePassConfig.getDayReward(seasonId, day)
	local rewards = BattlePassConfig.getSeasonRewards(seasonId)
	if not rewards then
		return nil
	end
	return rewards[day]
end

return BattlePassConfig
