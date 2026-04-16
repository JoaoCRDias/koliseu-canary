local THRONE_ACTION_ID = 45001
local MESSAGE = "Não ouse pisar no trono do Rei, bobo da corte"
local OUTFIT_DURATION_MS = 5000

local jesterMale = Condition(CONDITION_OUTFIT)
jesterMale:setTicks(OUTFIT_DURATION_MS)
jesterMale:setOutfit({ lookType = 270 })

local jesterFemale = Condition(CONDITION_OUTFIT)
jesterFemale:setTicks(OUTFIT_DURATION_MS)
jesterFemale:setOutfit({ lookType = 273 })

local throneBlock = MoveEvent()
throneBlock:type("stepin")

function throneBlock.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	local group = player:getGroup()
	if group and group:getName():lower() == "god" then
		return true
	end

	player:teleportTo(fromPosition, false)
	player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)

	if player:getSex() == PLAYERSEX_FEMALE then
		player:addCondition(jesterFemale)
	else
		player:addCondition(jesterMale)
	end

	player:say(MESSAGE, TALKTYPE_MONSTER_SAY, false, player, position)
	return true
end

throneBlock:aid(THRONE_ACTION_ID)
throneBlock:register()
