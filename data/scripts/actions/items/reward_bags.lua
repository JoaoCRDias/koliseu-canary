local rewardBags = {
	[BAG_YOU_DESIRE] = {
		{ id = 34082, name = "soulcutter" },
		{ id = 34083, name = "soulshredder" },
		{ id = 34084, name = "soulbiter" },
		{ id = 34085, name = "souleater" },
		{ id = 34086, name = "soulcrusher" },
		{ id = 34087, name = "soulmaimer" },
		{ id = 34097, name = "pair of soulwalkers" },
		{ id = 34099, name = "soulbastion" },
		{ id = 34088, name = "soulbleeder" },
		{ id = 34089, name = "soulpiercer" },
		{ id = 34094, name = "soulshell" },
		{ id = 34098, name = "pair of soulstalkers" },
		{ id = 34090, name = "soultainter" },
		{ id = 34092, name = "soulshanks" },
		{ id = 34095, name = "soulmantle" },
		{ id = 34091, name = "soulhexer" },
		{ id = 34093, name = "soulstrider" },
		{ id = 34096, name = "soulshroud" },
	},

	[PRIMAL_BAG] = {
		{ id = 39147, name = "spiritthorn armor" },
		{ id = 39148, name = "spiritthorn helmet" },
		{ id = 39177, name = "charged spiritthorn ring" },
		{ id = 39149, name = "alicorn headguard" },
		{ id = 39150, name = "alicorn quiver" },
		{ id = 39180, name = "charged alicorn ring" },
		{ id = 39151, name = "arcanomancer regalia" },
		{ id = 39152, name = "arcanomancer folio" },
		{ id = 39183, name = "charged arcanomancer sigil" },
		{ id = 39153, name = "arboreal crown" },
		{ id = 39154, name = "arboreal tome" },
	},

	[BAG_YOU_COVET] = {
		{ id = 43864, name = "sanguine blade" },
		{ id = 43866, name = "sanguine cudgel" },
		{ id = 43868, name = "sanguine hatchet" },
		{ id = 43870, name = "sanguine razor" },
		{ id = 43872, name = "sanguine bludgeon" },
		{ id = 43874, name = "sanguine battleaxe" },
		{ id = 43876, name = "sanguine legs" },
		{ id = 43877, name = "sanguine bow" },
		{ id = 43879, name = "sanguine crossbow" },
		{ id = 43881, name = "sanguine greaves" },
		{ id = 43882, name = "sanguine coil" },
		{ id = 43884, name = "sanguine boots" },
		{ id = 43885, name = "sanguine rod" },
		{ id = 43887, name = "sanguine galoshes" },
		{ id = 43865, name = "grand sanguine blade" },
		{ id = 43867, name = "grand sanguine cudgel" },
		{ id = 43869, name = "grand sanguine hatchet" },
		{ id = 43871, name = "grand sanguine razor" },
		{ id = 43873, name = "grand sanguine bludgeon" },
		{ id = 43875, name = "grand sanguine battleaxe" },
		{ id = 43878, name = "grand sanguine bow" },
		{ id = 43880, name = "grand sanguine crossbow" },
		{ id = 43883, name = "grand sanguine coil" },
		{ id = 43886, name = "grand sanguine rod" },
	},

	[BAG_OF_COSMIC_WISHES] = {
		{ id = 60541, name = "cosmic helmet" },
		{ id = 60542, name = "cosmic armor" },
		{ id = 60543, name = "cosmic legs" },
		{ id = 60545, name = "cosmic sword" },
		{ id = 60546, name = "cosmic club" },
		{ id = 60547, name = "cosmic axe" },
		{ id = 60548, name = "cosmic mask" },
		{ id = 60549, name = "cosmic mantle" },
		{ id = 60550, name = "cosmic pants" },
		{ id = 60551, name = "cosmic shoes" },
		{ id = 60552, name = "cosmic folio" },
		{ id = 60553, name = "cosmic wand" },
		{ id = 60554, name = "cosmic crown" },
		{ id = 60555, name = "cosmic robe" },
		{ id = 60556, name = "cosmic skirt" },
		{ id = 60557, name = "cosmic galoshes" },
		{ id = 60558, name = "cosmic tome" },
		{ id = 60559, name = "cosmic rod" },
		{ id = 60560, name = "cosmic headguard" },
		{ id = 60561, name = "cosmic plate" },
		{ id = 60562, name = "cosmic greaves" },
		{ id = 60564, name = "cosmic quiver" },
		{ id = 60565, name = "cosmic bow" },
		{ id = 60566, name = "cosmic crossbow" },
	},

	[BAG_OF_YOUR_DREAMS] = {
		-- Bloodrage (Knight)
		{ id = 60593, name = "bloodrage helmet" },
		{ id = 60600, name = "bloodrage armor" },
		{ id = 60594, name = "bloodrage legs" },
		{ id = 60590, name = "pair of bloodrage boots" },
		{ id = 60598, name = "bloodrage sword" },
		{ id = 60591, name = "bloodrage club" },
		{ id = 60589, name = "bloodrage axe" },
		-- Sacred (Paladin)
		{ id = 60587, name = "sacred headguard" },
		{ id = 60583, name = "sacred plate" },
		{ id = 60588, name = "sacred greaves" },
		{ id = 60584, name = "pair of sacred stalkers" },
		{ id = 60580, name = "sacred quiver" },
		{ id = 60585, name = "sacred bow" },
		{ id = 60586, name = "sacred crossbow" },
		-- Mystic Nature (Druid)
		{ id = 60606, name = "mystic nature mask" },
		{ id = 60608, name = "mystic nature robe" },
		{ id = 60605, name = "mystic nature skirt" },
		{ id = 60604, name = "mystic nature galoshes" },
		{ id = 60603, name = "mystic nature tome" },
		{ id = 60960, name = "mystic nature rod" },
		-- Void Pulse (Sorcerer)
		{ id = 60577, name = "void pulse mask" },
		{ id = 60574, name = "void pulse mantle" },
		{ id = 60578, name = "void pulse pants" },
		{ id = 60576, name = "pair of void pulse shoes" },
		{ id = 60575, name = "void pulse folio" },
		{ id = 60572, name = "void pulse wand" },
	},
}

local randomItems = Action()

function randomItems.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local rewardBag = rewardBags[item.itemid]
	if not rewardBag then
		return false
	end

	local randomIndex = math.random(1, #rewardBag)
	local rewardItem = rewardBag[randomIndex]
	player:addItem(rewardItem.id, 1)
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You received a " .. rewardItem.name .. ".")

	local text = player:getName() .. " received a " .. rewardItem.name .. " from a " .. item:getName() .. "."
	Webhook.sendMessage(":game_die: " .. player:getMarkdownLink() .. " received a **" .. rewardItem.name .. "** from a _" .. item:getName() .. "_.")
	Broadcast(text, function(targetPlayer)
		return targetPlayer ~= player
	end)

	item:remove(1)
	return true
end

for itemId, info in pairs(rewardBags) do
	randomItems:id(tonumber(itemId))
end

randomItems:register()
