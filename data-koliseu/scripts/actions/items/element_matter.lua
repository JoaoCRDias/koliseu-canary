-- Element Matter System
-- Use Matter items on cosmic+ weapons to change their elemental damage type

local matterElements = {
	[60676] = { element = COMBAT_DEATHDAMAGE, name = "death", effect = CONST_ME_MORTAREA },
	[60677] = { element = COMBAT_ICEDAMAGE, name = "ice", effect = CONST_ME_ICEAREA },
	[60678] = { element = COMBAT_HOLYDAMAGE, name = "holy", effect = CONST_ME_HOLYDAMAGE },
	[60679] = { element = COMBAT_FIREDAMAGE, name = "fire", effect = CONST_ME_FIREAREA },
	[60680] = { element = COMBAT_PHYSICALDAMAGE, name = "physical", effect = CONST_ME_HITAREA },
	[60681] = { element = COMBAT_ENERGYDAMAGE, name = "energy", effect = CONST_ME_ENERGYHIT },
	[60682] = { element = COMBAT_EARTHDAMAGE, name = "earth", effect = CONST_ME_POISONAREA },
}

-- Vocation element affinity restrictions
-- Each vocation can only use specific elemental matter types
local vocationAffinities = {
	-- Sorcerer / Master Sorcerer (base voc 1)
	[1] = { COMBAT_ENERGYDAMAGE, COMBAT_DEATHDAMAGE, COMBAT_FIREDAMAGE },
	[5] = { COMBAT_ENERGYDAMAGE, COMBAT_DEATHDAMAGE, COMBAT_FIREDAMAGE },

	-- Druid / Elder Druid (base voc 2)
	[2] = { COMBAT_ICEDAMAGE, COMBAT_EARTHDAMAGE, COMBAT_PHYSICALDAMAGE },
	[6] = { COMBAT_ICEDAMAGE, COMBAT_EARTHDAMAGE, COMBAT_PHYSICALDAMAGE },

	-- Paladin / Royal Paladin (base voc 3)
	[3] = { COMBAT_PHYSICALDAMAGE, COMBAT_ENERGYDAMAGE, COMBAT_EARTHDAMAGE, COMBAT_ICEDAMAGE, COMBAT_DEATHDAMAGE, COMBAT_FIREDAMAGE },
	[7] = { COMBAT_PHYSICALDAMAGE, COMBAT_ENERGYDAMAGE, COMBAT_EARTHDAMAGE, COMBAT_ICEDAMAGE, COMBAT_DEATHDAMAGE, COMBAT_FIREDAMAGE },

	-- Knight / Elite Knight (base voc 4) - All elements
	[4] = { COMBAT_PHYSICALDAMAGE, COMBAT_ENERGYDAMAGE, COMBAT_EARTHDAMAGE, COMBAT_ICEDAMAGE, COMBAT_DEATHDAMAGE, COMBAT_FIREDAMAGE },
	[8] = { COMBAT_PHYSICALDAMAGE, COMBAT_ENERGYDAMAGE, COMBAT_EARTHDAMAGE, COMBAT_ICEDAMAGE, COMBAT_DEATHDAMAGE, COMBAT_FIREDAMAGE },
}

-- Cosmic+ weapons that support element change
-- Maps weapon ID -> vocation IDs that own that weapon
-- Restrictions are applied based on the weapon's vocation, not the player's
local cosmicWeapons = {
	-- Cosmic melee (Knight: voc 4/8)
	[60921] = { 4, 8 }, -- astral sword
	[60918] = { 4, 8 }, -- astral club
	[60920] = { 4, 8 }, -- astral axe
	[60598] = { 4, 8 }, -- bloodrage sword
	[60591] = { 4, 8 }, -- bloodrage club
	[60589] = { 4, 8 }, -- bloodrage axe
	[60545] = { 4, 8 }, -- cosmic sword
	[60546] = { 4, 8 }, -- cosmic club
	[60547] = { 4, 8 }, -- cosmic axe

	-- Sunray melee (Knight: voc 4/8)
	[63371] = { 4, 8 }, -- sunray sword
	[63373] = { 4, 8 }, -- sunray club
	[63368] = { 4, 8 }, -- sunray axe

	-- Cosmic distance (Paladin: voc 3/7)
	[60586] = { 3, 7 }, -- sacred crossbow
	[60911] = { 3, 7 }, -- astral crossbow
	[60566] = { 3, 7 }, -- cosmic crossbow

	-- Sunray distance (Paladin: voc 3/7)
	[63372] = { 3, 7 }, -- sunray crossbow

	-- Cosmic wand (Sorcerer: voc 1/5)
	[60572] = { 1, 5 }, -- void pulse wand
	[60934] = { 1, 5 }, -- astral wand
	[60553] = { 1, 5 }, -- cosmic wand

	-- Sunray wand (Sorcerer: voc 1/5)
	[63369] = { 1, 5 }, -- sunray wand

	-- Cosmic rod (Druid: voc 2/6)
	[60960] = { 2, 6 }, -- mystic nature rod
	[60928] = { 2, 6 }, -- astral rod
	[60559] = { 2, 6 }, -- cosmic rod

	-- Sunray rod (Druid: voc 2/6)
	[63370] = { 2, 6 }, -- sunray rod
}

