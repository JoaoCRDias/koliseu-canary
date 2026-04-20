local config = {
	-- Window Config
	mainTitleMsg = "Crafting System", -- Main window title
	mainMsg = "Welcome to the crafting system. Please choose a vocation to begin.", -- Main window message

	craftTitle = "Crafting System: ", -- Title of the crafting screen after player picks of vocation
	craftMsg = "Here is a list of all items that can be crafted for the ", -- Message on the crafting screen after player picks of vocation
	-- End Window Config

	-- Player Notifications Config
	needItems = "You do not have all the required items to make ", -- This is the message the player recieves if he does not have all required items

	-- Crafting Config
	system = {
		[1] = {
			vocation = "Master Sorcerer", -- This is the category can be anything.
			items = {
				[1] = {
					item = "Grand Sanguine Coil",
					itemID = 43883,
					price = 500,
					reqItems = {
						[1] = { item = 43866, count = 1 },
						[2] = { item = 43868, count = 1 },
						[3] = { item = 43870, count = 1 },
						[4] = { item = 43872, count = 1 },
						[5] = { item = 43874, count = 1 },
						[6] = { item = 43877, count = 1 },
						[7] = { item = 43879, count = 1 },
						[8] = { item = 43885, count = 1 },
						[9] = { item = 43864, count = 1 },
						[10] = { item = 43882, count = 1 },
						[11] = { item = 43854, count = 250 },
						[12] = { item = 43855, count = 250 },
					},
				},
			},
		},

		[2] = {
			vocation = "Elder Druid",
			items = {
				[1] = {
					item = "Grand Sanguine Rod",
					itemID = 43886,
					price = 500,
					reqItems = {
						[1] = { item = 43866, count = 1 },
						[2] = { item = 43868, count = 1 },
						[3] = { item = 43870, count = 1 },
						[4] = { item = 43872, count = 1 },
						[5] = { item = 43874, count = 1 },
						[6] = { item = 43877, count = 1 },
						[7] = { item = 43879, count = 1 },
						[8] = { item = 43885, count = 1 },
						[9] = { item = 43864, count = 1 },
						[10] = { item = 43882, count = 1 },
						[11] = { item = 43854, count = 250 },
						[12] = { item = 43855, count = 250 },
					},
				},
			},
		},

		[3] = {
			vocation = "Royal Paladin",
			items = {
				[1] = {
					item = "Grand Sanguine Crossbow",
					itemID = 43880,
					price = 500,
					reqItems = {
						[1] = { item = 43866, count = 1 },
						[2] = { item = 43868, count = 1 },
						[3] = { item = 43870, count = 1 },
						[4] = { item = 43872, count = 1 },
						[5] = { item = 43874, count = 1 },
						[6] = { item = 43877, count = 1 },
						[7] = { item = 43879, count = 1 },
						[8] = { item = 43885, count = 1 },
						[9] = { item = 43864, count = 1 },
						[10] = { item = 43882, count = 1 },
						[11] = { item = 43854, count = 250 },
						[12] = { item = 43855, count = 250 },
					},
				},
				[2] = {
					item = "Grand Sanguine Bow",
					itemID = 43878,
					price = 500,
					reqItems = {
						[1] = { item = 43866, count = 1 },
						[2] = { item = 43868, count = 1 },
						[3] = { item = 43870, count = 1 },
						[4] = { item = 43872, count = 1 },
						[5] = { item = 43874, count = 1 },
						[6] = { item = 43877, count = 1 },
						[7] = { item = 43879, count = 1 },
						[8] = { item = 43885, count = 1 },
						[9] = { item = 43864, count = 1 },
						[10] = { item = 43882, count = 1 },
						[11] = { item = 43854, count = 250 },
						[12] = { item = 43855, count = 250 },
					},
				},

			},
		},

		[4] = {
			vocation = "Elite Knight",
			items = {
				[1] = {
					item = "Grand Sanguine Blade",
					itemID = 43865,
					price = 500,
					reqItems = {
						[1] = { item = 43866, count = 1 },
						[2] = { item = 43868, count = 1 },
						[3] = { item = 43870, count = 1 },
						[4] = { item = 43872, count = 1 },
						[5] = { item = 43874, count = 1 },
						[6] = { item = 43877, count = 1 },
						[7] = { item = 43879, count = 1 },
						[8] = { item = 43885, count = 1 },
						[9] = { item = 43864, count = 1 },
						[10] = { item = 43882, count = 1 },
						[11] = { item = 43854, count = 250 },
						[12] = { item = 43855, count = 250 },
					},
				},
				[2] = {
					item = "Grand Sanguine Cudgel",
					itemID = 43867,
					price = 500,
					reqItems = {
						[1] = { item = 43866, count = 1 },
						[2] = { item = 43868, count = 1 },
						[3] = { item = 43870, count = 1 },
						[4] = { item = 43872, count = 1 },
						[5] = { item = 43874, count = 1 },
						[6] = { item = 43877, count = 1 },
						[7] = { item = 43879, count = 1 },
						[8] = { item = 43885, count = 1 },
						[9] = { item = 43864, count = 1 },
						[10] = { item = 43882, count = 1 },
						[11] = { item = 43854, count = 250 },
						[12] = { item = 43855, count = 250 },
					},
				},
				[3] = {
					item = "Grand Sanguine Razor",
					itemID = 43871,
					price = 500,
					reqItems = {
						[1] = { item = 43866, count = 1 },
						[2] = { item = 43868, count = 1 },
						[3] = { item = 43870, count = 1 },
						[4] = { item = 43872, count = 1 },
						[5] = { item = 43874, count = 1 },
						[6] = { item = 43877, count = 1 },
						[7] = { item = 43879, count = 1 },
						[8] = { item = 43885, count = 1 },
						[9] = { item = 43864, count = 1 },
						[10] = { item = 43882, count = 1 },
						[11] = { item = 43854, count = 250 },
						[12] = { item = 43855, count = 250 },
					},
				},
				[4] = {
					item = "Grand Sanguine Bludgeon",
					itemID = 43873,
					price = 500,
					reqItems = {
						[1] = { item = 43866, count = 1 },
						[2] = { item = 43868, count = 1 },
						[3] = { item = 43870, count = 1 },
						[4] = { item = 43872, count = 1 },
						[5] = { item = 43874, count = 1 },
						[6] = { item = 43877, count = 1 },
						[7] = { item = 43879, count = 1 },
						[8] = { item = 43885, count = 1 },
						[9] = { item = 43864, count = 1 },
						[10] = { item = 43882, count = 1 },
						[11] = { item = 43854, count = 250 },
						[12] = { item = 43855, count = 250 },
					},
				},
				[5] = {
					item = "Grand Sanguine Battleaxe",
					itemID = 43875,
					price = 500,
					reqItems = {
						[1] = { item = 43866, count = 1 },
						[2] = { item = 43868, count = 1 },
						[3] = { item = 43870, count = 1 },
						[4] = { item = 43872, count = 1 },
						[5] = { item = 43874, count = 1 },
						[6] = { item = 43877, count = 1 },
						[7] = { item = 43879, count = 1 },
						[8] = { item = 43885, count = 1 },
						[9] = { item = 43864, count = 1 },
						[10] = { item = 43882, count = 1 },
						[11] = { item = 43854, count = 250 },
						[12] = { item = 43855, count = 250 },
					},
				},
				[6] = {
					item = "Grand Sanguine Hatchet",
					itemID = 43869,
					price = 500,
					reqItems = {
						[1] = { item = 43866, count = 1 },
						[2] = { item = 43868, count = 1 },
						[3] = { item = 43870, count = 1 },
						[4] = { item = 43872, count = 1 },
						[5] = { item = 43874, count = 1 },
						[6] = { item = 43877, count = 1 },
						[7] = { item = 43879, count = 1 },
						[8] = { item = 43885, count = 1 },
						[9] = { item = 43864, count = 1 },
						[10] = { item = 43882, count = 1 },
						[11] = { item = 43854, count = 250 },
						[12] = { item = 43855, count = 250 },
					},
				},
			},
		},
		[5] = {
			vocation = "All Vocations",
			items = {
				[1] = {
					item = "starlight power",
					itemID = 60148,
					warning = "Caution: Relic inside reliquaries will be lost, be sure of remove them before crafting your new item!",
					price = 1000, -- in KK
					reqItems = {
						[1] = { item = 60105, count = 1 },
						[2] = { item = 60106, count = 1 },
						[3] = { item = 60107, count = 1 },
						[4] = { item = 60108, count = 1 },
						[5] = { item = 60109, count = 1 },
						[6] = { item = 60110, count = 1 },
						[7] = { item = 43854, count = 500 },
						[8] = { item = 43855, count = 500 },
						[9] = { item = 43501, count = 5 },
						[10] = { item = 43502, count = 5 },
						[11] = { item = 43503, count = 5 },
						[12] = { item = 43504, count = 5 },
						[13] = { item = 43968, count = 5 },
						[14] = { item = 22516, count = 500 },
						[15] = { item = 22721, count = 500 },
						[16] = { item = 60104, count = 5 },

					},
				},
				[2] = {
					item = "gladiator's triumph",
					itemID = 63366,
					price = 2000, -- in KK
					warning = "Caution: Relic inside reliquaries will be lost, be sure of remove them before crafting your new item!",
					reqItems = {
						[1] = { item = 60105, count = 1 },
						[2] = { item = 60106, count = 1 },
						[3] = { item = 60107, count = 1 },
						[4] = { item = 60108, count = 1 },
						[5] = { item = 60109, count = 1 },
						[6] = { item = 60110, count = 1 },
						[7] = { item = 43854, count = 1000 },
						[8] = { item = 43855, count = 1000 },
						[9] = { item = 43501, count = 10 },
						[10] = { item = 43502, count = 10 },
						[11] = { item = 43503, count = 10 },
						[12] = { item = 43504, count = 10 },
						[13] = { item = 43968, count = 10 },
						[14] = { item = 22516, count = 1000 },
						[15] = { item = 22721, count = 1000 },
						[16] = { item = 60148, count = 1 },
						[17] = { item = 60156, count = 1 },
						[18] = { item = 60104, count = 5 },
					},
				},
				[3] = {
					item = "supreme pendulet",
					itemID = 60159,
					price = 2000, -- in KK
					reqItems = {
						[1] = { item = 60242, count = 1 },
						[2] = { item = 60243, count = 1 },
						[3] = { item = 60244, count = 1 },
						[4] = { item = 60245, count = 1 },
						[5] = { item = 60246, count = 1 },
						[6] = { item = 60247, count = 1 },
						[7] = { item = 43854, count = 1000 },
						[8] = { item = 43855, count = 1000 },
						[9] = { item = 43501, count = 5 },
						[10] = { item = 43502, count = 5 },
						[11] = { item = 43503, count = 5 },
						[12] = { item = 43504, count = 5 },
						[13] = { item = 43968, count = 5 },
						[14] = { item = 22516, count = 1000 },
						[15] = { item = 22721, count = 1000 },
						[16] = { item = 60155, count = 1 },
						[19] = { item = 60104, count = 5 },
					},
				},
				[4] = {
					item = "supreme sigil",
					itemID = 60158,
					price = 2000, -- in KK
					reqItems = {
						[1] = { item = 60240, count = 1 },
						[2] = { item = 60241, count = 1 },
						[3] = { item = 60248, count = 1 },
						[4] = { item = 60249, count = 1 },
						[5] = { item = 60250, count = 1 },
						[6] = { item = 60251, count = 1 },
						[7] = { item = 43854, count = 1000 },
						[8] = { item = 43855, count = 1000 },
						[9] = { item = 43501, count = 5 },
						[10] = { item = 43502, count = 5 },
						[11] = { item = 43503, count = 5 },
						[12] = { item = 43504, count = 5 },
						[13] = { item = 43968, count = 5 },
						[14] = { item = 22516, count = 1000 },
						[15] = { item = 22721, count = 1000 },
						[16] = { item = 60155, count = 1 },
						[17] = { item = 60104, count = 5 },
					},
				},

			},
		},

		[6] = {
			vocation = "Miscellaneous",
			items = {
				-- Gladiator's Triumph: combine 5 empty sight of truth
				[1] = {
					item = "Gladiator's Triumph",
					itemID = 63366,
					price = 0,
					reqItems = {
						[1] = {
							item = 60160, -- sight of truth
							count = 5,
							requireEmpty = true,
							emptyMessage = "You need 5 empty sight of truth (no relics inside) to craft this.",
						},
					},
					craftEffect = CONST_ME_MAGIC_GREEN,
				},

				-- Vocation backpacks from booster bps (single entry per vocation for clarity).
				[2] = {
					item = "Knight Backpack",
					itemID = 60656,
					price = 0,
					reqItems = {
						[1] = {
							item = 0,
							count = 5,
							requireEmpty = true,
							matcher = function(it)
								local id = it:getId()
								return id == 63363 or id == 63365
							end,
							emptyMessage = "You need 5 empty booster backpacks (cosmicsteel or ironlord).",
						},
					},
					craftEffect = CONST_ME_MAGIC_GREEN,
				},
				[3] = {
					item = "Paladin Backpack",
					itemID = 60653,
					price = 0,
					reqItems = {
						[1] = {
							item = 0,
							count = 5,
							requireEmpty = true,
							matcher = function(it)
								local id = it:getId()
								return id == 63363 or id == 63365
							end,
							emptyMessage = "You need 5 empty booster backpacks (cosmicsteel or ironlord).",
						},
					},
					craftEffect = CONST_ME_MAGIC_GREEN,
				},
				[4] = {
					item = "Druid Backpack",
					itemID = 60655,
					price = 0,
					reqItems = {
						[1] = {
							item = 0,
							count = 5,
							requireEmpty = true,
							matcher = function(it)
								local id = it:getId()
								return id == 63363 or id == 63365
							end,
							emptyMessage = "You need 5 empty booster backpacks (cosmicsteel or ironlord).",
						},
					},
					craftEffect = CONST_ME_MAGIC_GREEN,
				},
				[5] = {
					item = "Sorcerer Backpack",
					itemID = 60657,
					price = 0,
					reqItems = {
						[1] = {
							item = 0,
							count = 5,
							requireEmpty = true,
							matcher = function(it)
								local id = it:getId()
								return id == 63363 or id == 63365
							end,
							emptyMessage = "You need 5 empty booster backpacks (cosmicsteel or ironlord).",
						},
					},
					craftEffect = CONST_ME_MAGIC_GREEN,
				},

				-- Undead Soldier Exercise Dummy: 5 any store dummies -> wrapped deco kit in store inbox
				[6] = {
					item = "Undead Soldier Exercise Dummy",
					itemID = 60131,
					price = 0,
					reqItems = {
						[1] = {
							item = 0,
							count = 5,
							matcher = function(it)
								local STORE_DUMMY_IDS = {
									[60298] = true, [60299] = true, [60261] = true, [60262] = true,
									[60163] = true, [60164] = true, [60153] = true, [60154] = true,
									[60139] = true, [60140] = true, [60127] = true, [60128] = true,
									[60102] = true, [60103] = true, [60032] = true, [60033] = true,
									[60031] = true, [60034] = true, [60062] = true, [60063] = true,
									[60620] = true, [60621] = true, [60453] = true, [60454] = true,
								}
								local id = it:getId()
								if STORE_DUMMY_IDS[id] then
									return true
								end
								if id == 23398 then
									local unwrapId = it:getCustomAttribute("unWrapId")
									if unwrapId and STORE_DUMMY_IDS[unwrapId] then
										return true
									end
								end
								return false
							end,
							emptyMessage = "You need 5 exercise dummies from the store.",
						},
					},
					onCraft = function(player, craftItem)
						local inbox = player:getStoreInbox()
						if not inbox then
							player:sendTextMessage(MESSAGE_LOOK, "Error: Could not access your store inbox.")
							return false
						end
						if #inbox:getItems() >= inbox:getMaxCapacity() then
							player:sendTextMessage(MESSAGE_LOOK, "Your store inbox is full. Please free up a slot and try again.")
							return false
						end
						-- Create the kit first so we can set all attributes, then deliver via
						-- addItemStoreInboxEx(item, movable=false): sets owner + STORE attr (lets
						-- the item be unwrapped in a friend's house if the owner is a subowner there).
						local decoKit = Game.createItem(23398, 1)
						if not decoKit then
							player:sendTextMessage(MESSAGE_LOOK, "Error: Could not create decoration kit.")
							return false
						end
						decoKit:setAttribute(ITEM_ATTRIBUTE_DESCRIPTION, "Unwrap it in your own house to create a <undead soldier exercise dummy>.")
						decoKit:setCustomAttribute("unWrapId", 60131)
						player:addItemStoreInboxEx(decoKit, false, true)
						return true
					end,
					craftEffect = CONST_ME_HOLYDAMAGE,
				},

				-- Stone upgrades: 5 basic -> 1 medium
				[7] = {
					item = "Medium Upgrade Stone",
					itemID = 60428,
					price = 0,
					reqItems = {
						[1] = { item = 60429, count = 5 },
					},
					craftEffect = CONST_ME_HOLYAREA,
				},

				-- Stone upgrades: 5 medium -> 1 epic
				[8] = {
					item = "Epic Upgrade Stone",
					itemID = 60427,
					price = 0,
					reqItems = {
						[1] = { item = 60428, count = 5 },
					},
					craftEffect = CONST_ME_HOLYAREA,
				},
			},
		},
	},
}

local simpleCraftingSystem = Action()
function simpleCraftingSystem.onUse(player, item, fromPosition, itemEx, toPosition, isHotkey)
	player:sendMainCraftWindow(config)
	return true
end

simpleCraftingSystem:id(60011)
simpleCraftingSystem:register()
