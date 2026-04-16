-- God commands for testing Cosmic Rift bestiary requirements
-- Usage:
--   /cosmicunlock Judith,prereqs     - Unlocks Soul War + Gnomprona + Rotten bestiaries
--   /cosmicunlock Judith,rift1       - Unlocks Rift I bestiaries
--   /cosmicunlock Judith,rift2       - Unlocks Rift II bestiaries
--   /cosmicunlock Judith,rift3       - Unlocks Rift III bestiaries
--   /cosmicunlock Judith,rift4       - Unlocks Rift IV bestiaries
--   /cosmicunlock Judith,all         - Unlocks everything (prereqs + all 4 rifts)
--   /cosmicreset Judith              - Resets cosmic rift reward storage

local KILL_AMOUNT = 5000 -- enough to complete any bestiary

local SOULWAR_MONSTERS = {
	"Bony Sea Devil", "Many Faces", "Cloak of Terror", "Vibrant Phantom",
	"Brachiodemon", "Branchy Crawler", "Capricious Phantom", "Infernal Phantom",
	"Infernal Demon", "Rotten Golem", "Turbulent Elemental", "Courage Leech",
	"Mould Phantom", "Distorted Phantom",
}

local GNOMPRONA_MONSTERS = {
	"Sulphider", "Sulphur Spouter", "Gore Horn", "Sabretooth",
	"Emerald Tortoise", "Undertaker", "Nighthunter", "Hulking Prehemoth",
	"Stalking Stalk", "Mantosaurus", "Headpecker", "Noxious Ripptor",
	"Gorerilla", "Shrieking Cry-Stal", "Mercurial Menace",
}

local ROTTEN_MONSTERS = {
	"Mycobiontic Beetle", "Meandering Mushroom", "Oozing Carcass", "Darklight Construct",
	"Converter", "Darklight Matter", "Oozing Corpus", "Darklight Emitter",
	"Bloated Man-Maggot", "Rotten Man-Maggot", "Walking Pillar", "Wandering Pillar",
	"Sopping Carcass", "Sopping Corpus", "Darklight Source", "Darklight Striker",
}

local RIFT_MONSTERS = {
	[1] = { "Rift Stalker", "Void Crawler", "Astral Leech" },
	[2] = { "Nebula Weaver", "Dimensional Shade", "Starfall Sentinel" },
	[3] = { "Entropy Devourer", "Cosmic Warden", "Singularity Spawn" },
	[4] = { "Event Horizon", "Reality Fracture", "Oblivion Herald" },
}

local function unlockMonsters(target, monsterList)
	local count = 0
	for _, name in ipairs(monsterList) do
		target:addBestiaryKill(name, KILL_AMOUNT)
		count = count + 1
	end
	return count
end

-- /cosmicunlock
local cosmicUnlock = TalkAction("/cosmicunlock")

function cosmicUnlock.onSay(player, words, param)
	local usage = "/cosmicunlock PLAYER,prereqs|rift1|rift2|rift3|rift4|all"
	if param == "" then
		player:sendCancelMessage("Usage: " .. usage)
		return true
	end

	local split = param:split(",")
	if not split[2] then
		player:sendCancelMessage("Usage: " .. usage)
		return true
	end

	local target = Player(split[1])
	if not target then
		player:sendCancelMessage("Player '" .. split[1] .. "' is not online.")
		return true
	end

	local option = split[2]:trimSpace():lower()
	local total = 0

	if option == "prereqs" or option == "all" then
		total = total + unlockMonsters(target, SOULWAR_MONSTERS)
		total = total + unlockMonsters(target, GNOMPRONA_MONSTERS)
		total = total + unlockMonsters(target, ROTTEN_MONSTERS)
	end

	if option == "all" then
		for i = 1, 4 do
			total = total + unlockMonsters(target, RIFT_MONSTERS[i])
		end
	elseif option == "rift1" then
		total = total + unlockMonsters(target, RIFT_MONSTERS[1])
	elseif option == "rift2" then
		total = total + unlockMonsters(target, RIFT_MONSTERS[2])
	elseif option == "rift3" then
		total = total + unlockMonsters(target, RIFT_MONSTERS[3])
	elseif option == "rift4" then
		total = total + unlockMonsters(target, RIFT_MONSTERS[4])
	elseif option ~= "prereqs" then
		player:sendCancelMessage("Invalid option '" .. option .. "'. Use: prereqs, rift1, rift2, rift3, rift4, all")
		return true
	end

	player:sendCancelMessage("Unlocked " .. total .. " bestiaries for '" .. target:getName() .. "' (option: " .. option .. ").")
	target:sendCancelMessage("Your bestiaries have been updated! (" .. total .. " monsters)")
	target:getPosition():sendMagicEffect(CONST_ME_HOLYAREA)
	return true
end

cosmicUnlock:separator(" ")
cosmicUnlock:groupType("god")
cosmicUnlock:register()

-- /cosmicreset
local cosmicReset = TalkAction("/cosmicreset")

function cosmicReset.onSay(player, words, param)
	if param == "" then
		player:sendCancelMessage("Usage: /cosmicreset PLAYER")
		return true
	end

	local target = Player(param)
	if not target then
		player:sendCancelMessage("Player '" .. param .. "' is not online.")
		return true
	end

	target:setStorageValue(920100, -1)
	player:sendCancelMessage("Reset cosmic rift reward for '" .. target:getName() .. "'.")
	target:sendCancelMessage("Your Cosmic Rift reward has been reset.")
	target:getPosition():sendMagicEffect(CONST_ME_HOLYAREA)
	return true
end

cosmicReset:separator(" ")
cosmicReset:groupType("god")
cosmicReset:register()
