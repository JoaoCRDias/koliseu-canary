local login = CreatureEvent("SoulWarLogin")

function login.onLogin(player)
	player:resetTaints()
	return true
end

login:register()

-- Goshnar's Malice reflection (100%) of physical and death damage
local goshnarsMaliceReflection = CreatureEvent("Goshnar's-Malice")

function goshnarsMaliceReflection.onHealthChange(creature, attacker, primaryDamage, primaryType, secondaryDamage, secondaryType, origin)
	if not attacker then
		return primaryDamage, primaryType, secondaryDamage, secondaryType
	end

	local player = attacker:getPlayer()
	if player then
		if primaryDamage > 0 and (primaryType == COMBAT_PHYSICALDAMAGE or primaryType == COMBAT_DEATHDAMAGE) then
			player:addHealth(-primaryDamage)
		end
		if secondaryDamage > 0 and (secondaryType == COMBAT_PHYSICALDAMAGE or secondaryType == COMBAT_DEATHDAMAGE) then
			player:addHealth(-secondaryDamage)
		end
	end

	return primaryDamage, primaryType, secondaryDamage, secondaryType
end

goshnarsMaliceReflection:register()

local cloakOfTerrorHealthLoss = CreatureEvent("CloakOfTerrorHealthLoss")

function cloakOfTerrorHealthLoss.onHealthChange(creature, attacker, primaryDamage, primaryType, secondaryDamage, secondaryType, origin)
	if not creature or not attacker then
		return primaryDamage, primaryType, secondaryDamage, secondaryType
	end

	if attacker:getPlayer() and primaryDamage > 0 or secondaryDamage > 0 then
		local position = creature:getPosition()
		local tile = Tile(position)
		if tile then
			if not tile:getItemById(SoulWarQuest.theBloodOfCloakTerrorIds[1]) then
				Game.createItem(SoulWarQuest.theBloodOfCloakTerrorIds[1], 1, position)
			end
		end
	end

	return primaryDamage, primaryType, secondaryDamage, secondaryType
end

cloakOfTerrorHealthLoss:register()

local fourthTaintBossesDeath = CreatureEvent("FourthTaintBossesPrepareDeath")

function fourthTaintBossesDeath.onPrepareDeath(creature, killer, realDamage)
	if not creature or not killer or not killer:getPlayer() then
		return true
	end

	if creature:getHealth() - realDamage < 1 then
		if killer:getTaintNameByNumber(4) then
			local isInZone = killer:getSoulWarZoneMonster()
			if isInZone ~= nil then
				-- 10% of chance to heal
				if math.random(1, 10) == 1 then
					creature:say("Health restored by the mystic powers of Zarganash!")
					creature:addHealth(creature:getMaxHealth())
				end
			end
		end
	end
	return true
end

fourthTaintBossesDeath:register()

local bossesDeath = CreatureEvent("SoulWarBossesDeath")

function bossesDeath.onDeath(creature, corpse, killer, mostDamageKiller, lastHitUnjustified, mostDamageUnjustified)
	local bossName = creature:getName()
	if SoulWarQuest.miniBosses[bossName] then
		local killers = creature:getKillers(true)
		for i, killerPlayer in ipairs(killers) do
			logger.debug("Player {} killed the boss.", killerPlayer:getName())
			local soulWarQuest = killerPlayer:soulWarQuestKV()
			-- Checks if the boss has already been defeated
			if not soulWarQuest:get(bossName) then
				local firstTaintTime = soulWarQuest:get("firstTaintTime")
				if not firstTaintTime then
					local currentTime = os.time()
					soulWarQuest:set("firstTaintTime", currentTime)
				end

				soulWarQuest:set(bossName, true) -- Mark the boss as defeated
				-- Adds the next taint in the sequence that the player does not already have
				killerPlayer:addNextTaint()
			end
		end
	end
end

bossesDeath:register()

fourthTaintBossesDeath:register()

local checkTaint = TalkAction("!checktaint")

function checkTaint.onSay(player, words, param)
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Taint Mechanics currently disabled.")
	return true
	-- local taintLevel = player:getTaintLevel()
	-- local taintName = player:getTaintNameByNumber(taintLevel)
	-- if taintLevel ~= nil and taintName ~= nil then
	-- 	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Your current taint level is: " .. taintLevel .. " name: " .. taintName)
	-- else
	-- 	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You currently have no taint.")
	-- end

	-- return true
end

checkTaint:groupType("normal")
checkTaint:register()

local setTaint = TalkAction("/settaint")

function setTaint.onSay(player, words, param)
	local split = param:split(",")
	local target = Player(split[1])
	if not target then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Player is offline")
		return false
	end

	local taintLevel = split[2]:trim():lower()
	local taintName = player:getTaintNameByNumber(tonumber(taintLevel), true)
	if taintName ~= nil then
		target:resetTaints(true)
		target:soulWarQuestKV():set(taintName, true)
		target:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You new taint level is: " .. taintLevel .. ", name: " .. taintName)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Added taint level: " .. taintLevel .. ", name: " .. taintName .. " to player: " .. target:getName())
		target:setTaintIcon()
	end
end

setTaint:separator(" ")
setTaint:groupType("god")
setTaint:register()

local setTaint = TalkAction("/removetaint")

function setTaint.onSay(player, words, param)
	local split = param:split(",")
	local target = Player(split[1])
	if not target then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Player is offline")
		return false
	end

	local taintLevel = split[2]:trim():lower()
	local taintName = player:getTaintNameByNumber(tonumber(taintLevel))
	if taintName ~= nil then
		target:soulWarQuestKV():remove(taintName)
		target:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You lose taint level: " .. taintLevel .. ", name: " .. taintName)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Removed taint level: " .. taintLevel .. ", name: " .. taintName .. " from player: " .. target:getName())
	end
end

setTaint:separator(" ")
setTaint:groupType("god")
setTaint:register()

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
