-- Settings modal that groups multiple toggle commands
-- Combines: autoloot, chain, flask, dmglog, effects

local STORAGE_DAMAGE_LOG_DISABLED = 53001
local STORAGE_MAGIC_EFFECTS_DISABLED = 53002
local STORAGE_EMOTE_SPELL_DISABLED = 53003
local STORAGE_TASK_ENHANCEMENT = 58100

local settingsConfig = {
	{
		name = "Autoloot",
		getStatus = function(player)
			local feature = player:getFeature(Features.AutoLoot)
			return feature and feature >= 1 or false
		end,
		setStatus = function(player, enabled)
			player:setFeature(Features.AutoLoot, enabled and 1 or 0)
		end,
		checkEnabled = function()
			return configManager.getBoolean(configKeys.AUTOLOOT)
		end,
		checkVip = function(player)
			if configManager.getBoolean(configKeys.VIP_SYSTEM_ENABLED) and configManager.getBoolean(configKeys.VIP_AUTOLOOT_VIP_ONLY) and not player:isVip() then
				return false
			end
			return true
		end,
	},
	{
		name = "Chain System",
		getStatus = function(player)
			local feature = player:getFeature(Features.ChainSystem)
			return feature and feature == true or false
		end,
		setStatus = function(player, enabled)
			player:setFeature(Features.ChainSystem, enabled)
		end,
		checkEnabled = function()
			return configManager.getBoolean(configKeys.TOGGLE_CHAIN_SYSTEM)
		end,
		checkVip = function(player)
			return true
		end,
	},
	{
		name = "Cleave System",
		getStatus = function(player)
			if not Features.CleaveSystem then
				return false
			end
			local feature = player:getFeature(Features.CleaveSystem)
			return feature and feature == true or false
		end,
		setStatus = function(player, enabled)
			if not Features.CleaveSystem then
				return
			end
			player:setFeature(Features.CleaveSystem, enabled)
		end,
		checkEnabled = function()
			return Features.CleaveSystem ~= nil
		end,
		checkVip = function(player)
			return true
		end,
	},
	{
		name = "Flask (No Flasks)",
		getStatus = function(player)
			return player:kv():get("talkaction.potions.flask") == true
		end,
		setStatus = function(player, enabled)
			if enabled then
				player:kv():set("talkaction.potions.flask", true)
			else
				player:kv():remove("talkaction.potions.flask")
			end
		end,
		checkEnabled = function()
			return true
		end,
		checkVip = function(player)
			return true
		end,
	},
	{
		name = "Damage Log",
		getStatus = function(player)
			return player:getStorageValue(STORAGE_DAMAGE_LOG_DISABLED) ~= 1
		end,
		setStatus = function(player, enabled)
			player:setStorageValue(STORAGE_DAMAGE_LOG_DISABLED, enabled and -1 or 1)
		end,
		checkEnabled = function()
			return true
		end,
		checkVip = function(player)
			return true
		end,
	},
	{
		name = "Magic Effects",
		getStatus = function(player)
			return player:getStorageValue(STORAGE_MAGIC_EFFECTS_DISABLED) ~= 1
		end,
		setStatus = function(player, enabled)
			player:setStorageValue(STORAGE_MAGIC_EFFECTS_DISABLED, enabled and -1 or 1)
		end,
		checkEnabled = function()
			return true
		end,
		checkVip = function(player)
			return true
		end,
	},
	{
		name = "Emote",
		getStatus = function(player)
			return player:getStorageValue(STORAGE_EMOTE_SPELL_DISABLED) ~= 1
		end,
		setStatus = function(player, enabled)
			player:setStorageValue(STORAGE_EMOTE_SPELL_DISABLED, enabled and -1 or 1)
		end,
		checkEnabled = function()
			return true
		end,
		checkVip = function(player)
			return true
		end,
	},
	{
		name = "Close Pouch on Sell",
		getStatus = function(player)
			return player:kv():get("settings.close-pouch-on-sell") ~= false
		end,
		setStatus = function(player, enabled)
			player:kv():set("settings.close-pouch-on-sell", enabled)
		end,
		checkEnabled = function()
			return true
		end,
		checkVip = function(player)
			return true
		end,
	},
	{
		name = "Task Enhancement",
		getStatus = function(player)
			return player:getStorageValue(STORAGE_TASK_ENHANCEMENT) == 1
		end,
		setStatus = function(player, enabled)
			player:setStorageValue(STORAGE_TASK_ENHANCEMENT, enabled and 1 or 2)
		end,
		checkEnabled = function(player)
			if not player then return true end
			return player:getStorageValue(STORAGE_TASK_ENHANCEMENT) >= 1
		end,
		checkVip = function(player)
			return true
		end,
	},
}

local function sendSettingsModal(player)
	local window = ModalWindow({
		title = "Player Settings",
		message = "Select a setting to toggle ON or OFF:",
	})

	for i, setting in ipairs(settingsConfig) do
		if setting.checkEnabled(player) then
			local status = "[OFF]"
			if setting.checkVip(player) then
				if setting.getStatus(player) then
					status = "[ON]"
				end
			else
				status = "[VIP]"
			end
			window:addChoice(status .. " " .. setting.name)
		end
	end

	window:addButton("ON", function(player, button, choice)
		if not choice or not choice.text then
			return true
		end

		local settingName = choice.text:gsub("^%[.-%] ", "")
		for _, setting in ipairs(settingsConfig) do
			if setting.name == settingName then
				if not setting.checkEnabled(player) then
					player:sendTextMessage(MESSAGE_EVENT_ADVANCE, setting.name .. " is disabled by the administrator.")
					return true
				end
				if not setting.checkVip(player) then
					player:sendCancelMessage("You need to be VIP to use " .. setting.name .. "!")
					return true
				end
				setting.setStatus(player, true)
				player:sendTextMessage(MESSAGE_EVENT_ADVANCE, setting.name .. " is now ON.")
				player:getPosition():sendMagicEffect(CONST_ME_MAGIC_GREEN)
				return true
			end
		end
		return true
	end)

	window:addButton("OFF", function(player, button, choice)
		if not choice or not choice.text then
			return true
		end

		local settingName = choice.text:gsub("^%[.-%] ", "")
		for _, setting in ipairs(settingsConfig) do
			if setting.name == settingName then
				if not setting.checkEnabled(player) then
					player:sendTextMessage(MESSAGE_EVENT_ADVANCE, setting.name .. " is disabled by the administrator.")
					return true
				end
				if not setting.checkVip(player) then
					player:sendCancelMessage("You need to be VIP to use " .. setting.name .. "!")
					return true
				end
				setting.setStatus(player, false)
				player:sendTextMessage(MESSAGE_EVENT_ADVANCE, setting.name .. " is now OFF.")
				player:getPosition():sendMagicEffect(CONST_ME_MAGIC_RED)
				return true
			end
		end
		return true
	end)

	window:addButton("Close")

	window:setDefaultEnterButton(1)
	window:setDefaultEscapeButton(3)
	window:sendToPlayer(player)
end

local settings = TalkAction("!settings")

function settings.onSay(player, words, param)
	sendSettingsModal(player)
	return true
end

settings:groupType("normal")
settings:register()
