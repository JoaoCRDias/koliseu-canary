--[[
	Description: This file is part of Roulette System (refactored)
	Author: Ly�
	Discord: Ly�#8767
	Adaptado para o Canary:  NvSo#4349
]]

local Slot = dofile(DATA_DIRECTORY .. '/scripts/magic_roulette/lib/classes/slot.lua')
local Animation = dofile(DATA_DIRECTORY .. '/scripts/magic_roulette/lib/animation.lua')
local DatabaseRoulettePlays = dofile(DATA_DIRECTORY .. '/scripts/magic_roulette/lib/database/roulette_plays.lua')
local Strings = dofile(DATA_DIRECTORY .. '/scripts/magic_roulette/lib/core/strings.lua')

local roulleteItems = {
	-- Common (90% in ~30-38 runs)
	{ id = 3043, count = 100, chance = 7.76 }, -- 1kk
	{ id = 60146, count = 1, chance = 7.02 }, -- dust potion
	{ id = 60141, count = 2, chance = 6.92 }, -- exercise token

	-- Common+ (90% in ~45-66 runs)
	{ id = 37110, count = 10, chance = 5.16 }, -- exalted core
	{ id = 60104, count = 1, chance = 3.47 }, -- roulette token
	{ id = 60303, count = 1, chance = 3.47 }, -- lesser exp potion

	-- Bags (90% in ~66 runs each)
	{ id = 60409, count = 1, chance = 3.47 }, -- brainstealer bag
	{ id = 60410, count = 1, chance = 3.47 }, -- falcon bag
	{ id = 60411, count = 1, chance = 3.47 }, -- lion bag
	{ id = 60412, count = 1, chance = 3.47 }, -- ratmiral bag
	{ id = 60413, count = 1, chance = 3.47 }, -- cobra bag
	{ id = 60414, count = 1, chance = 3.47 }, -- timira bag
	{ id = 60408, count = 1, chance = 3.47 }, -- monster bag
	{ id = 60101, count = 1, chance = 3.47 }, -- prey wildcard

	-- Medium (90% in ~84 runs)
	{ id = 60301, count = 1, chance = 2.75 }, -- exp potion

	-- Uncommon (90% in ~125 runs)
	{ id = 49272, count = 2, chance = 1.84 }, -- reflect potion
	{ id = 11372, count = 2, chance = 1.84 }, -- interdimensional potion
	{ id = 60302, count = 1, chance = 1.84 }, -- greater exp potion

	-- Rare (90% in ~151 runs)
	{ id = 39546, count = 1, chance = 1.52, rare = true }, -- primal bag
	{ id = 43895, count = 1, chance = 1.52, rare = true }, -- bag you covet
	{ id = 34109, count = 1, chance = 1.52, rare = true }, -- bag you desire
	{ id = 60520, count = 1, chance = 1.52, rare = true }, -- relic reveal enhancement
	{ id = 50064, count = 1, chance = 1.52, rare = true }, -- demon in a green box

	-- Very Rare (90% in ~202 runs)
	{ id = 60022, count = 1, chance = 1.14, rare = true }, -- tier upgrader
	{ id = 60619, count = 1, chance = 1.14, rare = true }, -- grand sanguine potion
	{ id = 60614, count = 1, chance = 1.14, rare = true }, -- common training chest

	-- Ultra Rare (90% in ~253 runs)
	{ id = 60625, count = 1, chance = 0.91, rare = true }, -- red demon box
	{ id = 60622, count = 1, chance = 0.91, rare = true }, -- cyan demon box
	{ id = 60623, count = 1, chance = 0.91, rare = true }, -- green demon box
	{ id = 60624, count = 1, chance = 0.91, rare = true }, -- white demon box
	{ id = 60240, count = 1, chance = 0.91, rare = true }, -- death protection ring
	{ id = 60241, count = 1, chance = 0.91, rare = true }, -- earth protection ring
	{ id = 60242, count = 1, chance = 0.91, rare = true }, -- earth protection amulet
	{ id = 60243, count = 1, chance = 0.91, rare = true }, -- energy protection amulet
	{ id = 60244, count = 1, chance = 0.91, rare = true }, -- fire protection amulet
	{ id = 60245, count = 1, chance = 0.91, rare = true }, -- holy protection amulet
	{ id = 60246, count = 1, chance = 0.91, rare = true }, -- ice protection amulet
	{ id = 60247, count = 1, chance = 0.91, rare = true }, -- death protection amulet
	{ id = 60248, count = 1, chance = 0.91, rare = true }, -- energy protection ring
	{ id = 60249, count = 1, chance = 0.91, rare = true }, -- fire protection ring
	{ id = 60250, count = 1, chance = 0.91, rare = true }, -- holy protection ring
	{ id = 60251, count = 1, chance = 0.91, rare = true }, -- ice protection ring

	-- Legendary (90% in ~299 runs)
	{ id = 60522, count = 1, chance = 0.77, rare = true }, -- unrevealed relic
	{ id = 60626, count = 1, chance = 0.77, rare = true }, -- bag of cosmic wishes
	{ id = 23538, count = 1, chance = 0.77, rare = true }, -- vibrant egg
	{ id = 23684, count = 1, chance = 0.77, rare = true }, -- crackling egg
	{ id = 23685, count = 1, chance = 0.77, rare = true }, -- menacing egg
	{ id = 32629, count = 1, chance = 0.77, rare = true }, -- spectral scrap of cloth
}

