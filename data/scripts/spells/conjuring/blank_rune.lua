local spell = Spell("instant")

function spell.onCastSpell(creature, variant)
	return creature:conjureItem(0, 3147, 1)
end

spell:name("Blank Rune")
spell:words("adori blank")
spell:group("support")
spell:vocation("druid;true", "paladin;true", "sorcerer;true", "elder druid;true", "primal druid;true", "royal paladin;true", "celestial paladin;true", "master sorcerer;true", "arcane sorcerer;true")
spell:cooldown(2 * 1000)
spell:groupCooldown(2 * 1000)
spell:level(20)
spell:mana(50)
spell:soul(1)
spell:needLearn(false)
spell:register()
