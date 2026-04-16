local megalomaniaDeath = CreatureEvent("MegalomaniaDeath")

function megalomaniaDeath.onDeath(creature, corpse, killer, mostDamageKiller, lastHitUnjustified, mostDamageUnjustified)
	local killers = creature:getKillers(true)
	for i, killerPlayer in ipairs(killers) do
		local soulWarQuest = killerPlayer:soulWarQuestKV()
		-- Checks if the boss has already been defeated
		if not soulWarQuest:get("goshnar's-megalomania-killed") then
			soulWarQuest:set("goshnar's-megalomania-killed", true)
			-- TODO: ADD OUTFIT TO PLAYER
			killerPlayer:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have defeated Goshnar's Megalomania.")
		end
	end
	return true
end

megalomaniaDeath:register()
