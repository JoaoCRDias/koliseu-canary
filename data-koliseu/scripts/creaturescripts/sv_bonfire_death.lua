-- Fired when the Supreme Vocation bonfire dies during the fire chamber.
-- Triggers the catastrophic failure sequence (player damage + reset).

local event = CreatureEvent("SvBonfireDeath")

function event.onDeath(creature)
	if not SupremeVocation.fireChamberIsActive() then
		return true
	end
	SupremeVocation.fireChamberFail()
	return true
end

event:register()
