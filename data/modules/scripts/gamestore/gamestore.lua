--[[
Items have been updated so that if the offer type is not one of the types: OFFER_TYPE_OUTFIT, OFFER_TYPE_OUTFIT_ADDON,
OFFER_TYPE_MOUNT, OFFER_TYPE_NAMECHANGE, OFFER_TYPE_SEXCHANGE, OFFER_TYPE_PROMOTION, OFFER_TYPE_EXPBOOST,
OFFER_TYPE_PREYSLOT, OFFER_TYPE_PREYBONUS, OFFER_TYPE_TEMPLE, OFFER_TYPE_BLESSINGS, OFFER_TYPE_PREMIUM,
OFFER_TYPE_ALLBLESSINGS
]]

-- Parser
dofile(CORE_DIRECTORY .. "/modules/scripts/gamestore/init.lua")
-- Config

HomeBanners = {
	images = { "/home/fazopix.jpg" },
	delay = 10,
}

local premiumCategoryName = "Premium Time"
local premiumOfferName = "Premium Time"
if configManager.getBoolean(configKeys.VIP_SYSTEM_ENABLED) then
	premiumCategoryName = "VIP Shop"
	premiumOfferName = "VIP"
end

local premiumDescription =
"<i>Enhance your gaming experience by gaining additional abilities and advantages:</i>\n\n&#8226; access to Premium areas\n&#8226; use Tibia's transport system (ships, carpet)\n&#8226; more spells\n&#8226; rent houses\n&#8226; found guilds\n&#8226; offline training\n&#8226; larger depots\n&#8226; and many more\n\n{usablebyallicon} valid for all characters on this account\n{activated}"
if configManager.getBoolean(configKeys.VIP_SYSTEM_ENABLED) then
	local vipBonusExp = configManager.getNumber(configKeys.VIP_BONUS_EXP)
	local vipBonusLoot = configManager.getNumber(configKeys.VIP_BONUS_LOOT)
	local vipBonusSkill = configManager.getNumber(configKeys.VIP_BONUS_SKILL)
	local vipStayOnline = configManager.getBoolean(configKeys.VIP_STAY_ONLINE)

	premiumDescription = "<i>Enhance your gaming experience by gaining advantages:</i>\n\n"
	if vipBonusExp > 0 then
		premiumDescription = premiumDescription .. "&#8226; +" .. vipBonusExp .. "% experience rate\n"
	end
	if vipBonusSkill > 0 then
		premiumDescription = premiumDescription .. "&#8226; +" .. vipBonusSkill .. "% skill training speed\n"
	end
	if vipBonusLoot > 0 then
		premiumDescription = premiumDescription .. "&#8226; +" .. vipBonusLoot .. "% loot\n"
	end
	if vipStayOnline then
		premiumDescription = premiumDescription .. "&#8226; stay online idle without getting disconnected\n"
	end
	premiumDescription = premiumDescription .. "\n{usablebyallicon} valid for all characters on this account\n{activated}"
end

-- GameStore.SearchCategory = {
-- 	icons = {},
-- 	name = "Search Results",
-- 	rookgaard = true,
-- 	state = GameStore.States.STATE_NONE,
-- }

