local callback = EventCallback("MonsterOnDropLootBountyTalisman")

function callback.monsterOnDropLoot(monster, corpse)
	local player = Player(corpse:getCorpseOwner())
	if not player or not player:canReceiveLoot() then
		return
	end
	local mType = monster:getType()
	if not mType then
		return
	end

	-- bountyLootBonus is in hundredths of percent (e.g. 50 = 0.50%, 1025 = 10.25%)
	local bountyLootBonus = player:getBountyTalismanLootBonus(mType:raceId())
	if bountyLootBonus <= 0 then
		return
	end

	if math.random(1, 10000) > bountyLootBonus then
		return
	end

	local existingSuffix = corpse:getAttribute(ITEM_ATTRIBUTE_LOOTMESSAGE_SUFFIX) or ""
	local msgSuffix = string.len(existingSuffix) > 0 and ", bounty talisman bonus" or "bounty talisman bonus"

	corpse:addLoot(mType:generateLootRoll({ factor = 1.0, gut = false }, {}, player))
	corpse:setAttribute(ITEM_ATTRIBUTE_LOOTMESSAGE_SUFFIX, existingSuffix .. msgSuffix)
end

callback:register()
