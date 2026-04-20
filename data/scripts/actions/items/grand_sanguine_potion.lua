--[[
	Grand Sanguine Potion - Transforms Sanguine weapons into Grand Sanguine versions
	Warning: This transformation will reset all upgrades, imbuements, and tier levels
]]

local sanguineTransformations = {
	-- [sanguine id] = grand sanguine id
	[43864] = 43865, -- Sanguine Blade -> Grand Sanguine Blade
	[43866] = 43867, -- Sanguine Cudgel -> Grand Sanguine Cudgel
	[43868] = 43869, -- Sanguine Hatchet -> Grand Sanguine Hatchet
	[43870] = 43871, -- Sanguine Razor -> Grand Sanguine Razor
	[43872] = 43873, -- Sanguine Bludgeon -> Grand Sanguine Bludgeon
	[43874] = 43875, -- Sanguine Battleaxe -> Grand Sanguine Battleaxe
	[43877] = 43878, -- Sanguine Bow -> Grand Sanguine Bow
	[43879] = 43880, -- Sanguine Crossbow -> Grand Sanguine Crossbow
	[43882] = 43883, -- Sanguine Coil -> Grand Sanguine Coil
	[43885] = 43886,
}

-- Initialize global transformation confirmations table
if not _G.GrandSanguineConfirmations then
	_G.GrandSanguineConfirmations = {}
end

local function performTransformation(player, weapon, potion, transformTo)
	-- Validate items still exist
	if not weapon or not potion then
		player:sendCancelMessage("The weapon or potion could not be found.")
		return false
	end

	-- Remover a arma antiga primeiro
	weapon:remove(1)

	-- Remover a potion
	potion:remove(1)

	-- Realizar a transformação
	local newItem = player:addItem(transformTo, 1)
	if not newItem then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "An error occurred during the transformation. The weapon and potion were consumed.")
		return false
	end

	-- Efeitos visuais
	player:getPosition():sendMagicEffect(CONST_ME_FIREATTACK)
	player:say("Your weapon has been transformed into its Grand Sanguine version!", TALKTYPE_MONSTER_SAY)

	return true
end

local function showTransformationModal(player, weapon, potion, transformTo)
	local weaponName = weapon:getName()
	local transformedItem = ItemType(transformTo)
	local transformedName = transformedItem:getName()

	-- Check if weapon has any upgrades
	local hasUpgrades = false

	-- Verificar tier
	local tier = weapon:getTier()
	if tier and tier > 0 then
		hasUpgrades = true
	end

	-- Verificar imbuements
	if not hasUpgrades then
		for slot = 1, 3 do
			local imbuement = weapon:getImbuement(slot)
			if imbuement then
				hasUpgrades = true
				break
			end
		end
	end

	-- Verificar special attributes (pode indicar upgrades)
	if not hasUpgrades then
		local specialDesc = weapon:getSpecialDescription()
		if specialDesc and specialDesc ~= "" then
			hasUpgrades = true
		end
	end

	-- Create modal message
	local message
	if hasUpgrades then
		message = string.format([[Transform Sanguine Weapon?

Weapon: %s
Transform to: %s

WARNING: This transformation will remove ALL upgrades, tier levels, imbuements, and special attributes from this weapon!

This transformation is irreversible!
Do you want to continue?]], weaponName, transformedName)
	else
		message = string.format([[Transform Sanguine Weapon?

Weapon: %s
Transform to: %s

Do you want to continue?]], weaponName, transformedName)
	end

	-- Create confirmation key
	local confirmKey = "grand_sanguine_" .. player:getId()

	-- Store weapon, potion and transform data
	_G.GrandSanguineConfirmations[confirmKey] = {
		weapon = weapon,
		potion = potion,
		transformTo = transformTo,
		player = player
	}

	-- Create modal window
	local modal = ModalWindow({
		title = "Grand Sanguine Transformation",
		message = message,
	})

	modal:addButton("Confirm", function(clickedPlayer, button)
		local data = _G.GrandSanguineConfirmations[confirmKey]
		if data then
			performTransformation(clickedPlayer, data.weapon, data.potion, data.transformTo)
		end
		_G.GrandSanguineConfirmations[confirmKey] = nil
	end)

	modal:addButton("Cancel", function(clickedPlayer, button)
		clickedPlayer:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Transformation cancelled.")
		_G.GrandSanguineConfirmations[confirmKey] = nil
	end)

	modal:setDefaultEnterButton(1)
	modal:setDefaultEscapeButton(2)

	modal:sendToPlayer(player)
end

local grandSanguinePotion = Action()

function grandSanguinePotion.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	-- Verificar se tem um target válido
	if not target or not target:isItem() then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You must use this potion on a Sanguine weapon.")
		return true
	end

	local targetId = target:getId()
	local transformTo = sanguineTransformations[targetId]

	-- Verificar se é uma arma Sanguine válida
	if not transformTo then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "This potion can only be used on Sanguine weapons (Blade, Cudgel, Hatchet, Razor, Bludgeon, Battleaxe, Bow, Crossbow, or Coil).")
		return true
	end

	-- Show modal confirmation
	showTransformationModal(player, target, item, transformTo)

	return true
end

grandSanguinePotion:id(60619)
grandSanguinePotion:register()
