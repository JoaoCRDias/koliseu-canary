local internalNpcName = "Thorgar Rider"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 3053,
	lookHead = 168,
	lookBody = 89,
	lookLegs = 99,
	lookFeet = 230,
	lookAddons = 3,
}

npcConfig.flags = {
	floorchange = false
}

npcConfig.voices = {
	interval = 15000,
	chance = 50,
	{
		text = 'Come see my Mounts Sir!'
	}
}

local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)

npcType.onThink = function(npc, interval)
	npcHandler:onThink(npc, interval)
end

npcType.onAppear = function(npc, creature)
	npcHandler:onAppear(npc, creature)
end

npcType.onDisappear = function(npc, creature)
	npcHandler:onDisappear(npc, creature)
end

npcType.onMove = function(npc, creature, fromPosition, toPosition)
	npcHandler:onMove(npc, creature, fromPosition, toPosition)
end

npcType.onSay = function(npc, creature, type, message)
	npcHandler:onSay(npc, creature, type, message)
end

npcType.onCloseChannel = function(npc, creature)
	npcHandler:onCloseChannel(npc, creature)
end

local addoninfo = {
	["antelope"] = { cost = 0, items = { { 21948, 50 } }, mount = 163 },
	["arctic unicorn"] = { cost = 0, items = { { 21948, 50 } }, mount = 114 },
	["armoured war horse"] = { cost = 0, items = { { 21948, 50 } }, mount = 23 },
	["azudocus"] = { cost = 0, items = { { 21948, 50 } }, mount = 44 },
	["batcat"] = { cost = 0, items = { { 21948, 50 } }, mount = 77 },
	["battle badger"] = { cost = 0, items = { { 21948, 50 } }, mount = 153 },
	["black sheep"] = { cost = 0, items = { { 21948, 50 } }, mount = 4 },
	["black stag"] = { cost = 0, items = { { 21948, 50 } }, mount = 73 },
	["blackpelt"] = { cost = 0, items = { { 21948, 50 } }, mount = 58 },
	["blazebringer"] = { cost = 0, items = { { 21948, 50 } }, mount = 9 },
	["blazing unicorn"] = { cost = 0, items = { { 21948, 50 } }, mount = 113 },
	["bloodcurl"] = { cost = 0, items = { { 21948, 50 } }, mount = 92 },
	["blue rolling barrel"] = { cost = 0, items = { { 21948, 50 } }, mount = 156 },
	["bog tyrant"] = { cost = 0, items = { { 21948, 50 } }, mount = 229 },
	["bogwurm"] = { cost = 0, items = { { 21948, 50 } }, mount = 189 },
	["boisterous bull"] = { cost = 0, items = { { 21948, 50 } }, mount = 213 },
	["boreal owl"] = { cost = 0, items = { { 21948, 50 } }, mount = 129 },
	["brass speckled koi"] = { cost = 0, items = { { 21948, 50 } }, mount = 208 },
	["bright percht sleigh"] = { cost = 0, items = { { 21948, 50 } }, mount = 133 },
	["bright percht sleigh final"] = { cost = 0, items = { { 21948, 50 } }, mount = 151 },
	["bright percht sleigh variant"] = { cost = 0, items = { { 21948, 50 } }, mount = 148 },
	["bumblebee"] = { cost = 0, items = { { 21948, 50 } }, mount = 231 },
	["bunny dray"] = { cost = 0, items = { { 21948, 50 } }, mount = 139 },
	["caped snowman"] = { cost = 0, items = { { 21948, 50 } }, mount = 137 },
	["carpacosaurus"] = { cost = 0, items = { { 21948, 50 } }, mount = 45 },
	["cave tarantula"] = { cost = 0, items = { { 21948, 50 } }, mount = 117 },
	["cerberus champion"] = { cost = 0, items = { { 21948, 50 } }, mount = 146 },
	["cinderhoof"] = { cost = 0, items = { { 21948, 50 } }, mount = 90 },
	["cinnamon ibex"] = { cost = 0, items = { { 21948, 50 } }, mount = 200 },
	["cold percht sleigh"] = { cost = 0, items = { { 21948, 50 } }, mount = 132 },
	["cold percht sleigh final"] = { cost = 0, items = { { 21948, 50 } }, mount = 150 },
	["cold percht sleigh variant"] = { cost = 0, items = { { 21948, 50 } }, mount = 147 },
	["cony cart"] = { cost = 0, items = { { 21948, 50 } }, mount = 140 },
	["copper fly"] = { cost = 0, items = { { 21948, 50 } }, mount = 61 },
	["coral rhea"] = { cost = 0, items = { { 21948, 50 } }, mount = 169 },
	["coralripper"] = { cost = 0, items = { { 21948, 50 } }, mount = 79 },
	["corpsefire skull"] = { cost = 0, items = { { 21948, 50 } }, mount = 221 },
	["cranium spider"] = { cost = 0, items = { { 21948, 50 } }, mount = 116 },
	["crimson fang"] = { cost = 0, items = { { 21948, 50 } }, mount = 230 },
	["crimson ray"] = { cost = 0, items = { { 21948, 50 } }, mount = 33 },
	["crystal wolf"] = { cost = 0, items = { { 21948, 50 } }, mount = 16 },
	["cunning hyaena"] = { cost = 0, items = { { 21948, 50 } }, mount = 172 },
	["dandelion"] = { cost = 0, items = { { 21948, 50 } }, mount = 187 },
	["dark percht sleigh"] = { cost = 0, items = { { 21948, 50 } }, mount = 134 },
	["dark percht sleigh final"] = { cost = 0, items = { { 21948, 50 } }, mount = 152 },
	["dark percht sleigh variant"] = { cost = 0, items = { { 21948, 50 } }, mount = 149 },
	["darkfire devourer"] = { cost = 0, items = { { 21948, 50 } }, mount = 216 },
	["dawn strayer"] = { cost = 0, items = { { 21948, 50 } }, mount = 166 },
	["dawnbringer pegasus"] = { cost = 0, items = { { 21948, 50 } }, mount = 224 },
	["death crawler"] = { cost = 0, items = { { 21948, 50 } }, mount = 46 },
	["desert king"] = { cost = 0, items = { { 21948, 50 } }, mount = 41 },
	["donkey"] = { cost = 0, items = { { 21948, 50 } }, mount = 13 },
	["doom skull"] = { cost = 0, items = { { 21948, 50 } }, mount = 219 },
	["doombringer"] = { cost = 0, items = { { 21948, 50 } }, mount = 53 },
	["dragonling"] = { cost = 0, items = { { 21948, 50 } }, mount = 31 },
	["draptor"] = { cost = 0, items = { { 21948, 50 } }, mount = 6 },
	["dreadhare"] = { cost = 0, items = { { 21948, 50 } }, mount = 104 },
	["dromedary"] = { cost = 0, items = { { 21948, 50 } }, mount = 20 },
	["dusk pryer"] = { cost = 0, items = { { 21948, 50 } }, mount = 165 },
	["ebony tiger"] = { cost = 0, items = { { 21948, 50 } }, mount = 123 },
	["ember saurian"] = { cost = 0, items = { { 21948, 50 } }, mount = 111 },
	["emerald raven"] = { cost = 0, items = { { 21948, 50 } }, mount = 191 },
	["emerald sphinx"] = { cost = 0, items = { { 21948, 50 } }, mount = 108 },
	["emerald waccoon"] = { cost = 0, items = { { 21948, 50 } }, mount = 70 },
	["emperor deer"] = { cost = 0, items = { { 21948, 50 } }, mount = 74 },
	["ether badger"] = { cost = 0, items = { { 21948, 50 } }, mount = 154 },
	["eventide nandu"] = { cost = 0, items = { { 21948, 50 } }, mount = 170 },
	["feral tiger"] = { cost = 0, items = { { 21948, 50 } }, mount = 124 },
	["festive mammoth"] = { cost = 0, items = { { 21948, 50 } }, mount = 178 },
	["festive snowman"] = { cost = 0, items = { { 21948, 50 } }, mount = 135 },
	["flamesteed"] = { cost = 0, items = { { 21948, 50 } }, mount = 47 },
	["fleeting knowledge"] = { cost = 0, items = { { 21948, 50 } }, mount = 126 },
	["flitterkatzen"] = { cost = 0, items = { { 21948, 50 } }, mount = 75 },
	["floating augur"] = { cost = 0, items = { { 21948, 50 } }, mount = 161 },
	["floating kashmir"] = { cost = 0, items = { { 21948, 50 } }, mount = 67 },
	["floating sage"] = { cost = 0, items = { { 21948, 50 } }, mount = 159 },
	["floating scholar"] = { cost = 0, items = { { 21948, 50 } }, mount = 160 },
	["flying divan"] = { cost = 0, items = { { 21948, 50 } }, mount = 65 },
	["foxmouse"] = { cost = 0, items = { { 21948, 50 } }, mount = 218 },
	["frostbringer"] = { cost = 0, items = { { 21948, 50 } }, mount = 210 },
	["frostflare"] = { cost = 0, items = { { 21948, 50 } }, mount = 89 },
	["giant beaver"] = { cost = 0, items = { { 21948, 50 } }, mount = 201 },
	["glacier vagabond"] = { cost = 0, items = { { 21948, 50 } }, mount = 64 },
	["glacier wyrm"] = { cost = 0, items = { { 21948, 50 } }, mount = 228 },
	["gloom widow"] = { cost = 0, items = { { 21948, 50 } }, mount = 118 },
	["gloomwurm"] = { cost = 0, items = { { 21948, 50 } }, mount = 190 },
	["glooth glider"] = { cost = 0, items = { { 21948, 50 } }, mount = 71 },
	["gloothomotive"] = { cost = 0, items = { { 21948, 50 } }, mount = 194 },
	["gnarlhound"] = { cost = 0, items = { { 21948, 50 } }, mount = 32 },
	["gold sphinx"] = { cost = 0, items = { { 21948, 50 } }, mount = 107 },
	["golden dragonfly"] = { cost = 0, items = { { 21948, 50 } }, mount = 59 },
	["gorgon hydra"] = { cost = 0, items = { { 21948, 50 } }, mount = 223 },
	["gorongra"] = { cost = 0, items = { { 21948, 50 } }, mount = 81 },
	["green rolling barrel"] = { cost = 0, items = { { 21948, 50 } }, mount = 158 },
	["gryphon"] = { cost = 0, items = { { 21948, 50 } }, mount = 144 },
	["hailstorm fury"] = { cost = 0, items = { { 21948, 50 } }, mount = 55 },
	["haze"] = { cost = 0, items = { { 21948, 50 } }, mount = 162 },
	["hibernal moth"] = { cost = 0, items = { { 21948, 50 } }, mount = 131 },
	["highland yak"] = { cost = 0, items = { { 21948, 50 } }, mount = 63 },
	["holiday mammoth"] = { cost = 0, items = { { 21948, 50 } }, mount = 177 },
	["hyacinth"] = { cost = 0, items = { { 21948, 50 } }, mount = 185 },
	["icebreacher"] = { cost = 0, items = { { 21948, 50 } }, mount = 212 },
	["ink spotted koi"] = { cost = 0, items = { { 21948, 50 } }, mount = 209 },
	["ironblight"] = { cost = 0, items = { { 21948, 50 } }, mount = 29 },
	["ivory fang"] = { cost = 0, items = { { 21948, 50 } }, mount = 100 },
	["jackalope"] = { cost = 0, items = { { 21948, 50 } }, mount = 103 },
	["jade lion"] = { cost = 0, items = { { 21948, 50 } }, mount = 48 },
	["jade pincer"] = { cost = 0, items = { { 21948, 50 } }, mount = 49 },
	["jade shrine"] = { cost = 0, items = { { 21948, 50 } }, mount = 196 },
	["jousting eagle"] = { cost = 0, items = { { 21948, 50 } }, mount = 145 },
	["jousting horse"] = { cost = 0, items = { { 21948, 50 } }, mount = 204 },
	["jungle saurian"] = { cost = 0, items = { { 21948, 50 } }, mount = 110 },
	["jungle tiger"] = { cost = 0, items = { { 21948, 50 } }, mount = 125 },
	["kingly deer"] = { cost = 0, items = { { 21948, 50 } }, mount = 18 },
	["krakoloss"] = { cost = 0, items = { { 21948, 50 } }, mount = 175 },
	["lacewing moth"] = { cost = 0, items = { { 21948, 50 } }, mount = 130 },
	["lady bug"] = { cost = 0, items = { { 21948, 50 } }, mount = 27 },
	["lagoon saurian"] = { cost = 0, items = { { 21948, 50 } }, mount = 112 },
	["leafscuttler"] = { cost = 0, items = { { 21948, 50 } }, mount = 93 },
	["magic carpet"] = { cost = 0, items = { { 21948, 50 } }, mount = 66 },
	["magma crawler"] = { cost = 0, items = { { 21948, 50 } }, mount = 30 },
	["magma skull"] = { cost = 0, items = { { 21948, 50 } }, mount = 220 },
	["manta ray"] = { cost = 0, items = { { 21948, 50 } }, mount = 28 },
	["marsh toad"] = { cost = 0, items = { { 21948, 50 } }, mount = 120 },
	["merry mammoth"] = { cost = 0, items = { { 21948, 50 } }, mount = 176 },
	["midnight panther"] = { cost = 0, items = { { 21948, 50 } }, mount = 5 },
	["mint ibex"] = { cost = 0, items = { { 21948, 50 } }, mount = 199 },
	["mole"] = { cost = 0, items = { { 21948, 50 } }, mount = 119 },
	["mould shell"] = { cost = 0, items = { { 21948, 50 } }, mount = 96 },
	["mouldpincer"] = { cost = 0, items = { { 21948, 50 } }, mount = 91 },
	["muffled snowman"] = { cost = 0, items = { { 21948, 50 } }, mount = 136 },
	["mutated abomination"] = { cost = 0, items = { { 21948, 50 } }, mount = 206 },
	["mystic jaguar"] = { cost = 0, items = { { 21948, 50 } }, mount = 222 },
	["mystic raven"] = { cost = 0, items = { { 21948, 50 } }, mount = 192 },
	["neon sparkid"] = { cost = 0, items = { { 21948, 50 } }, mount = 98 },
	["nethersteed"] = { cost = 0, items = { { 21948, 50 } }, mount = 50 },
	["night waccoon"] = { cost = 0, items = { { 21948, 50 } }, mount = 69 },
	["nightdweller"] = { cost = 0, items = { { 21948, 50 } }, mount = 88 },
	["nightmarish crocovile"] = { cost = 0, items = { { 21948, 50 } }, mount = 143 },
	["nightstinger"] = { cost = 0, items = { { 21948, 50 } }, mount = 85 },
	["noble lion"] = { cost = 0, items = { { 21948, 50 } }, mount = 40 },
	["noctungra"] = { cost = 0, items = { { 21948, 50 } }, mount = 82 },
	["noxious ripptor"] = { cost = 0, items = { { 21948, 50 } }, mount = 202 },
	["obsidian shrine"] = { cost = 0, items = { { 21948, 50 } }, mount = 197 },
	["obstinate ox"] = { cost = 0, items = { { 21948, 50 } }, mount = 215 },
	["parade horse"] = { cost = 0, items = { { 21948, 50 } }, mount = 203 },
	["pegasus"] = { cost = 0, items = { { 21948, 50 } }, mount = 227 },
	["peony"] = { cost = 0, items = { { 21948, 50 } }, mount = 186 },
	["phant"] = { cost = 0, items = { { 21948, 50 } }, mount = 182 },
	["phantasmal jade"] = { cost = 0, items = { { 21948, 50 } }, mount = 167 },
	["platesaurian"] = { cost = 0, items = { { 21948, 50 } }, mount = 37 },
	["plumfish"] = { cost = 0, items = { { 21948, 50 } }, mount = 80 },
	["poisonbane"] = { cost = 0, items = { { 21948, 50 } }, mount = 57 },
	["poppy ibex"] = { cost = 0, items = { { 21948, 50 } }, mount = 198 },
	["primal demonosaur"] = { cost = 0, items = { { 21948, 50 } }, mount = 232 },
	["prismatic unicorn"] = { cost = 0, items = { { 21948, 50 } }, mount = 115 },
	["rabbit rickshaw"] = { cost = 0, items = { { 21948, 50 } }, mount = 138 },
	["racing bird"] = { cost = 0, items = { { 21948, 50 } }, mount = 2 },
	["radiant raven"] = { cost = 0, items = { { 21948, 50 } }, mount = 193 },
	["rapid boar"] = { cost = 0, items = { { 21948, 50 } }, mount = 10 },
	["razorcreep"] = { cost = 0, items = { { 21948, 50 } }, mount = 86 },
	["red rolling barrel"] = { cost = 0, items = { { 21948, 50 } }, mount = 157 },
	["reed lurker"] = { cost = 0, items = { { 21948, 50 } }, mount = 97 },
	["rented horse"] = { cost = 0, items = { { 21948, 50 } }, mount = 22 },
	["rented horse (brown)"] = { cost = 0, items = { { 21948, 50 } }, mount = 26 },
	["rented horse (gray)"] = { cost = 0, items = { { 21948, 50 } }, mount = 25 },
	["rift runner"] = { cost = 0, items = { { 21948, 50 } }, mount = 87 },
	["rift watcher"] = { cost = 0, items = { { 21948, 50 } }, mount = 181 },
	["ringtail waccoon"] = { cost = 0, items = { { 21948, 50 } }, mount = 68 },
	["river crocovile"] = { cost = 0, items = { { 21948, 50 } }, mount = 141 },
	["rune watcher"] = { cost = 0, items = { { 21948, 50 } }, mount = 180 },
	["rustwurm"] = { cost = 0, items = { { 21948, 50 } }, mount = 188 },
	["sanguine frog"] = { cost = 0, items = { { 21948, 50 } }, mount = 121 },
	["savanna ostrich"] = { cost = 0, items = { { 21948, 50 } }, mount = 168 },
	["scorpion king"] = { cost = 0, items = { { 21948, 50 } }, mount = 21 },
	["scruffy hyaena"] = { cost = 0, items = { { 21948, 50 } }, mount = 173 },
	["sea devil"] = { cost = 0, items = { { 21948, 50 } }, mount = 78 },
	["shadow claw"] = { cost = 0, items = { { 21948, 50 } }, mount = 101 },
	["shadow draptor"] = { cost = 0, items = { { 21948, 50 } }, mount = 24 },
	["shadow hart"] = { cost = 0, items = { { 21948, 50 } }, mount = 72 },
	["shadow sphinx"] = { cost = 0, items = { { 21948, 50 } }, mount = 109 },
	["shellodon"] = { cost = 0, items = { { 21948, 50 } }, mount = 183 },
	["shock head"] = { cost = 0, items = { { 21948, 50 } }, mount = 42 },
	["siegebreaker"] = { cost = 0, items = { { 21948, 50 } }, mount = 56 },
	["silverneck"] = { cost = 0, items = { { 21948, 50 } }, mount = 83 },
	["singeing steed"] = { cost = 0, items = { { 21948, 50 } }, mount = 184 },
	["skybreaker pegasus"] = { cost = 0, items = { { 21948, 50 } }, mount = 226 },
	["slagsnare"] = { cost = 0, items = { { 21948, 50 } }, mount = 84 },
	["snow pelt"] = { cost = 0, items = { { 21948, 50 } }, mount = 102 },
	["snow strider"] = { cost = 0, items = { { 21948, 50 } }, mount = 164 },
	["snowy owl"] = { cost = 0, items = { { 21948, 50 } }, mount = 128 },
	["sparkion"] = { cost = 0, items = { { 21948, 50 } }, mount = 94 },
	["spirit of purity"] = { cost = 0, items = { { 21948, 50 } }, mount = 217 },
	["stampor"] = { cost = 0, items = { { 21948, 50 } }, mount = 11 },
	["steel bee"] = { cost = 0, items = { { 21948, 50 } }, mount = 60 },
	["steelbeak"] = { cost = 0, items = { { 21948, 50 } }, mount = 34 },
	["stone rhino"] = { cost = 0, items = { { 21948, 50 } }, mount = 106 },
	["surly steer"] = { cost = 0, items = { { 21948, 50 } }, mount = 214 },
	["swamp crocovile"] = { cost = 0, items = { { 21948, 50 } }, mount = 142 },
	["swamp snapper"] = { cost = 0, items = { { 21948, 50 } }, mount = 95 },
	["tamed panda"] = { cost = 0, items = { { 21948, 50 } }, mount = 19 },
	["tangerine flecked koi"] = { cost = 0, items = { { 21948, 50 } }, mount = 207 },
	["tawny owl"] = { cost = 0, items = { { 21948, 50 } }, mount = 127 },
	["tempest"] = { cost = 0, items = { { 21948, 50 } }, mount = 51 },
	["the hellgrip"] = { cost = 0, items = { { 21948, 50 } }, mount = 39 },
	["tiger slug"] = { cost = 0, items = { { 21948, 50 } }, mount = 14 },
	["tin lizzard"] = { cost = 0, items = { { 21948, 50 } }, mount = 8 },
	["titanica"] = { cost = 0, items = { { 21948, 50 } }, mount = 7 },
	["tombstinger"] = { cost = 0, items = { { 21948, 50 } }, mount = 36 },
	["topaz shrine"] = { cost = 0, items = { { 21948, 50 } }, mount = 195 },
	["tourney horse"] = { cost = 0, items = { { 21948, 50 } }, mount = 205 },
	["toxic toad"] = { cost = 0, items = { { 21948, 50 } }, mount = 122 },
	["tundra rambler"] = { cost = 0, items = { { 21948, 50 } }, mount = 62 },
	["undead cavebear"] = { cost = 0, items = { { 21948, 50 } }, mount = 12 },
	["uniwheel"] = { cost = 0, items = { { 21948, 50 } }, mount = 15 },
	["ursagrodon"] = { cost = 0, items = { { 21948, 50 } }, mount = 38 },
	["venompaw"] = { cost = 0, items = { { 21948, 50 } }, mount = 76 },
	["verdant raven"] = { cost = 0, items = { { 21948, 50 } }, mount = 300 },
	["void watcher"] = { cost = 0, items = { { 21948, 50 } }, mount = 179 },
	["voracious hyaena"] = { cost = 0, items = { { 21948, 50 } }, mount = 171 },
	["vortexion"] = { cost = 0, items = { { 21948, 50 } }, mount = 99 },
	["walker"] = { cost = 0, items = { { 21948, 50 } }, mount = 43 },
	["war bear"] = { cost = 0, items = { { 21948, 50 } }, mount = 3 },
	["war horse"] = { cost = 0, items = { { 21948, 50 } }, mount = 17 },
	["water buffalo"] = { cost = 0, items = { { 21948, 50 } }, mount = 35 },
	["white lion"] = { cost = 0, items = { { 21948, 50 } }, mount = 174 },
	["widow queen"] = { cost = 0, items = { { 21948, 50 } }, mount = 1 },
	["winter king"] = { cost = 0, items = { { 21948, 50 } }, mount = 52 },
	["winterstride"] = { cost = 0, items = { { 21948, 50 } }, mount = 211 },
	["wolpertinger"] = { cost = 0, items = { { 21948, 50 } }, mount = 105 },
	["woodland prince"] = { cost = 0, items = { { 21948, 50 } }, mount = 54 },
	["wrathfire pegasus"] = { cost = 0, items = { { 21948, 50 } }, mount = 225 },
	["zaoan badger"] = { cost = 0, items = { { 21948, 50 } }, mount = 155 },
	["ancient demonosaur"] = { cost = 0, items = { { 21948, 50 } }, mount = 239 },
	["battle werewolf"] = { cost = 0, items = { { 21948, 50 } }, mount = 245 },
	["corpse phoenix"] = { cost = 0, items = { { 21948, 50 } }, mount = 240 },
	["death phoenix"] = { cost = 0, items = { { 21948, 50 } }, mount = 241 },
	["gloom maw"] = { cost = 0, items = { { 21948, 50 } }, mount = 244 },
	["hellish demonosaur"] = { cost = 0, items = { { 21948, 50 } }, mount = 238 },
	["leaf locust"] = { cost = 0, items = { { 21948, 50 } }, mount = 234 },
	["night locust"] = { cost = 0, items = { { 21948, 50 } }, mount = 233 },
	["pallbearer"] = { cost = 0, items = { { 21948, 50 } }, mount = 237 },
	["pearl locust"] = { cost = 0, items = { { 21948, 50 } }, mount = 235 },
	["satin moth"] = { cost = 0, items = { { 21948, 50 } }, mount = 236 },
	["soul phoenix"] = { cost = 0, items = { { 21948, 50 } }, mount = 242 },
	["white gloom maw"] = { cost = 0, items = { { 21948, 50 } }, mount = 243 },
}
local o = {}
local pendingMount = {}
local function creatureSayCallback(npc, creature, type, message)
	local talkUser = creature
	local player = Player(creature)
	local playerId = player:getId()
	local messageLower = message:lower()
	local addonInfo = addoninfo[messageLower]

	local talkState = {}
	if not npcHandler:checkInteraction(npc, creature) then
		return false
	end

	if addonInfo ~= nil then
		local itemsTable = addonInfo.items
		local items_list = ''

		if (player:hasMount(addonInfo.mount)) then
			npcHandler:say('You already have this mount!', npc, creature)
			npcHandler:resetNpc(creature)
			return true
		elseif table.maxn(itemsTable) > 0 then
			for i = 1, table.maxn(itemsTable) do
				local item = itemsTable[i]
				items_list = items_list .. item[2] .. ' ' .. ItemType(item[1]):getName()
				if i ~= table.maxn(itemsTable) then
					items_list = items_list .. ', '
				end
			end
		end
		local text = ''
		if (addonInfo.cost > 0) and (table.maxn(addonInfo.items) > 0) then
			text = items_list .. ' and ' .. addonInfo.cost .. ' gp'
		elseif (addonInfo.cost > 0) then
			text = addonInfo.cost .. ' gp'
		elseif table.maxn(addonInfo.items) > 0 then
			text = items_list
		end
		npcHandler:say('For ' .. messageLower .. ' you will need ' .. text .. '. Do you have it all with you?', npc, creature)
		pendingMount[playerId] = messageLower
		npcHandler:setTopic(playerId, 2)
		return true
	elseif npcHandler:getTopic(playerId) == 2 then
		if MsgContains(message, "yes") then
			local selectedMount = pendingMount[playerId]
			if not selectedMount or not addoninfo[selectedMount] then
				npcHandler:say('Sorry, I did not catch which mount you want. Please say the mount name again.', npc, creature)
				pendingMount[playerId] = nil
				npcHandler:setTopic(playerId, 0)
				npcHandler:resetNpc(creature)
				return true
			end
			local items_number = 0
			if table.maxn(addoninfo[selectedMount].items) > 0 then
				for i = 1, table.maxn(addoninfo[selectedMount].items) do
					local item = addoninfo[selectedMount].items[i]
					if (getPlayerItemCount(creature, item[1]) >= item[2]) then
						items_number = items_number + 1
					end
				end
			end
			if (getPlayerMoney(creature) >= addoninfo[selectedMount].cost) and
					(items_number == table.maxn(addoninfo[selectedMount].items)) then
				doPlayerRemoveMoney(creature, addoninfo[selectedMount].cost)
				if table.maxn(addoninfo[selectedMount].items) > 0 then
					for i = 1, table.maxn(addoninfo[selectedMount].items) do
						local item = addoninfo[selectedMount].items[i]
						doPlayerRemoveItem(creature, item[1], item[2])
					end
				end
				player:addMount(addoninfo[selectedMount].mount)
				npcHandler:say('Here you are.', npc, creature)
			else
				npcHandler:say('You do not have needed items!', npc, creature)
			end
			pendingMount[playerId] = nil
			npcHandler:setTopic(playerId, 0)
			talkState[talkUser] = 0
			npcHandler:resetNpc(creature)
			return true
		end
	elseif MsgContains(message, "mount") then
		-- build names list dynamically from addoninfo keys
		o = {}
		for name, _ in pairs(addoninfo) do table.insert(o, name) end
		table.sort(o)
		
		npcHandler:say('I can give you the following mounts:', npc, creature)
		
		local function sendBatch(npcId, cid, index)
			local n = Npc(npcId)
			local p = Player(cid)
			if not n or not p then return end
			
			if index > #o then
				npcHandler:resetNpc(p)
				return
			end
			
			local batch = {}
			local limit = math.min(index + 19, #o)
			for i = index, limit do
				table.insert(batch, o[i])
			end
			
			npcHandler:say('{' .. table.concat(batch, '}, {') .. '}', n, p)
			addEvent(sendBatch, 1000, npcId, cid, index + 20)
		end
		
		addEvent(sendBatch, 500, npc:getId(), playerId, 1)
		
		pendingMount[playerId] = nil
		npcHandler:setTopic(playerId, 0)
		talkState[talkUser] = 0
		return true
	elseif MsgContains(message, "help") then
		npcHandler:say('You must say \'NAME\', for the mount', npc, creature)
		pendingMount[playerId] = nil
		npcHandler:setTopic(playerId, 0)
		talkState[talkUser] = 0
		npcHandler:resetNpc(creature)
		return true
	else
		if talkState[talkUser] ~= nil then
			if talkState[talkUser] > 0 then
				npcHandler:say('Come back when you get these items.', npc, creature)
				pendingMount[playerId] = nil
				npcHandler:setTopic(playerId, 0)
				talkState[talkUser] = 0
				npcHandler:resetNpc(creature)
				return true
			end
		end
	end
	return true
end

npcHandler:setMessage(MESSAGE_GREET,
	'Welcome |PLAYERNAME|! If you want some mount, just ask me! Do you want to see my {mounts}, or are you decided? If you are decided, just ask me like this: {donkey}')
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)
npcType:register(npcConfig)
