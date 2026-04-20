-- Snowball Throw - Event spell
-- Words: exori infir ico
-- Only works during the Snowball Fight event

local spell = Spell("instant")

function spell.onCastSpell(creature, var)
	local player = creature:getPlayer()
	if not player then
		return false
	end

	-- Only works during Snowball event
	if not Snowball or Snowball.state ~= "running" then
		player:sendCancelMessage("This spell can only be used during the Snowball Fight event.")
		player:getPosition():sendMagicEffect(CONST_ME_POFF)
		return false
	end

	if player:getStorageValue(Snowball.config.storageActive) ~= 1 then
		player:sendCancelMessage("This spell can only be used during the Snowball Fight event.")
		player:getPosition():sendMagicEffect(CONST_ME_POFF)
		return false
	end

	-- Block haste spells for flag carriers (reuse pattern)
	player:getPosition():sendMagicEffect(CONST_ME_ICEATTACK)
	Snowball:throwSnowball(player)
	return true
end

spell:group("attack")
spell:id(300)
spell:name("Snowball Throw")
spell:words("exori infir ico")
spell:castSound(SOUND_EFFECT_TYPE_SPELL_OR_RUNE)
spell:level(1)
spell:mana(0)
spell:isPremium(false)
spell:isSelfTarget(false)
spell:isAggressive(false)
spell:needDirection(true)
spell:blockWalls(false)
spell:cooldown(1 * 1000)
spell:groupCooldown(1 * 1000)
spell:needLearn(false)
spell:vocation("druid;true", "elder druid;true", "sorcerer;true", "master sorcerer;true", "knight;true", "elite knight;true", "paladin;true", "royal paladin;true", "monk;true", "exalted monk;true")
spell:register()
