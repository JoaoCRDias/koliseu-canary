RelicBonus = {}

-- Condition subId for relic bonuses (separate from GemBag subId 98)
local RELIC_CONDITION_SUBID = RelicSystem.CONDITION_SUBID -- 53010

-- Skill-type condition params: value * 100 (e.g., 3% = 300)
local SKILL_BONUS_MAP = {
	crit_chance = CONDITION_PARAM_SKILL_CRITICAL_HIT_CHANCE,
	crit_damage = CONDITION_PARAM_SKILL_CRITICAL_HIT_DAMAGE,
}

-- Bonuses that use storage values (read in C++)
local STORAGE_BONUS_IDS = {
	-- Attack spell bonuses (read in game.cpp)
	"executioners_throw_dmg", "fierce_berserk_dmg", "annihilation_dmg",
	"divine_grenade_dmg", "divine_caldera_dmg", "strong_ethereal_spear_dmg",
	"great_death_beam_dmg", "rage_of_the_skies_dmg", "hells_core_dmg",
	"terra_burst_dmg", "ice_burst_dmg", "eternal_winter_dmg", "wrath_of_nature_dmg",
	-- Onslaught (read in combat.cpp)
	"onslaught_buff",
	-- Support spell bonuses (read in game.cpp + Lua spell scripts)
	"fair_wound_cleansing_heal", "salvation_heal", "ultimate_healing_heal",
	"divine_empowerment_buff",
	"avatar_steel_buff", "avatar_storm_buff", "avatar_nature_buff",
	"avatar_light_buff",
	-- New spell bonuses (read in Lua spell scripts + C++)
	"expose_weakness_buff", "sap_strength_buff", "blood_rage_buff",
	"protector_buff", "avatar_damage_buff", "divine_empowerment_dmg_buff",
	-- Potion heal bonus (read in potions.lua)
	"potion_heal_buff",
	-- Element resist bonuses (read in player.cpp + protocolgame.cpp)
	"fire_resist", "ice_resist", "earth_resist", "energy_resist",
	"holy_resist", "death_resist", "physical_resist",
}

-- Build quick lookup set for storage-based bonuses
local STORAGE_BONUS_SET = {}
for _, id in ipairs(STORAGE_BONUS_IDS) do
	STORAGE_BONUS_SET[id] = true
end

-- Schedule bonus recalculation via addEvent (deferred to avoid mid-move issues)
local function scheduleRecalculate(player)
	if not player then
		return
	end
	local playerId = player:getId()
	if not playerId then
		return
	end
	addEvent(function(targetId)
		local target = Player(targetId)
		if not target then
			return
		end
		RelicBonus.recalculateBonuses(target)
	end, 0, playerId)
end

-- Remove all relic bonuses from a player
function RelicBonus.removeAllBonuses(player)
	if not player then
		return
	end

	-- Remove condition
	if player:getCondition(CONDITION_ATTRIBUTES, CONDITIONID_COMBAT, RELIC_CONDITION_SUBID) then
		player:removeCondition(CONDITION_ATTRIBUTES, CONDITIONID_COMBAT, RELIC_CONDITION_SUBID)
	end

	-- Reset all storage values
	for _, storageId in ipairs(RelicSystem.ALL_STORAGE_IDS) do
		player:setStorageValue(storageId, -1)
	end
end

