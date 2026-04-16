local function createSparksOfDestruction()
	Game.createMonster("Spark Of Destruction", Position(966, 919, 15), false, true)
	Game.createMonster("Spark Of Destruction", Position(971, 919, 15), false, true)
	Game.createMonster("Spark Of Destruction", Position(966, 924, 15), false, true)
	Game.createMonster("Spark Of Destruction", Position(971, 924, 15), false, true)
end

local shocksDeath = CreatureEvent("ShocksDeath")

function shocksDeath.onDeath(creature)
	if not creature or not creature:isMonster() then
		return true
	end

	local creatureName = creature:getName():lower()
	if creatureName == "foreshock" then
		local monster = Game.createMonster("Aftershock", Position(969, 922, 15), false, true)
		if monster then
			local aftershockHealth = Game.getStorageValue(GlobalStorage.HeartOfDestruction.AftershockHealth) > 0 and Game.getStorageValue(GlobalStorage.HeartOfDestruction.AftershockHealth) or 0
			monster:addHealth(-monster:getHealth() + aftershockHealth, COMBAT_PHYSICALDAMAGE)
			createSparksOfDestruction()
		end
	elseif creatureName == "aftershock" then
		local monster = Game.createMonster("Realityquake", creature:getPosition(), false, true)
		if monster then
			createSparksOfDestruction()
		end
	end
	return true
end

shocksDeath:register()
