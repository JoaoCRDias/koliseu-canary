local STORAGE_ATTACK_SPEED = 55001
local STORAGE_CRIT_CHANCE = 55002
local STORAGE_MITIGATION = 55003

local upgrades = {
	{
		name = "Attack Speed Cap",
		storage = STORAGE_ATTACK_SPEED,
		maxLevel = 50,
		description = "Reduz o cap de attack speed em 1ms por level (250ms -> 200ms).",
		tiers = {
			{ from = 1, to = 25, cost = 10000 },
			{ from = 26, to = 50, cost = 25000 },
		},
	},
	{
		name = "Critical Hit Chance Cap",
		storage = STORAGE_CRIT_CHANCE,
		maxLevel = 250,
		description = "Aumenta o cap de critical hit chance em 0.1% por level (50% -> 75%).",
		tiers = {
			{ from = 1, to = 100, cost = 10000 },
			{ from = 101, to = 200, cost = 25000 },
			{ from = 201, to = 250, cost = 45000 },
		},
	},
	{
		name = "Mitigation Cap",
		storage = STORAGE_MITIGATION,
		maxLevel = 150,
		description = "Aumenta o cap de mitigation em 0.1% por level (PvP 50% -> 65%, PvE 60% -> 75%).",
		tiers = {
			{ from = 1, to = 50, cost = 10000 },
			{ from = 51, to = 100, cost = 25000 },
			{ from = 101, to = 150, cost = 45000 },
		},
	},
}

local function getPlayerLevel(player, upgrade)
	local val = player:getStorageValue(upgrade.storage)
	return val > 0 and val or 0
end

local function getCostForNextLevel(upgrade, currentLevel)
	local nextLevel = currentLevel + 1
	if nextLevel > upgrade.maxLevel then
		return nil
	end
	for _, tier in ipairs(upgrade.tiers) do
		if nextLevel >= tier.from and nextLevel <= tier.to then
			return tier.cost
		end
	end
	return nil
end

local function getTotalCostForTier(tier)
	return (tier.to - tier.from + 1) * tier.cost
end

local function formatNumber(n)
	local formatted = tostring(n)
	local k
	while true do
		formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", "%1.%2")
		if k == 0 then
			break
		end
	end
	return formatted
end

local function formatUpgradeChoice(player, upgrade)
	local currentLevel = getPlayerLevel(player, upgrade)
	local nextCost = getCostForNextLevel(upgrade, currentLevel)
	local info = string.format("%s [%d/%d]", upgrade.name, currentLevel, upgrade.maxLevel)
	if nextCost then
		info = info .. string.format(" - Proximo: %s HTP", formatNumber(nextCost))
	else
		info = info .. " - MAX"
	end
	return info
end

local htpBonus = TalkAction("!htp")

function htpBonus.onSay(player, words, param)
	local points = player:getTaskHuntingPoints()

	local message = string.format("Seus Hunting Task Points: %s\n\n", formatNumber(points))
	message = message .. "Selecione um upgrade para comprar o proximo level:\n\n"

	for _, upgrade in ipairs(upgrades) do
		local currentLevel = getPlayerLevel(player, upgrade)
		message = message .. string.format("-- %s --\n", upgrade.name)
		message = message .. upgrade.description .. "\n"
		message = message .. string.format("Level: %d/%d\n", currentLevel, upgrade.maxLevel)
		for _, tier in ipairs(upgrade.tiers) do
			local tierTotal = getTotalCostForTier(tier)
			message = message .. string.format("  Levels %d-%d: %s HTP cada (total: %s)\n", tier.from, tier.to, formatNumber(tier.cost), formatNumber(tierTotal))
		end
		message = message .. "\n"
	end

	local window = ModalWindow({
		title = "HTP Bonus System",
		message = message,
	})

	for _, upgrade in ipairs(upgrades) do
		local currentLevel = getPlayerLevel(player, upgrade)
		if currentLevel < upgrade.maxLevel then
			window:addChoice(formatUpgradeChoice(player, upgrade), function(player, button, choice)
				if button.name ~= "Upgrade" then
					return true
				end

				local lvl = getPlayerLevel(player, upgrade)
				local cost = getCostForNextLevel(upgrade, lvl)
				if not cost then
					player:sendTextMessage(MESSAGE_EVENT_ADVANCE, upgrade.name .. " ja esta no level maximo.")
					return true
				end

				local pts = player:getTaskHuntingPoints()
				if pts < cost then
					player:sendTextMessage(MESSAGE_EVENT_ADVANCE,
						string.format("Voce precisa de %s HTP mas so tem %s.", formatNumber(cost), formatNumber(pts)))
					return true
				end

				player:removeTaskHuntingPoints(cost)
				player:setStorageValue(upgrade.storage, lvl + 1)
				player:sendTextMessage(MESSAGE_EVENT_ADVANCE,
					string.format("%s melhorado para level %d! (%s HTP gastos)", upgrade.name, lvl + 1, formatNumber(cost)))
				return true
			end)
		else
			window:addChoice(formatUpgradeChoice(player, upgrade), function(player, button, choice)
				if button.name == "Upgrade" then
					player:sendTextMessage(MESSAGE_EVENT_ADVANCE, upgrade.name .. " ja esta no level maximo!")
				end
				return true
			end)
		end
	end

	window:addButton("Upgrade")
	window:addButton("Close")
	window:setDefaultEnterButton(0)
	window:setDefaultEscapeButton(1)
	window:sendToPlayer(player)
	return false
end

htpBonus:separator(" ")
htpBonus:groupType("normal")
htpBonus:register()
