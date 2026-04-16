local sparkOfDestructionPositions = {
	Position(966, 919, 15),
	Position(971, 919, 15),
	Position(966, 923, 15),
	Position(971, 923, 15),
}

local monsterTable = {
	[80] = { fromStage = 0, toStage = 1 },
	[60] = { fromStage = 1, toStage = 2 },
	[40] = { fromStage = 2, toStage = 3 },
	[20] = { fromStage = 3, toStage = 4 },
	[10] = { fromStage = 4, toStage = 5 },
}

local aftershockTransform = CreatureEvent("AftershockTransform")

function aftershockTransform.onThink(creature)
	if not creature or not creature:isMonster() then
		return true
	end

	local hpPercent = (creature:getHealth() / creature:getMaxHealth()) * 100
	Game.setStorageValue(GlobalStorage.HeartOfDestruction.AftershockHealth, creature:getHealth())
	local aftershockStage = Game.getStorageValue(GlobalStorage.HeartOfDestruction.AftershockStage) > 0 and Game.getStorageValue(GlobalStorage.HeartOfDestruction.AftershockStage) or 0

	for index, value in pairs(monsterTable) do
		if hpPercent <= index and aftershockStage == value.fromStage then
			local monster = Game.createMonster("Foreshock", Position(969, 921, 15), false, true)
			if monster then
				creature:remove()
				for i = 1, #sparkOfDestructionPositions do
					Game.createMonster("Spark of Destruction", sparkOfDestructionPositions[i], false, true)
				end
				local foreshockHealth = Game.getStorageValue(GlobalStorage.HeartOfDestruction.ForeshockHealth) > 0 and Game.getStorageValue(GlobalStorage.HeartOfDestruction.ForeshockHealth) or 0
				monster:addHealth(-monster:getHealth() + foreshockHealth, COMBAT_PHYSICALDAMAGE)
				Game.setStorageValue(GlobalStorage.HeartOfDestruction.AftershockStage, value.toStage)
				return true
			end
		end
	end
	return true
end

aftershockTransform:register()
