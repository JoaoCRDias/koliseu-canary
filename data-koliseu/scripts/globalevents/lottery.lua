local lottery = GlobalEvent("lottery")

local config = {
	interval = 60, -- 1 minute
	rewards = {
		{ 49272, 1 }, -- Reflect pot
		{ 44604, 1 }, -- greater gem
		{ 44607, 1 }, -- greater gem
		{ 44610, 1 }, -- greater gem
		{ 44613, 1 }, -- greater gem
		{ 60141, 1 }, -- exercise weapon token
		{ 36725, 1 }, -- Stamina extension
		{ 60129, 3 }, -- task token
		{ 60083, 3 }, -- boss token
	},
	website = false
}

function lottery.onThink(interval)
	local players = {}
	for _, player in ipairs(Game.getPlayers()) do
		if not player:getGroup():getAccess() then
			table.insert(players, player)
		end
	end

	local c = #players
	if c <= 0 then
		return true
	end

	local winner = players[math.random(#players)]

	local reward = config.rewards[math.random(#config.rewards)]
	local itemid, amount = reward[1], reward[2]
	winner:addItemStoreInbox(itemid, amount, true, false)

	local it = ItemType(itemid)
	local name = (amount == 1) and (it:getArticle() .. " " .. it:getName()) or (amount .. " " .. it:getPluralName())

	broadcastMessage("[LOTTERY SYSTEM] " .. winner:getName() .. " won " .. name .. "! Congratulations! (Next lottery in " .. config.interval .. " minutes)")

	return true
end

lottery:interval(config.interval * 60 * 1000) -- Convert minutes to milliseconds
lottery:register()
