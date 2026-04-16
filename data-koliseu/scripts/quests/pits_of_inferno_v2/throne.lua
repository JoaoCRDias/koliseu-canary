-- POI v2 - Throne step-in events
-- Player steps on a throne to absorb its spirit, then gets teleported back to the room entrance

local setting = {
	[21231] = {
		storage = Storage.PitsOfInfernoV2.ThroneRoom1,
		text = "You have conquered the first chamber and absorbed its dark power.",
		effect = CONST_ME_FIREAREA,
		toPosition = Position(683, 1650, 9), -- TODO: set return position for room 1
	},
	[21232] = {
		storage = Storage.PitsOfInfernoV2.ThroneRoom2,
		text = "You have conquered the second chamber and absorbed its dark power.",
		effect = CONST_ME_MORTAREA,
		toPosition = Position(644, 1808, 9), -- TODO: set return position for room 2
	},
	[21233] = {
		storage = Storage.PitsOfInfernoV2.ThroneRoom3,
		text = "You have conquered the third chamber and absorbed its dark power.",
		effect = CONST_ME_POISONAREA,
		toPosition = Position(654, 1737, 9), -- TODO: set return position for room 3
	},
	[21234] = {
		storage = Storage.PitsOfInfernoV2.ThroneRoom4,
		text = "You have conquered the fourth chamber and absorbed its dark power.",
		effect = CONST_ME_EXPLOSIONAREA,
		toPosition = Position(619, 1776, 9), -- TODO: set return position for room 4
	},
	[21235] = {
		storage = Storage.PitsOfInfernoV2.ThroneRoom5,
		text = "You have conquered the fifth chamber and absorbed its dark power.",
		effect = CONST_ME_MAGIC_GREEN,
		toPosition = Position(659, 1616, 9), -- TODO: set return position for room 5
	},
	[21236] = {
		storage = Storage.PitsOfInfernoV2.ThroneRoom6,
		text = "You have conquered the sixth and final chamber. The way forward is open.",
		effect = CONST_ME_HOLYAREA,
		toPosition = Position(722, 1664, 9), -- TODO: set return position for room 6
	},
}

local throne = MoveEvent()

function throne.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end
	local config = setting[item.actionid]
	if not config then
		return true
	end
	if player:getStorageValue(config.storage) ~= 1 then
		player:setStorageValue(config.storage, 1)
		player:getPosition():sendMagicEffect(config.effect)
		player:say(config.text, TALKTYPE_MONSTER_SAY)
	else
		player:teleportTo(config.toPosition)
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		player:say("You have already absorbed the power of this chamber.", TALKTYPE_MONSTER_SAY)
	end
	return true
end

throne:type("stepin")

for aid, _ in pairs(setting) do
	throne:aid(aid)
end

throne:register()
