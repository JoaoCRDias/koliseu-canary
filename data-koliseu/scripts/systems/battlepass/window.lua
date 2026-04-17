local BattlePassConfig = dofile("data-koliseu/scripts/systems/battlepass/config_rewards.lua")

local BattlePassWindow = {}

function BattlePassWindow.open(player, season, playerData)
	if not player or not season or not playerData then
		return false
	end

	local window = ModalWindow(1000, "Battle Pass - " .. season.name, "Claim your rewards!")

	-- Calcular dias disponíveis
	local activationTime = playerData.activation_time
	local currentTime = os.time()
	local daysPassed = math.floor((currentTime - activationTime) / 86400) + 1
	daysPassed = math.min(daysPassed, 15) -- Máximo 15 dias

	-- Parsear dias já coletados
	local claimedDays = {}
	if playerData.claimed_days and playerData.claimed_days ~= "" then
		for day in string.gmatch(playerData.claimed_days, "([^,]+)") do
			claimedDays[tonumber(day)] = true
		end
	end

	-- Adicionar recompensas como choices
	local rewards = BattlePassConfig.getSeasonRewards(season.id)
	if not rewards then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "No rewards configured for this season.")
		return false
	end

	for day = 1, 15 do
		local reward = rewards[day]
		if not reward then
			break
		end

		local status = ""

		if claimedDays[day] then
			status = "[CLAIMED] "
		elseif day <= daysPassed then
			status = "[AVAILABLE] "
		else
			status = "[LOCKED] "
		end

		local description = status .. "Day " .. day .. ": " .. reward.description
		window:addChoice(day, description)
	end

	-- Botões
	window:addButton(100, "Claim")
	window:addButton(101, "Close")

	-- Texto de informação
	local claimedCount = playerData.claimed_count or 0
	local infoText = string.format(
		"Days unlocked: %d/15\nDays claimed: %d/15\n\nSelect a reward and click 'Claim' to collect it.",
		daysPassed,
		claimedCount
	)
	window:setMessage(infoText)

	-- Callback para processar escolha
	window:setDefaultEnterButton(100)
	window:setDefaultEscapeButton(101)

	-- Registrar callback
	player:registerEvent("BattlePassWindowCallback")
	player:setStorageValue(Storage.BattlePass.WindowOpen, season.id)

	window:sendToPlayer(player)
	return true
end

return BattlePassWindow
