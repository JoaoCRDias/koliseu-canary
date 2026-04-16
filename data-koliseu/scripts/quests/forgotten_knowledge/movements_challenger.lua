local destination = {
	[1067] = {
		newPos = Position(1262, 1067, 15),
		backPos = Position(832, 1428, 7),
		boss = "Lady Tenebris",
	},
	[1068] = {
		newPos = Position(1428, 1079, 15),
		backPos = Position(840, 1428, 7),
		boss = "The Enraged Thorn Knight",
	},
	[1069] = {
		newPos = Position(1222, 1067, 15),
		backPos = Position(840, 1432, 7),
		boss = "Soul of Dragonking Zyrtarch",
	},
	[1070] = {
		newPos = Position(1334, 1069, 15),
		backPos = Position(832, 1432, 7),
		boss = "Melting Frozen Horror",
	},
	[1071] = {
		newPos = Position(1299, 1065, 15),
		backPos = Position(840, 1432, 7),
		boss = "The Time Guardian",
	},
	[1072] = {
		newPos = Position(1472, 1075, 15),
		backPos = Position(836, 1432, 7),
		boss = "The Last Lore Keeper",
		requiredKills = {
			"Lady Tenebris",
			"The Enraged Thorn Knight",
			"Soul of Dragonking Zyrtarch",
			"Melting Frozen Horror",
			"The Time Guardian",
			"Lloyd"
		}
	},
	[1073] = {
		newPos = Position(1376, 1070, 15),
		backPos = Position(832, 1432, 7),
		boss = "Lloyd",
	},
}

local challenger = MoveEvent()

function challenger.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	local teleport = destination[item.uid]
	if not teleport then
		return true
	end

	-- Se for o Last Lore Keeper, verificar se todos os bosses anteriores foram derrotados
	if teleport.boss == "The Last Lore Keeper" and teleport.requiredKills then
		for _, bossName in ipairs(teleport.requiredKills) do
			if not player:kv():get(bossName:lower()) then
				player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You must defeat all other bosses before facing The Last Lore Keeper.")
				player:teleportTo(teleport.backPos)
				player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
				return true
			end
		end
	end

	-- if player:canFightBoss(teleport.boss) then
	position:sendMagicEffect(CONST_ME_TELEPORT)
	player:teleportTo(teleport.newPos)
	player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	-- else
	-- 	player:teleportTo(teleport.backPos)
	-- 	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have to wait to challenge this enemy again!")
	-- 	player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	-- end

	return true
end

challenger:type("stepin")

for uid in pairs(destination) do
	challenger:uid(uid)
end

challenger:register()
