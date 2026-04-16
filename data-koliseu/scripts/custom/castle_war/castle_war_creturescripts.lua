local mwPositionsToSiegeGenerator = {
	Position(590, 810, 7),
	Position(591, 810, 7),
	Position(592, 810, 7),
	Position(595, 813, 7),
	Position(595, 814, 7),
	Position(595, 815, 7),
	Position(592, 818, 7),
	Position(591, 818, 7),
	Position(590, 818, 7),
	Position(587, 815, 7),
	Position(587, 814, 7),
	Position(587, 813, 7)
}

local mwPositionsToThrone = {
	Position(590, 813, 6),
	Position(591, 813, 6),
	Position(592, 813, 6)
}

local WarGeneratorDeath = CreatureEvent("WarGeneratorDeath")

function WarGeneratorDeath.onDeath(creature, corpse, killer, mostDamageKiller, lastHitUnjustified, mostDamageUnjustified)
	Castle.warGeneratorCount = Castle.warGeneratorCount - 1
	if Castle.warGeneratorCount <= 0 then
		for _, position in ipairs(mwPositionsToSiegeGenerator) do
			local tile = Tile(position)
			if tile then
				local item = tile:getItemById(2129)
				if item then
					item:remove()
				end
			end
		end
	end
	return true
end

WarGeneratorDeath:register()

local SiegeGeneratorDeath = CreatureEvent("SiegeGeneratorDeath")

function SiegeGeneratorDeath.onDeath(creature, corpse, killer, mostDamageKiller, lastHitUnjustified, mostDamageUnjustified)
	for _, position in ipairs(mwPositionsToThrone) do
		local tile = Tile(position)
		if tile then
			local item = tile:getItemById(2129)
			if item then
				item:remove()
			end
		end
	end
	return true
end

SiegeGeneratorDeath:register()


local warSiegeParticipation = CreatureEvent("WarGeneratorParticipation")

function warSiegeParticipation.onHealthChange(creature, attacker, primaryDamage, primaryType, secondaryDamage, secondaryType, origin)
	if not creature or not attacker then
		return primaryDamage, primaryType, secondaryDamage, secondaryType
	end

	-- Only process damage from players with guilds
	local attackerPlayer = attacker:getPlayer()
	if not attackerPlayer then
		return primaryDamage, primaryType, secondaryDamage, secondaryType
	end

	local attackerGuild = attackerPlayer:getGuild()
	if not attackerGuild then
		return primaryDamage, primaryType, secondaryDamage, secondaryType
	end

	local monster = creature:getMonster()
	local pointsEarnedMultiplier = 0
	if monster and monster:getName() == "War Generator" then
		pointsEarnedMultiplier = 1
	elseif monster and monster:getName() == "Siege Generator" then
		pointsEarnedMultiplier = 5
	end

	local earnedPoints = math.abs(math.ceil((primaryDamage + secondaryDamage) / 100)) * pointsEarnedMultiplier

	local attackerGuildId = attackerGuild:getId()
	if not Castle.guildsPoints[attackerGuildId] then
		Castle.guildsPoints[attackerGuildId] = 0
	end
	Castle.guildsPoints[attackerGuildId] = Castle.guildsPoints[attackerGuildId] + earnedPoints
	return primaryDamage, primaryType, secondaryDamage, secondaryType
end

warSiegeParticipation:register()
