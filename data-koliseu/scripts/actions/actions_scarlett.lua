local armorId = 31482
local armorPos = Position(1476, 1220, 15)

local function createArmor(id, amount, pos)
	local armor = Game.createItem(id, amount, pos)
	if armor then
		armor:setActionId(40003)
	end
end

local config = {
	boss = {
		name = "Scarlett Etzel",
		createFunction = function()
			local scarlett = Game.createMonster("Scarlett Etzel", Position(1474, 1221, 15), true, true)
			scarlett:setStorageValue(Storage.U12_20.GraveDanger.Cobra, 1)
			return scarlett
		end,
	},
	playerPositions = {
		{ pos = Position(1473, 1241, 15), teleport = Position(1473, 1238, 15) },
		{ pos = Position(1473, 1242, 15), teleport = Position(1473, 1238, 15) },
		{ pos = Position(1473, 1243, 15), teleport = Position(1473, 1238, 15) },
		{ pos = Position(1474, 1242, 15), teleport = Position(1473, 1238, 15) },
		{ pos = Position(1472, 1242, 15), teleport = Position(1473, 1238, 15) },
	},
	specPos = {
		from = Position(1464, 1219, 15),
		to = Position(1483, 1239, 15),
	},
	onUseExtra = function()
		SCARLETT_MAY_TRANSFORM = 0
	end,
	exit = Position(1473, 1246, 15),
}

local lever = BossLever(config)
lever:position(Position(1473, 1240, 15))
lever:register()

local transformTo = {
	[31474] = 31475,
	[31475] = 31476,
	[31476] = 31477,
	[31477] = 31474,
}

local mirror = {
	fromPos = Position(1468, 1222, 15),
	toPos = Position(1480, 1234, 15),
	mirrors = { 31474, 31475, 31476, 31477 },
}

local function backMirror()
	for x = mirror.fromPos.x, mirror.toPos.x do
		for y = mirror.fromPos.y, mirror.toPos.y do
			local sqm = Tile(Position(x, y, 15))

			if sqm then
				for _, id in pairs(mirror.mirrors) do
					local item = sqm:getItemById(id)
					if item then
						item:transform(mirror.mirrors[math.random(#mirror.mirrors)])
						item:getPosition():sendMagicEffect(CONST_ME_POFF)
					end
				end
			end
		end
	end
end

local graveScarlettAid = Action()

function graveScarlettAid.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if table.contains(transformTo, item.itemid) then
		local pilar = transformTo[item.itemid]
		if pilar then
			item:transform(pilar)
			item:getPosition():sendMagicEffect(CONST_ME_POFF)
		end
	elseif item.itemid == armorId then
		item:getPosition():sendMagicEffect(CONST_ME_THUNDER)
		item:remove(1)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You hold the old chestplate of Galthein in front of you. It does not fit and far too old to withstand any attack.")
		addEvent(createArmor, 10 * 1000, armorId, 1, armorPos)
		addEvent(backMirror, 10 * 1000)
		SCARLETT_MAY_TRANSFORM = 1
		addEvent(function()
			SCARLETT_MAY_TRANSFORM = 0
		end, 2000)
	end

	return true
end

graveScarlettAid:aid(40003)
graveScarlettAid:register()
