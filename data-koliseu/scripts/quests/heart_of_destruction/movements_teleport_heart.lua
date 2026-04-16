local vortex = {
	[14324] = Position(832, 1417, 7), -- Anomaly Exit
	[14343] = Position(832, 1413, 7), -- Rupture Exit
	[14345] = Position(840, 1413, 7), -- Realityquake Exit
	[14348] = Position(840, 1417, 7), -- Eradicator Exit (Main Room)
	[14350] = Position(834, 1413, 7), -- Outburst Exit (Main Room)
	[14352] = Position(838, 1413, 7), -- World Devourer Exit (Main Room)
	[14354] = Position(891, 969, 15), -- World Devourer (Reward Room)
}

local accessVortex = {
	-- Anomaly enter
	[14323] = {
		position = Position(1004, 922, 15),
		boss = "Anomaly",
	},
	-- Rupture enter
	[14342] = {
		position = Position(995, 992, 15),
		boss = "Rupture",
	},
	-- Realityquake enter
	[14344] = {
		position = Position(939, 913, 15),
		boss = "Realityquake",
	},
	-- Eradicator enter
	[14346] = {
		position = Position(1030, 960, 15),
		boss = "Eradicator",
	},
	-- Outburst enter
	[14349] = {
		position = Position(928, 958, 15),
		boss = "Outburst",
	},
}

local teleportHeart = MoveEvent()

function teleportHeart.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	local normalVortex = vortex[item.actionid]
	local bossVortex = accessVortex[item.actionid]
	if normalVortex then
		player:teleportTo(normalVortex)
	elseif bossVortex then
		if player:canFightBoss(bossVortex.boss) then
			player:teleportTo(bossVortex.position)
		else
			player:teleportTo(fromPosition)
			player:sendTextMessage(19, "It's too early for you to endure this challenge again.")
		end
	elseif item.actionid == 14351 then
		if player:getStorageValue(14330) >= 1 and player:getStorageValue(14332) >= 1 and player:getStorageValue(14326) >= 1 and player:getStorageValue(14327) >= 1 and player:getStorageValue(14328) >= 1 then
			if player:canFightBoss("World Devourer") then
				player:teleportTo(Position(907, 1006, 15))
			else
				player:teleportTo(fromPosition)
				player:sendTextMessage(19, "It's too early for you to endure this challenge again.")
			end
		else
			player:teleportTo(fromPosition)
			player:sendTextMessage(19, "You don't have access to this portal.")
		end
	end
	return true
end

teleportHeart:type("stepin")

teleportHeart:aid(14351, 14324, 14343, 14345, 14348, 14350, 14352, 14354, 14323, 14342, 14344, 14346, 14349)

teleportHeart:register()
