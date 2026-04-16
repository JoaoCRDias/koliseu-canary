-- Castle Surprise Casket
-- Reward given to winning guild members at the end of a Castle War.
-- Drops a single item from a weighted loot table that ranges from useless junk
-- to extremely rare prizes.

local CASKET_ID = 63377

-- Loot table format:
-- {
--     itemId   = number,                           -- item id to give
--     weight   = number,                           -- relative drawing weight (higher = more common)
--     count    = number | { min = X, max = Y },    -- optional, defaults to 1
--     message  = string,                           -- optional, custom flavor message shown to the player
-- }
--
-- The chance of a given entry being drawn is: weight / (sum of all weights).
-- Fill the table below with the desired items; weights can be tuned later.
local lootTable = {
	-- TODO: fill with items
	-- Example:
	-- { itemId = 3031, weight = 1000, count = { min = 1, max = 100 }, message = "You find a small pile of gold." },
	-- { itemId = 3043, weight = 50, message = "A crystal coin gleams from inside the casket." },
	-- { itemId = 9971, weight = 1, message = "An incredibly rare prize lies inside!" },
	{ itemId = 60391, weight = 3 }, -- castle warlord outfits
	{ itemId = BAG_OF_YOUR_DREAMS, weight = 1 }, -- bag of your dreams
	{ itemId = BAG_OF_COSMIC_WISHES, weight = 1 }, -- bag of cosmic wishes
	{ itemId = PRIMAL_BAG, weight = 5 }, -- primal bag
	{ itemId = BAG_YOU_COVET, weight = 5 }, -- bag you covet
	{ itemId = BAG_YOU_DESIRE, weight = 5 }, -- bag you desire
	{ itemId = 8778, weight = 10, count = 50 }, -- addon doll
	{ itemId = 21948, weight = 10, count = 50 }, -- mount doll
	{ itemId = 60303, weight = 10, count = 3 }, -- lesser exp potion
	{ itemId = 60301, weight = 10, count = 3 }, -- exp potion
	{ itemId = 60302, weight = 10, count = 3 }, -- greater exp potion
	{ itemId = 49272, weight = 10, count = 5 }, -- reflect potion
	{ itemId = 11372, weight = 10, count = 5 }, -- mitigation potion
	{ itemId = 60101, weight = 15 }, -- prey wildcard
	{ itemId = 60522, weight = 15 }, -- unrevealed relic
	{ itemId = 60520, weight = 15 }, -- relic reveal enhancement
	{ itemId = 60022, weight = 15 }, -- tier upgrader
	{ itemId = 60614, weight = 15 }, -- common training chest
	{ itemId = 60613, weight = 10 }, -- rare training chest
	{ itemId = 3043, weight = 35, count = 100 }, -- crystal coin

	-- Medium value items (Cryptor potions - enhancements)
	{ itemId = 36723, weight = 30, count = 2 }, -- kooldown-aid
	{ itemId = 36724, weight = 30, count = 2 }, -- strike enhancement
	{ itemId = 36725, weight = 30, count = 2 }, -- stamina extension
	{ itemId = 36726, weight = 30, count = 2 }, -- charm upgrade
	{ itemId = 36728, weight = 30, count = 2 }, -- bestiary betterment
	-- Medium value items (Cryptor potions - resilience)
	{ itemId = 36729, weight = 30, count = 2 }, -- fire resilience
	{ itemId = 36730, weight = 30, count = 2 }, -- ice resilience
	{ itemId = 36731, weight = 30, count = 2 }, -- earth resilience
	{ itemId = 36732, weight = 30, count = 2 }, -- energy resilience
	{ itemId = 36733, weight = 30, count = 2 }, -- holy resilience
	{ itemId = 36734, weight = 30, count = 2 }, -- death resilience
	{ itemId = 36735, weight = 30, count = 2 }, -- physical resilience
	-- Medium value items (Cryptor potions - amplification)
	{ itemId = 36736, weight = 30, count = 2 }, -- fire amplification
	{ itemId = 36737, weight = 30, count = 2 }, -- ice amplification
	{ itemId = 36738, weight = 30, count = 2 }, -- earth amplification
	{ itemId = 36739, weight = 30, count = 2 }, -- energy amplification
	{ itemId = 36740, weight = 30, count = 2 }, -- holy amplification
	{ itemId = 36741, weight = 30, count = 2 }, -- death amplification
	{ itemId = 36742, weight = 30, count = 2 }, -- physical amplification
	-- Medium value items (Galdor element matters)
	{ itemId = 60676, weight = 30, count = 1 }, -- death matter
	{ itemId = 60677, weight = 30, count = 1 }, -- ice matter
	{ itemId = 60678, weight = 30, count = 1 }, -- holy matter
	{ itemId = 60679, weight = 30, count = 1 }, -- fire matter
	{ itemId = 60680, weight = 30, count = 1 }, -- physical matter
	{ itemId = 60681, weight = 30, count = 1 }, -- energy matter
	{ itemId = 60682, weight = 30, count = 1 }, -- earth matter
}

local function rollLoot()
	local totalWeight = 0
	for i = 1, #lootTable do
		totalWeight = totalWeight + (lootTable[i].weight or 0)
	end

	if totalWeight <= 0 then
		return nil
	end

	local roll = math.random(1, totalWeight)
	local cumulative = 0
	for i = 1, #lootTable do
		cumulative = cumulative + (lootTable[i].weight or 0)
		if roll <= cumulative then
			return lootTable[i]
		end
	end

	return lootTable[#lootTable]
end

local function resolveCount(entry)
	local c = entry.count
	if not c then
		return 1
	end
	if type(c) == "number" then
		return c
	end
	if type(c) == "table" then
		local minCount = c.min or 1
		local maxCount = c.max or minCount
		if maxCount < minCount then
			maxCount = minCount
		end
		return math.random(minCount, maxCount)
	end
	return 1
end

local castleSurpriseCasket = Action()

function castleSurpriseCasket.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if #lootTable == 0 then
		player:sendCancelMessage("This casket is not yet configured. Contact a gamemaster.")
		return true
	end

	local entry = rollLoot()
	if not entry then
		player:sendCancelMessage("The casket appears to be empty.")
		return true
	end

	local count = resolveCount(entry)
	local reward = player:addItem(entry.itemId, count)
	if not reward then
		player:sendCancelMessage("You have no space to receive the reward. Free some inventory space and try again.")
		return true
	end

	if entry.message then
		player:sendTextMessage(MESSAGE_LOOT, "[Castle Casket] " .. entry.message)
	else
		local rewardName = ItemType(entry.itemId):getName()
		player:sendTextMessage(MESSAGE_LOOT, string.format("[Castle Casket] You received %dx %s.", count, rewardName))
	end

	player:getPosition():sendMagicEffect(CONST_ME_GIFT_WRAPS)
	item:remove(1)
	return true
end

castleSurpriseCasket:id(CASKET_ID)
castleSurpriseCasket:register()