GameStore.Categories = {
	-- Premium Time
	{
		icons = { "Category_PremiumTime.png" },
		name = premiumCategoryName,
		rookgaard = true,
		state = GameStore.States.STATE_NONE,
		offers = {
			{
				icons = { "Premium_Time_30.png" },
				name = string.format("7 Days of %s", premiumOfferName),
				price = 100,
				id = 3007,
				validUntil = 7,
				description = premiumDescription,
				type = GameStore.OfferTypes.OFFER_TYPE_PREMIUM,
			},
			{
				icons = { "Premium_Time_30.png" },
				name = string.format("30 Days of %s", premiumOfferName),
				price = 300,
				id = 3030,
				validUntil = 30,
				description = premiumDescription,
				type = GameStore.OfferTypes.OFFER_TYPE_PREMIUM,
			},
			{
				icons = { "Premium_Time_90.png" },
				name = string.format("90 Days of %s", premiumOfferName),
				price = 750,
				id = 3090,
				validUntil = 90,
				description = premiumDescription,
				type = GameStore.OfferTypes.OFFER_TYPE_PREMIUM,
			},
			{
				icons = { "Premium_Time_180.png" },
				name = string.format("180 Days of %s", premiumOfferName),
				price = 1250,
				id = 3180,
				validUntil = 180,
				description = premiumDescription,
				type = GameStore.OfferTypes.OFFER_TYPE_PREMIUM,
			},
			{
				icons = { "Premium_Time_360.png" },
				name = string.format("360 Days of %s", premiumOfferName),
				price = 2300,
				id = 3360,
				validUntil = 360,
				description = premiumDescription,
				type = GameStore.OfferTypes.OFFER_TYPE_PREMIUM,
			},
		},
	},
	-- Packages and Bundles
	{
		icons = { "Category_Bundles.png" },
		name = "Packages and Bundles",
		rookgaard = true,
		offers = {
			{
				name = "Starter Bundle",
				price = 1500,
				itemtype = 60036,
				count = 1,
				movable = false,
				onePerAccount = true,
				description =
				"<i>The essential starter kit for new adventurers!</i>\n\n<b>Contains:</b>\n 3x Boosted Exercise Weapon\n 3x Exercise Token\n 1x Exercise Speed Improvement\n 2x Lesser Exp Potion\n 1x Exp Potion\n 3x Surprise Gem Bag\n 1x Training Dummy\n 1x Starlight Power\n 1x Premium Scroll\n 1x Prey Wildcard\n\nWarning: Can only be purchased once per account!",
				type = GameStore.OfferTypes.OFFER_TYPE_ITEM,
			},
			{
				name = "Common Training Bundle",
				price = 150,
				itemtype = 60614,
				count = 1,
				movable = true,
				description = "<i>A basic training package.</i>\n\n<b>Contains:</b>\n 3x Boosted Exercise Token\n 1x Exercise Speed Improvement",
				type = GameStore.OfferTypes.OFFER_TYPE_ITEM,
			},
			{
				name = "Rare Training Bundle",
				price = 250,
				itemtype = 60613,
				count = 1,
				movable = true,
				description = "<i>An advanced training package.</i>\n\n<b>Contains:</b>\n 5x Boosted Exercise Token\n 3x Exercise Speed Improvement",
				type = GameStore.OfferTypes.OFFER_TYPE_ITEM,
			},
			{
				name = "Starter Package",
				price = 1000,
				itemtype = 63375,
				count = 1,
				movable = true,
				description =
				"<i>The perfect package for beginners!</i>\n\n<b>April Edition - Contains:</b>\n\n 1x Premium Scroll\n\n 1x Mystery Bag\n\n 1x Bag You Desire\n\n 1x Prey Wildcard\n\n 2x Surprise Gem Bag\n\n 1x Exp Potion\n\n 2x Lesser Exp Potion\n\n 1x Boosted Exercise Token\n\n 4x Roulette Coin\n\n 30x Cosmic Token\n\n 1x Exercise Speed Improvement\n\n 1x Random Elemental Protector\n\n 1x Star Backpack\n\n\n<b>BONUS:</b>\n\n Mount: Brown Cosmic Wolf\n\n\n{info} Can be traded in the Market!",
				type = GameStore.OfferTypes.OFFER_TYPE_ITEM,
			},
			{
				name = "Standard Package",
				price = 2000,
				itemtype = 63376,
				count = 1,
				movable = true,
				description =
				"<i>Great value package with premium items!</i>\n\n<b>April Edition - Contains:</b>\n\n 1x Premium Scroll\n\n 2x Mystery Bag\n\n 1x Bag You Desire\n\n 1x Primal Bag\n\n 3x Exp Potion\n\n 3x Lesser Exp Potion\n\n 2x Prey Wildcard\n\n 8x Roulette Coin\n\n 60x Cosmic Token\n\n 4x Surprise Gem Bag\n\n 3x Boosted Exercise Token\n\n 1x Exercise Speed Improvement\n\n 1x Starlight Power\n\n 1x Wilduck Backpack\n\n 1x Random Store Dummy\n\n\n<b>BONUS:</b>\n\n Mount: Purple Cosmic Wolf\n\n\n{info} Can be traded in the Market!",
				type = GameStore.OfferTypes.OFFER_TYPE_ITEM,
			},
			{
				name = "Booster Package",
				price = 4000,
				itemtype = 63374,
				count = 1,
				movable = true,
				description =
				"<i>The ULTIMATE package with exclusive rewards!</i>\n\n<b>April Edition - Contains:</b>\n\n 1x Premium Scroll\n\n 3x Mystery Bag\n\n 2x Bag You Covet\n\n 2x Primal Bag\n\n 2x Bag You Desire\n\n 3x Prey Wildcard\n\n 4x Surprise Gem Bag\n\n 12x Roulette Coin\n\n 100x Cosmic Token\n\n 1x Improved Surprise Gem Bag\n\n 5x Boosted Exercise Token\n\n 3x Exercise Speed Improvement\n\n 3x Greater Exp Potion\n\n 3x Exp Potion\n\n 3x Lesser Exp Potion\n\n 1x Sight of Truth\n\n 1x Ironlord Backpack\n\n 1x Random Store Dummy\n\n\n<b>EXCLUSIVE BONUSES:</b>\n\n Mount: Black Cosmic Wolf\n\n Outfit: Dark Wing with full addons\n\n\n{info} Can be traded in the Market!",
				type = GameStore.OfferTypes.OFFER_TYPE_ITEM,
			},
		},
	},

	-- Exclusive
	{
		icons = { "Category_ExclusiveOffers.png" },
		name = "Exclusives",
		rookgaard = true,
		subclasses = { "Tokens", "Items", "Specials", "Forge System" },
	},

	{
		icons = { "Category_Tickets.png" },
		name = "Tokens",
		parent = "Exclusives",
		rookgaard = true,
		state = GameStore.States.STATE_NONE,
		offers = {
			{
				name = "Roulette Token",
				price = 50,
				itemtype = 60104,
				count = 1,
				movable = true,
				description = "<i>Test your lucky</i>",
				type = GameStore.OfferTypes.OFFER_TYPE_STACKABLE,
			},
			{
				name = "Roulette Token",
				price = 400,
				itemtype = 60104,
				movable = true,
				count = 10,
				description = "<i>Test your lucky</i>",
				type = GameStore.OfferTypes.OFFER_TYPE_STACKABLE,
			},
		},
	},
	{
		icons = { "Category_ExclusiveOffers.png" },
		name = "Items",
		parent = "Exclusives",
		rookgaard = true,
		state = GameStore.States.STATE_NONE,
		offers = {
			{
				name = "Supreme Cube",
				price = 100,
				itemtype = 31633,
				count = 1,
				description = "<i>Teleport to any city or house</i>\n\nCD 1 minute.",
				type = GameStore.OfferTypes.OFFER_TYPE_ITEM,
			},
			{
				name = "Professional Fishing Rod",
				price = 400,
				itemtype = 60674,
				count = 1,
				movable = false,
				description = "<i>A high-quality fishing rod crafted by master artisans.</i>\n\nGrants <b>double fishing skill tries</b> per use compared to a normal fishing rod.",
				type = GameStore.OfferTypes.OFFER_TYPE_ITEM,
			},
			{
				name = "Starlight Power",
				price = 1000,
				itemtype = 60148,
				movable = true,
				home = true,
				count = 1,
				description = "<i>protection all +6%</i>\n<i>skill boost axe +2</i>\n<i>skill boost sword +2</i>\n<i>skill boost club +2</i>\n<i>skill boost fist +2</i>\n<i>skill boost shielding +2</i>\n<i>skill boost distance +2</i>\n<i>skill boost magic level +2</i>\n<i>critical hit +2</i>\n<i>imbue slot: 2</i>",
				type = GameStore.OfferTypes.OFFER_TYPE_ITEM,
			},
			{
				name = "Relic Reveal Enhancement",
				price = 50,
				coinType = GameStore.CoinType.Transferable,
				itemtype = 60520,
				count = 1,
				movable = true,
				description = "<i>Enhance your relic reveal!</i>\n\n{character}\n{storeinbox}\n{info} use together with a Relic Revealer to improve reveal chances\n{info} increases the chance of getting a higher rarity relic",
				type = GameStore.OfferTypes.OFFER_TYPE_STACKABLE,
			},
			{
				name = "Mystery Bag",
				price = 100,
				itemtype = 60077,
				movable = true,
				count = 1,
				description = "<i>See available rewards on website.</i>",
				type = GameStore.OfferTypes.OFFER_TYPE_STACKABLE,
			},
			{
				name = "Mystery Bag",
				price = 900,
				itemtype = 60077,
				movable = true,
				count = 10,
				description = "<i>See available rewards on website.</i>",
				type = GameStore.OfferTypes.OFFER_TYPE_STACKABLE,
			},
			{
				name = "Upgrade Transfer Token",
				price = 25,
				itemtype = 60430,
				movable = true,
				count = 1,
				description = "<i>Extract weapon upgrades and transfer them to another weapon.\n\nHow to use:\n1. Use on an upgraded weapon to extract its upgrade level\n2. Use the charged token on another weapon to apply the upgrade\n\nPerfect for transferring upgrades when you get a new weapon!</i>",
				type = GameStore.OfferTypes.OFFER_TYPE_ITEM,
			},
			{
				name = "Skill Transfer Token",
				price = 25,
				itemtype = 60431,
				movable = true,
				count = 1,
				description = "<i>Extract skill bonuses from equipment and transfer them to another piece.\n\nHow to use:\n1. Use on equipment with skill bonuses to extract them\n2. Use the charged token on another equipment to apply the bonuses\n\nWorks with helmets, armors, legs and boots!</i>",
				type = GameStore.OfferTypes.OFFER_TYPE_ITEM,
			},
			{
				name = "Tier Transfer Token",
				price = 25,
				itemtype = 60636,
				count = 1,
				movable = true,
				description = "<i>Transfer item tiers between equipment pieces!</i>\n\n{character}\n{storeinbox}\n{info} use on tiered item to extract tier level\n{info} then use on another item to apply the tier\n{info} perfect for moving tiers to better equipment",
				type = GameStore.OfferTypes.OFFER_TYPE_STACKABLE,
			},
		},
	},
	{
		icons = { "Category_ExclusiveOffers.png" },
		name = "Specials",
		parent = "Exclusives",
		rookgaard = true,
		state = GameStore.States.STATE_NONE,
		offers = {
			{
				name = "Infinite Pizza",
				price = 50,
				itemtype = 60023,
				movable = true,
				count = 1,
				description = "<i>Never worry about food again!</i>\n\n{character}\n{storeinbox}\n{info} infinite uses - never gets consumed\n{info} restores 22 hunger points per use\n{info} grants the same vocation-specific buffs as Berserk/Mastermind/Bullseye/Transcendence potions when eaten\n{info} stacks with spells such as utito tempo and utito tempo san",
				type = GameStore.OfferTypes.OFFER_TYPE_ITEM,
			},
			{
				name = "Skull Remover",
				price = 250,
				itemtype = 60100,
				movable = true,
				count = 1,
				description = "<i>Remove your red/black skull</i>",
				type = GameStore.OfferTypes.OFFER_TYPE_ITEM,
			},

			{
				name = "Infinite Boss CD Reducer",
				price = 350,
				itemtype = 16262,
				movable = false,
				count = 1,
				description = "<i>Sets all boss cooldowns above 8 hours to exactly 8 hours.\nCan be used unlimited times with no cooldown.</i>",
				type = GameStore.OfferTypes.OFFER_TYPE_ITEM_UNIQUE,
			},
			{
				name = "Ring Pouch",
				price = 200,
				itemtype = 60162,
				count = 1,
				movable = false,
				description = "<i>Load as many rings as you want</i>",
				type = GameStore.OfferTypes.OFFER_TYPE_ITEM_UNIQUE,
			},
			{
				name = "Amulet Pouch",
				price = 200,
				itemtype = 60161,
				movable = false,
				count = 1,

				description = "<i>Load as many amulets as you want</i>",
				type = GameStore.OfferTypes.OFFER_TYPE_ITEM_UNIQUE,
			},
			{
				name = "Gem Extender",
				price = 500,
				icons = { "Gem_Extender.png" },
				home = true,
				description = "<i>Unlocks the third slot of your Gem Bag, granting access to all gem slots.</i>",
				type = GameStore.OfferTypes.OFFER_TYPE_GEM_EXTENDER,
			},
			{
				name = "Task Enhancement",
				price = 350,
				icons = { "Task_Enhancement.png" },
				home = true,
				description = "<i>While VIP: tasks auto-claim rewards, auto-restart, +1000 Hunting Task Points per completion, and daily task limit increased to 4 (shared across all tiers).</i>",
				type = GameStore.OfferTypes.OFFER_TYPE_TASK_ENHANCEMENT,
			},
			{
				name = "Mining Boost",
				price = 250,
				icons = { "Mining_Boost.png" },
				home = true,
				description = "<i>Permanently boosts your mining efficiency:</i>\n\n&#8226; +1 extra mining try per tick (4 instead of 3)\n&#8226; +5% mining success chance\n\n{permanenticon} permanent upgrade for this character",
				type = GameStore.OfferTypes.OFFER_TYPE_MINING_BOOST,
			},
			{
				name = "Surprise Gem Bag",
				price = 25,
				itemtype = 60316,
				movable = true,
				home = true,
				count = 1,
				description = "<i>Give you a random level 1 gem by using it.</i>",
				type = GameStore.OfferTypes.OFFER_TYPE_STACKABLE,
			},
			{
				name = "Surprise Gem Bag",
				price = 200,
				itemtype = 60316,
				movable = true,
				count = 10,
				description = "<i>Give you a random level 1 gem by using it.</i>",
				type = GameStore.OfferTypes.OFFER_TYPE_STACKABLE,
			},
		},
	},
	{
		icons = { "Category_ExclusiveOffers.png" },
		name = "Forge System",
		parent = "Exclusives",
		rookgaard = true,
		state = GameStore.States.STATE_NONE,
		offers = {
			{
				name = "Dust Potion",
				price = 25,
				itemtype = 60146,
				movable = true,
				count = 1,
				description = "<i>Fill all your dust limit</i>",
				type = GameStore.OfferTypes.OFFER_TYPE_ITEM,
			},
		},
	},
	-- {
	-- 	icons = { "Category_ExclusiveOffers.png" },
	-- 	name = "Battle Pass",
	-- 	parent = "Exclusives",
	-- 	rookgaard = true,
	-- 	state = GameStore.States.STATE_NONE,
	-- 	offers = {
	-- 		{
	-- 			name = "Battle Pass - Season 2",
	-- 			price = 2000,
	-- 			itemtype = 60422,
	-- 			count = 1,
	-- 			movable = false,
	-- 			description =
	-- 			"<i>Unlock daily rewards for 15 days!</i>\n\n<b>Cosmic Wolfes - Season 2</b>\n\n<b>Rewards:</b>\nDay 1: 10x Reflect Potion\nDay 2: 2x Lesser + 2x Normal + 2x Greater Exp Potion\nDay 3: 5x Roulette Coin\nDay 4: 3x Improved Surprise Gem Bag\nDay 5: Mount: Brown Cosmic Wolf (EXCLUSIVE!)\nDay 6: 5x Exercise Token\nDay 7: 2x Unrevealed Relic\nDay 8: 5x Mystery Bag + 3x Dust Potion\nDay 9: 3x Basic + 3x Medium + 2x Epic Upgrade Stone\nDay 10: Mount: Purple Cosmic Wolf (EXCLUSIVE!)\nDay 11: 2x Relic Reveal Enhancement + 2x Prey Wildcard\nDay 12: Grand Sanguine Potion + Scroll of Cosmic Transformation\nDay 13: 10x Roulette Coin\nDay 14: 3x Badge Protection Scroll\nDay 15: Mount: Black Cosmic Wolf (EXCLUSIVE!)",
	-- 			type = GameStore.OfferTypes.OFFER_TYPE_ITEM_UNIQUE,
	-- 		},
	-- 	},
	-- },
	-- Consumables
	{
		icons = { "Category_Consumables.png" },
		name = "Consumables",
		rookgaard = true,
		subclasses = { "Infinite Kegs", "Exercise Weapons" },
	},
	-- Consumables ~ Kegs
	{
		icons = { "Category_Kegs.png" },
		name = "Infinite Kegs",
		parent = "Consumables",
		rookgaard = true,
		state = GameStore.States.STATE_NONE,
		offers = {
			{
				icons = { "Supreme_Health_Keg.png" },
				name = "Cosmic Health Keg",
				price = 300,
				itemtype = 25907,
				description = "<i>Provide you 500 Cosmic health potions at the same price of NPC!</i>",
				type = GameStore.OfferTypes.OFFER_TYPE_ITEM_UNIQUE,
			},
			{
				icons = { "Ultimate_Mana_Keg.png" },
				name = "Cosmic Mana Keg",
				price = 300,
				itemtype = 25911,
				description = "<i>Provide you 500 Cosmic mana potion at the same price of NPC!</i>",
				type = GameStore.OfferTypes.OFFER_TYPE_ITEM_UNIQUE,
			},
			{
				icons = { "Ultimate_Spirit_Keg.png" },
				name = "Cosmic Spirit Keg",
				price = 300,
				itemtype = 25914,
				description = "<i>Provide you 500 Cosmic spirit potions at the same price of NPC!</i>",
				type = GameStore.OfferTypes.OFFER_TYPE_ITEM_UNIQUE,
			},
		},
	},
	-- Consumables ~ Exercise Weapons
	{
		icons = { "Category_ExerciseWeapons.png" },
		name = "Exercise Weapons",
		parent = "Consumables",
		rookgaard = true,
		state = GameStore.States.STATE_NONE,
		offers = {
			{
				icons = { "Lasting_Exercise_Axe.png" },
				name = "Lasting Exercise Axe",
				price = 20,
				itemtype = 35286,
				charges = 14400,
				description = "<i>Use it to train your axe fighting skill on an exercise dummy!</i>\n\n{character}\n{storeinbox}\n{info} use it on an exercise dummy to train your axe fighting skill\n{info} usable 14400 times a piece",
				type = GameStore.OfferTypes.OFFER_TYPE_CHARGES,
			},
			{
				icons = { "Lasting_Exercise_Bow.png" },
				name = "Lasting Exercise Bow",
				price = 20,
				itemtype = 35288,
				charges = 14400,
				description = "<i>Use it to train your distance fighting skill on an exercise dummy!</i>\n\n{character}\n{storeinbox}\n{info} use it on an exercise dummy to train your distance fighting skill\n{info} usable 14400 times a piece",
				type = GameStore.OfferTypes.OFFER_TYPE_CHARGES,
			},
			{
				icons = { "Lasting_Exercise_Club.png" },
				name = "Lasting Exercise Club",
				price = 20,
				itemtype = 35287,
				charges = 14400,
				description = "<i>Use it to train your club fighting skill on an exercise dummy!</i>\n\n{character}\n{storeinbox}\n{info} use it on an exercise dummy to train your club fighting skill\n{info} usable 14400 times a piece",
				type = GameStore.OfferTypes.OFFER_TYPE_CHARGES,
			},
			{
				icons = { "Lasting_Exercise_Rod.png" },
				name = "Lasting Exercise Rod",
				price = 20,
				itemtype = 35289,
				charges = 14400,
				description = "<i>Use it to train your magic level on an exercise dummy!</i>\n\n{character}\n{storeinbox}\n{info} use it on an exercise dummy to train your magic level\n{info} usable 14400 times a piece",
				type = GameStore.OfferTypes.OFFER_TYPE_CHARGES,
			},
			{
				icons = { "Lasting_Exercise_Sword.png" },
				name = "Lasting Exercise Sword",
				price = 20,
				itemtype = 35285,
				charges = 14400,
				description = "<i>Use it to train your sword fighting skill on an exercise dummy!</i>\n\n{character}\n{storeinbox}\n{info} use it on an exercise dummy to train your sword fighting skill\n{info} usable 14400 times a piece",
				type = GameStore.OfferTypes.OFFER_TYPE_CHARGES,
			},
			{
				icons = { "Lasting_Exercise_Wand.png" },
				name = "Lasting Exercise Wand",
				price = 20,
				itemtype = 35290,
				charges = 14400,
				description = "<i>Use it to train your magic level on an exercise dummy!</i>\n\n{character}\n{storeinbox}\n{info} use it on an exercise dummy to train your magic level\n{info} usable 14400 times a piece",
				type = GameStore.OfferTypes.OFFER_TYPE_CHARGES,
			},
			{
				icons = { "Lasting_Exercise_Shield.png" },
				name = "Lasting Exercise Shield",
				price = 20,
				itemtype = 44067,
				charges = 14400,
				description = "<i>Use it to train your shielding skill on an exercise dummy!</i>\n\n{character}\n{storeinbox}\n{info} use it on an exercise dummy to train your shielding skill\n{info} usable 14400 times a piece",
				type = GameStore.OfferTypes.OFFER_TYPE_CHARGES,
			},
			{
				name = "Lasting Exercise Wraps",
				price = 20,
				itemtype = 50295,
				charges = 14400,
				description = "<i>Use it to train your fisting skill on an exercise dummy!</i>\n\n{character}\n{storeinbox}\n{info} use it on an exercise dummy to train your fist skill\n{info} usable 14400 times a piece",
				type = GameStore.OfferTypes.OFFER_TYPE_CHARGES,
			},
		},
	},
	-- Cosmetics
	{
		icons = { "Category_Cosmetics.png" },
		name = "Cosmetics",
		rookgaard = true,
		subclasses = { "Mounts", "Outfits", "Magic Wall Skins" },
	},
	{
		icons = { "Category_Outfits.png" },
		name = "Outfits",
		parent = "Cosmetics",
		rookgaard = true,
		state = GameStore.States.STATE_NONE,
		offers = {
			{ name = "Physical Adept", price = 190, sexId = { female = 3003, male = 3004 }, addon = 3, description = "Unleash raw physical power with the Physical Adept outfit!\n+1% Max HP / +1% Max MP\n+100 Capacity\n+1 Magic Level\n+1 All Skills (Fist, Club, Axe, Sword, Distance, Shielding)", type = GameStore.OfferTypes.OFFER_TYPE_OUTFIT },
			{ name = "Cursed Skeleton", price = 190, sexId = { female = 3007, male = 3007 }, addon = 3, description = "Channel the power of the undead with Cursed Skeleton!\n+1% Max HP / +1% Max MP\n+100 Capacity\n+1 Magic Level\n+1 All Skills (Fist, Club, Axe, Sword, Distance, Shielding)", type = GameStore.OfferTypes.OFFER_TYPE_OUTFIT },
			{ name = "Rotten Wizard", price = 190, sexId = { female = 3008, male = 3008 }, addon = 3, description = "Command dark magic with the Rotten Wizard!\n+1% Max HP / +1% Max MP\n+100 Capacity\n+1 Magic Level\n+1 All Skills (Fist, Club, Axe, Sword, Distance, Shielding)", type = GameStore.OfferTypes.OFFER_TYPE_OUTFIT },
			{ name = "Cosmic Adept", price = 190, sexId = { female = 3133, male = 3132 }, addon = 3, description = "Command the cosmic forces with Cosmic Adept!\n+1% Max HP / +1% Max MP\n+100 Capacity\n+1 Magic Level\n+1 All Skills (Fist, Club, Axe, Sword, Distance, Shielding)", type = GameStore.OfferTypes.OFFER_TYPE_OUTFIT },
			{ name = "Royal Clothing", price = 190, sexId = { female = 3021, male = 3020 }, addon = 3, description = "Dress in royalty with the Royal Clothing!\n+1% Max HP / +1% Max MP\n+100 Capacity\n+1 Magic Level\n+1 All Skills (Fist, Club, Axe, Sword, Distance, Shielding)", type = GameStore.OfferTypes.OFFER_TYPE_OUTFIT },
			{ name = "Bodybuilder", price = 190, sexId = { female = 3024, male = 3023 }, addon = 3, description = "Show off your strength with Bodybuilder!\n+1% Max HP / +1% Max MP\n+100 Capacity\n+1 Magic Level\n+1 All Skills (Fist, Club, Axe, Sword, Distance, Shielding)", type = GameStore.OfferTypes.OFFER_TYPE_OUTFIT },
			{ name = "Ice Adept", price = 190, sexId = { female = 3038, male = 3045 }, addon = 3, description = "Master the power of frost with Ice Adept!\n+1% Max HP / +1% Max MP\n+100 Capacity\n+1 Magic Level\n+1 All Skills (Fist, Club, Axe, Sword, Distance, Shielding)", type = GameStore.OfferTypes.OFFER_TYPE_OUTFIT },
			{ name = "Energy Adept", price = 190, sexId = { female = 3040, male = 3039 }, addon = 3, description = "Harness electric power with Energy Adept!\n+1% Max HP / +1% Max MP\n+100 Capacity\n+1 Magic Level\n+1 All Skills (Fist, Club, Axe, Sword, Distance, Shielding)", type = GameStore.OfferTypes.OFFER_TYPE_OUTFIT },
			{ name = "Earth Adept", price = 190, sexId = { female = 3042, male = 3041 }, addon = 3, description = "Control nature's might with Earth Adept!\n+1% Max HP / +1% Max MP\n+100 Capacity\n+1 Magic Level\n+1 All Skills (Fist, Club, Axe, Sword, Distance, Shielding)", type = GameStore.OfferTypes.OFFER_TYPE_OUTFIT },
			{ name = "Fire Adept", price = 190, sexId = { female = 3044, male = 3043 }, addon = 3, description = "Wield flames of destruction with Fire Adept!\n+1% Max HP / +1% Max MP\n+100 Capacity\n+1 Magic Level\n+1 All Skills (Fist, Club, Axe, Sword, Distance, Shielding)", type = GameStore.OfferTypes.OFFER_TYPE_OUTFIT },
			{ name = "Divine Vassal", price = 190, sexId = { female = 3046, male = 3047 }, addon = 3, description = "Embrace holy power with Divine Vassal!\n+1% Max HP / +1% Max MP\n+100 Capacity\n+1 Magic Level\n+1 All Skills (Fist, Club, Axe, Sword, Distance, Shielding)", type = GameStore.OfferTypes.OFFER_TYPE_OUTFIT },
			{ name = "Hidden Demon", price = 190, sexId = { female = 3049, male = 3048 }, addon = 3, description = "Conceal demonic power with Hidden Demon!\n+1% Max HP / +1% Max MP\n+100 Capacity\n+1 Magic Level\n+1 All Skills (Fist, Club, Axe, Sword, Distance, Shielding)", type = GameStore.OfferTypes.OFFER_TYPE_OUTFIT },
			{ name = "Dwilight", price = 190, sexId = { female = 3051, male = 3050 }, addon = 3, description = "Command twilight magic with Dwilight!\n+1% Max HP / +1% Max MP\n+100 Capacity\n+1 Magic Level\n+1 All Skills (Fist, Club, Axe, Sword, Distance, Shielding)", type = GameStore.OfferTypes.OFFER_TYPE_OUTFIT },
			{ name = "Crusher", price = 190, sexId = { female = 3056, male = 3055 }, addon = 3, description = "Dominate with brute force as Crusher!\n+1% Max HP / +1% Max MP\n+100 Capacity\n+1 Magic Level\n+1 All Skills (Fist, Club, Axe, Sword, Distance, Shielding)", type = GameStore.OfferTypes.OFFER_TYPE_OUTFIT },
			{ name = "Darkness Warrior", price = 190, sexId = { female = 3059, male = 3058 }, addon = 3, description = "Embrace shadow combat with Darkness Warrior!\n+1% Max HP / +1% Max MP\n+100 Capacity\n+1 Magic Level\n+1 All Skills (Fist, Club, Axe, Sword, Distance, Shielding)", type = GameStore.OfferTypes.OFFER_TYPE_OUTFIT },
			{ name = "Platinum", price = 190, sexId = { female = 3061, male = 3060 }, addon = 3, description = "Shine with platinum elegance!\n+1% Max HP / +1% Max MP\n+100 Capacity\n+1 Magic Level\n+1 All Skills (Fist, Club, Axe, Sword, Distance, Shielding)", type = GameStore.OfferTypes.OFFER_TYPE_OUTFIT },
			{ name = "Crystal", price = 190, sexId = { female = 3063, male = 3062 }, addon = 3, description = "Radiate crystalline power with Crystal!\n+1% Max HP / +1% Max MP\n+100 Capacity\n+1 Magic Level\n+1 All Skills (Fist, Club, Axe, Sword, Distance, Shielding)", type = GameStore.OfferTypes.OFFER_TYPE_OUTFIT },
			{ name = "Skull Master", price = 190, sexId = { female = 3066, male = 3067 }, addon = 3, description = "Command death itself with Skull Master!\n+1% Max HP / +1% Max MP\n+100 Capacity\n+1 Magic Level\n+1 All Skills (Fist, Club, Axe, Sword, Distance, Shielding)", type = GameStore.OfferTypes.OFFER_TYPE_OUTFIT },
			{ name = "Monk Warlord", price = 190, sexId = { female = 1936, male = 1937 }, addon = 3, description = "Unleash martial fury with the Monk Warlord!\n+1% Max HP / +1% Max MP\n+100 Capacity\n+1 Magic Level\n+1 All Skills (Fist, Club, Axe, Sword, Distance, Shielding)", type = GameStore.OfferTypes.OFFER_TYPE_OUTFIT },
			{ name = "Sun Servant", price = 190, sexId = { female = 1920, male = 1921 }, addon = 3, description = "Bask in radiant glory with the Sun Servant!\n+1% Max HP / +1% Max MP\n+100 Capacity\n+1 Magic Level\n+1 All Skills (Fist, Club, Axe, Sword, Distance, Shielding)", type = GameStore.OfferTypes.OFFER_TYPE_OUTFIT },
			{ name = "Feral Trapper", price = 190, sexId = { female = 1907, male = 1906 }, addon = 3, description = "Hunt with primal instinct as the Feral Trapper!\n+1% Max HP / +1% Max MP\n+100 Capacity\n+1 Magic Level\n+1 All Skills (Fist, Club, Axe, Sword, Distance, Shielding)", type = GameStore.OfferTypes.OFFER_TYPE_OUTFIT },
			{ name = "Special Warrior", price = 190, sexId = { female = 7282, male = 7281 }, addon = 3, description = "Unleash the power of the Special Warrior!\n+1% Max HP / +1% Max MP\n+100 Capacity\n+1 Magic Level\n+1 All Skills (Fist, Club, Axe, Sword, Distance, Shielding)", type = GameStore.OfferTypes.OFFER_TYPE_OUTFIT },
			{ name = "Special Warrior Death", price = 190, sexId = { female = 7284, male = 7283 }, addon = 3, description = "Embrace death's power with Special Warrior Death!\n+1% Max HP / +1% Max MP\n+100 Capacity\n+1 Magic Level\n+1 All Skills (Fist, Club, Axe, Sword, Distance, Shielding)", type = GameStore.OfferTypes.OFFER_TYPE_OUTFIT },
			{ name = "Special Warrior Energy", price = 190, sexId = { female = 7286, male = 7285 }, addon = 3, description = "Channel electric fury with Special Warrior Energy!\n+1% Max HP / +1% Max MP\n+100 Capacity\n+1 Magic Level\n+1 All Skills (Fist, Club, Axe, Sword, Distance, Shielding)", type = GameStore.OfferTypes.OFFER_TYPE_OUTFIT },
			{ name = "Special Citizen Earth", price = 190, sexId = { female = 7288, male = 7287 }, addon = 3, description = "Command nature's might with Special Citizen Earth!\n+1% Max HP / +1% Max MP\n+100 Capacity\n+1 Magic Level\n+1 All Skills (Fist, Club, Axe, Sword, Distance, Shielding)", type = GameStore.OfferTypes.OFFER_TYPE_OUTFIT },
			{ name = "Special Citizen Death", price = 190, sexId = { female = 7290, male = 7289 }, addon = 3, description = "Wield dark forces with Special Citizen Death!\n+1% Max HP / +1% Max MP\n+100 Capacity\n+1 Magic Level\n+1 All Skills (Fist, Club, Axe, Sword, Distance, Shielding)", type = GameStore.OfferTypes.OFFER_TYPE_OUTFIT },
			{ name = "Special Citizen Energy", price = 190, sexId = { female = 7292, male = 7291 }, addon = 3, description = "Harness lightning with Special Citizen Energy!\n+1% Max HP / +1% Max MP\n+100 Capacity\n+1 Magic Level\n+1 All Skills (Fist, Club, Axe, Sword, Distance, Shielding)", type = GameStore.OfferTypes.OFFER_TYPE_OUTFIT },
			{ name = "Special Citizen Ice", price = 190, sexId = { female = 7294, male = 7293 }, addon = 3, description = "Master the cold with Special Citizen Ice!\n+1% Max HP / +1% Max MP\n+100 Capacity\n+1 Magic Level\n+1 All Skills (Fist, Club, Axe, Sword, Distance, Shielding)", type = GameStore.OfferTypes.OFFER_TYPE_OUTFIT },
			{ name = "Special Citizen Fire", price = 190, sexId = { female = 7296, male = 7295 }, addon = 3, description = "Blaze with power as Special Citizen Fire!\n+1% Max HP / +1% Max MP\n+100 Capacity\n+1 Magic Level\n+1 All Skills (Fist, Club, Axe, Sword, Distance, Shielding)", type = GameStore.OfferTypes.OFFER_TYPE_OUTFIT },
			{ name = "Special Citizen Holy", price = 190, sexId = { female = 7298, male = 7297 }, addon = 3, description = "Radiate divine light with Special Citizen Holy!\n+1% Max HP / +1% Max MP\n+100 Capacity\n+1 Magic Level\n+1 All Skills (Fist, Club, Axe, Sword, Distance, Shielding)", type = GameStore.OfferTypes.OFFER_TYPE_OUTFIT },
			{ name = "Special Warrior Ice", price = 190, sexId = { female = 7300, male = 7299 }, addon = 3, description = "Freeze your enemies with Special Warrior Ice!\n+1% Max HP / +1% Max MP\n+100 Capacity\n+1 Magic Level\n+1 All Skills (Fist, Club, Axe, Sword, Distance, Shielding)", type = GameStore.OfferTypes.OFFER_TYPE_OUTFIT },
			{ name = "Special Warrior Holy", price = 190, sexId = { female = 7302, male = 7301 }, addon = 3, description = "Shine with holy power as Special Warrior Holy!\n+1% Max HP / +1% Max MP\n+100 Capacity\n+1 Magic Level\n+1 All Skills (Fist, Club, Axe, Sword, Distance, Shielding)", type = GameStore.OfferTypes.OFFER_TYPE_OUTFIT },
			{ name = "Special Warrior Earth", price = 190, sexId = { female = 7304, male = 7303 }, addon = 3, description = "Wield earth's fury with Special Warrior Earth!\n+1% Max HP / +1% Max MP\n+100 Capacity\n+1 Magic Level\n+1 All Skills (Fist, Club, Axe, Sword, Distance, Shielding)", type = GameStore.OfferTypes.OFFER_TYPE_OUTFIT },
			{ name = "Special Warrior Fire", price = 190, sexId = { female = 7306, male = 7305 }, addon = 3, description = "Burn with fiery wrath as Special Warrior Fire!\n+1% Max HP / +1% Max MP\n+100 Capacity\n+1 Magic Level\n+1 All Skills (Fist, Club, Axe, Sword, Distance, Shielding)", type = GameStore.OfferTypes.OFFER_TYPE_OUTFIT },
		},
	},
	{
		icons = { "Category_Mounts.png" },
		name = "Mounts",
		parent = "Cosmetics",
		rookgaard = true,
		state = GameStore.States.STATE_NONE,
		offers = {
			{
				name = "Dark Scorpion",
				price = 240,
				id = 246,
				description =
				"Embrace the shadows with the Dark Scorpion mount!\n<i>+0.25% Max HP / +0.25% Max MP</i>\n<i>+1 Magic Level</i>\n<i>+1 All Skills (Fist, Club, Axe, Sword, Distance, Shielding)</i>\n<i>+0.2% Critical Chance / +0.5% Critical Damage</i>",
				type = GameStore.OfferTypes.OFFER_TYPE_MOUNT,
			},
			{
				name = "Violet Scorpion",
				price = 240,
				id = 247,
				description =
				"Command the mystical power of the Violet Scorpion!\n<i>+0.25% Max HP / +0.25% Max MP</i>\n<i>+1 Magic Level</i>\n<i>+1 All Skills (Fist, Club, Axe, Sword, Distance, Shielding)</i>\n<i>+0.2% Critical Chance / +0.5% Critical Damage</i>",
				type = GameStore.OfferTypes.OFFER_TYPE_MOUNT,
			},
			{
				name = "Blood Scorpion",
				price = 240,
				id = 248,
				description =
				"Dominate the battlefield with the fearsome Blood Scorpion!\n<i>+0.25% Max HP / +0.25% Max MP</i>\n<i>+1 Magic Level</i>\n<i>+1 All Skills (Fist, Club, Axe, Sword, Distance, Shielding)</i>\n<i>+0.2% Critical Chance / +0.5% Critical Damage</i>",
				type = GameStore.OfferTypes.OFFER_TYPE_MOUNT,
			},
			{
				name = "Smoke Scorpion",
				price = 240,
				id = 249,
				description =
				"Vanish into the mist with the elusive Smoke Scorpion!\n<i>+0.25% Max HP / +0.25% Max MP</i>\n<i>+1 Magic Level</i>\n<i>+1 All Skills (Fist, Club, Axe, Sword, Distance, Shielding)</i>\n<i>+0.2% Critical Chance / +0.5% Critical Damage</i>",
				type = GameStore.OfferTypes.OFFER_TYPE_MOUNT,
			},
			{
				name = "Crystal Lion",
				price = 240,
				id = 253,
				description =
				"Unleash crystalline fury with the radiant Crystal Lion!\n<i>+0.25% Max HP / +0.25% Max MP</i>\n<i>+1 Magic Level</i>\n<i>+1 All Skills (Fist, Club, Axe, Sword, Distance, Shielding)</i>\n<i>+0.2% Critical Chance / +0.5% Critical Damage</i>",
				type = GameStore.OfferTypes.OFFER_TYPE_MOUNT,
			},
			{
				name = "Ghost Draptor",
				price = 240,
				id = 254,
				description =
				"Haunt your enemies with the spectral Ghost Draptor!\n<i>+0.25% Max HP / +0.25% Max MP</i>\n<i>+1 Magic Level</i>\n<i>+1 All Skills (Fist, Club, Axe, Sword, Distance, Shielding)</i>\n<i>+0.2% Critical Chance / +0.5% Critical Damage</i>",
				type = GameStore.OfferTypes.OFFER_TYPE_MOUNT,
			},
			{
				name = "White Scorpion",
				price = 240,
				id = 258,
				description =
				"Strike with deadly precision on the White Scorpion!\n<i>+0.25% Max HP / +0.25% Max MP</i>\n<i>+1 Magic Level</i>\n<i>+1 All Skills (Fist, Club, Axe, Sword, Distance, Shielding)</i>\n<i>+0.2% Critical Chance / +0.5% Critical Damage</i>",
				type = GameStore.OfferTypes.OFFER_TYPE_MOUNT,
			},
			{
				name = "Celestial Horse",
				price = 240,
				id = 259,
				description =
				"Ride through the heavens on the majestic Celestial Horse!\n<i>+0.25% Max HP / +0.25% Max MP</i>\n<i>+1 Magic Level</i>\n<i>+1 All Skills (Fist, Club, Axe, Sword, Distance, Shielding)</i>\n<i>+0.2% Critical Chance / +0.5% Critical Damage</i>",
				type = GameStore.OfferTypes.OFFER_TYPE_MOUNT,
			},
			{
				name = "Brown Scorpion",
				price = 240,
				id = 260,
				description =
				"Crush your foes with the mighty Brown Scorpion!\n<i>+0.25% Max HP / +0.25% Max MP</i>\n<i>+1 Magic Level</i>\n<i>+1 All Skills (Fist, Club, Axe, Sword, Distance, Shielding)</i>\n<i>+0.2% Critical Chance / +0.5% Critical Damage</i>",
				type = GameStore.OfferTypes.OFFER_TYPE_MOUNT,
			},
			{
				name = "Green Wolf",
				price = 240,
				id = 261,
				description =
				"Prowl through the wilds on the fierce Green Wolf!\n<i>+0.25% Max HP / +0.25% Max MP</i>\n<i>+1 Magic Level</i>\n<i>+1 All Skills (Fist, Club, Axe, Sword, Distance, Shielding)</i>\n<i>+0.2% Critical Chance / +0.5% Critical Damage</i>",
				type = GameStore.OfferTypes.OFFER_TYPE_MOUNT,
			},
			{
				name = "White Wolf",
				price = 240,
				id = 262,
				description =
				"Run with the spirit of winter on the White Wolf!\n<i>+0.25% Max HP / +0.25% Max MP</i>\n<i>+1 Magic Level</i>\n<i>+1 All Skills (Fist, Club, Axe, Sword, Distance, Shielding)</i>\n<i>+0.2% Critical Chance / +0.5% Critical Damage</i>",
				type = GameStore.OfferTypes.OFFER_TYPE_MOUNT,
			},
			{
				name = "Red Wolf",
				price = 240,
				id = 263,
				description =
				"Unleash fiery fury with the blazing Red Wolf!\n<i>+0.25% Max HP / +0.25% Max MP</i>\n<i>+1 Magic Level</i>\n<i>+1 All Skills (Fist, Club, Axe, Sword, Distance, Shielding)</i>\n<i>+0.2% Critical Chance / +0.5% Critical Damage</i>",
				type = GameStore.OfferTypes.OFFER_TYPE_MOUNT,
			},
			{
				name = "Yellow Wolf",
				price = 240,
				id = 264,
				description =
				"Charge into battle with the swift Yellow Wolf!\n<i>+0.25% Max HP / +0.25% Max MP</i>\n<i>+1 Magic Level</i>\n<i>+1 All Skills (Fist, Club, Axe, Sword, Distance, Shielding)</i>\n<i>+0.2% Critical Chance / +0.5% Critical Damage</i>",
				type = GameStore.OfferTypes.OFFER_TYPE_MOUNT,
			},
			{
				name = "Gray Wolf",
				price = 240,
				id = 265,
				description =
				"Stalk your prey with the cunning Gray Wolf!\n<i>+0.25% Max HP / +0.25% Max MP</i>\n<i>+1 Magic Level</i>\n<i>+1 All Skills (Fist, Club, Axe, Sword, Distance, Shielding)</i>\n<i>+0.2% Critical Chance / +0.5% Critical Damage</i>",
				type = GameStore.OfferTypes.OFFER_TYPE_MOUNT,
			},
			{
				name = "Smoke Skeleton Horse",
				price = 240,
				id = 266,
				description =
				"Rise from the ashes on the eerie Smoke Skeleton Horse!\n<i>+0.25% Max HP / +0.25% Max MP</i>\n<i>+1 Magic Level</i>\n<i>+1 All Skills (Fist, Club, Axe, Sword, Distance, Shielding)</i>\n<i>+0.2% Critical Chance / +0.5% Critical Damage</i>",
				type = GameStore.OfferTypes.OFFER_TYPE_MOUNT,
			},
			{
				name = "Purple Scorpion",
				price = 240,
				id = 267,
				description =
				"Wield venomous power with the Purple Scorpion!\n<i>+0.25% Max HP / +0.25% Max MP</i>\n<i>+1 Magic Level</i>\n<i>+1 All Skills (Fist, Club, Axe, Sword, Distance, Shielding)</i>\n<i>+0.2% Critical Chance / +0.5% Critical Damage</i>",
				type = GameStore.OfferTypes.OFFER_TYPE_MOUNT,
			},
			{
				name = "Flaming Horse",
				price = 240,
				id = 268,
				description =
				"Blaze through the battlefield on the Flaming Horse!\n<i>+0.25% Max HP / +0.25% Max MP</i>\n<i>+1 Magic Level</i>\n<i>+1 All Skills (Fist, Club, Axe, Sword, Distance, Shielding)</i>\n<i>+0.2% Critical Chance / +0.5% Critical Damage</i>",
				type = GameStore.OfferTypes.OFFER_TYPE_MOUNT,
			},
			{
				name = "Water Dragon",
				price = 240,
				id = 269,
				description =
				"Command the tides with the magnificent Water Dragon!\n<i>+0.25% Max HP / +0.25% Max MP</i>\n<i>+1 Magic Level</i>\n<i>+1 All Skills (Fist, Club, Axe, Sword, Distance, Shielding)</i>\n<i>+0.2% Critical Chance / +0.5% Critical Damage</i>",
				type = GameStore.OfferTypes.OFFER_TYPE_MOUNT,
			},
			{
				name = "Stoneflesh Mole",
				price = 240,
				id = 270,
				description =
				"Burrow through the earth on the resilient Stoneflesh Mole!\n<i>+0.25% Max HP / +0.25% Max MP</i>\n<i>+1 Magic Level</i>\n<i>+1 All Skills (Fist, Club, Axe, Sword, Distance, Shielding)</i>\n<i>+0.2% Critical Chance / +0.5% Critical Damage</i>",
				type = GameStore.OfferTypes.OFFER_TYPE_MOUNT,
			},
			{
				name = "Cosmic Bird",
				price = 240,
				id = 271,
				description =
				"Soar across the cosmos on the dazzling Cosmic Bird!\n<i>+0.25% Max HP / +0.25% Max MP</i>\n<i>+1 Magic Level</i>\n<i>+1 All Skills (Fist, Club, Axe, Sword, Distance, Shielding)</i>\n<i>+0.2% Critical Chance / +0.5% Critical Damage</i>",
				type = GameStore.OfferTypes.OFFER_TYPE_MOUNT,
			},
			{
				name = "Royal Tiger",
				price = 240,
				id = 272,
				description =
				"Rule the jungle on the regal Royal Tiger!\n<i>+0.25% Max HP / +0.25% Max MP</i>\n<i>+1 Magic Level</i>\n<i>+1 All Skills (Fist, Club, Axe, Sword, Distance, Shielding)</i>\n<i>+0.2% Critical Chance / +0.5% Critical Damage</i>",
				type = GameStore.OfferTypes.OFFER_TYPE_MOUNT,
			},
			{
				name = "Blue Draptor",
				price = 240,
				id = 273,
				description =
				"Dominate the skies with the mighty Blue Draptor!\n<i>+0.25% Max HP / +0.25% Max MP</i>\n<i>+1 Magic Level</i>\n<i>+1 All Skills (Fist, Club, Axe, Sword, Distance, Shielding)</i>\n<i>+0.2% Critical Chance / +0.5% Critical Damage</i>",
				type = GameStore.OfferTypes.OFFER_TYPE_MOUNT,
			},
			{
				name = "Green Draptor",
				price = 240,
				id = 274,
				description =
				"Soar through the forests with the Green Draptor!\n<i>+0.25% Max HP / +0.25% Max MP</i>\n<i>+1 Magic Level</i>\n<i>+1 All Skills (Fist, Club, Axe, Sword, Distance, Shielding)</i>\n<i>+0.2% Critical Chance / +0.5% Critical Damage</i>",
				type = GameStore.OfferTypes.OFFER_TYPE_MOUNT,
			},
			{
				name = "Pink Draptor",
				price = 240,
				id = 281,
				description =
				"Dazzle your enemies with the fabulous Pink Draptor!\n<i>+0.25% Max HP / +0.25% Max MP</i>\n<i>+1 Magic Level</i>\n<i>+1 All Skills (Fist, Club, Axe, Sword, Distance, Shielding)</i>\n<i>+0.2% Critical Chance / +0.5% Critical Damage</i>",
				type = GameStore.OfferTypes.OFFER_TYPE_MOUNT,
			},
			{
				name = "White Draptor",
				price = 240,
				id = 275,
				description =
				"Glide through the clouds on the pristine White Draptor!\n<i>+0.25% Max HP / +0.25% Max MP</i>\n<i>+1 Magic Level</i>\n<i>+1 All Skills (Fist, Club, Axe, Sword, Distance, Shielding)</i>\n<i>+0.2% Critical Chance / +0.5% Critical Damage</i>",
				type = GameStore.OfferTypes.OFFER_TYPE_MOUNT,
			},
			{
				name = "Green Scorpion",
				price = 240,
				id = 276,
				description =
				"Strike with toxic fury on the Green Scorpion!\n<i>+0.25% Max HP / +0.25% Max MP</i>\n<i>+1 Magic Level</i>\n<i>+1 All Skills (Fist, Club, Axe, Sword, Distance, Shielding)</i>\n<i>+0.2% Critical Chance / +0.5% Critical Damage</i>",
				type = GameStore.OfferTypes.OFFER_TYPE_MOUNT,
			},
			{
				name = "Red Scorpion",
				price = 240,
				id = 277,
				description =
				"Unleash crimson venom with the Red Scorpion!\n<i>+0.25% Max HP / +0.25% Max MP</i>\n<i>+1 Magic Level</i>\n<i>+1 All Skills (Fist, Club, Axe, Sword, Distance, Shielding)</i>\n<i>+0.2% Critical Chance / +0.5% Critical Damage</i>",
				type = GameStore.OfferTypes.OFFER_TYPE_MOUNT,
			},
			{
				name = "Eletric Scorpion",
				price = 240,
				id = 278,
				description =
				"Shock your foes with the electrifying Eletric Scorpion!\n<i>+0.25% Max HP / +0.25% Max MP</i>\n<i>+1 Magic Level</i>\n<i>+1 All Skills (Fist, Club, Axe, Sword, Distance, Shielding)</i>\n<i>+0.2% Critical Chance / +0.5% Critical Damage</i>",
				type = GameStore.OfferTypes.OFFER_TYPE_MOUNT,
			},
			{
				name = "Sandskull Scorpion",
				price = 240,
				id = 279,
				description =
				"Conquer the desert sands on the Sandskull Scorpion!\n<i>+0.25% Max HP / +0.25% Max MP</i>\n<i>+1 Magic Level</i>\n<i>+1 All Skills (Fist, Club, Axe, Sword, Distance, Shielding)</i>\n<i>+0.2% Critical Chance / +0.5% Critical Damage</i>",
				type = GameStore.OfferTypes.OFFER_TYPE_MOUNT,
			},
			{
				name = "Flaming Scorpion",
				price = 240,
				id = 280,
				description =
				"Burn everything in your path with the Flaming Scorpion!\n<i>+0.25% Max HP / +0.25% Max MP</i>\n<i>+1 Magic Level</i>\n<i>+1 All Skills (Fist, Club, Axe, Sword, Distance, Shielding)</i>\n<i>+0.2% Critical Chance / +0.5% Critical Damage</i>",
				type = GameStore.OfferTypes.OFFER_TYPE_MOUNT,
			},
			{
				name = "Frazzlemount",
				price = 240,
				id = 287,
				description =
				"Ride the electrifying Frazzlemount into battle!\n<i>+0.25% Max HP / +0.25% Max MP</i>\n<i>+1 Magic Level</i>\n<i>+1 All Skills (Fist, Club, Axe, Sword, Distance, Shielding)</i>\n<i>+0.2% Critical Chance / +0.5% Critical Damage</i>",
				type = GameStore.OfferTypes.OFFER_TYPE_MOUNT,
			},
			{
				name = "Flame Bear",
				price = 240,
				id = 288,
				description =
				"Unleash fiery fury with the Flame Bear!\n<i>+0.25% Max HP / +0.25% Max MP</i>\n<i>+1 Magic Level</i>\n<i>+1 All Skills (Fist, Club, Axe, Sword, Distance, Shielding)</i>\n<i>+0.2% Critical Chance / +0.5% Critical Damage</i>",
				type = GameStore.OfferTypes.OFFER_TYPE_MOUNT,
			},
			{
				name = "Blue Tidal Predator",
				price = 240,
				id = 289,
				description =
				"Surge through the waves on the Blue Tidal Predator!\n<i>+0.25% Max HP / +0.25% Max MP</i>\n<i>+1 Magic Level</i>\n<i>+1 All Skills (Fist, Club, Axe, Sword, Distance, Shielding)</i>\n<i>+0.2% Critical Chance / +0.5% Critical Damage</i>",
				type = GameStore.OfferTypes.OFFER_TYPE_MOUNT,
			},
			{
				name = "Crimson Tidal Predator",
				price = 240,
				id = 290,
				description =
				"Command the crimson tides with the Crimson Tidal Predator!\n<i>+0.25% Max HP / +0.25% Max MP</i>\n<i>+1 Magic Level</i>\n<i>+1 All Skills (Fist, Club, Axe, Sword, Distance, Shielding)</i>\n<i>+0.2% Critical Chance / +0.5% Critical Damage</i>",
				type = GameStore.OfferTypes.OFFER_TYPE_MOUNT,
			},
			{
				name = "Red Tidal Predator",
				price = 240,
				id = 291,
				description =
				"Dominate the seas on the Red Tidal Predator!\n<i>+0.25% Max HP / +0.25% Max MP</i>\n<i>+1 Magic Level</i>\n<i>+1 All Skills (Fist, Club, Axe, Sword, Distance, Shielding)</i>\n<i>+0.2% Critical Chance / +0.5% Critical Damage</i>",
				type = GameStore.OfferTypes.OFFER_TYPE_MOUNT,
			},
			{
				name = "Guardian Lion",
				price = 240,
				id = 292,
				description =
				"March with royal pride on the Guardian Lion!\n<i>+0.25% Max HP / +0.25% Max MP</i>\n<i>+1 Magic Level</i>\n<i>+1 All Skills (Fist, Club, Axe, Sword, Distance, Shielding)</i>\n<i>+0.2% Critical Chance / +0.5% Critical Damage</i>",
				type = GameStore.OfferTypes.OFFER_TYPE_MOUNT,
			},
		},
	},
	-- Magic Wall Skins
	{
		icons = { "Category_Cosmetics.png" },
		name = "Magic Wall Skins",
		parent = "Cosmetics",
		rookgaard = false,
		state = GameStore.States.STATE_NONE,
		offers = {
			{ itemtype = 60799, name = "Magic Wall Skin 1", price = 50, description = "<i>Cosmetico de Magic Wall. Apos a compra, utilize o comando !mw para ativar a skin desejada.</i>", type = GameStore.OfferTypes.OFFER_TYPE_MW_SKIN },
			{ itemtype = 60800, name = "Magic Wall Skin 2", price = 50, description = "<i>Cosmetico de Magic Wall. Apos a compra, utilize o comando !mw para ativar a skin desejada.</i>", type = GameStore.OfferTypes.OFFER_TYPE_MW_SKIN },
			{ itemtype = 60801, name = "Magic Wall Skin 3", price = 50, description = "<i>Cosmetico de Magic Wall. Apos a compra, utilize o comando !mw para ativar a skin desejada.</i>", type = GameStore.OfferTypes.OFFER_TYPE_MW_SKIN },
			{ itemtype = 60802, name = "Magic Wall Skin 4", price = 50, description = "<i>Cosmetico de Magic Wall. Apos a compra, utilize o comando !mw para ativar a skin desejada.</i>", type = GameStore.OfferTypes.OFFER_TYPE_MW_SKIN },
			{ itemtype = 60803, name = "Magic Wall Skin 5", price = 50, description = "<i>Cosmetico de Magic Wall. Apos a compra, utilize o comando !mw para ativar a skin desejada.</i>", type = GameStore.OfferTypes.OFFER_TYPE_MW_SKIN },
			{ itemtype = 60804, name = "Magic Wall Skin 6", price = 50, description = "<i>Cosmetico de Magic Wall. Apos a compra, utilize o comando !mw para ativar a skin desejada.</i>", type = GameStore.OfferTypes.OFFER_TYPE_MW_SKIN },
			{ itemtype = 60805, name = "Magic Wall Skin 7", price = 50, description = "<i>Cosmetico de Magic Wall. Apos a compra, utilize o comando !mw para ativar a skin desejada.</i>", type = GameStore.OfferTypes.OFFER_TYPE_MW_SKIN },
			{ itemtype = 60806, name = "Magic Wall Skin 8", price = 50, description = "<i>Cosmetico de Magic Wall. Apos a compra, utilize o comando !mw para ativar a skin desejada.</i>", type = GameStore.OfferTypes.OFFER_TYPE_MW_SKIN },
			{ itemtype = 60807, name = "Magic Wall Skin 9", price = 50, description = "<i>Cosmetico de Magic Wall. Apos a compra, utilize o comando !mw para ativar a skin desejada.</i>", type = GameStore.OfferTypes.OFFER_TYPE_MW_SKIN },
			{ itemtype = 60808, name = "Magic Wall Skin 10", price = 50, description = "<i>Cosmetico de Magic Wall. Apos a compra, utilize o comando !mw para ativar a skin desejada.</i>", type = GameStore.OfferTypes.OFFER_TYPE_MW_SKIN },
			{ itemtype = 60809, name = "Magic Wall Skin 11", price = 50, description = "<i>Cosmetico de Magic Wall. Apos a compra, utilize o comando !mw para ativar a skin desejada.</i>", type = GameStore.OfferTypes.OFFER_TYPE_MW_SKIN },
			{ itemtype = 60810, name = "Magic Wall Skin 12", price = 50, description = "<i>Cosmetico de Magic Wall. Apos a compra, utilize o comando !mw para ativar a skin desejada.</i>", type = GameStore.OfferTypes.OFFER_TYPE_MW_SKIN },
			{ itemtype = 60811, name = "Magic Wall Skin 13", price = 50, description = "<i>Cosmetico de Magic Wall. Apos a compra, utilize o comando !mw para ativar a skin desejada.</i>", type = GameStore.OfferTypes.OFFER_TYPE_MW_SKIN },
			{ itemtype = 60812, name = "Magic Wall Skin 14", price = 50, description = "<i>Cosmetico de Magic Wall. Apos a compra, utilize o comando !mw para ativar a skin desejada.</i>", type = GameStore.OfferTypes.OFFER_TYPE_MW_SKIN },
			{ itemtype = 60813, name = "Magic Wall Skin 15", price = 50, description = "<i>Cosmetico de Magic Wall. Apos a compra, utilize o comando !mw para ativar a skin desejada.</i>", type = GameStore.OfferTypes.OFFER_TYPE_MW_SKIN },
			{ itemtype = 60814, name = "Magic Wall Skin 16", price = 50, description = "<i>Cosmetico de Magic Wall. Apos a compra, utilize o comando !mw para ativar a skin desejada.</i>", type = GameStore.OfferTypes.OFFER_TYPE_MW_SKIN },
			{ itemtype = 60815, name = "Magic Wall Skin 17", price = 50, description = "<i>Cosmetico de Magic Wall. Apos a compra, utilize o comando !mw para ativar a skin desejada.</i>", type = GameStore.OfferTypes.OFFER_TYPE_MW_SKIN },
			{ itemtype = 60816, name = "Magic Wall Skin 18", price = 50, description = "<i>Cosmetico de Magic Wall. Apos a compra, utilize o comando !mw para ativar a skin desejada.</i>", type = GameStore.OfferTypes.OFFER_TYPE_MW_SKIN },
			{ itemtype = 60817, name = "Magic Wall Skin 19", price = 50, description = "<i>Cosmetico de Magic Wall. Apos a compra, utilize o comando !mw para ativar a skin desejada.</i>", type = GameStore.OfferTypes.OFFER_TYPE_MW_SKIN },
			{ itemtype = 60818, name = "Magic Wall Skin 20", price = 50, description = "<i>Cosmetico de Magic Wall. Apos a compra, utilize o comando !mw para ativar a skin desejada.</i>", type = GameStore.OfferTypes.OFFER_TYPE_MW_SKIN },
			{ itemtype = 60819, name = "Magic Wall Skin 21", price = 50, description = "<i>Cosmetico de Magic Wall. Apos a compra, utilize o comando !mw para ativar a skin desejada.</i>", type = GameStore.OfferTypes.OFFER_TYPE_MW_SKIN },
		},
	},
	-- House
	{
		icons = { "Category_HouseTools.png" },
		name = "Houses",
		rookgaard = true,
		subclasses = { "Upgrades" },
	},
	-- House ~ Upgrades
	{
		icons = { "Category_HouseUpgrades.png" },
		name = "Upgrades",
		parent = "Houses",
		rookgaard = true,
		state = GameStore.States.STATE_NONE,
		offers = {
			{
				name = "Fishing Basin",
				price = 300,
				itemtype = BATHTUB_FILLED,
				count = 1,
				description = "<i>Use to train your fishing skills inside your house, this basin provides 30% more fishing skill train efficiency!</i>\n\n{house}\n{box}\n{storeinbox}\n{usablebyall}\n{useicon} use it to open the bath tub\n{backtoinbox}",
				type = GameStore.OfferTypes.OFFER_TYPE_HOUSE,
			},
			{
				name = "Stamina Bath Tube",
				price = 500,
				itemtype = 41610,
				count = 1,
				description = "<i>Use to relax inside your house and regenerate stamina. Every minute inside restores 2 minutes of stamina. Supports up to 2 players.</i>\n\n{house}\n{box}\n{storeinbox}\n{usablebyall}\n{useicon} use it to enter the bath tub\n{backtoinbox}",
				type = GameStore.OfferTypes.OFFER_TYPE_HOUSE,
			},
			{
				icons = { "Reward_Shrine.png" },
				name = "Daily Reward Shrine",
				price = 150,
				itemtype = 25721,
				count = 1,
				description = "<i>Pick up your daily reward comfortably in your own four walls!</i>\n\n{house}\n{box}\n{storeinbox}\n{usablebyall}\n{useicon} use it to open the reward wall\n{backtoinbox}",
				type = GameStore.OfferTypes.OFFER_TYPE_HOUSE,
			},
			{
				name = "Strawman Exercise Dummy",
				price = 350,
				itemtype = 60299,
				count = 1,
				description = "{info} 20% more exp than public dummy\n{info} can only be used by 5 characters at a time\n{house}\n{box}\n{storeinbox}\n{usablebyall}\n{backtoinbox}\n{info}if you have 5 dummys inside your store inbox use commando `!undeaddummy` this dummy provides 50% more skill bonus\n{info}",
				type = GameStore.OfferTypes.OFFER_TYPE_HOUSE,
			},
			{
				name = "Angelical Exercise Dummy",
				price = 350,
				itemtype = 60262,
				count = 1,
				description = "{info} 20% more exp than public dummy\n{info} can only be used by 5 characters at a time\n{house}\n{box}\n{storeinbox}\n{usablebyall}\n{backtoinbox}\n{info}if you have 5 dummys inside your store inbox use commando `!undeaddummy` this dummy provides 50% more skill bonus\n{info}",
				type = GameStore.OfferTypes.OFFER_TYPE_HOUSE,
			},
			{
				name = "Ferumbras' Strawman Exercise Dummy",
				price = 350,
				itemtype = 60163,
				count = 1,
				description = "{info} 20% more exp than public dummy\n{info} can only be used by 5 characters at a time\n{house}\n{box}\n{storeinbox}\n{usablebyall}\n{backtoinbox}\n{info}if you have 5 dummys inside your store inbox use commando `!undeaddummy` this dummy provides 50% more skill bonus\n{info}",
				type = GameStore.OfferTypes.OFFER_TYPE_HOUSE,
			},
			{
				name = "Arthas Exercise Dummy",
				price = 350,
				itemtype = 60153,
				count = 1,
				description = "{info} 20% more exp than public dummy\n{info} can only be used by 5 characters at a time\n{house}\n{box}\n{storeinbox}\n{usablebyall}\n{backtoinbox}\n{info}if you have 5 dummys inside your store inbox use commando `!undeaddummy` this dummy provides 50% more skill bonus\n{info}",
				type = GameStore.OfferTypes.OFFER_TYPE_HOUSE,
			},
			{
				name = "Royal Costume Exercise Dummy",
				price = 350,
				itemtype = 60140,
				count = 1,
				description = "{info} 20% more exp than public dummy\n{info} can only be used by 5 characters at a time\n{house}\n{box}\n{storeinbox}\n{usablebyall}\n{backtoinbox}\n{info}if you have 5 dummys inside your store inbox use commando `!undeaddummy` this dummy provides 50% more skill bonus\n{info}",
				type = GameStore.OfferTypes.OFFER_TYPE_HOUSE,
			},
			{
				name = "Toad Exercise Dummy",
				price = 350,
				itemtype = 60128,
				count = 1,
				description = "{info} 20% more exp than public dummy\n{info} can only be used by 5 characters at a time\n{house}\n{box}\n{storeinbox}\n{usablebyall}\n{backtoinbox}\n{info}if you have 5 dummys inside your store inbox use commando `!undeaddummy` this dummy provides 50% more skill bonus\n{info}",
				type = GameStore.OfferTypes.OFFER_TYPE_HOUSE,
			},
			{
				name = "Divinity Exercise Dummy",
				price = 350,
				itemtype = 60103,
				count = 1,
				description = "{info} 20% more exp than public dummy\n{info} can only be used by 5 characters at a time\n{house}\n{box}\n{storeinbox}\n{usablebyall}\n{backtoinbox}\n{info}if you have 5 dummys inside your store inbox use commando `!undeaddummy` this dummy provides 50% more skill bonus\n{info}",
				type = GameStore.OfferTypes.OFFER_TYPE_HOUSE,
			},
			{
				name = "Nerd Exercise Dummy",
				price = 350,
				itemtype = 60033,
				count = 1,
				description = "{info} 20% more exp than public dummy\n{info} can only be used by 5 characters at a time\n{house}\n{box}\n{storeinbox}\n{usablebyall}\n{backtoinbox}\n{info}if you have 5 dummys inside your store inbox use commando `!undeaddummy` this dummy provides 50% more skill bonus\n{info}",
				type = GameStore.OfferTypes.OFFER_TYPE_HOUSE,
			},
			{
				name = "Fat Nerd Exercise Dummy",
				price = 350,
				itemtype = 60031,
				count = 1,
				description = "{info} 20% more exp than public dummy\n{info} can only be used by 5 characters at a time\n{house}\n{box}\n{storeinbox}\n{usablebyall}\n{backtoinbox}\n{info}if you have 5 dummys inside your store inbox use commando `!undeaddummy` this dummy provides 50% more skill bonus\n{info}",
				type = GameStore.OfferTypes.OFFER_TYPE_HOUSE,
			},
			{
				name = "Akasha Exercise Dummy",
				price = 350,
				itemtype = 60062,
				count = 1,
				description = "{info} 20% more exp than public dummy\n{info} can only be used by 5 characters at a time\n{house}\n{box}\n{storeinbox}\n{usablebyall}\n{backtoinbox}\n{info}if you have 5 dummys inside your store inbox use commando `!undeaddummy` this dummy provides 50% more skill bonus\n{info}",
				type = GameStore.OfferTypes.OFFER_TYPE_HOUSE,
			},
			{
				icons = { "Mailbox.png" },
				name = "Mailbox",
				price = 100,
				itemtype = 23399,
				count = 1,
				description = "<i>Send your letters and parcels right from your own home!</i>\n\n{house}\n{box}\n{storeinbox}\n{usablebyall}\n{backtoinbox}",
				type = GameStore.OfferTypes.OFFER_TYPE_HOUSE,
			},
			{
				icons = { "Ornate_Mailbox.png" },
				name = "Ornate Mailbox",
				price = 100,
				itemtype = 23401,
				count = 1,
				description = "<i>Send your letters and parcels right from your own home!</i>\n\n{house}\n{box}\n{storeinbox}\n{usablebyall}\n{backtoinbox}",
				type = GameStore.OfferTypes.OFFER_TYPE_HOUSE,
			},
			{
				icons = { "Shiny_Reward_Shrine.png" },
				name = "Shiny Daily Reward Shrine",
				price = 100,
				itemtype = 25723,
				count = 1,
				description = "<i>Pick up your daily reward comfortably in your own four walls!</i>\n\n{house}\n{box}\n{storeinbox}\n{usablebyall}\n{useicon} use it to open the reward wall\n{backtoinbox}",
				type = GameStore.OfferTypes.OFFER_TYPE_HOUSE,
			},
			{
				name = "Portable Depot",
				price = 200,
				itemtype = 60820,
				count = 1,
				description = "<i>Access your depot, stash and market from the comfort of your own home!</i>\n\n{house}\n{box}\n{storeinbox}\n{usablebyall}\n{useicon} use it to open your depot\n{backtoinbox}",
				type = GameStore.OfferTypes.OFFER_TYPE_HOUSE,
			},
		},
	},
	-- Boost
	{
		icons = { "Category_Boosts.png" },
		name = "Boosts",
		rookgaard = true,
		state = GameStore.States.STATE_NONE,
		offers = {
			{
				icons = { "XP_Boost.png" },
				name = "XP Boost",
				price = 30,
				id = 65010,
				description = "<i>Purchase a boost that increases the experience points your character gains from hunting by 50%!</i>\n\n{character}\n{info} lasts for 1 hour hunting time\n{info} paused if stamina falls under 14 hours\n{info} can be purchased up to 5 times between 2 server saves\n{info} price increases with every purchase\n{info} cannot be purchased if an XP boost is already active",
				type = GameStore.OfferTypes.OFFER_TYPE_EXPBOOST,
			},
		},
	},
	-- Extras
	{
		icons = { "Category_Extras.png" },
		name = "Extras",
		rookgaard = true,
		subclasses = { "Extra Services", "Useful Things" },
	},
	-- Extras ~ Extras Services
	{
		icons = { "Category_ExtraServices.png" },
		name = "Extra Services",
		parent = "Extras",
		rookgaard = true,
		state = GameStore.States.STATE_NONE,
		offers = {
			{
				icons = { "Name_Change.png" },
				name = "Character Name Change",
				price = 150,
				id = 65002,
				description = "<i>Tired of your current character name? Purchase a new one!</i>\n\n{character}\n{info} relog required after purchase to finalise the name change",
				type = GameStore.OfferTypes.OFFER_TYPE_NAMECHANGE,
			},
		},
	},
	-- Extras ~ Usefull Things
	{
		icons = { "Category_UsefulThings.png" },
		name = "Useful Things",
		parent = "Extras",
		rookgaard = true,
		state = GameStore.States.STATE_NONE,
		offers = {
			{
				icons = { "Prey_Bonus_Reroll.png" },
				name = "Prey Wildcard",
				price = 25,
				coinType = GameStore.CoinType.Transferable,
				id = GameStore.SubActions.PREY_WILDCARD,
				count = 10,
				description = "<i>Use Prey Wildcards to reroll the bonus of an active prey, to lock your active prey or to select a prey of your choice.</i>\n\n{character}\n{info} added directly to Prey dialog\n{info} maximum amount that can be owned by character: 50",
				type = GameStore.OfferTypes.OFFER_TYPE_PREYBONUS,
			},
			{
				icons = { "Charm_Expansion_Offer.png" },
				name = "Charm Expansion",
				price = 250,
				id = GameStore.SubActions.CHARM_EXPANSION,
				description = "<i>Assign as many of your unlocked Charms as you like and get a 25% discount whenever you are removing a Charm from a creature!</i>\n\n{character}\n{once}",
				type = GameStore.OfferTypes.OFFER_TYPE_CHARMS,
			},
			{
				icons = { "Permanent_Prey_Slot.png" },
				name = "Permanent Prey Slot",
				price = 400,
				id = GameStore.SubActions.PREY_THIRDSLOT_REDIRECT,
				description = "<i>Get an additional prey slot to activate additional prey!</i>\n\n{character}\n{info} maximum amount that can be owned by character: 3\n{info} added directly to Prey dialog",
				type = GameStore.OfferTypes.OFFER_TYPE_PREYSLOT,
			},
			{
				icons = { "Permanent_Hunting_Task_Slot.png" },
				name = "Permanent Hunting Task Slot",
				price = 150,
				id = GameStore.SubActions.TASKHUNTING_THIRDSLOT,
				description = "<i>Get an additional hunting tasks slot to activate additional hunting task!</i>\n\n{character}\n{info} maximum amount that can be owned by character: 3\n{info} added directly to Hunting Task dialog",
				type = GameStore.OfferTypes.OFFER_TYPE_HUNTINGSLOT,
			},
			{
				icons = { "Prey_Bonus_Reroll.png" },
				name = "Prey Wildcard",
				price = 100,
				count = 50,
				description = "<i>Use Prey Wildcards to reroll the bonus of an active prey, to lock your active prey or to select a prey of your choice.</i>\n\n{character}\n{info} added directly to Prey dialog",
				type = GameStore.OfferTypes.OFFER_TYPE_PREYBONUS,
			},
			{
				name = "Grand Sanguine Potion",
				price = 500,
				itemtype = 60619,
				count = 1,
				movable = true,
				description =
				"<i>Transform your Sanguine weapons into their Grand Sanguine versions!</i>\n\n<b>Compatible Weapons:</b>\n&#8226; Sanguine Blade, Cudgel, Hatchet, Razor\n&#8226; Sanguine Bludgeon, Battleaxe\n&#8226; Sanguine Bow, Crossbow, Coil\n\n{info} <b>WARNING:</b> Transformation will reset all upgrades, imbuements, and tier levels!\n{info} Confirmation required before transformation\n{info} Can be traded in the Market!",
				type = GameStore.OfferTypes.OFFER_TYPE_STACKABLE,
			},
		},
	},
	-- Online shop
	{
		icons = { "Category_ExclusiveOffers.png" },
		name = "Online Shop",
		rookgaard = true,
		subclasses = { "Exercises", "Utilities", "Basic Mounts", "Basic Outfits" },
	},
	-- Extras ~ Usefull Things
	{
		icons = { "Category_ExerciseWeapons.png" },
		name = "Exercises",
		parent = "Online Shop",
		rookgaard = true,
		state = GameStore.States.STATE_NONE,
		offers = {
			{
				icons = { "Lasting_Exercise_Axe.png" },
				name = "Lasting Exercise Axe",
				price = 100,
				coinType = GameStore.CoinType.Coin,
				itemtype = 35286,
				charges = 14400,
				description = "<i>Use it to train your axe fighting skill on an exercise dummy!</i>\n\n{character}\n{storeinbox}\n{info} use it on an exercise dummy to train your axe fighting skill\n{info} usable 14400 times a piece",
				type = GameStore.OfferTypes.OFFER_TYPE_CHARGES,
			},
			{
				icons = { "Lasting_Exercise_Bow.png" },
				name = "Lasting Exercise Bow",
				price = 100,
				coinType = GameStore.CoinType.Coin,
				itemtype = 35288,
				charges = 14400,
				description = "<i>Use it to train your distance fighting skill on an exercise dummy!</i>\n\n{character}\n{storeinbox}\n{info} use it on an exercise dummy to train your distance fighting skill\n{info} usable 14400 times a piece",
				type = GameStore.OfferTypes.OFFER_TYPE_CHARGES,
			},
			{
				icons = { "Lasting_Exercise_Club.png" },
				name = "Lasting Exercise Club",
				price = 100,
				coinType = GameStore.CoinType.Coin,
				itemtype = 35287,
				charges = 14400,
				description = "<i>Use it to train your club fighting skill on an exercise dummy!</i>\n\n{character}\n{storeinbox}\n{info} use it on an exercise dummy to train your club fighting skill\n{info} usable 14400 times a piece",
				type = GameStore.OfferTypes.OFFER_TYPE_CHARGES,
			},
			{
				icons = { "Lasting_Exercise_Rod.png" },
				name = "Lasting Exercise Rod",
				price = 100,
				coinType = GameStore.CoinType.Coin,
				itemtype = 35289,
				charges = 14400,
				description = "<i>Use it to train your magic level on an exercise dummy!</i>\n\n{character}\n{storeinbox}\n{info} use it on an exercise dummy to train your magic level\n{info} usable 14400 times a piece",
				type = GameStore.OfferTypes.OFFER_TYPE_CHARGES,
			},
			{
				icons = { "Lasting_Exercise_Sword.png" },
				name = "Lasting Exercise Sword",
				price = 100,
				coinType = GameStore.CoinType.Coin,
				itemtype = 35285,
				charges = 14400,
				description = "<i>Use it to train your sword fighting skill on an exercise dummy!</i>\n\n{character}\n{storeinbox}\n{info} use it on an exercise dummy to train your sword fighting skill\n{info} usable 14400 times a piece",
				type = GameStore.OfferTypes.OFFER_TYPE_CHARGES,
			},
			{
				icons = { "Lasting_Exercise_Wand.png" },
				name = "Lasting Exercise Wand",
				price = 100,
				coinType = GameStore.CoinType.Coin,
				itemtype = 35290,
				charges = 14400,
				description = "<i>Use it to train your magic level on an exercise dummy!</i>\n\n{character}\n{storeinbox}\n{info} use it on an exercise dummy to train your magic level\n{info} usable 14400 times a piece",
				type = GameStore.OfferTypes.OFFER_TYPE_CHARGES,
			},
			{
				icons = { "Lasting_Exercise_Shield.png" },
				name = "Lasting Exercise Shield",
				price = 100,
				coinType = GameStore.CoinType.Coin,
				itemtype = 44067,
				charges = 14400,
				description = "<i>Use it to train your shielding skill on an exercise dummy!</i>\n\n{character}\n{storeinbox}\n{info} use it on an exercise dummy to train your shielding skill\n{info} usable 14400 times a piece",
				type = GameStore.OfferTypes.OFFER_TYPE_CHARGES,
			},
			{
				name = "Lasting Exercise Wraps",
				price = 100,
				coinType = GameStore.CoinType.Coin,
				itemtype = 50295,
				charges = 14400,
				description = "<i>Use it to train your fisting skill on an exercise dummy!</i>\n\n{character}\n{storeinbox}\n{info} use it on an exercise dummy to train your fist skill\n{info} usable 14400 times a piece",
				type = GameStore.OfferTypes.OFFER_TYPE_CHARGES,
			},
		},
	},
	-- Utilities
	{
		icons = { "Category_UsefulThings.png" },
		name = "Utilities",
		parent = "Online Shop",
		rookgaard = true,
		state = GameStore.States.STATE_NONE,
		offers = {
			-- Transfer Tokens
			{
				name = "Skill Transfer Token",
				price = 350,
				coinType = GameStore.CoinType.Coin,
				itemtype = 60431,
				count = 1,
				movable = true,
				description = "<i>Extract and transfer skill bonuses between equipment pieces!</i>\n\n{character}\n{storeinbox}\n{info} use on equipment with skill bonus to extract it\n{info} then use on another equipment to apply the bonus\n{info} perfect for optimizing your gear",
				type = GameStore.OfferTypes.OFFER_TYPE_STACKABLE,
			},
			{
				name = "Upgrade Transfer Token",
				price = 350,
				coinType = GameStore.CoinType.Coin,
				itemtype = 60430,
				count = 1,
				movable = true,
				description = "<i>Transfer weapon upgrade levels between weapons!</i>\n\n{character}\n{storeinbox}\n{info} use on upgraded weapon to extract upgrade level\n{info} then use on another weapon to apply the upgrade\n{info} don't lose upgrades when changing weapons",
				type = GameStore.OfferTypes.OFFER_TYPE_STACKABLE,
			},
			{
				name = "Tier Transfer Token",
				price = 350,
				coinType = GameStore.CoinType.Coin,
				itemtype = 60636,
				count = 1,
				movable = true,
				description = "<i>Transfer item tiers between equipment pieces!</i>\n\n{character}\n{storeinbox}\n{info} use on tiered item to extract tier level\n{info} then use on another item to apply the tier\n{info} perfect for moving tiers to better equipment",
				type = GameStore.OfferTypes.OFFER_TYPE_STACKABLE,
			},
			-- Infinite Food
			{
				name = "Infinite Pizza",
				price = 1500,
				coinType = GameStore.CoinType.Coin,
				itemtype = 60023,
				count = 1,
				movable = true,
				description = "<i>Never worry about food again!</i>\n\n{character}\n{storeinbox}\n{info} infinite uses - never gets consumed\n{info} restores 22 hunger points per use\n{info} grants the same vocation-specific buffs as Berserk/Mastermind/Bullseye/Transcendence potions when eaten\n{info} stacks with spells such as utito tempo and utito tempo san",
				type = GameStore.OfferTypes.OFFER_TYPE_STACKABLE,
			},
			-- Dust Potion
			{
				name = "Dust Potion",
				price = 100,
				coinType = GameStore.CoinType.Coin,
				itemtype = 60146,
				count = 1,
				movable = true,
				description = "<i>Special utility potion for various uses!</i>\n\n{character}\n{storeinbox}\n{info} utility item for special purposes\n{info} check in-game mechanics for specific uses",
				type = GameStore.OfferTypes.OFFER_TYPE_STACKABLE,
			},
			-- Relic Reveal Enhancement

		},
	},
	-- Basic Mounts
	{
		icons = { "Category_Mounts.png" },
		name = "Basic Mounts",
		parent = "Online Shop",
		rookgaard = true,
		state = GameStore.States.STATE_NONE,
		offers = {
			{
				name = "Racing Bird Mount",
				price = 300,
				coinType = GameStore.CoinType.Coin,
				id = 2,
				description = "<i>A basic mount with standard bonuses!</i>\n\n{character}\n{info} +0.25% Max HP\n{info} +0.25% Max MP\n{info} +10 Speed",
				type = GameStore.OfferTypes.OFFER_TYPE_MOUNT,
			},
			{
				name = "War Bear Mount",
				price = 300,
				coinType = GameStore.CoinType.Coin,
				id = 3,
				description = "<i>A basic mount with standard bonuses!</i>\n\n{character}\n{info} +0.25% Max HP\n{info} +0.25% Max MP\n{info} +10 Speed",
				type = GameStore.OfferTypes.OFFER_TYPE_MOUNT,
			},
			{
				name = "Black Sheep Mount",
				price = 300,
				coinType = GameStore.CoinType.Coin,
				id = 4,
				description = "<i>A basic mount with standard bonuses!</i>\n\n{character}\n{info} +0.25% Max HP\n{info} +0.25% Max MP\n{info} +10 Speed",
				type = GameStore.OfferTypes.OFFER_TYPE_MOUNT,
			},
			{
				name = "Midnight Panther Mount",
				price = 300,
				coinType = GameStore.CoinType.Coin,
				id = 5,
				description = "<i>A basic mount with standard bonuses!</i>\n\n{character}\n{info} +0.25% Max HP\n{info} +0.25% Max MP\n{info} +10 Speed",
				type = GameStore.OfferTypes.OFFER_TYPE_MOUNT,
			},
			{
				name = "Draptor Mount",
				price = 300,
				coinType = GameStore.CoinType.Coin,
				id = 6,
				description = "<i>A basic mount with standard bonuses!</i>\n\n{character}\n{info} +0.25% Max HP\n{info} +0.25% Max MP\n{info} +10 Speed",
				type = GameStore.OfferTypes.OFFER_TYPE_MOUNT,
			},
		},
	},
	-- Basic Outfits
	{
		icons = { "Category_Outfits.png" },
		name = "Basic Outfits",
		parent = "Online Shop",
		rookgaard = true,
		state = GameStore.States.STATE_NONE,
		offers = {
			{
				name = "Entrepreneur Outfit",
				price = 500,
				coinType = GameStore.CoinType.Coin,
				sexId = { female = 471, male = 472 },
				addon = 3,
				description = "<i>A basic outfit with standard bonuses!</i>\n\n{character}\n{info} +1% Max HP\n{info} +1% Max MP\n{info} +100 Capacity\n{info} +1 Magic Level\n{info} +1 All Skills",
				type = GameStore.OfferTypes.OFFER_TYPE_OUTFIT,
			},
			{
				name = "Champion Outfit",
				price = 500,
				coinType = GameStore.CoinType.Coin,
				sexId = { female = 632, male = 633 },
				addon = 3,
				description = "<i>A basic outfit with standard bonuses!</i>\n\n{character}\n{info} +1% Max HP\n{info} +1% Max MP\n{info} +100 Capacity\n{info} +1 Magic Level\n{info} +1 All Skills",
				type = GameStore.OfferTypes.OFFER_TYPE_OUTFIT,
			},
			{
				name = "Conjurer Outfit",
				price = 500,
				coinType = GameStore.CoinType.Coin,
				sexId = { female = 635, male = 634 },
				addon = 3,
				description = "<i>A basic outfit with standard bonuses!</i>\n\n{character}\n{info} +1% Max HP\n{info} +1% Max MP\n{info} +100 Capacity\n{info} +1 Magic Level\n{info} +1 All Skills",
				type = GameStore.OfferTypes.OFFER_TYPE_OUTFIT,
			},
			{
				name = "Beastmaster Outfit",
				price = 500,
				coinType = GameStore.CoinType.Coin,
				sexId = { female = 636, male = 637 },
				addon = 3,
				description = "<i>A basic outfit with standard bonuses!</i>\n\n{character}\n{info} +1% Max HP\n{info} +1% Max MP\n{info} +100 Capacity\n{info} +1 Magic Level\n{info} +1 All Skills",
				type = GameStore.OfferTypes.OFFER_TYPE_OUTFIT,
			},
			{
				name = "Ranger Outfit",
				price = 500,
				coinType = GameStore.CoinType.Coin,
				sexId = { female = 683, male = 684 },
				addon = 3,
				description = "<i>A basic outfit with standard bonuses!</i>\n\n{character}\n{info} +1% Max HP\n{info} +1% Max MP\n{info} +100 Capacity\n{info} +1 Magic Level\n{info} +1 All Skills",
				type = GameStore.OfferTypes.OFFER_TYPE_OUTFIT,
			},
			{
				name = "Puppeteer Outfit",
				price = 500,
				coinType = GameStore.CoinType.Coin,
				sexId = { female = 696, male = 697 },
				addon = 3,
				description = "<i>A basic outfit with standard bonuses!</i>\n\n{character}\n{info} +1% Max HP\n{info} +1% Max MP\n{info} +100 Capacity\n{info} +1 Magic Level\n{info} +1 All Skills",
				type = GameStore.OfferTypes.OFFER_TYPE_OUTFIT,
			},

		},
	},
}