-- Recalculate and apply all relic bonuses from equipped reliquary
function RelicBonus.recalculateBonuses(player)
	if not player then
		return
	end

	-- Remove existing bonuses first
	RelicBonus.removeAllBonuses(player)

	-- Get equipped reliquary
	local reliquary = RelicSystem.getEquippedReliquary(player)
	if not reliquary then
		player:sendStats()
		player:forceSkillsSend()
		return
	end

	-- Get relics inside reliquary
	local relics = RelicSystem.getRelicsInReliquary(reliquary)
	if #relics == 0 then
		player:sendStats()
		player:forceSkillsSend()
		return
	end

	-- Accumulate bonuses: storageId -> total value (×100)
	local storageBonuses = {}
	-- Accumulate condition bonuses: bonusId -> total percentage value
	local conditionBonuses = {}
	-- Special condition bonuses
	local maxHpPercent = 0
	local maxManaPercent = 0
	local magicShieldPercent = 0

	for _, relic in ipairs(relics) do
		local data = RelicSystem.getRelicData(relic)
		if data then
			local bonus = RelicSystem.getBonusDefinition(data.bonusId)
			if bonus then
				local value = RelicSystem.getBonusValue(data.rarity, data.tier)

				if STORAGE_BONUS_SET[data.bonusId] then
					-- Storage-based bonus (spell dmg, resist, onslaught, etc)
					local storageValue = value * 100
					storageBonuses[bonus.storageId] = (storageBonuses[bonus.storageId] or 0) + storageValue
				elseif SKILL_BONUS_MAP[data.bonusId] then
					-- Condition-based skill bonus (crit, leech)
					conditionBonuses[data.bonusId] = (conditionBonuses[data.bonusId] or 0) + value
				elseif data.bonusId == "max_hp" then
					maxHpPercent = maxHpPercent + value
				elseif data.bonusId == "max_mana" then
					maxManaPercent = maxManaPercent + value
				elseif data.bonusId == "magic_shield" then
					magicShieldPercent = magicShieldPercent + value
				end
			end
		end
	end

	-- Apply storage-based bonuses
	for storageId, totalValue in pairs(storageBonuses) do
		player:setStorageValue(storageId, totalValue)
	end

	-- Apply condition-based bonuses
	local hasAnyCondition = false
	local relicCondition = Condition(CONDITION_ATTRIBUTES)
	relicCondition:setParameter(CONDITION_PARAM_TICKS, -1)
	relicCondition:setParameter(CONDITION_PARAM_SUBID, RELIC_CONDITION_SUBID)

	-- Skill bonuses (crit, leech) - value * 100
	for bonusId, totalValue in pairs(conditionBonuses) do
		if SKILL_BONUS_MAP[bonusId] and totalValue > 0 then
			relicCondition:setParameter(SKILL_BONUS_MAP[bonusId], totalValue * 100)
			hasAnyCondition = true
		end
	end

	-- Max HP percent bonus
	if maxHpPercent > 0 then
		local baseHealth = player:getMaxHealth()
		local hpBonus = math.floor(baseHealth * (maxHpPercent / 100))
		if hpBonus > 0 then
			relicCondition:setParameter(CONDITION_PARAM_STAT_MAXHITPOINTS, hpBonus)
			hasAnyCondition = true
		end
	end

	-- Max Mana percent bonus
	if maxManaPercent > 0 then
		local baseMana = player:getMaxMana()
		local manaBonus = math.floor(baseMana * (maxManaPercent / 100))
		if manaBonus > 0 then
			relicCondition:setParameter(CONDITION_PARAM_STAT_MAXMANAPOINTS, manaBonus)
			hasAnyCondition = true
		end
	end

	if hasAnyCondition then
		player:addCondition(relicCondition)
	end

	-- Magic shield capacity stored via storage for C++ to read
	if magicShieldPercent > 0 then
		player:setStorageValue(920034, magicShieldPercent * 100)
	end

	player:sendStats()
	player:forceSkillsSend()
end

-- Called from Player:onItemMoved - detects relic/reliquary movement
function RelicBonus.onItemMoved(player, item, fromPosition, toPosition)
	if not player or not item then
		return
	end

	-- Case 1: Reliquary equipped or deequipped from ammo slot
	if RelicSystem.isReliquary(item) then
		local isFromAmmo = fromPosition.x == CONTAINER_POSITION and fromPosition.y == CONST_SLOT_AMMO
		local isToAmmo = toPosition.x == CONTAINER_POSITION and toPosition.y == CONST_SLOT_AMMO
		if isFromAmmo or isToAmmo then
			scheduleRecalculate(player)
		end
		return
	end

	-- Case 2: Relic moved - always recalculate if player has equipped reliquary
	-- (cheap operation: reads a few items from a small container)
	local isRelic = RelicSystem.isRelic(item)
	local hasReliquary = RelicSystem.getEquippedReliquary(player) ~= nil
	if isRelic and hasReliquary then
		scheduleRecalculate(player)
	end
end

-- Called on player login to reapply relic bonuses
function RelicBonus.onLogin(player)
	if not player then
		return
	end
	RelicBonus.recalculateBonuses(player)
end

return RelicBonus
