local MW_SKINS = {
	{ id = 60799, name = "Magic Wall Skin 1" },
	{ id = 60800, name = "Magic Wall Skin 2" },
	{ id = 60801, name = "Magic Wall Skin 3" },
	{ id = 60802, name = "Magic Wall Skin 4" },
	{ id = 60803, name = "Magic Wall Skin 5" },
	{ id = 60804, name = "Magic Wall Skin 6" },
	{ id = 60805, name = "Magic Wall Skin 7" },
	{ id = 60806, name = "Magic Wall Skin 8" },
	{ id = 60807, name = "Magic Wall Skin 9" },
	{ id = 60808, name = "Magic Wall Skin 10" },
	{ id = 60809, name = "Magic Wall Skin 11" },
	{ id = 60810, name = "Magic Wall Skin 12" },
	{ id = 60811, name = "Magic Wall Skin 13" },
	{ id = 60812, name = "Magic Wall Skin 14" },
	{ id = 60813, name = "Magic Wall Skin 15" },
	{ id = 60814, name = "Magic Wall Skin 16" },
	{ id = 60815, name = "Magic Wall Skin 17" },
	{ id = 60816, name = "Magic Wall Skin 18" },
	{ id = 60817, name = "Magic Wall Skin 19" },
	{ id = 60818, name = "Magic Wall Skin 20" },
	{ id = 60819, name = "Magic Wall Skin 21" },
}

local function sendMWSkinModal(player)
	local kvScope = player:kv():scoped("mw-skins")
	local selected = kvScope:get("selected") or 0

	local window = ModalWindow({
		title = "Magic Wall Skins",
		message = "Select your active Magic Wall skin.\nPurchase skins in the Store.",
	})

	local defaultLabel = (selected == 0) and "[ACTIVE] Default" or "Default"
	window:addChoice(defaultLabel)

	for _, skin in ipairs(MW_SKINS) do
		if kvScope:get("skin_" .. skin.id) then
			local label = (selected == skin.id) and ("[ACTIVE] " .. skin.name) or skin.name
			window:addChoice(label)
		end
	end

	window:addButton("Select", function(clickedPlayer, button, choice)
		if not choice or not choice.text then
			return true
		end

		local choiceName = choice.text:gsub("^%[ACTIVE%] ", "")
		local scope = clickedPlayer:kv():scoped("mw-skins")

		if choiceName == "Default" then
			scope:set("selected", 0)
			clickedPlayer:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Magic Wall skin set to Default.")
			clickedPlayer:getPosition():sendMagicEffect(CONST_ME_MAGIC_GREEN)
			return true
		end

		for _, skin in ipairs(MW_SKINS) do
			if skin.name == choiceName then
				if not scope:get("skin_" .. skin.id) then
					clickedPlayer:sendCancelMessage("You don't own this skin.")
					return true
				end
				scope:set("selected", skin.id)
				clickedPlayer:sendTextMessage(MESSAGE_EVENT_ADVANCE,
					string.format("Magic Wall skin set to '%s'.", skin.name))
				clickedPlayer:getPosition():sendMagicEffect(CONST_ME_MAGIC_GREEN)
				return true
			end
		end
		return true
	end)

	window:addButton("Close")
	window:setDefaultEnterButton(1)
	window:setDefaultEscapeButton(2)
	window:sendToPlayer(player)
end

local mwCommand = TalkAction("!mw")

function mwCommand.onSay(player, words, param)
	sendMWSkinModal(player)
	return true
end

mwCommand:groupType("normal")
mwCommand:register()
