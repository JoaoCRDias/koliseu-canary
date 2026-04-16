-- Thorgrim the Hammerborn - Death Event
-- Teleports all players out, increases hazard level, and rewards at level 7

local thorgrimDeath = CreatureEvent("ThorgrimTheHammerbornDeath")

local EXIT_POSITION = Position(3109, 3165, 4)

-- Boss room bounds
local ROOM_NW = Position(3102, 3144, 4)
local ROOM_SE = Position(3112, 3160, 4)

-- Hazard zone usada pelo Thorgrim
local HAZARD_NAME = "hazard.edron-kingdom"

-- Reward ao atingir hazard level 7
local REWARD_HAZARD_LEVEL = 7
local REWARD_ITEM_ID = 0 -- PLACEHOLDER: Item ID do reward
local REWARD_AMOUNT = 1

function thorgrimDeath.onDeath(creature)
	local hazard = Hazard.getByName(HAZARD_NAME)
	if not hazard then
		logger.error("[ThorgrimDeath] Hazard '{}' not found!", HAZARD_NAME)
		return true
	end

	-- Get damage map to identify participants
	local damageMap = creature:getDamageMap()
	local participants = {}

	for playerId, damageInfo in pairs(damageMap) do
		local player = Player(playerId)
		if player then
			participants[player:getId()] = player
		end
	end

	-- Get the lowest hazard level among participants (used for levelUp check)
	local _, hazardPoints = hazard:getHazardPlayerAndPoints(damageMap)

	-- Get all players inside boss room bounds
	local cx = math.floor((ROOM_NW.x + ROOM_SE.x) / 2)
	local cy = math.floor((ROOM_NW.y + ROOM_SE.y) / 2)
	local rx = math.ceil((ROOM_SE.x - ROOM_NW.x) / 2)
	local ry = math.ceil((ROOM_SE.y - ROOM_NW.y) / 2)
	local specs = Game.getSpectators(Position(cx, cy, ROOM_NW.z), false, true, rx, rx, ry, ry)

	for _, spec in ipairs(specs) do
		if spec:isPlayer() then
			-- Only participants who dealt damage get hazard levelUp
			if participants[spec:getId()] then
				-- Increase hazard max level by 1 if player is at their max
				local playerMax = hazard:getPlayerMaxLevel(spec)
				local playerCurrent = hazard:getPlayerCurrentLevel(spec)

				if playerCurrent == playerMax and playerMax == hazardPoints then
					hazard:levelUp(spec)
					local newMax = hazard:getPlayerMaxLevel(spec)
					spec:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("Your hazard level has been increased to %d!", newMax))

					-- Check if player reached the reward level
					if newMax >= REWARD_HAZARD_LEVEL and not spec:kv():scoped("thorgrim"):get("hazard-reward-claimed") then
						if REWARD_ITEM_ID > 0 then
							local inbox = spec:getStoreInbox()
							if inbox then
								local reward = inbox:addItem(REWARD_ITEM_ID, REWARD_AMOUNT)
								if reward then
									spec:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have reached hazard level 7! A special reward has been sent to your inbox.")
									spec:kv():scoped("thorgrim"):set("hazard-reward-claimed", true)
								end
							end
						end
					end
				end
			end

			-- Teleport everyone to exit
			spec:teleportTo(EXIT_POSITION, true)
			EXIT_POSITION:sendMagicEffect(CONST_ME_TELEPORT)
			spec:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Thorgrim the Hammerborn has been defeated! The storm subsides...")
		end
	end

	return true
end

thorgrimDeath:register()
