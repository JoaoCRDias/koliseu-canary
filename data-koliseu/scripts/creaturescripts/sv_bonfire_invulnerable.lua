-- Supreme Bonfire damage filter.
--
-- - Damage from players is always neutralised (the bonfire cannot be harmed
--   by players).
-- - Player fire damage heals the bonfire for `fireHealMultiplier` times the
--   incoming damage:
--     * Fire field ticks (ORIGIN_CONDITION) heal every tick — no cooldown.
--     * Other fire damage (spell / rune / weapon) heals once per
--       fireHealCooldownSeconds window.
-- - Damage from monsters is the only thing that can reduce the bonfire's HP.

local event = CreatureEvent("SvBonfireInvulnerable")

local function tryHeal(creature, cfg, incomingDamage, bypassCooldown)
	if bypassCooldown or SupremeVocation.fireChamberCanHeal() then
		local heal = math.floor(math.abs(incomingDamage) * cfg.fireHealMultiplier)
		if heal > 0 then
			creature:addHealth(heal)
		end
		if not bypassCooldown then
			SupremeVocation.fireChamberMarkHealDone()
		end
		creature:getPosition():sendMagicEffect(CONST_ME_FIREATTACK)
	end
end

function event.onHealthChange(creature, attacker, primaryDamage, primaryType, secondaryDamage, secondaryType, origin)
	-- Not damage — let through.
	if primaryDamage >= 0 and secondaryDamage >= 0 then
		return primaryDamage, primaryType, secondaryDamage, secondaryType
	end

	-- Any damage coming from a player is fully neutralised; fire damage also
	-- heals (fields with no cooldown, other sources with cooldown).
	if attacker and attacker:isPlayer() then
		local cfg = SupremeVocation.FireChamber
		if primaryType == COMBAT_FIREDAMAGE then
			tryHeal(creature, cfg, primaryDamage, origin == ORIGIN_CONDITION)
		elseif secondaryType == COMBAT_FIREDAMAGE then
			tryHeal(creature, cfg, secondaryDamage, origin == ORIGIN_CONDITION)
		end
		return 0, primaryType, 0, secondaryType
	end

	-- Monster damage passes through normally.
	return primaryDamage, primaryType, secondaryDamage, secondaryType
end

event:register()
