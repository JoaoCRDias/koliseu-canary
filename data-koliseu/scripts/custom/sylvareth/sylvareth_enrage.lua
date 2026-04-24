-- Amplifies Sylvareth's outgoing damage during its enrage window (after a
-- failed purify-phase timeout). Implemented as a creatureOnCombat callback so
-- we only touch damage coming from this specific boss.

local callback = EventCallback("SylvarethEnrageDamage")

function callback.creatureOnCombat(caster, target, damage)
	if not caster or not target then
		return true
	end

	local monster = caster:getMonster()
	if not monster or monster:getName() ~= SupremeVocation.NatureBoss.name then
		return true
	end

	if not SupremeVocation.isBossEnraged() then
		return true
	end

	local bonus = SupremeVocation.getBossEnrageBonusPercent() / 100
	if damage.primary.value < 0 then
		damage.primary.value = damage.primary.value + math.ceil(damage.primary.value * bonus)
	end
	if damage.secondary.value < 0 then
		damage.secondary.value = damage.secondary.value + math.ceil(damage.secondary.value * bonus)
	end
end

callback:register()