-- Wands/rods cannot use Physical Matter (they deal only elemental damage)
local wandRodIds = {
	[60553] = true, -- cosmic wand
	[60559] = true, -- cosmic rod
	[63369] = true, -- sunray wand
	[63370] = true, -- sunray rod
}

-- Default element of wands/rods (avoids relying on getElementType() which
-- can return wrong value due to elemental magic level point attributes)
local defaultWandElement = {
	[60553] = COMBAT_ENERGYDAMAGE, -- cosmic wand -> energy
	[60559] = COMBAT_EARTHDAMAGE, -- cosmic rod  -> earth
	[63369] = COMBAT_ENERGYDAMAGE, -- sunray wand -> energy
	[63370] = COMBAT_EARTHDAMAGE, -- sunray rod  -> earth
}

local elementMatter = Action()

function elementMatter.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if not target or type(target) ~= "userdata" or not target:isItem() then
		player:sendCancelMessage("You can only use this on a weapon.")
		return true
	end

	local targetId = target:getId()
	local weaponVocs = cosmicWeapons[targetId]
	if not weaponVocs then
		player:sendCancelMessage("You can not use matter on that weapon.")
		return true
	end

	local matterData = matterElements[item:getId()]
	if not matterData then
		return false
	end




	-- Check restrictions based on the weapon's vocation, not the player's vocation
	local allowedElements = nil
	for _, vocId in ipairs(weaponVocs) do
		if vocationAffinities[vocId] then
			allowedElements = vocationAffinities[vocId]
			break
		end
	end

	if allowedElements then
		local hasAffinity = false
		for _, allowedElement in ipairs(allowedElements) do
			if allowedElement == matterData.element then
				hasAffinity = true
				break
			end
		end

		if not hasAffinity then
			player:sendCancelMessage("This weapon cannot receive " .. matterData.name .. " matter.")
			return true
		end
	end

	-- Check if weapon already has this element
	local currentElement = target:getCustomAttribute("element_type")
	local isWandRod = wandRodIds[targetId]
	if matterData.element == COMBAT_PHYSICALDAMAGE then
		-- Physical Matter: remove override to restore default damage
		if not currentElement then
			-- For wands/rods, no custom attribute means default element (earth/energy), not physical
			-- So physical matter should still work to override to physical
			if not isWandRod then
				player:sendCancelMessage("This weapon already deals full physical damage.")
				return true
			end
		end
		if isWandRod then
			-- Wands/rods: set physical as custom attribute (their default is elemental)
			target:setCustomAttribute("element_type", COMBAT_PHYSICALDAMAGE)
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have changed your weapon's element to physical.")
		else
			target:removeCustomAttribute("element_type")
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have restored your weapon to full physical damage.")
		end
	else
		if currentElement and currentElement == matterData.element then
			player:sendCancelMessage("This weapon already has " .. matterData.name .. " element.")
			return true
		end

		-- For wands/rods, use the hardcoded default element (avoids getElementType() bug)
		if not currentElement and isWandRod then
			local defaultElem = defaultWandElement[targetId]
			if defaultElem and defaultElem == matterData.element then
				player:sendCancelMessage("This weapon already has " .. matterData.name .. " element.")
				return true
			end
		end

		target:setCustomAttribute("element_type", matterData.element)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have changed your weapon's element to " .. matterData.name .. ".")
	end

	-- Visual feedback
	player:getPosition():sendMagicEffect(matterData.effect)

	-- Consume the matter item
	item:remove(1)
	return true
end

for matterId, _ in pairs(matterElements) do
	elementMatter:id(matterId)
end
elementMatter:register()
