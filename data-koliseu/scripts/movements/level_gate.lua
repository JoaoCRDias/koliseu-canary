-- Level Gate System
-- Tabela de ActionID -> Level mínimo necessário para passar
-- Para adicionar novas entradas, basta inserir na tabela abaixo:
--   [ACTION_ID] = LEVEL_MINIMO
local levelGates = {
	[50100] = 12000,
}

local levelGate = MoveEvent()
levelGate:type("stepin")

function levelGate.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	local requiredLevel = levelGates[item.actionid]
	if not requiredLevel then
		return true
	end

	if player:getLevel() < requiredLevel then
		player:teleportTo(fromPosition, true)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Voce precisa ser level " .. requiredLevel .. " para passar por aqui.")
		position:sendMagicEffect(CONST_ME_POFF)
		return false
	end

	return true
end

for actionId, _ in pairs(levelGates) do
	levelGate:aid(actionId)
end

levelGate:register()
