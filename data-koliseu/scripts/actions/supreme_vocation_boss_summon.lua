-- Item that summons Sylvareth the Unyielding into the boss arena.
-- Only one boss may be alive at a time.

local summon = Action()

function summon.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local cfg = SupremeVocation.NatureBoss

	if not SupremeVocation.isBossAreaClear() then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The guardian still walks the grove. You cannot summon another.")
		return true
	end

	local boss = Game.createMonster(cfg.name, cfg.spawnPosition, false, true)
	if not boss then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The grove resists the summoning. Try again in a moment.")
		return true
	end

	NatureBoss.bossId = boss:getId()
	NatureBoss.phaseActive = false
	NatureBoss.phaseStepsLeft = 0
	NatureBoss.phaseSecondsLeft = 0
	NatureBoss.currentStepPos = nil
	NatureBoss.enrageUntil = 0
	NatureBoss.originalSpeed = boss:getBaseSpeed()

	cfg.spawnPosition:sendMagicEffect(CONST_ME_GREEN_RINGS)
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The guardian of the fountain rises from the moss.")
	return true
end

summon:aid(SupremeVocation.NatureBossSummonActionId)
summon:register()