-- ============================================================
-- GLOBAL STORE DISCOUNT SYSTEM
-- ============================================================
-- To activate a sale, set enabled = true, configure discount %
-- and the day of the month the sale ends.
-- To deactivate, set enabled = false (prices revert automatically).
-- ============================================================
GameStore.GlobalDiscount = {
	enabled = false, -- true to activate, false to deactivate
	discountPercent = 20, -- discount percentage (20 = 20% off)
	saleEndDay = 17, -- day of the month the sale ends (17 = March 17, Monday)
	excludedTypes = { -- offer types excluded from discount
		[GameStore.OfferTypes.OFFER_TYPE_EXPBOOST] = true,
	},
}

local function applyGlobalDiscount()
	local config = GameStore.GlobalDiscount
	if not config.enabled then
		return
	end

	local discount = config.discountPercent / 100
	local saleEndDay = config.saleEndDay

	for _, category in ipairs(GameStore.Categories) do
		if category.offers then
			for _, offer in ipairs(category.offers) do
				if not offer._originalPrice and not config.excludedTypes[offer.type] then
					offer._originalPrice = offer.price
					offer.basePrice = offer.price
					offer.price = math.max(1, math.floor(offer.price * (1 - discount)))
					offer.state = GameStore.States.STATE_SALE
					offer.validUntil = saleEndDay
				end
			end
		end
	end
end

applyGlobalDiscount()

-- Each outfit must be uniquely identified to distinguish between addons.
-- Here we dynamically assign ids for outfits. These ids must be unique.
local runningId = 45000
for k, category in ipairs(GameStore.Categories) do
	if category.offers then
		for m, offer in ipairs(category.offers) do
			if not offer.id then
				if type(offer.count) == "table" then
					for i = 1, #offer.price do
						offer.id[i] = runningId
						runningId = runningId + 1
					end
				else
					offer.id = runningId
					runningId = runningId + 1
				end
			end
			if not offer.type then
				offer.type = GameStore.OfferTypes.OFFER_TYPE_NONE
			end
			if not offer.coinType then
				offer.coinType = GameStore.CoinType.Transferable
			end
		end
	end
end
