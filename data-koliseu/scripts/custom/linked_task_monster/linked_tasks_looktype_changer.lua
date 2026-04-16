-- Configuration for Linked Tasks monster looktype changer
local config = {
	monsterName = "Linked Tasks",
	changeInterval = 5000, -- Time in milliseconds between looktype changes (5 seconds)

	looktypes = {
		25,   -- Minotaur
		79,   -- Ancient Scarab
		68,   -- Vampire
		73,   -- Hero
		856,  -- Hellflayer
		240,  -- Hellhound
		150,  -- Midnight Asura
		1061, -- Burning Book
		1139, -- Spiky Carnivor
		1296, -- Many Faces
		1626, -- Oozing Carcass
		1659, -- Sopping Corpus
		1298, -- Capricious Phantom
		3005, -- Anomaly Man
		3002, -- Gloomcaster Minister
		676,  -- Venomrot Wraith
		3171, -- Rotmaw Ogre
		3191, -- Gloomcaster President
	},

	useLookTypeEx = false,
}

if not _G.LinkedTaskLooktypeIndex then
	_G.LinkedTaskLooktypeIndex = {}
end

if not _G.LinkedTaskLastChangeTime then
	_G.LinkedTaskLastChangeTime = {}
end

local linkedTaskLooktypeChanger = CreatureEvent("LinkedTaskLooktypeChanger")

function linkedTaskLooktypeChanger.onThink(creature)
	if not creature or not creature:isMonster() then
		return false
	end

	if creature:getName():lower() ~= config.monsterName:lower() then
		return true
	end

	local creatureId = creature:getId()
	if not _G.LinkedTaskLooktypeIndex[creatureId] then
		_G.LinkedTaskLooktypeIndex[creatureId] = 1
	end

	local currentTime = os.time() * 1000
	local lastChangeTime = _G.LinkedTaskLastChangeTime[creatureId] or 0

	if currentTime - lastChangeTime < config.changeInterval then
		return true
	end

	_G.LinkedTaskLastChangeTime[creatureId] = currentTime

	local currentIndex = _G.LinkedTaskLooktypeIndex[creatureId]
	local nextIndex = currentIndex + 1

	if nextIndex > #config.looktypes then
		nextIndex = 1
	end

	_G.LinkedTaskLooktypeIndex[creatureId] = nextIndex

	local newLooktype = config.looktypes[nextIndex]
	local outfit = creature:getOutfit()

	if config.useLookTypeEx then
		outfit.lookTypeEx = newLooktype
		outfit.lookType = 0
	else
		outfit.lookType = newLooktype
		outfit.lookTypeEx = 0
	end

	creature:setOutfit(outfit)
	creature:getPosition():sendMagicEffect(CONST_ME_TELEPORT)

	return true
end

linkedTaskLooktypeChanger:register()
