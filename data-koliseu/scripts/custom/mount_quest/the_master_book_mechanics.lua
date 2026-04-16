-- The Master Book - Rage mechanic
-- When HP drops to <= 500k, players have 60 seconds to kill it.
-- If time expires, the boss fully regenerates.

local RAGE_THRESHOLD = 500000
local RAGE_DURATION = 60 * 1000 -- 1 minute in ms

-- Runtime state keyed by boss uid so multiple instances stay independent.
_G.TheMasterBookRage = _G.TheMasterBookRage or {}
local RageState = _G.TheMasterBookRage

local function clearState(bossId)
	local entry = RageState[bossId]
	if not entry then
		return
	end
	if entry.event then
		stopEvent(entry.event)
	end
	RageState[bossId] = nil
end

local function broadcastToSpectators(pos, message)
	local specs = Game.getSpectators(pos, false, true, 15, 15, 15, 15)
	for _, p in ipairs(specs) do
		p:sendTextMessage(MESSAGE_EVENT_ADVANCE, message)
	end
end

local rage = CreatureEvent("TheMasterBookRage")

function rage.onHealthChange(creature, attacker, primaryDamage, primaryType, secondaryDamage, secondaryType, origin)
	if not creature or creature:getName():lower() ~= "the master book" then
		return primaryDamage, primaryType, secondaryDamage, secondaryType
	end

	local bossId = creature:getId()
	local hpAfter = creature:getHealth() - (primaryDamage or 0) - (secondaryDamage or 0)

	-- Trigger rage only once, when HP crosses the threshold
	if not RageState[bossId] and hpAfter <= RAGE_THRESHOLD and hpAfter > 0 then
		local pos = creature:getPosition()
		pos:sendMagicEffect(CONST_ME_MAGIC_RED)
		creature:say("You have one minute... or my wounds will mend!", TALKTYPE_MONSTER_SAY)
		broadcastToSpectators(pos, "The Master Book enters a frenzy! Kill it within 60 seconds or it will fully regenerate!")

		local eventId = addEvent(function(id)
			local boss = Monster(id)
			local state = RageState[id]
			RageState[id] = nil
			if not boss or not state then
				return
			end
			if boss:getHealth() <= 0 then
				return
			end

			boss:addHealth(boss:getMaxHealth())
			local bossPos = boss:getPosition()
			bossPos:sendMagicEffect(CONST_ME_MAGIC_GREEN)
			boss:say("My wounds are mended! Your efforts were in vain!", TALKTYPE_MONSTER_SAY)
			broadcastToSpectators(bossPos, "The Master Book has fully regenerated!")
		end, RAGE_DURATION, bossId)

		RageState[bossId] = { event = eventId }
	end

	return primaryDamage, primaryType, secondaryDamage, secondaryType
end

rage:register()

-- Clean up state when the boss dies
local rageDeath = CreatureEvent("TheMasterBookRageDeath")

function rageDeath.onDeath(creature)
	if creature and creature:getName():lower() == "the master book" then
		clearState(creature:getId())
	end
	return true
end

rageDeath:register()