slots = {
	[17320] = Slot {
		needItem = { id = 60104, count = 1 },
		tilesPerSlot = 11,
		centerPosition = Position(941, 1213, 7), --Centro da Roleta onde o pr�mio do item para

		items = roulleteItems,
	},
	[17321] = Slot {
		needItem = { id = 60104, count = 1 },
		tilesPerSlot = 11,
		centerPosition = Position(941, 1225, 7), --Centro da Roleta onde o pr�mio do item para

		items = roulleteItems,
	},
	[17322] = Slot {
		needItem = { id = 60104, count = 1 },
		tilesPerSlot = 11,
		centerPosition = Position(957, 1213, 7), --Centro da Roleta onde o pr�mio do item para

		items = roulleteItems,
	},
	[17323] = Slot {
		needItem = { id = 60104, count = 1 },
		tilesPerSlot = 11,
		centerPosition = Position(957, 1225, 7), --Centro da Roleta onde o pr�mio do item para

		items = roulleteItems,
	}
}

local Roulette = {}

function Roulette:startup()
	DatabaseRoulettePlays:updateAllRollingToPending()

	self.slots = slots
	for actionid, slot in pairs(self.slots) do
		slot:generatePositions()
		slot:loadChances(actionid)
	end
end

function Roulette:roll(player, slot)
	if slot:isRolling() then
		player:sendTextMessage(MESSAGE_STATUS, string.format(Strings.WAIT_TO_SPIN))
		return false
	end

	local reward = slot:generateReward()
	if not reward then
		player:sendTextMessage(MESSAGE_STATUS, string.format(Strings.GENERATE_REWARD_FAILURE))
		return false
	end

	local needItem = slot:getNeedItem()
	local needItemName = ItemType(needItem.id):getName()

	if not player:removeItem(needItem.id, needItem.count) then
		player:sendTextMessage(MESSAGE_STATUS, string.format(Strings.NEEDITEM_TO_SPIN:format(
			needItem.count,
			needItemName
		)))
		return false
	end

	local playerName = player:getName()

	slot.uuid = uuid()
	DatabaseRoulettePlays:create(slot.uuid, player:getGuid(), reward)

	slot:setRolling(true)
	slot:clearDummies()

	local onFinish = function()
		slot:deliverReward()
		slot:setRolling(false)

		if reward.rare then
			local players = Game.getPlayers()
			for _, player in ipairs(players) do
				player:sendColoredMessage(string.format(Strings.GIVE_REWARD_FOUND_RARE:format(
					playerName,
					reward.count,
					'{blue|' .. ItemType(reward.id):getName() .. '}')), MESSAGE_EVENT_ADVANCE)
			end
		end
	end

	Animation:start({
		slot = slot,
		reward = reward,
		onFinish = onFinish
	})
	return true
end

function Roulette:getSlot(actionid)
	self:startup()
	return self.slots[actionid]
end

return Roulette
