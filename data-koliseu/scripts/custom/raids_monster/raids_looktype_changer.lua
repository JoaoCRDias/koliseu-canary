-- Configuration for Raids monster looktype changer
-- Add or remove looktype IDs that you want the monster to cycle through
local config = {
	monsterName = "Raids",
	changeInterval = 5000, -- Time in milliseconds between looktype changes (5 seconds)

	-- Configure the looktypes here - the monster will cycle through these
	looktypes = {
		229, -- Male citizen
		201,
		12,
		591,
		595,
		295,
	},

	-- Optional: You can also use lookTypeEx (item IDs) instead of lookType
	-- Set to true to use lookTypeEx instead
	useLookTypeEx = false,
}

-- Global storage for tracking current looktype index per monster
if not _G.RaidsLooktypeIndex then
	_G.RaidsLooktypeIndex = {}
end

-- Global storage for tracking last change time per monster
if not _G.RaidsLastChangeTime then
	_G.RaidsLastChangeTime = {}
end

local raidsLooktypeChanger = CreatureEvent("RaidsLooktypeChanger")

function raidsLooktypeChanger.onThink(creature)
	if not creature or not creature:isMonster() then
		return false
	end

	if creature:getName():lower() ~= config.monsterName:lower() then
		return true
	end

	-- Get or initialize the looktype index for this specific creature
	local creatureId = creature:getId()
	if not _G.RaidsLooktypeIndex[creatureId] then
		_G.RaidsLooktypeIndex[creatureId] = 1
	end

	-- Check if enough time has passed since last change
	local currentTime = os.time() * 1000 -- Convert to milliseconds
	local lastChangeTime = _G.RaidsLastChangeTime[creatureId] or 0

	if currentTime - lastChangeTime < config.changeInterval then
		return true -- Not enough time has passed, skip this tick
	end

	-- Update last change time
	_G.RaidsLastChangeTime[creatureId] = currentTime

	-- Get current index and increment
	local currentIndex = _G.RaidsLooktypeIndex[creatureId]
	local nextIndex = currentIndex + 1

	-- Loop back to first looktype if we've reached the end
	if nextIndex > #config.looktypes then
		nextIndex = 1
	end

	-- Update the index
	_G.RaidsLooktypeIndex[creatureId] = nextIndex

	-- Get the new looktype
	local newLooktype = config.looktypes[nextIndex]

	-- Get current outfit
	local outfit = creature:getOutfit()

	-- Change the looktype
	if config.useLookTypeEx then
		outfit.lookTypeEx = newLooktype
		outfit.lookType = 0
	else
		outfit.lookType = newLooktype
		outfit.lookTypeEx = 0
	end

	-- Apply the new outfit
	creature:setOutfit(outfit)

	-- Optional: Send magic effect when changing
	creature:getPosition():sendMagicEffect(CONST_ME_TELEPORT)

	return true
end

raidsLooktypeChanger:register()
