if not Quests then
	Quests = {
		[1] = {
			name = "The Ultimate Challenges",
			startStorageId = Storage.Quest.U8_0.BarbarianArena.QuestLogGreenhorn,
			startStorageValue = 1,
			missions = {},
		},
	}

	local modes = {
		{ name = "Greenhorn", storage = Storage.Quest.U8_0.BarbarianArena.QuestLogGreenhorn, missionId = 10312 },
		{ name = "Scrapper", storage = Storage.Quest.U8_0.BarbarianArena.QuestLogScrapper, missionId = 10313 },
		{ name = "Warlord", storage = Storage.Quest.U8_0.BarbarianArena.QuestLogWarlord, missionId = 10314 },
	}

	for i, mode in ipairs(modes) do
		Quests[1].missions[i] = {
			name = "Barbarian Arena - " .. mode.name .. " Mode",
			storageId = mode.storage,
			missionId = mode.missionId,
			startValue = 1,
			endValue = 2,
			states = {
				[1] = "You have to defeat all enemies in this mode.",
				[2] = "You have defeated all enemies in this mode.",
			},
		}
	end

	Quests[2] = {
		name = "The Supreme Vocation",
		startStorageId = Storage.SupremeVocation.QuestLine,
		startStorageValue = 1,
		missions = {
			[1] = {
				name = "Trial of Access",
				storageId = Storage.SupremeVocation.MissionAccess,
				missionId = 60201,
				startValue = 1,
				endValue = 2,
				states = {
					[1] = "The Elder Warrior Vharen on the forsaken isle has etched a pattern into your memory. \z
						Climb to the second floor of the mountain, match the twenty stone levers to the shape, \z
						and pull the central mechanism to prove your resolve.",
					[2] = "You aligned the stones and pulled the mechanism. The mountain's first gate \z
						has yielded. The true trials of the supreme vocations await beyond.",
				},
			},
			[2] = {
				name = "Report the Trial",
				storageId = Storage.SupremeVocation.MissionReport,
				missionId = 60202,
				startValue = 1,
				endValue = 2,
				states = {
					[1] = "Return to the Elder Warrior Vharen and report your success at the trial of access.",
					[2] = "The elder warrior listened to your account and revealed the next step: \z
						the wall of energies beyond the mountain, and the ritual of the four basins.",
				},
			},
			[3] = {
				name = "Ritual of the Basins",
				storageId = Storage.SupremeVocation.MissionBasinRitual,
				missionId = 60203,
				startValue = 1,
				endValue = 3,
				states = {
					[1] = "Four plants bloom across the continent, each carrying a different extract. \z
						Gather the four extracts, place one on each basin at the mountain's nature sanctum, \z
						and use the central mechanism to open the way.",
					[2] = "You placed the four extracts on the basins and the central mechanism opened \z
						a portal. Step through before it fades. The corridor and its guardian await.",
					[3] = "You purified the fountain of nature within the mountain. Return to Elder \z
						Warrior Vharen to report what you have done.",
				},
			},
			[4] = {
				name = "Trial of the Poison Chamber",
				storageId = Storage.SupremeVocation.MissionPoisonReport,
				missionId = 60209,
				startValue = 1,
				endValue = 2,
				states = {
					[1] = "You survived the poison chamber. Return to Elder Warrior Vharen and \z
						report your trial.",
					[2] = "The elder warrior heard of your trial in the poison chamber and prepared \z
						the next path of the mountain.",
				},
			},
			[5] = {
				name = "Trial of the Death Chamber",
				storageId = Storage.SupremeVocation.MissionDeathReport,
				missionId = 60215,
				startValue = 1,
				endValue = 2,
				states = {
					[1] = "You cleared the death chamber — the puzzle of the skeletons, the \z
						labyrinth, and the rite of the four spectres. Return to Elder Warrior \z
						Vharen and report your trial.",
					[2] = "The elder warrior acknowledged your victory over the death chamber. \z
						The path of flame now opens.",
				},
			},
			[6] = {
				name = "Trial of the Fire Chamber",
				storageId = Storage.SupremeVocation.MissionFireReport,
				missionId = 60219,
				startValue = 1,
				endValue = 2,
				states = {
					[1] = "You kept the bonfire burning for five minutes against the frost. \z
						Return to Elder Warrior Vharen and report your trial.",
					[2] = "The elder warrior acknowledged your victory over the fire chamber.",
				},
			},
			[7] = {
				name = "Trial of the Wealth Chamber",
				storageId = Storage.SupremeVocation.MissionWealthReport,
				missionId = 60224,
				startValue = 1,
				endValue = 2,
				states = {
					[1] = "You beat Goldmouth the gambler at his own dice. Return to Elder \z
						Warrior Vharen and report your trial.",
					[2] = "The elder warrior acknowledged your victory over Goldmouth. The \z
						summit of the mountain is finally open to you.",
				},
			},
			[8] = {
				name = "The Summit",
				storageId = Storage.SupremeVocation.MissionSummitReport,
				missionId = 60228,
				startValue = 1,
				endValue = 1,
				states = {
					[1] = "Ascenar has lifted your vocation to its supreme form. The trial \z
						of the mountain is complete.",
				},
			},
		},
	}
end
