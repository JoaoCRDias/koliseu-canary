-- Frost mobs inside the fire chamber smash any magic wall or wild growth
-- that appears in their adjacent tiles. Since only players cast these items
-- inside the sealed chamber, no ownership check is needed.

local FROST_NAMES = {
	["Frost Crawler"] = true,
	["Frost Stalker"] = true,
	["Frost Elder"] = true,
	["Hailstorm Brute"] = true,
}

-- All hard-coded magic-wall / wild-growth variants from
-- src/utils/utils_definitions.hpp plus the 21 customization skins
-- (60799-60819) that behave like magic walls.
local SMASH_IDS = {
	[2128] = true,  -- ITEM_MAGICWALL
	[2129] = true,  -- ITEM_MAGICWALL_PERSISTENT
	[10181] = true, -- ITEM_MAGICWALL_SAFE
	[2130] = true,  -- ITEM_WILDGROWTH
	[3635] = true,  -- ITEM_WILDGROWTH_PERSISTENT
	[10182] = true, -- ITEM_WILDGROWTH_SAFE
}
-- Custom magic wall skins 60799..60819
for id = 60799, 60819 do SMASH_IDS[id] = true end

local event = CreatureEvent("SvFrostMobSmash")

local function smashTile(pos)
	local tile = Tile(pos)
	if not tile then return end
	for id in pairs(SMASH_IDS) do
		local item = tile:getItemById(id)
		if item then
			item:remove()
			pos:sendMagicEffect(CONST_ME_POFF)
		end
	end
end

function event.onThink(creature, interval)
	if not creature or not creature:isMonster() then return true end
	local monster = creature:getMonster()
	if not monster or not FROST_NAMES[monster:getName()] then return true end
	if not SupremeVocation.fireChamberIsActive() then return true end

	local pos = monster:getPosition()
	for dx = -1, 1 do
		for dy = -1, 1 do
			smashTile(Position(pos.x + dx, pos.y + dy, pos.z))
		end
	end
	return true
end

event:register()
